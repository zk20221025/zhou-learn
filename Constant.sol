// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;
contract Constant {
    uint256 constant CONSTANT_NUM = 10;
    string constant CONSTANT_STRING = "0xAA";
    bytes constant CONSTANT_BYTES = "WTF";
    address constant CONSTANT_ADDRESS = 0x0000000000000000000000000000000000000000;
    uint256 public immutable IMMUTABLE_NuM = 999999999;
    address public immutable IMMUTABLE_ADDRESS;
    uint256 public immutable IMMUTABLE_BLOCK;
    uint256 public immutable IMMUTABLE_TEST;
    constructor() {
        IMMUTABLE_ADDRESS = address(this);
        IMMUTABLE_BLOCK = block.number;
        IMMUTABLE_TEST = test();

    }
    function test() public pure returns(uint256){
        uint256 what = 9;
        return(what);
    }
}