// SPDX-License-Identifier: MIT
pragma solidity 0.8.30;

contract DAO {
    struct Proposal {
        string description;
        uint amount;
        address payable recipient;
        uint voteTimeEnd;
        uint weight;
        mapping(address => bool) investors;
    }

    address private immutable owner = msg.sender;

    mapping(uint => Proposal) private proposals;
    uint private proposalsLength;

    mapping(address => uint) private shares;
    address[] private investorsList;

    uint private contributionTimeEnd;
    uint private voteDuration;
    uint private quorum;

    function initializeDAO(uint contributionDuration, uint newVoteDuration, uint newQuorum) external {
        require(msg.sender == owner);
        require(contributionDuration > 0);
        require(newVoteDuration > 0);
        require(newQuorum > 0);

        contributionTimeEnd = contributionDuration + block.timestamp;
        voteDuration = newVoteDuration;
        quorum = newQuorum;
    }

    function contribution() external payable {
        require(msg.value > 0);
        require(block.timestamp < contributionTimeEnd);

        if (shares[msg.sender] == 0) investorsList.push(msg.sender);
        shares[msg.sender] += msg.value;
    }

    function redeemShare(uint amount) external {
        require(address(this).balance >= amount);
        require(shares[msg.sender] >= amount);

        payable(msg.sender).transfer(amount);
        shares[msg.sender] -= amount;
    }

    function transferShare(uint amount, address to) external {
        require(amount > 0);
        require(shares[msg.sender] >= amount);

        if (shares[to] == 0) investorsList.push(to);
        shares[msg.sender] -= amount;
        shares[to] += amount;
    }

    function createProposal(string calldata description, uint amount, address payable receipient) external {
        require(msg.sender == owner);
        require(address(this).balance >= amount);

        Proposal storage newProposal = proposals[proposalsLength++];

        newProposal.description = description;
        newProposal.amount = amount;
        newProposal.recipient = receipient;
        newProposal.voteTimeEnd = voteDuration + block.timestamp;
    }

    function voteProposal(uint proposalId) external {
        Proposal storage proposal = proposals[proposalId];

        require(shares[msg.sender] > 0);
        require(proposal.voteTimeEnd > block.timestamp);
        require(!proposal.investors[msg.sender]);

        proposal.weight += shares[msg.sender];
        proposal.investors[msg.sender] = true;
    }

    function executeProposal(uint proposalId) external {
        Proposal storage proposal = proposals[proposalId];

        require(msg.sender == owner);
        require(block.timestamp > proposal.voteTimeEnd);

        if (proposal.weight >= quorum) proposal.recipient.transfer(proposal.amount);
    }

    function proposalList() external view returns (string[] memory, uint[] memory, address[] memory) {
        require(proposalsLength > 0);

        string[] memory descriptions = new string[](proposalsLength);
        uint[] memory amounts = new uint[](proposalsLength);
        address[] memory recipients = new address[](proposalsLength);

        for (uint index; index < proposalsLength; ++index) {
            Proposal storage proposal = proposals[index];

            descriptions[index] = proposal.description;
            amounts[index] = proposal.amount;
            recipients[index] = proposal.recipient;
        }

        return (descriptions, amounts, recipients);
    }

    function allInvestorList() external view returns (address[] memory) {
        require(investorsList.length > 0);

        return investorsList;
    }
}
