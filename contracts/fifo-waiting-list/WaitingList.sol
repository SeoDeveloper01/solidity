// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

contract WaitingList {
    struct User {
        address payable to;
        uint amount;
    }

    address private immutable owner;
    User[] private queue;
    uint private start;

    constructor() {
        owner = msg.sender;
    }

    function push() external payable {
        require(msg.value > 0.09 ether);

        queue.push(User(payable(msg.sender), msg.value));
    }

    function pop() external {
        require(msg.sender == owner);
        require(queue.length != start);

        User storage user = queue[start];

        user.to.transfer(user.amount);
        ++start;
    }

    function size() external view returns (uint) {
        return queue.length - start;
    }

    function get(uint index) external view returns (address, uint) {
        require(queue.length - start > index);

        User storage user = queue[start + index];

        return (user.to, user.amount);
    }
}
