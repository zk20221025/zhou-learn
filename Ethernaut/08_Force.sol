pragma solidity ^0.8.18;
 

contract Force {
    constructor() payable {

    }
    function destruct(address payable addr) public  {
        selfdestruct(addr);
    }
}

