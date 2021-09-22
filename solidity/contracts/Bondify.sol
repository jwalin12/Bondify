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


  function verifyPayout(string memory bondURI) {
    itemID = 
  }


  function createBond(string memory bondURI,uint256 principal,uint256 payout,uint256 expiryDate) public returns (uint256) {
    uint256 newItemId = tokenCounter;
    _safeMint(msg.sender, newItemId);
    itemIdToSender[newItemId] = msg.sender;
    _setTokenURI(newItemId, bondURI);
    itemIdToTokenURI[newItemId] = bondURI;
    tokenCounter = tokenCounter + 1;
    tokenIdToPrincipal[newItemId] = principal;
    tokenIdToPayout[newItemId] = payout;
    tokenIdToIssuanceDate[newItemId] = block.timestamp;
    tokenIdToExpiryDate[newItemId] = expiryDate;
    return newItemId;

  }



  //TODO: figure out how to do bond payouts


  //TODO: figure out how to access structs/display mapping info

  //TODO: create deployment scripts from here (https://betterprogramming.pub/how-to-create-nfts-with-solidity-4fa1398eb70a)




}



