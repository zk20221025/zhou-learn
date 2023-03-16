// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

contract UncheckedBank {
    mapping (address => uint256) public balanceOf;

    function deposit() external payable {
        balanceOf[msg.sender] += msg.value;
    }

    function withdraw() external {
        uint256 balance = balanceOf[msg.sender];
        require(balance > 0 , "Insufficient balance");
        balanceOf[msg.sender] = 0;
        bool success = payable(msg.sender).send(balance);
    }

    function getBalance() external view returns (uint256) {
        return address(this).balance;
    }
}

contract Attack {
    UncheckedBank public bank;

    constructor(UncheckedBank _bank) {
        bank = _bank;
    }

    receive() external payable {
        revert();
    }

    function deposit() external payable {
        bank.deposit{value: msg.value}();
    }

    function withdraw() external payable {
        bank.withdraw();
    }

    function getBalance() external view returns (uint256) {
        return address(this).balance;
    }
}