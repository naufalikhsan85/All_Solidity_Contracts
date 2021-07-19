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
Admin, //is adminable?
ERC721,
ERC721Enumerable, //is enumerable?
ERC721URIStorage, 
ERC721Pausable, //is pausable?
ERC721Burnable //is burnable?
{
    using SafeMath for uint256;
    
    string private __baseURI;
    uint256 private tokenIdCounter;
    
    event TokenERC721Created(address minter, uint256 tokenId, uint256 timestamp);
    event TokenERC721BurnedByAdmin(address burner, address account, uint256 tokenId, uint256 timestamp);
    
    constructor(
        string memory name,
        string memory symbol,
        string memory baseURI
    )
    ERC721(name,symbol){
        __baseURI = baseURI;
    }
    
    //override
    function supportsInterface(bytes4 interfaceId) public view virtual override(ERC721Enumerable, ERC721) returns (bool){
        return super.supportsInterface(interfaceId);
    }
    function _beforeTokenTransfer(address _from, address _to, uint256 _amount) internal virtual override(ERC721Enumerable, ERC721Pausable, ERC721) {
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
    
     //additional function part
     
     //mint with token id counter
     function _mintERC721(string memory _tokenURI) public whenNotPaused{ //if public
     //function _mintERC721() internal virtual { //if internal
        tokenIdCounter=tokenIdCounter.add(1);
        _safeMint(msg.sender, tokenIdCounter);
        
        if(bytes(_tokenURI).length > 0){ //token uri not empty
            _setTokenURI(tokenIdCounter, _tokenURI);
        }
        
        emit TokenERC721Created(msg.sender, tokenIdCounter, block.timestamp);
     }
     
     //burn by admin
     function _burnERC721byAdmin(address _account, uint256 _tokenId) public whenNotPaused onlyAdmin{
        require(ownerOf(_tokenId) == _account,"account must owner of token id");
        _burn(_tokenId);
        emit TokenERC721BurnedByAdmin(msg.sender, _account, _tokenId, block.timestamp);
     }
     
     //get last token id
     function _tokenIdCounter() public view returns(uint256){
         return tokenIdCounter;
     }
     
     //get list token by owner (ERC721Enumerable)
     function _getListTokenByOwner(address _owner) public view returns (uint256 count, uint256[] memory listToken){
        uint256[] memory list = new uint256[](balanceOf(_owner));
        for(uint256 i = 0; i< balanceOf(_owner); i++){
            list[i]= tokenOfOwnerByIndex(_owner,i);
        }
        return (list.length,list);
     }
     
     //get list token (ERC721Enumerable)
     function _getListToken() public view returns (uint256 count, uint256[] memory listToken){
        uint256[] memory list = new uint256[](totalSupply());
        for(uint256 i = 0; i< totalSupply(); i++){
            list[i]= tokenByIndex(i);
        }
        return (list.length,list);
     }
}
