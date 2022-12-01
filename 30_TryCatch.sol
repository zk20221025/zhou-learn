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

contract TryCatch {

    event SuccessEvent();
    event CatchEvent(string message);
    event CatchByte(bytes data);

    OnlyEven even;

    constructor() {
        even = new OnlyEven(2);
    }

    function execute(uint amount) external returns (bool success) {
        try even.onlyEven(amount) returns(bool _success) {
            emit SuccessEvent();
            return _success;
        } catch Error(string memory reason) {
            emit CatchEvent(reason);
        }
    }
}