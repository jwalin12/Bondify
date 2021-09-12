pragma solidity ^0.8.7;

contract Bondify {



/**
Reading data out of these “storage” structures is free 
and you don’t have to wait for the next block either
nodes will just read the data and return it to you right away.
 */

  mapping ( bytes32 => notarizedBond) notarizedBonds; // this allows to look up notarizedBonds by their SHA256notaryHash
  bytes32[] bondsByNotaryHash; // this is like a whitepages of all bonds, by SHA256notaryHash
  address BondifyAdmin; 
  mapping ( address => User ) Users;   // this allows to look up Users by their ethereum address
  address[] usersByAddress;  // this is like a whitepages of all users, by ethereum address





    struct notarizedBond {
        int principal;
        int maturity;
        int coupon;
        int price;
        uint timestamp;
    }
    struct User {
        bytes32[] myBonds;
  }


  function addBondToUser(bytes32 SHA256notaryHash) private returns (bool success) {

       address thisNewAddress = msg.sender;

  }





}

