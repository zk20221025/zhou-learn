// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;
contract Fallback {
    event Received (address sender , uint256 value);
    receive() external payable {
        emit Received(msg.sender , msg.value);
    }
}