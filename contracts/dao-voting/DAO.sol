// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

contract DAO {
    struct Proposal {
        string description;
        uint amount;
        address payable recipient;
        uint voteTimeEnd;
        uint weight;
        mapping(address => bool) investors;
    }

    struct InvestorInfo {
        uint share;
        bool hasContributed;
    }

    address private immutable owner = msg.sender;

    mapping(uint => Proposal) private proposals;
    uint private proposalsLength;

    mapping(address => InvestorInfo) private shares;
    address[] private investorsList;

    uint private contributionTimeEnd;
    uint private voteDuration;
    uint private quorum;

    modifier onlyOwner() {
        require(msg.sender == owner);
        _;
    }

    function initializeDAO(uint contributionDuration, uint newVoteDuration, uint newQuorum) external onlyOwner {
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

        InvestorInfo storage investor = shares[msg.sender];

        if (!investor.hasContributed) {
            investor.hasContributed = true;
            investorsList.push(msg.sender);
        }

        investor.share += msg.value;
    }

    function redeemShare(uint amount) external {
        InvestorInfo storage investor = shares[msg.sender];

        require(address(this).balance >= amount);
        require(investor.share >= amount);

        payable(msg.sender).transfer(amount);
        investor.share -= amount;
    }

    function transferShare(uint amount, address to) external {
        InvestorInfo storage sender = shares[msg.sender];
        InvestorInfo storage recipient = shares[to];

        require(amount > 0);
        require(sender.share >= amount);

        if (!recipient.hasContributed) {
            recipient.hasContributed = true;
            investorsList.push(to);
        }

        sender.share -= amount;
        recipient.share += amount;
    }

    function createProposal(string calldata description, uint amount, address payable receipient) external onlyOwner {
        require(address(this).balance >= amount);

        Proposal storage newProposal = proposals[proposalsLength++];

        newProposal.description = description;
        newProposal.amount = amount;
        newProposal.recipient = receipient;
        newProposal.voteTimeEnd = voteDuration + block.timestamp;
    }

    function voteProposal(uint proposalId) external {
        Proposal storage proposal = proposals[proposalId];
        uint investorShare = shares[msg.sender].share;

        require(investorShare > 0);
        require(proposal.voteTimeEnd > block.timestamp);
        require(!proposal.investors[msg.sender]);

        proposal.weight += investorShare;
        proposal.investors[msg.sender] = true;
    }

    function executeProposal(uint proposalId) external onlyOwner {
        Proposal storage proposal = proposals[proposalId];

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
