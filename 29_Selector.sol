// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;
contract Selector {

    event Log(bytes data);

    function mint(address to) external {
        emit Log(msg.data);
    }

}