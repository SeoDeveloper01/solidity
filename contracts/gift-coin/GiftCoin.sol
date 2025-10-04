// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

contract GiftCoin {
    mapping(address => uint) private coins;
    address private immutable owner = msg.sender;

    event GiftSent(address from, address to, uint amount);

    modifier onlyOwner() {
        require(msg.sender == owner);
        _;
    }

    function sendGift(address receiver, uint amount) external {
        require(coins[msg.sender] >= amount);

        coins[msg.sender] -= amount;
        coins[receiver] += amount;

        emit GiftSent(msg.sender, receiver, amount);
    }

    function mintCoins(address target, uint mintedAmount) external onlyOwner {
        coins[target] += mintedAmount;
    }

    function balanceOf(address addr) external view returns (uint) {
        return coins[addr];
    }
}
