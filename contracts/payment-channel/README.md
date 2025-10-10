# Payment Channel

You're tasked with creating a Simple Payment Channel smart contract for wholesale business. This contract will enable local shopkeepers to deposit, list payments for items, and close channels directly, simplifying transactions and improving the overall shopping experience for both parties.

## Input:

-   `constructor(address payable recipient)`: The constructor function should initialize the contract by setting the wholesale seller's address as the owner and the recipient of the contract. The recipient parameter sets the address that will receive the payments.

-   `deposit() payable`: This payable function should allow the local shopkeeper to deposit funds into the Simple Payment Channel. The function should check if the amount sent is greater than 0.

-   `listPayment(uint amount)`: This function should allow the local shopkeeper to list a new payment. The user should only be able to list a maximum of their deposited amount. The corresponding amount in wei should be reserved for the listed payment.

-   `closeChannel()`: This function should allow either the local shopkeeper or the wholesale seller to close the Simple Payment Channel. The function should check if the sender or the recipient is calling this function. All remaining funds in the channel should be transferred to the shopkeeper.

## Output:

-   `checkBalance() returns (uint)`: This function should return the current balance in the Simple Payment Channel.

-   `getAllPayments() returns (uint[])`: This function should return an array of all the payments listed in the Simple Payment Channel. Each element in the array represents the amount of a listed payment.
