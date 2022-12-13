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

    constructor(
        IERC20 token_,
        address beneficiary_,
        uint256 lockTime_
    ) {
        require(lockTime_ > 0 , "Tokenlock: lock time should greater than 0");
        token = token_;
        beneficiary = beneficiary_;
        lockTime = lockTime_;
        startTime = block.timestamp;

        emit TokenLockStart(beneficiary_ , address(token_) , block.timestamp , lockTime_);
    }

    function release() public {
        require(block.timestamp >= startTime+lockTime , "Tokenlock: current time is before release time");
        uint256 amount = token.balanceOf(address(this));
        require(amount > 0 , "Tokenlock: no tokens to release");
        token.transfer(beneficiary , amount);
        emit Release(msg.sender , address(token) , block.timestamp , amount);
    }
}