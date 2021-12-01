// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "hardhat/console.sol";



contract Bondify is ERC721URIStorage {
  event Deposit(address sender, uint amount);
  event Withdrawal(address receiver, uint amount);
  uint256 public tokenCounter;
  enum Compounding{ANNUAL, MONTHLY, WEEKLY, DAILY, CONTINOUS}
  mapping(uint256 => address) public itemIdToSender;
  mapping(uint256 => string) public itemIdToTokenURI;
  mapping(uint256 => uint256) public tokenIdToPrincipal;
  mapping(uint256=> uint256) public tokenIdToPayout; 
  mapping (uint256 => uint256) tokenIdToIssuanceDate;
  mapping (uint256 => uint256) tokenIdToExpiryDate;
  mapping (address => uint256) ETHBalances;

  constructor() ERC721("Bond", "BOND") {
    tokenCounter = 1;
    }




  //called by bond issuer to create bond
  function createBond(uint256 principal,uint256 payout,uint256 expiryDate) external returns (uint256) {
    
    verifyBond(principal, payout, expiryDate);
    uint256 newItemId = tokenCounter;
    console.log(newItemId);
    tokenCounter = tokenCounter + 1;
    _safeMint(msg.sender, newItemId);
    string memory bondURI = tokenURI(newItemId);
    itemIdToSender[newItemId] = msg.sender;
    _setTokenURI(newItemId, bondURI);
    itemIdToTokenURI[newItemId] = bondURI;
    tokenIdToPrincipal[newItemId] = principal;
    tokenIdToPayout[newItemId] = payout;
    tokenIdToIssuanceDate[newItemId] = block.timestamp;
    tokenIdToExpiryDate[newItemId] = expiryDate;
    console.log(newItemId, "created bond");
    return newItemId;

  }

  function verifyBond(uint256 principal, uint256 payout, uint256 expiryDate) private view {
    require(principal >0, 'principal must be greater than 0');
    require(payout > principal, 'payout must be greater than principal');
    uint256 time = block.timestamp;
    console.log("CURR TIME", time);
    console.log("EXPIRY TIME", expiryDate);
    console.log(expiryDate >= time);
    require(expiryDate >= time, 'bond must expire in the future');
  }

    //called by owner of bond to get payment after expiry
  function excersizeBond(uint256 tokenId) external payable {
    require(_exists(tokenId), "ERC721URIStorage: URI query for nonexistent token");
    console.log(tokenId," attemping to excersizing bond");
    uint256 expiry = tokenIdToExpiryDate[tokenId];
    uint256 payout = tokenIdToPayout[tokenId];
    address issuer = itemIdToSender[tokenId];
    address owner = ownerOf(tokenId);
    
    require(owner == msg.sender, "you do not own this bond");
    require(owner != issuer, "you cannot excersize a bond you issued");
    require(expiry <= block.timestamp, "tried to get bond payout before bond expires!");
    //send something to a payments contract
    require(ETHBalances[issuer]>= payout, 'not enough funds deposited by issuer to honor bond!');
    console.log("checks passed");
    //call default function
    ETHBalances[issuer] = ETHBalances[issuer] - (payout);
    ETHBalances[owner] = ETHBalances[owner] + (payout);
    emit Transfer(issuer, owner, payout);
    //todo use https://consensys.net/diligence/blog/2019/09/stop-using-soliditys-transfer-now/ instead of transfer

  }

  receive() external payable {
     ETHBalances[msg.sender] += msg.value;
     emit Deposit(msg.sender, msg.value);
 
  }

  function withdraw() external payable {
    address payable to = payable(msg.sender);
    uint256 val = ETHBalances[msg.sender];
    to.transfer(ETHBalances[msg.sender]);
    ETHBalances[msg.sender] = 0;
    emit Withdrawal(to, val);

  }

  //TODO: figure out collateral (use NFTs as collateral?)

  //TODO: create deployment scripts from here (https://betterprogramming.pub/how-to-create-nfts-with-solidity-4fa1398eb70a)




}



