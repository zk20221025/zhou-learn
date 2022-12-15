// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

contract Foo {
    bytes4 public selector1 = bytes4(keccak256("burn(uint256"));
    bytes4 public selector2 = bytes4(keccak256("collate_propagate_storage(bytes16)"));
}

contract TransparentProxy {
    address implementation;
    address admin;
    string public words;

    constructor(address _implementation) {
        admin = msg.sender;
        implementation = _implementation;
    }

    
}