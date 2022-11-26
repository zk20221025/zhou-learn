// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;
contract OtherContract {
    uint256 private _x = 0;
    event Log(uint amount , uint gas);

    function getBalance() view public returns(uint) {
        return address(this).balance;
    }

    function setX(uint256 x) external payable {
        _x = x ;
        if (msg.value > 0) {
            emit Log(msg.value , gasleft());
        }
    }

    function getX() external view returns(uint x) {
        x = _x ;
    }
}