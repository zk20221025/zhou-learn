// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;
contract IntialValue {
    bool public _bool;//false
    string public _student;//""
    int public _int; //0
    uint public _uint; // 0
    address public _address;//0x0000000000000000000000000000000000000000
    enum ActionSet {Buy,Hold,Sell}
    ActionSet public _enum;
    function fi() internal{}
    function fe() external{}
    uint[8] public _staticArray;//[0,0,0,0,0,0,0,0,]
    uint[] public _dynamicArrayl;//[]
    mapping(uint => address) public _mapping;
    struct Student{
       uint256 id;
       uint256 score;
    }
    Student public student;
    bool public _bool2 = true;
    function d() external {
        delete _bool2;
    }
}