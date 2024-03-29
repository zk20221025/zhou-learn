// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Recovery {

    function generateToken(string memory _name, uint256 _initialSupply) public {
        new SimpleToken(_name, msg.sender, _initialSupply);
  
    }
}

contract SimpleToken {

    string public name;
    mapping (address => uint) public balances;

    constructor(string memory _name, address _creator, uint256 _initialSupply) {
        name = _name;
        balances[_creator] = _initialSupply;
    }

    receive() external payable {
        balances[msg.sender] = msg.value * 10;
    }

    function transfer(address _to, uint _amount) public { 
        require(balances[msg.sender] >= _amount);
        balances[msg.sender] = balances[msg.sender] - _amount;
        balances[_to] = _amount;
    }

    function destroy(address payable _to) public {
        selfdestruct(_to);
    }
}

//从实例地址找到代币合约地址，remix部署SimpleToken，在At address中填写代币合约地址，然后destroy