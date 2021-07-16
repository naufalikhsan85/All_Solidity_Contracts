// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Burnable.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Pausable.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";
import "./Admin.sol";


contract TokenERC721 is
Admin,
ERC721,
ERC721Enumerable, 
ERC721URIStorage, 
ERC721Pausable, 
ERC721Burnable {
    using SafeMath for uint256;
    
    string private __baseURI;
    
    event TokenERC721Created(address minter, uint256 tokenId, uint256 timestamp);
    
    constructor(
        string memory name,
        string memory symbol,
        string memory baseURI
    )
    ERC721(name,symbol){
        
    }
    
    //override
    function supportsInterface(bytes4 interfaceId) public view virtual override(ERC721Enumerable, ERC721) returns (bool){
        return super.supportsInterface(interfaceId);
    }
    function _beforeTokenTransfer(address _from, address _to, uint256 _amount) internal override(ERC721Enumerable, ERC721Pausable, ERC721) {
        return super._beforeTokenTransfer(_from, _to, _amount);
    }
    function tokenURI(uint256 _tokenId) public view virtual override (ERC721URIStorage, ERC721) returns (string memory){
        return super.tokenURI(_tokenId);
    }
    function _baseURI() internal view virtual override returns (string memory) {
        return __baseURI;
    }
    function _burn(uint256 tokenId) internal virtual override(ERC721,ERC721URIStorage){
        return super._burn(tokenId);
    }
    
    //function part
     function mintERC721() public {
         uint256 tokenId = totalSupply();
        _safeMint(msg.sender, tokenId.add(1));
        emit TokenERC721Created(msg.sender, tokenId, block.timestamp);
     }
}
