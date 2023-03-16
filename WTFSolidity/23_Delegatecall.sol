// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

/**
* delegatecall在调用合约时可以指定交易发送的gas，但不能指定发送的ETH数额
* delegatecall有安全隐患，使用时要保证当前合约和目标合约的状态变量存储结构相同，并且目标合约安全，不然会造成资产损失。
* delegatecall 应用场景：
* 1.代理合约（Proxy Contract）：将智能合约的存储合约和逻辑合约分开：代理合约（Proxy Contract）存储所有相关的变量，并且保存逻辑合约的地址；
*  所有函数存在逻辑合约（Logic Contract）里，通过delegatecall执行。当升级时，只需要将代理合约指向新的逻辑合约即可。
* 2.EIP-2535 Diamonds（钻石）：钻石是一个支持构建可在生产中扩展的模块化智能合约系统的标准。钻石是具有多个实施合同的代理合同。
*/



contract B {
    //代理合约状态变量需与逻辑合约存储结构相同；
    uint public num;
    address public sender;
    // 通过call来调用C的setVars()函数，将改变合约C里的状态变量
    function callSetVars(address _addr , uint  _num) external payable {
        (bool success , bytes memory data) = _addr.call(
            abi.encodeWithSignature("setVars(uint256)" , _num)
        );
    }
    // 通过delegatecall来调用C的setVars()函数，将改变合约B里的状态变量

    function delegatecallSetVars(address _addr , uint _num) external payable {
    (bool success , bytes memory data) = _addr.delegatecall(
        abi.encodeWithSignature("setVars(uint256)" , _num)
    );  
    }
}

contract C {
    uint public num;
    address public sender;

    function setVars(uint _num) public payable {
        num = _num;
        sender = msg.sender;
    }
}

    //代理合约状态变量需与逻辑合约存储结构相同；
    // 通过call来调用C的setVars()函数，将改变合约C里的状态变量(同时可以发送ETH)
    // 通过delegatecall来调用C的setVars()函数，将改变合约B里的状态变量(仅能发送gas)

contract B1 {
    uint public num;
    address public sender;

    function callSetVars(address _addr , uint _num) external payable {
        (bool success , bytes memory data) = _addr.call(abi.encodeWithSignature("setVars(uint256)" , _num));
    } 

    function delegatecallSetVars(address _addr , uint _num) external payable {
        (bool success , bytes memory data) = _addr.delegatecall(abi.encodeWithSignature("setVars(uint256)" , _num));
    }
}