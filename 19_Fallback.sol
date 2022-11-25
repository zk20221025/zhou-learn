// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;
contract Fallback {
    event Received (address Sender , uint256 Value);
    event fallbackCalled (address Sender , uint256 Value , bytes Data);
    receive() external payable {
        emit Received(msg.sender , msg.value);
    }
    fallback() external payable {
        emit fallbackCalled(msg.sender , msg.value , msg.data);
    }

}