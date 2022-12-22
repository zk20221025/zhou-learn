// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

contract DoSGame {
    bool public refundFinished;
    mapping(address => uint256) public balanceOf;
    address[] public players;
}