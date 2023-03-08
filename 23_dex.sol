// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC20/IERC20.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC20/ERC20.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/access/Ownable.sol";

contract Dex is Ownable {
  address public token1;
  address public token2;
  constructor() {}

  function setTokens(address _token1, address _token2) public onlyOwner {
    token1 = _token1;
    token2 = _token2;
  }
  
  function addLiquidity(address token_address, uint amount) public onlyOwner {
    IERC20(token_address).transferFrom(msg.sender, address(this), amount);
  }
  
  function swap(address from, address to, uint amount) public {
    require((from == token1 && to == token2) || (from == token2 && to == token1), "Invalid tokens");
    require(IERC20(from).balanceOf(msg.sender) >= amount, "Not enough to swap");
    uint swapAmount = getSwapPrice(from, to, amount);
    IERC20(from).transferFrom(msg.sender, address(this), amount);
    IERC20(to).approve(address(this), swapAmount);
    IERC20(to).transferFrom(address(this), msg.sender, swapAmount);
  }

  function getSwapPrice(address from, address to, uint amount) public view returns(uint){
    return((amount * IERC20(to).balanceOf(address(this)))/IERC20(from).balanceOf(address(this)));
  }

  function approve(address spender, uint amount) public {
    SwappableToken(token1).approve(msg.sender, spender, amount);
    SwappableToken(token2).approve(msg.sender, spender, amount);
  }

  function balanceOf(address token, address account) public view returns (uint){
    return IERC20(token).balanceOf(account);
  }
}

contract SwappableToken is ERC20 {
  address private _dex;
  constructor(address dexInstance, string memory name, string memory symbol, uint256 initialSupply) ERC20(name, symbol) {
        _mint(msg.sender, initialSupply);
        _dex = dexInstance;
  }

  function approve(address owner, address spender, uint256 amount) public {
    require(owner != _dex, "InvalidApprover");
    super._approve(owner, spender, amount);
  }
}

//await contract.approve(contract.address, 1111)
//await contract.swap(await contract.token1(), await contract.token2(), await contract.balanceOf(await contract.token1(), player))
// player.token1 = 0, contract.token1 = 110
// player.token2 = 20, contract.token2 = 90
//await contract.swap(await contract.token2(), await contract.token1(), await contract.balanceOf(await contract.token2(), player))
// player.token1 = 24, contract.token1 = 86
// player.token2 = 0, contract.token2 = 110
//await contract.swap(await contract.token1(), await contract.token2(), await contract.balanceOf(await contract.token1(), player))
// player.token1 = 0, contract.token1 = 110
// player.token2 = 30, contract.token2 = 80
//await contract.swap(await contract.token2(), await contract.token1(), await contract.balanceOf(await contract.token2(), player))
// player.token1 = 41, contract.token1 = 69
// player.token2 = 0, contract.token2 = 110
//await contract.swap(await contract.token1(), await contract.token2(), await contract.balanceOf(await contract.token1(), player))
// player.token1 = 0, contract.token1 = 110
// player.token2 = 65, contract.token2 = 45
//await contract.swap(await contract.token2(), await contract.token1(), 45)
// player.token1 = 110, contract.token1 = 0
// player.token2 = 20, contract.token2 = 90

