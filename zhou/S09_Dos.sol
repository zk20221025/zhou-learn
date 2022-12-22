// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

contract DoSGame {
    bool public refundFinished;
    mapping(address => uint256) public balanceOf;
    address[] public players;

    function deposit() external payable {
        require(!refundFinished , "Game Over");
        require(msg.value > 0 , "Please donate ETH");
        balanceOf[msg.sender] = msg.value;
        players.push(msg.sender);
    }
}