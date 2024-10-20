# Solutions

### Hello Ethernaut (Level 1)
```javascript
await contract.info()
await contract.info1()
await contract.info2("hello")
await contract.infoNum()
await contract.info42()
await contract.theMethodName()
await contract.method7123949()
await contract.password()
await contract.authenticate("ethernaut0")
```

### Fallback (Level 2)
```javascript
await contract.contribute({value:toWei("0.0001")})
await contract.getContribution()
web3.eth.sendTransaction({from:player,to:contract.address , value:web3.utils.toWei('0.0001','ether')})
await contract.withdraw()
```

### Fallout (Level 3)
```javascript
await contract.Fal1out()
```
Basically the story about Rubixi, that changed the contract name but not the old constructor.

### Coin Flip (Level 4)
The solution is in ```coin-flip.sol```, but basically we create another contract with a function to get the correct guess using the same logic the original coin flip uses to determine which side the coin flipped. The problem here is that the strategy to generate a random side does not generate a random side in fact and it is easily reproduced.

### Telephone (Level 5)
The solution is in ```telephone.sol``` and consisted of calling the function to change ownership with the player address as parameter but from another contract, so tx.origin is not the address of the player.

### Token (Level 6)
The idea to solve this is to cause an onverflow, because the subtraction of tokens from balances is done by simply doing
```javascript
balances[msg.sender] -= _value;
```
we can transfer all our tokens to the address of the contract for example, and then transfer an extra token, this will put our balance to the maximum of uint256.

### Delegation (Level 7)
This level taught how do fallback methods and delegatecall works. By sending a transaction to a contract that did not have a receive function prepared, we force the execution of the fallback function, in which there is a delegatecall method to the contract delegate. The idea here is to call the pwn() function from the Delegate contract but with delegatecall, which makes the Delegation contract run the pwn function from Delegate but with its own msg.sender, msg.value and more important to this, its own storage.
```javascript
web3.eth.sendTransaction({from: player, to: contract.address, data: web3.eth.abi.encodeFunctionSignature("pwn()")})
```

### Force (Level 8)
In this level, we had to send money to an empty contract, which did not have fallback neither receive methods. The solution for this challenge was to create another contract that was able to receive money and then self destruct with the address of the original empty contract, so the balance of my contract was transfered to the empty one. (force.sol)

### King (Level 9)
The solution of this level is in ```king.sol``` but basically what happened is that we create another contract that is payable on constructor and sends the money to the original King contract to become king, but the receive and fallback methods of that contract are all malicious (reverts). What happens is that when the level tries to claim back ownership of the contract, the transfer function fails and the operation is never concluded. The contract needed to implement error handling and possibly a separate function for the king that was dethroned to reclaim funds for this not to happen.

### Re-entrancy (Level 10)
This was a funny one, I had transferred 0.003 eth to the contract until I found a solution and then forgot to make a function in my contract to withdraw the values back, so in the end I got nothing back =). The solution is in ```re-entracy.sol```, but all I did was to call the original Re-Entrancy contract withdraw inside my fallback function and voilá, all the money of the contract in my pockets (or not).

### Elevator (Level 11)
No secret here, just a simple flag that detects that is the second time calling the ```isLastFloor``` function and returns true the second time so the elevator contract top variable is true;