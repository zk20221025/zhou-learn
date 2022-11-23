// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;
contract s {

    uint [] array1;
    address private owner;

    modifier onlyOwner {
        require (msg.sender == owner);
        _;
    }

    constructor() {
        owner = msg.sender;
    }

    function save(uint[] calldata _number) public{
        for(uint i = 0; i < _number.length;i++){
            array1.push(_number[i]);
        }
    }
    function show() public view returns(uint[] memory array2){
        array2 = array1;
    }
    function Delete() public onlyOwner {
        array1.pop();
    }
    
}