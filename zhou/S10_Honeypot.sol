// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract HoneyPot is ERC20 , Ownable {
    address public pair;

    constructor() ERC20("HoneyPot" , "Pi Xiu") {
        address factory = 0x5C69bEe701ef814a2B6a3EDD4B1652CB9cc5aA6f;
        address tokenA = address(this);
        address tokenB = 0xB4FBF271143F4FBf7B91A5ded31805e42b2208d6;
        (address token0, address token1) = tokenA < tokenB ? (tokenA, tokenB) : (tokenB, tokenA); 
        bytes32 salt = keccak256(abi.encodePacked(token0, token1));
        pair = address(uint160(uint(keccak256(abi.encodePacked(
        hex'ff',
        factory,
        salt,
        hex'96e8ac4277198ff8b6f785478aa9a39f403cb768dd02cbee326c3e7da348845f'
        )))));
    }

    function mint(address to, uint amount) public onlyOwner {
        _mint(to, amount);
    }
}