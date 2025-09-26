# Gift Coin

For this challenge we're going to deploy a new currency to our blockchain! The contract contains a couple state variables: `owner` and `coins`. The `owner` variable is a hexidecimal address that will correspond to the address on the blockchain of the account who deployed the smart contract. The `coins` are a mapping of hexidecimal blockchain addresses to their corresponding amount of coins that they own.

**Challenge:**

-   Fill out the `sendGift` function. It should only send a gift if the account making the transaction has enough coins to cover the amount they plan to gift. Should have they have sufficient funds, the funds should be subtracted from that account and added to the beneficiary's account. Then we should broadcast the `GiftSent` event for logging purposes and so applications can respond to these events.

-   Complete the `onlyOwner` modifier. It is a modifier meant for the `mintCoins` function, which should only be allowed to be called by the owner of the contract. We can't just let anyone create new gift coins!
