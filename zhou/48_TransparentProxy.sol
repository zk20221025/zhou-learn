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

    fallback() external payable {
        require(msg.sender != admin);
        (bool success , bytes memory data) = implementation.delegatecall(msg.data);
    }

    function upgrade(address newImplementation) external {
        if (msg.sender != admin) revert();
        implementation = newImplementation;
    }
}

contract Logic1 {
    address public implementation; 
    address public admin; 
    string public words;

    function foo() public{
        words = "old";
    }
}