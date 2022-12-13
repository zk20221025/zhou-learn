// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "../31_ERC20.sol";

contract TokenVesting {
    event ERC20Released(address indexed token , uint256 amount);

    mapping(address => uint256) public erc20Released;
    address public immutable beneficiary;
    uint256 public immutable start;
    uint256 public immutable duration;

    constructor(
        address beneficiaryAddress,
        uint256 durationSeconds
    ) {
        require(beneficiaryAddress != address(0) , "VestingWallet: beneficiary is zero address");
        beneficiary = beneficiaryAddress;
        start = block.timestamp;
        duration = durationSeconds;
    }
}