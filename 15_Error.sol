// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;
error TransferNotOwner();

contract Errors {
    mapping(uint256 => address) private _owners;

    function transferOwner1(uint256 tokenId , address newOwner) public {
        if (_owners[tokenId] != msg.sender) {
            revert TransferNotOwner() ;
        }
        _owners[tokenId] = newOwner ;
    }


}
