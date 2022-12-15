// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

contract SimpleUpgrade {
    address public implementation;
    address public admin;
    string public words;

    constructor(address _implementation) {
        admin = msg.sender;
        implementation = _implementation;
    }
}