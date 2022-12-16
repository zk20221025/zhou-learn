// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

contract Bank {
    mapping (address => uint256) public balanceOf;

    function deposit() external payable {
        balanceOf[msg.sender] += msg.value;
    }

    
}