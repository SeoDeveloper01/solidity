// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

contract DAO {
    struct Proposal {
        string description;
        uint256 amount;
        address payable recipient;
        address[] investors;
        uint voteTimeEnd;
    }

    address private immutable owner = msg.sender;
    uint private contributionTimeEnd;
    uint public proposalsLength;
    uint private voteTime;
    uint private quorum;
    address[] private allInvestors;
    mapping(address => uint) private users;
    mapping(uint => Proposal) private proposals;

    function initializeDAO(uint256 _contributionTimeEnd, uint256 _voteTime, uint256 _quorum) public {
        require(msg.sender == owner);
        require(_contributionTimeEnd > 0);
        require(_voteTime > 0);
        require(_quorum > 0);

        contributionTimeEnd = block.timestamp + _contributionTimeEnd;
        voteTime = _voteTime;
        quorum = _quorum;
    }

    function contribution() public payable {
        require(block.timestamp < contributionTimeEnd);
        require(msg.value > 0);

        users[msg.sender] = msg.value;
        addInvestor(msg.sender);
    }

    function redeemShare(uint256 amount) public {
        require(users[msg.sender] >= amount);

        payable(msg.sender).transfer(amount);
        users[msg.sender] -= amount;
    }

    function transferShare(uint256 amount, address to) public {
        require(amount > 0);
        require(users[msg.sender] >= amount);

        users[msg.sender] -= amount;
        users[to] += amount;
        addInvestor(to);
    }

    function createProposal(string calldata description, uint256 amount, address payable recipient) public {
        require(msg.sender == owner);
        require(address(this).balance >= amount);

        Proposal storage proposal = proposals[proposalsLength++];

        proposal.description = description;
        proposal.amount = amount;
        proposal.recipient = recipient;
        proposal.voteTimeEnd = block.timestamp + voteTime;
    }

    function voteProposal(uint256 proposalId) public {
        require(proposals[proposalId].voteTimeEnd > block.timestamp);

        address[] memory investors = allInvestorList();
        bool isInvestor;

        for (uint index; index < investors.length; ++index) {
            if (investors[index] == msg.sender) {
                isInvestor = true;
                break;
            }
        }

        require(isInvestor);

        address[] storage proposalInvestors = proposals[proposalId].investors;

        for (uint index; index < proposalInvestors.length; ++index) {
            if (proposalInvestors[index] == msg.sender) revert();
        }

        proposalInvestors.push(msg.sender);
    }

    function executeProposal(uint256 proposalId) public {
        require(msg.sender == owner);

        Proposal memory proposal = proposals[proposalId];
        address[] memory investors = proposal.investors;
        uint currentQuorum;

        for (uint index; index < investors.length; ++index) {
            currentQuorum += users[investors[index]];
        }

        if (currentQuorum >= quorum) proposal.recipient.transfer(proposal.amount);
    }

    function proposalList() public view returns (string[] memory, uint[] memory, address[] memory) {
        require(proposalsLength > 0, 'emty list');

        string[] memory descriptions = new string[](proposalsLength);
        uint[] memory amounts = new uint[](proposalsLength);
        address[] memory recipients = new address[](proposalsLength);

        for (uint index; index < proposalsLength; ++index) {
            Proposal memory proposal = proposals[index];

            descriptions[index] = proposal.description;
            amounts[index] = proposal.amount;
            recipients[index] = proposal.recipient;
        }

        return (descriptions, amounts, recipients);
    }

    function allInvestorList() public view returns (address[] memory) {
        require(allInvestors.length > 0);

        return allInvestors;
    }

    function addInvestor(address investor) private {
        bool hasInvestor;

        for (uint index; index < allInvestors.length; ++index) {
            if (allInvestors[index] == investor) {
                hasInvestor = true;
                break;
            }
        }

        if (!hasInvestor) allInvestors.push(investor);
    }
}
