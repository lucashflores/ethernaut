# Solutions

### Hello Ethernaut (Level 0)
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

### Fallback (Level 1)
```javascript
await contract.contribute({value:toWei("0.0001")})
await contract.getContribution()
web3.eth.sendTransaction({from:player,to:contract.address , value:web3.utils.toWei('0.0001','ether')})
await contract.withdraw()
```

### Fallout (Level 2)
```javascript
await contract.Fal1out()
```
Basically the story about Rubixi, that changed the contract name but not the old constructor.

### Coin Flip (Level 3)
The solution is in ```coin-flip.sol```, but basically we create another contract with a function to get the correct guess using the same logic the original coin flip uses to determine which side the coin flipped. The problem here is that the strategy to generate a random side does not generate a random side in fact and it is easily reproduced.

### Telephone (Level 4)
The solution is in ```telephone.sol``` and consisted of calling the function to change ownership with the player address as parameter but from another contract, so tx.origin is not the address of the player.

### Token (Level 5)
The idea to solve this is to cause an onverflow, because the subtraction of tokens from balances is done by simply doing
```javascript
balances[msg.sender] -= _value;
```
we can transfer all our tokens to the address of the contract for example, and then transfer an extra token, this will put our balance to the maximum of uint256.

### Delegation (Level 6)
This level taught how do fallback methods and delegatecall works. By sending a transaction to a contract that did not have a receive function prepared, we force the execution of the fallback function, in which there is a delegatecall method to the contract delegate. The idea here is to call the pwn() function from the Delegate contract but with delegatecall, which makes the Delegation contract run the pwn function from Delegate but with its own msg.sender, msg.value and more important to this, its own storage.
```javascript
web3.eth.sendTransaction({from: player, to: contract.address, data: web3.eth.abi.encodeFunctionSignature("pwn()")})
```

### Force (Level 7)
In this level, we had to send money to an empty contract, which did not have fallback neither receive methods. The solution for this challenge was to create another contract that was able to receive money and then self destruct with the address of the original empty contract, so the balance of my contract was transfered to the empty one. (force.sol)

### Vault (Level 8)
The main lesson that I took from this is that everything in the blockchain is public. If you store a password in the contract, it needs to be encrypted, otherwise I can use a network explorer and find the contract creation code in bytes and just take the password from there.

### King (Level 9)
The solution of this level is in ```king.sol``` but basically what happened is that we create another contract that is payable on constructor and sends the money to the original King contract to become king, but the receive and fallback methods of that contract are all malicious (reverts). What happens is that when the level tries to claim back ownership of the contract, the transfer function fails and the operation is never concluded. The contract needed to implement error handling and possibly a separate function for the king that was dethroned to reclaim funds for this not to happen.

### Re-entrancy (Level 10)
This was a funny one, I had transferred 0.003 eth to the contract until I found a solution and then forgot to make a function in my contract to withdraw the values back, so in the end I got nothing back =). The solution is in ```re-entracy.sol```, but all I did was to call the original Re-Entrancy contract withdraw inside my fallback function and voilá, all the money of the contract in my pockets (or not).

### Elevator (Level 11)
No secret here, just a simple flag that detects that is the second time calling the ```isLastFloor``` function and returns true the second time so the elevator contract top variable is true;

### Privacy (Level 12)
Another block explorer one, just get the bytecode of the creation of the contract, get the last 64 hex characters that represent the last item of the array an I just had to learn that bytes16 cast of bytes32 will get the first 32 hex characters from left to right and not from right to left.

### Gatekeeper One (Level 13)
The most complicated part about this was the gasLeft thing, I was trying to determine which gas to use by trial and error for a long time before I decided to just use a brute force solution. The gatekey was easy to determine ```0x0000001000003Bad```, i just got a 8 byte string that the last 2 bytes were the last 2 bytes of my player address, and a different byte in the first 4 to conform to the second requirement.3

### Gatekeeper Two (Level 14)
The main thing to solve this one was to know that when something is called withing the constructor, the extcodesize will be 0 because the contract indeed have no code yet. For the gate key I just needed to do the inverse operation to calculate it. ```gatekeeper-two.sol```

### Naught Coin (Level 15)
The secret to this was to see ERC20 implementation and discover usage of approve and transferFrom, and also to use ```web3.utils.toBN()``` with the string version of the number to transfer, otherwise javascript will not accept it.

### Preservation (Level 16)
An important thing about delegatecall is that it runs the code from another contract but keeps the context of the contract that did the delegatecall. In this case, the problem was that when you call another contract via delegatecall, you need to be sure that the storage of that contract follows the same pattern as your contract, because solidity when running a code that changes a storage variable, it does not look at the name or type of the variable, it only looks at the position of that variable in storage, so in the timezone library, the only variable was uint256 storedTime, so when it tries to change that, it looked at the first position of storage in Preservation, which was timeZone1Library address variable. The solution to claim ownership was to pass in the setFirstTime function an address in the uint format of a malicious contract that implements the setTime function but what the function does is to change the owner of the contract, which will be executed in Preservation context. The malicious contract needs to have a similar storage schema for this to work, that is, three adresses, a uint256 and a bytes4 variables. The code is in ```preservation.sol```.

### Recovery (Level 17)
This was an easy one, by looking at the instance contract in a block explorer, we can see internal transactions and then discover the address of the lost contract. With the address in hand, we can just call destroy with the desired recipient address and that's it.

### Magic Number (Level 18)
For this I needed guidance to solve, but I followed the explanation of this website: https://dev.to/nvnx/ethernaut-hacks-level-18-magic-number-27ep and I liked learning what happens at the low level of the EVM and the freedom we have to deploy the bytecode directly to it.