// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

contract OnlyEven {
    constructor(uint a) {
        require(a != 0 , "invalid number");
        assert(a != 1);
    }

    function onlyEven(uint256 b) external pure returns(bool success) {
        require(b % 2 == 0 , "Ups! Reverting");
        success = true;
    }
}