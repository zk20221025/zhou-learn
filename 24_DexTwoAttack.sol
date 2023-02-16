// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract Token3 is ERC20 {
    constructor(uint256 initialSupply) ERC20("Token3", "T3") {
        _mint(msg.sender, initialSupply);
  
    }
}