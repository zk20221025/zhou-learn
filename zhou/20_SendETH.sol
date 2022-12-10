// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

error SendFailed();
error CallFailed();

contract ReceiveETH {
    event Log (uint amount , uint gas);

    receive() external payable {
        emit Log (msg.value , gasleft());
    }

    function getBalance() view public returns(uint) {
        return address(this).balance;
    }
}

contract SendETH {
    constructor() payable {}
    receive() external payable{}

    function transferETH (address payable _to , uint256 amount) external payable {
        _to.transfer(amount);
    }

    function sendETH (address payable _to , uint256 amount) external payable {
        bool success = _to.send(amount);
        if (!success) {
            revert SendFailed();
        }
    }

    function callETtH (address payable _to , uint256 amount) external payable {
        (bool success,) = _to.call{value: amount}("");
        if (!success) {
            revert CallFailed();
        }
    }
}