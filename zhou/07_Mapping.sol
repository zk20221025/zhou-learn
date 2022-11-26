// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;
contract Mapping {
    mapping(uint => address) public inToaddress;
    mapping(address => address) public swapPair;
    function writeMap(uint _Key, address _Value) public {
        inToaddress[_Key] = _Value;
    }
}