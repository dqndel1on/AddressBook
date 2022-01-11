// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/math/SafeMath.sol";

contract AddressBook {
    using SafeMath for uint;

    mapping(address => address[]) private _addresses;

    mapping(address => mapping(address => string)) private _aliases;

    // add data to _addresses and _aliases
    function addAddress(address _addr, string calldata _alias) external {
        _addresses[msg.sender].push(_addr);
        _aliases[msg.sender][_addr] = _alias;
    }

    function removeAddress(address addr) public {
        // get the length of the addresses in the array from the msg sender
        uint length = _addresses[msg.sender].length;
        for(uint i = 0; i < length; i++) {
            // if the address that you want to remove = one of the addresses you own 
            //and is one of the iterations of the loop
            if (addr == _addresses[msg.sender][i]) {
                //once we find the item in the array we need to delete the item
                //then shift each item down 1.  You can't just delete an item in the middle of an array
                //make sure the length of the address is not < 1 (this is needed because we are going to reorder the array)
                if(1 < _addresses[msg.sender].length && i < length-1) {
                    //shift the last item in the array to the position of the item that we are removing
                    _addresses[msg.sender][i] = _addresses[msg.sender][length-1];
                }

                // delete the item we just swapped from
                delete _addresses[msg.sender][length-1];
                //delete the alias for it
                delete _aliases[msg.sender][addr];
                //_state[msg.sender]++;
                break;
            }
        }
    }

    function getAddressArray(address _addr) view external returns(address[] memory){
        return _addresses[_addr];
    }

    function getAlias(address _owner,address _addr) view external returns(string memory) {
        return _aliases[_owner][_addr];
    }
}