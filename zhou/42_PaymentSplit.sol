// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

contract PaymentSplit {
    event PayeeAdded(address account , uint256 shares);
    event PaymentReleased(address to , uint256 amount);
    event PaymentReceived(address from , uint256 amount);

    uint256 public totalShares;
    uint256 public totalRealeased;

    mapping(address => uint256) public shares;
    mapping(address => uint256) public released;
    address[] public payees;

    
}