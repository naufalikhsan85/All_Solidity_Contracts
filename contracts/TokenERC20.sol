// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Pausable.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Capped.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Snapshot.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";
import "./Admin.sol";

contract TokenERC20 is
Admin,
ERC20,
ERC20Pausable,
ERC20Burnable,
ERC20Capped,
ERC20Snapshot {

  using SafeMath for uint256;
  
  uint256 public initial_supply;
  uint8 private _decimals;
  
  event MintByAdmin(address admin, address to, uint256 amount, uint256 timeStamp);
  event BurnByAdmin(address admin, address account, uint256 amount, uint256 timeStamp);

    constructor( //set token name, symbol, initial supply, decimals
        string memory _setName,
        string memory _setSymbol,
        //uint256 _setInitial_supply,
        uint8 _setDecimals,
        uint256 _setCap
    )
    ERC20(_setName, _setSymbol)
    ERC20Capped(_setCap*(10 ** uint256(_setDecimals))){ 
        _decimals = _setDecimals;
        
        //if you want mint initial_supply while deploy contract
        //initial_supply = _setInitial_supply*(10 ** uint256(_setDecimals));
        //_mint(msg.sender, INITIAL_SUPPLY);
        
    }
    
    //override
    function decimals() public view virtual override returns (uint8) {
        return _decimals;
    }
    function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual override(ERC20,ERC20Pausable,ERC20Snapshot){
        super._beforeTokenTransfer(from, to, amount);
    }
    function _mint(address account, uint256 amount) internal virtual override (ERC20,ERC20Capped) {
        super._mint(account,amount);
    }
    
    //pausable part
    function pause() public onlyOwner whenNotPaused {
        return _pause();
    }

    function unpause() public onlyOwner whenPaused {
        return _unpause();
    }
    
    
    //function part
    function mintByAdmin(address _to, uint256 _amount) public whenNotPaused onlyAdmin {
        if(initial_supply == 0){
            initial_supply = _amount*(10 ** uint256(decimals()));  //mint initial_supply
        }
        _mint(_to, _amount);
        emit MintByAdmin(msg.sender, _to, _amount, block.timestamp);
    }
    
    function burnByAdmin(address _account, uint256 _amount) public whenNotPaused onlyAdmin {
        _burn(_account, _amount);
        emit BurnByAdmin(msg.sender, _account, _amount, block.timestamp);
    }
    

}