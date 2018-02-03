# Solidity-Oraclize-Betting-Game
A simple Smart contract created in Solidity with Oraclize services to play betting game.

The first working version of the 'Betting' contract created and tested on ORACLIZE REMIX DAPP. 
To test the code execute functions in below sequence:

1. Invoke 'setBetQuestion' by writing a question. As of now, code supports only those questions which give a numerical result. Sample questions include square root of 9, a random number between 2 and 10. This function should be invoked by contract owner account only.
2. Then invoke 'putBet' function. This function cannot be invoked by contract owner account. As function parameter pass the answer to the question. Also, provide ether while invoking the function. This amount will be treated as bet amount by function and double of this amount will be rewarded if the answer is correct.
3. Then invoke 'playBet' function. This function cannot be invoked by contract owner account. This function will trigger Oraclize services and compare the answers given by the user and Oraclize 'WolframAlpha' service. If same then the user will be rewarded with twice the amount else he will lose all the ether.

Administrator level functions that can be invoked only my contract owner:
1. transferbetamount : to issue a refund to an address in case of any dispute or to transfer ether to contract in case its balance is less than a threshold to receive bets.
2. destroy:  to destroy the contract.

Simple Call functions:
1. getBalance : to get the balance of an account.
2. getbalancebyAddress:  to get the balance of an account by passing an account address as an input parameter.
