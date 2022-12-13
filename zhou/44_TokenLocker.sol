// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "../31_IERC20.sol";
import "../31_ERC20.sol";

contract TokenLocker {
    event TokenLockStart(address indexed beneficiary , address indexed token , uint256 startTime , uint256 lockTime);
    event Release(address indexed beneficiary , address indexed token , uint256 releaseTime , uint256 amount);

    IERC20 public immutable token;
    address public immutable beneficiary;
    uint256 public immutable lockTime;
    uint256 public immutable startTime;

    
}