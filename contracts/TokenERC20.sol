// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.0;


import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Pausable.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";
import "./Admin.sol";

contract TokenERC20 is Admin, ERC20Pausable {

  using SafeMath for uint256;
  
  uint256 public INITIAL_SUPPLY;
  uint8 private _decimals;

    constructor( //set token name, symbol, initial supply, decimals
        string memory _setName,
        string memory _setSymbol,
        uint256 _setInitial_supply,
        uint8 _setDecimals
    )
    ERC20(_setName, _setSymbol) { 
        
        INITIAL_SUPPLY = _setInitial_supply*(10 ** uint256(_setDecimals));
        _decimals = _setDecimals;
        _mint(msg.sender, INITIAL_SUPPLY);
    }
  
    function decimals() public view virtual override returns (uint8) {
        return _decimals;
    }
    
    //pausable
    function pause() public onlyOwner whenNotPaused {
        return _pause();
    }

    function unpause() public onlyOwner whenPaused {
        return _unpause();
    }
    
    function mint(address account, uint256 amount) public whenNotPaused onlyAdmin { //mint tokn to some address
        return _mint(account, amount);
    }
    
    function burn(uint256 amount) public whenNotPaused { //burn your token
        return _burn(msg.sender, amount);
    }

}