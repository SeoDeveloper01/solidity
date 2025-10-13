// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

contract SmartWallet {
    address private immutable owner = msg.sender;
    mapping(address => bool) private whitelist;

    uint private balance;

    modifier onlyOwner() {
        require(msg.sender == owner);
        _;
    }

    modifier onlyWhitelisted() {
        require(msg.sender == owner || whitelist[msg.sender]);
        _;
    }

    function addFunds(uint amount) external onlyWhitelisted {
        unchecked {
            uint newBalance = balance + amount;

            require(newBalance <= 10_000);

            balance = newBalance;
        }
    }

    function spendFunds(uint amount) external onlyWhitelisted {
        unchecked {
            require(amount <= balance);

            balance -= amount;
        }
    }

    function addAccess(address user) external onlyOwner {
        whitelist[user] = true;
    }

    function revokeAccess(address user) external onlyOwner {
        delete whitelist[user];
    }

    function viewBalance() external view onlyWhitelisted returns (uint) {
        return balance;
    }
}
