# Bookstore

John is starting a new bookstore and wants to use a smart contract to securely store data and make the process easy for customers. John needs functionalities to be enabled for customers to directly check the availability of books using the smart contract. He needs your help in implementing the smart contract with the following functionalities:

## Input:

-   `addBook(string title, string author, string publication)`: This function should only be accessible by owner. Using this function, he can add a book by specifying the title, author, and publication of the book respectively. The book should automatically get an ID of type uint assigned to it in the smart contract. The ID of the newly added book should be one greater than the ID of the previously added book, or 1 if no books have been added yet.

-   `removeBook(uint id)`: This function should only be accessible by owner. Using this function, John can make a book unavailable in cases like the book being sold, the book getting damaged, etc.

-   `updateDetails(uint id, string title, string author, string publication, bool available)`: This function should only be accessible by owner. Using this function, John can modify the details of a book whose ID is id. If there is no book with ID id in the database, the transaction must fail. ( Check the explanation of getDetailsById() function below for better understanding).

## Output:

-   `findBookByTitle(string title) returns (uint[])`: This function is accessible by everyone. If owner calls this function, an array of IDs of all the books (available as well as unavailable) in the database that match the title given in the parameter should be returned. If this function is accessed by any address other than owner, then the function must return the IDs of only the available books which match the title given in the parameter.

-   `findAllBooksOfPublication(string publication) returns (uint[])`: This function is accessible by everyone. If owner calls this function, an array of IDs of all the books (available as well as unavailable) in the database that match the publication given in the parameter should be returned. If this function is accessed by any address other than owner, then the function must return the IDs of only the available books which match the publication given in the parameter.

-   `findAllBooksOfAuthor(string author) returns (uint[])`: This function is accessible by everyone. If owner calls this function, an array of IDs of all the books (available as well as unavailable) in the database that match the author given in the parameter should be returned. If this function is accessed by any address other than owner, then the function must return the IDs of only the available books which match the author given in the parameter.

-   `getDetailsById(uint id) returns (string title, string author, string publication, bool available)`: This function is accessible by everyone. This function must return the following details of the book which has an ID id. The title, author, publication, and a boolean value respectively. This boolean value must be true if the book is available and false if the book is not available. If there is no book with the given ID in the database, then the transaction must fail. If this function is accessed by any address other than owner, then the function must return the details only if the book is available, else the transaction must fail.
