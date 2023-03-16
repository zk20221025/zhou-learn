// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

contract Null {
    function kill() public {
        selfdestruct(payable(msg.sender));
    }
}