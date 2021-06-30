// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.0;

import '@openzeppelin/contracts/access/Ownable.sol';


abstract contract Admin is Ownable{
    event AddAdminLog(address indexed newAdmin);
    event RemoveAdminLog(address indexed removedAdmin);
    address[] admin;
    mapping(address=>bool) records;
    
    /**
    * @dev Modifier to check if function called by registered admins.
    */
    modifier onlyAdmin(){
        require(records[msg.sender]==true, "msg.sender must be admin");
        _;
    }

    /**
    * @dev Constructor. Set the creator of the contract as one of admin.
    */
    constructor() {
        admin.push(msg.sender);
        records[msg.sender] = true;
    }
    
    /**
    * @dev function to add new admin.
    * @param _address Address of new admin.
    */
    function addAdmin(address _address) onlyOwner() external {
        if (!records[_address]) {
            admin.push(_address);
            records[_address] = true;
            emit AddAdminLog(_address);
        }
    }

    /**
    * @dev function to remove an admin
    * @param _address Address of the admin that is going to be removed.
    */
    function removeAdmin(address _address) onlyOwner() external{
        for (uint i = 0; i < admin.length; i++) {
            if (admin[i] == _address) {
                delete admin[i];
                records[_address] = false;
                emit RemoveAdminLog(_address);
            }
        }
    }

    /**
    * @dev function to check whether the address is registered admin or not
    * @param _address Address to be checked.
    */
    function isAdmin(address _address) public view returns(bool) {
        return records[_address];
    }
}