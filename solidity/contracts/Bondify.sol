pragma solidity ^0.8.7;
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";


contract Bondify is ERC721URIStorage {

  uint256 public tokenCounter;

  constructor() public ERC721("Bond", "BOND") {
    tokenCounter = 0;
    }
  function createBond(string memory bondURI) public returns (uint256) {
    uint256 newItemId = tokenCounter;
    _safeMint(msg.sender, newItemId);
    _setTokenURI(newItemId, bondURI);
    tokenCounter = tokenCounter + 1;
    return newItemId;

  }




}



