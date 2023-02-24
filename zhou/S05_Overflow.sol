// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

contract Token {
    mapping(address => uint) balances;
    uint public totalSupply;

    constructor(uint _initialSupply) {
        balances[msg.sender] = totalSupply = _initialSupply;
    }

    function transfer(address _to , uint _value) public returns (bool) {
        unchecked {
            require(balances[msg.sender] - _value >= 0);
            balances[msg.sender] -= _value;
            balances[_to] += _value;
        }
        return true;
    }

    function balanceOf(address _owner) public view returns (uint balance) {
        return balances[_owner];
    }
}
//8.0之前引入Safemath库即可避免
//8.0之后内置Safemath，上文是使用unchecked则临时关闭整型溢出检测，可节省gas