pragma solidity ^0.8.7;
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";



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

  constructor() public ERC721("Bond", "BOND") {
    tokenCounter = 0;
    }




  //called by bond issuer to create bond
  function createBond(uint256 principal,uint256 payout,uint256 expiryDate) external returns (uint256) {
    verifyBond(principal, payout, expiryDate);
    uint256 newItemId = tokenCounter;
    tokenCounter = tokenCounter + 1;
    string memory bondURI = tokenURI(newItemId);
    _safeMint(msg.sender, newItemId);
    itemIdToSender[newItemId] = msg.sender;
    _setTokenURI(newItemId, bondURI);
    itemIdToTokenURI[newItemId] = bondURI;
    tokenIdToPrincipal[newItemId] = principal;
    tokenIdToPayout[newItemId] = payout;
    tokenIdToIssuanceDate[newItemId] = block.timestamp;
    tokenIdToExpiryDate[newItemId] = expiryDate;
    return newItemId;

  }

  function verifyBond(uint256 principal, uint256 payout, uint256 expiryDate) private view {
    require(principal >0, 'principal cannot be 0');
    require(payout > principal, 'payout must be greater than principal');
    require(expiryDate > block.timestamp, 'bond must expire in the future');
  }

    //called by owner of bond to get payment after expiry
  function excersizeBond(uint256 tokenId) external payable {
    require(_exists(tokenId), "ERC721URIStorage: URI query for nonexistent token");
    uint256 expiry = tokenIdToExpiryDate[tokenId];
    uint256 payout = tokenIdToPayout[tokenId];
    address issuer = itemIdToSender[tokenId];
    address owner = ownerOf(tokenId);
    require(owner == msg.sender, "you do not own this bond");
    require(owner != issuer, "you cannot excersize a bond you issued");
    require(expiry <= block.timestamp, "tried to get bond payout before bond expires!");
    //send something to a payments contract
    require(ETHBalances[issuer]>= payout, 'not enough funds deposited by issuer to honor bond!');
    //call default function
    ETHBalances[issuer] = ETHBalances[issuer] - (payout);
    ETHBalances[owner] = ETHBalances[owner] + (payout);
    emit Transfer(issuer, owner, payout);
    //todo use https://consensys.net/diligence/blog/2019/09/stop-using-soliditys-transfer-now/ instead of transfer

  }

  function depositETH() external payable {
    emit Deposit(msg.sender, msg.value);
    ETHBalances[msg.sender] += msg.value;

  }

  function withdrawETH() external payable {
    emit Withdrawal(msg.sender, msg.value);
    ETHBalances[msg.sender] -= msg.value;

  }


  //TODO: figure out collateral (use NFTs as collateral?)

  //TODO: create deployment scripts from here (https://betterprogramming.pub/how-to-create-nfts-with-solidity-4fa1398eb70a)




}



