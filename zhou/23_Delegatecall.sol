// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

contract C {
    uint public num;
    address public sender;

    function setVars(uint _num) public payable {
        num = _num;
        sender = msg.sender;
    }
}

contract B {
    uint public num;
    address public sender;

    function callSetVars(address _addr , uint  _num) external payable {
        (bool success , bytes memory data) = _addr.call(
            abi.encodeWithSignature("setVars(uint256)" , _num)
        );
    }

    function delegatecallSetVars(address _addr , uint _num) external payable {
    (bool success , bytes memory data) = _addr.delegatecall(
        abi.encodeWithSignature("setVars(uint256)" , _num)
    );  
    }
}