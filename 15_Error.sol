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

    function transferOwner2(uint256 tokenId , address newOwner) public {
        require(_owners[tokenId] != msg.sender , "transfer Not Owner");
        _owners[tokenId] = newOwner ;
    }
}
