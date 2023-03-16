// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Vault {
  bool public locked;
  bytes32 private password;

  constructor(bytes32 _password) {
    locked = true;
    password = _password;
  }

  function unlock(bytes32 _password) public {
    if (password == _password) {
      locked = false;
    }
  }
}

// locked存储在slot 0 ， password虽然设为了 private，但是在区块中的数据仍然是可见的，存储在slot 1
//await web3.eth.getStorageAt(instance, 1)
//await contract.unlock(password)