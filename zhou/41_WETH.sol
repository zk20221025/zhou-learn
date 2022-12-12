// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract WETH is ERC20 {
    event Deposit(address indexed dst , uint wad);
    event Withdrawal(address indexed src , uint wad);

    constructor() ERC20("WETH" , "WETH") {
    }

    fallback() external payable {
        deposit();
    }

    receive() external
}