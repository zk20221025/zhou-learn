// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

contract UUPSProxy {
    address public implementation;
    address public admin;
    string public words;

    construtor(address _implementation) {
        admin = msg.sender;
        implementation = _implementation;
    }

    fallback() external payable {
        (bool success , bytes memory data) = implementation.delegatecall(msg.data);
    }
}