// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

contract SimplePaymentChannel {
    address payable private immutable shopkeeper;
    address payable private immutable wholesaleSeller;

    uint[] private allPayments;

    constructor(address payable recipient) {
        shopkeeper = payable(msg.sender);
        wholesaleSeller = recipient;
    }

    function deposit() external payable {
        require(msg.sender == shopkeeper);
        require(msg.value > 0);
    }

    function listPayment(uint amount) external {
        require(msg.sender == shopkeeper);
        require(address(this).balance >= amount);

        wholesaleSeller.transfer(amount);
        allPayments.push(amount);
    }

    function closeChannel() external {
        require(msg.sender == shopkeeper || msg.sender == wholesaleSeller);

        shopkeeper.transfer(address(this).balance);
    }

    function checkBalance() external view returns (uint) {
        return address(this).balance;
    }

    function getAllPayments() external view returns (uint[] memory) {
        return allPayments;
    }
}
