// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

contract Attack {
    function attack() public {
        selfdestruct(payable(msg.sender));
    }
}
