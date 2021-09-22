pragma solidity ^0.8.7;
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";


// interface Aion
contract Aion {
    uint256 public serviceFee;
    function ScheduleCall(uint256 blocknumber, address to, uint256 value, uint256 gaslimit, uint256 gasprice, bytes memory data, bool schedType) public payable returns (uint,address);

}

contract Bondify is ERC721URIStorage, ERC721Burnable {

  uint256 public tokenCounter;
  enum Compounding{ANNUAL, MONTHLY, WEEKLY, DAILY, CONTINOUS}
  mapping(uint256 => address) public itemIdToSender;
  mapping(uint256 => string) public itemIdToTokenURI;
  mapping(uint256 => uint256) public tokenIdToPrincipal;
  mapping(uint256=> uint256) public tokenIdToPayout; 
  mapping (uint256 => uint256) tokenIdToIssuanceDate;
  mapping (uint256 => uint256) tokenIdToExpiryDate;
  Aion aion;

  constructor() public ERC721("Bond", "BOND") {
    tokenCounter = 0;
    }


  function excersizeBond(string memory bondURI) external {
    itemID = _tokenURIs[bondURI];
    require(_exists(tokenId), "ERC721URIStorage: URI query for nonexistent token");
    expiry = tokenIdToExpiryDate[itemID];
    payout = tokenIdToPayout[itemID];
    issuer = itemIdToSender[itemID];
    require(owner(bondURI) == msg.sender, "you do not own this bond");
    require(owner(bondURI) != issuer, "you cannot excersize a bond you issued");
    require(payout <= block.timestamp, "tried to get bond payout before bond expires!");
    //send something to a payments contract
    token.transferFrom(issuer,owner(bondURI), payout);

  }


  function createBond(string memory bondURI,uint256 principal,uint256 payout,uint256 expiryDate) external returns (uint256) {
    verifyBond(princiapl, payout, expiryDate);
    uint256 newItemId = tokenCounter;
    tokenCounter = tokenCounter + 1;
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

  function verifyBond(uint256 principal, uint256 payout, uint256 expiryDate) private returns (void) {
    require(principal >0, 'principal cannot be 0');
    require(payout > principal, 'payout must be greater than principal');
    require(expiryDate > block.timestamp, 'bond must expire in the future');
  }



  //TODO: figure out how to do bond payouts

  //TODO: figure out how to access structs/display mapping info

  //TODO: create deployment scripts from here (https://betterprogramming.pub/how-to-create-nfts-with-solidity-4fa1398eb70a)




}



