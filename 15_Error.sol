// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;
error TransferNotOwner();

contract Errors {
    mapping(uint256 => address) private _owner;

    function transferOwner1(uint256 TokenId , address _newOwner) public {
        if (_owners[TokenId] != msg.sender) {
            revert transferNotOwner() ;
        }
        _owners[TokenId] = newOwner ;
    }
}
