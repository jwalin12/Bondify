# Bondify Project

This project demonstrates the utility and functionality of a cryptographic bond market tied to etherium. This decentralized market offers competitive and viable alternatives to private bank bonds which are often very expensive. 

## Bondify API
```contracts/Bondify.sol``` Contains the main code to create and access a contract. 
```createBond(uint256 principal,uint256 payout,uint256 expiryDate)```
Input: in principle, payout amount, and expiration date to create an open zeppelin smart contract 
Output: pointer to the created smart contract.
Usage: An issuer of the bond can use createBond to initialize a bond they want to sell. This can then be listed on the market.

```exerciseBond(uint256 tokenId)```
	Input: token id of a smart contract
	Output: N/A
Useage: The owner of the smart contract should call this function when the contract has reached its expiration date. At this point, They will be transferred the required money needed

## Unit Testing

```Test/Bondify.js```
Runs unit tests for Bondify.sol.

Tests minting, exercising, and depositing / widthdrawal

### Minting - Tests creation of the bonds. 

edge cases - 
  1. should fail if principal is higher than payout
  2. should fail if principal is less than or equal to 0
  3. should fail if expiry is in the past


### Exercising - Tests if the bond contract can successfully exercise the bond 

edge cases -
  1. should work when bond is transferred between users and new owner tries to  excersize
  2. should fail when the bond has not expired
  3. should fail if there is not enough money in the smart contract

### Deposit and Withdrawal - Tests if you can successfully deposit and withdraw money


Try running some of the following tasks:

```shell
npx hardhat accounts
npx hardhat compile
npx hardhat clean
npx hardhat test
npx hardhat node
node scripts/sample-script.js
npx hardhat help
```
