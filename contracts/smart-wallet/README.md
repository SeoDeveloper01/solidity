# Smart Wallet

John wants you to help him create a wallet and develop a smart contract that he can deploy and own after verification. John wants to be the only one who can grant or revoke access to the wallet, and anyone with access should be able to add, spend, and view its balance.

John is hoping that you can set the maximum limit of the wallet to 10000 and ensure that its balance never exceeds this amount. The wallet should start with an initial balance of 0.

## Input:

-   `addFunds(uint amount)`: Allows adding funds to the wallet's balance, but the amount should not exceed 10000. Only John and the addresses he has granted access to can use this function;

-   `spendFunds(uint amount)`: Allows spending funds from the wallet's balance. Only John and the addresses he has granted access to can use this function. The balance cannot be negative;

-   `addAccess(address user)`: Grants access to address x to the smart contract. Only John (contract owner) has the authority to execute this function;

-   `revokeAccess(address user)`: Revokes the access of address y to the smart contract. Only John (contract owner) has the authority to execute this function.

## Output:

-   `viewBalance() returns (uint)`: Displays the current balance of the wallet. Only John and the addresses he has granted access to can use this function.
