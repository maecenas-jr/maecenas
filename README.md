# maecenas

I've got the idea when I contemplated why there is no Patreon service rip-off that accepts cryptocurrencies. The main idea of Patreon is that it's a mediator service that charges you some sum every month and relates it to the creator of your choice who provide you some premium content in return. Check it out if you don't know the site, there is a lot of good campaigns going. It's very handy, you just register, enter your  card data, enter a sum you're willing to spend and get a very satisfying billing messages every month.

Obvoius way to replicate that with Etherium are kinda unwieldy. You either have to send payment yourself every month or make a contract to do that for you, but you still got to figure how to trigger it, also you have to watch for your recipient wallet change (due to key theft or something). It's a chore, I wouldn't bother with it but I'm a long-time Patreon user. 

So I designed a bastard child of a checkbook and a debit card to solve that issue. It's a contract that stores what I call checks: a data structure that contains some info on how the money can be redeemed (maximum amount, timeout between checkouts, fixed receiver, expiration date etc.) and a public key.

If a redeem function is called with fitting parameters (time, sum and receiver are not restricted by check's parameters), hash of call parameters is properly signed by a private key corresponding to a public key stored in check and there's enough ether on checkbook's balance, the caller gets the money.

I intend to substitute this with a Parity DApp where you can create a checkbook and and a check, generating a check secret represented by a string of symbols that contain private key and a check's address in the blockchain. Check can be redeemed by copypasting a check to a text field. I think it's a fairly simple to incorporate in a webapp to use for simple small transactions, post-paid services etc. You only need to trust the receiver a little.

Contracts for this are not very expensive: checkbook is about 500k gas, I think, and both making a check and redeeming it amount to a under a 100k gas. I'd like to know your opinion on this. I'd appreciate a code review now and then, and an advice on whether I should make an interface and/or a library out of this.
