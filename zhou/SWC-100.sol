pragma solidity ^0.4.24;

contract HashForEther {

    function withdrawWinnings() {
        // Winner if the last 8 hex characters of the address are 0. 
        require(uint32(msg.sender) == 0);
        _sendWinnings();
     }

     function _sendWinnings() {
         msg.sender.transfer(this.balance);
     }
}

//没有指定函数可见性类型的函数是public默认的;函数可以指定为external、public或internal、private建议有意识地决定哪种可见性类型适合某个功能。这可以大大减少合同系统的攻击面。