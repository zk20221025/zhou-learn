// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;
contract ABIEncode {

    uint x = 10;
    address addr = 0x7A58c0Be72BE218B41C608b7Fe7C5bB630736C71;
    string name = "0xAA";
    uint[2] array = [5,6];

    function encode() public view returns (bytes memory result) {
        result = abi.encode(x , addr , name , array);
    }

    
}