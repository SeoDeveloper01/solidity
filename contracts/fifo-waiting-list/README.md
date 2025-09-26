# FIFO-like waiting list

Let's create a smart contract with a FIFO queue-like interface that may serve as a simple waiting list.

## Requirements:

1. The user should be able to add themselves (i.e. their address) to the end of the queue by calling the `push` method. It should take no arguments;
2. A deposit of at least **0.1 ether** is required for a push operation to succeed. The deposit should be kept by the contract and be returned to user on `pop` (see point 5);
3. The contract should keep the number of items in the queue and serve it via `size()` method;
4. All items in the queue should be accessible via `get` method. It should take the index of an item as an argument and return the tuple containing address and deposit size. Trying to get an item from an empty queue should revert. Getting an item with non-existing index should also revert;
5. Calling the `pop` method should remove an item from the front of the queue. It should be callable only by the contract owner. Upon calling the method the deposit made by the user on `push` should be returned to them in the exact same amount. Popping an empty queue should revert;
6. The following gas limits should be met:

    | Operation | Gas limit |
    | --------- | --------- |
    | push      | 75000     |
    | pop       | 61000     |

## Summary:

Your task is to implement four interface methods according to the requiremens:

-   `push() external payable`
-   `pop() external`
-   `size() external view returns(uint)`
-   `get(uint index) external view returns(address, uint)`

Keeping the function signatures as specified above is also a requirement.
