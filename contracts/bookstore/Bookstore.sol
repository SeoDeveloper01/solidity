// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

contract Bookstore {
    struct Book {
        string title;
        string author;
        string publication;
        bool available;
    }

    address private immutable owner = msg.sender;
    uint[][1] private tempIds;
    Book[] private books;

    modifier onlyOwner() {
        require(msg.sender == owner);
        _;
    }

    function addBook(string calldata title, string calldata author, string calldata publication) external onlyOwner {
        books.push(Book(title, author, publication, true));
    }

    function removeBook(uint id) external onlyOwner {
        books[id - 1].available = false;
    }

    function updateDetails(
        uint id,
        string calldata title,
        string calldata author,
        string calldata publication,
        bool available
    ) external onlyOwner {
        books[id - 1] = Book(title, author, publication, available);
    }

    function findBookByTitle(string calldata title) external returns (uint[] memory ids) {
        bytes32 titleHash = keccak256(bytes(title));

        if (msg.sender == owner) {
            for (uint index; index < books.length; ++index) {
                if (keccak256(bytes(books[index].title)) == titleHash) tempIds[0].push(index + 1);
            }
        } else {
            for (uint index; index < books.length; ++index) {
                if (books[index].available && keccak256(bytes(books[index].title)) == titleHash)
                    tempIds[0].push(index + 1);
            }
        }

        ids = tempIds[0];
        delete tempIds[0];
    }

    function findAllBooksOfPublication(string calldata publication) external returns (uint[] memory ids) {
        bytes32 publicationHash = keccak256(bytes(publication));

        if (msg.sender == owner) {
            for (uint index; index < books.length; ++index) {
                if (keccak256(bytes(books[index].publication)) == publicationHash) tempIds[0].push(index + 1);
            }
        } else {
            for (uint index; index < books.length; ++index) {
                if (books[index].available && keccak256(bytes(books[index].publication)) == publicationHash)
                    tempIds[0].push(index + 1);
            }
        }

        ids = tempIds[0];
        delete tempIds[0];
    }

    function findAllBooksOfAuthor(string calldata author) external returns (uint[] memory ids) {
        bytes32 authorHash = keccak256(bytes(author));

        if (msg.sender == owner) {
            for (uint index; index < books.length; ++index) {
                if (keccak256(bytes(books[index].author)) == authorHash) tempIds[0].push(index + 1);
            }
        } else {
            for (uint index; index < books.length; ++index) {
                if (books[index].available && keccak256(bytes(books[index].author)) == authorHash)
                    tempIds[0].push(index + 1);
            }
        }

        ids = tempIds[0];
        delete tempIds[0];
    }

    function getDetailsById(uint id) external view returns (string memory, string memory, string memory, bool) {
        Book memory book = books[id - 1];

        require(msg.sender == owner || book.available);

        return (book.title, book.author, book.publication, book.available);
    }
}
