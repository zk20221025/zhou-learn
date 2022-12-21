// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;
import "../34_ERC721.sol";

contract BadRandomness is ERC721 {
    uint256 totalSupply;

    constructor() ERC721("", ""){}

    function luckyMint(uint256 luckyNumber) external {
        uint256 randomNumber = 
        uint256(keccak256(abi.encodePacked(blockhash(block.number - 1), block.timestamp))) % 100;
        require(randomNumber == luckyNumber, "Better luck next time!");
        _mint(msg.sender, totalSupply);
        totalSupply++;
    }
}