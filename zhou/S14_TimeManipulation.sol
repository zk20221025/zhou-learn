// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;
import "openzeppelin-contracts/token/ERC721/ERC721.sol";

contract TimeManipulation is ERC721 {
    uint256 totalSupply;

    constructor() ERC721("" , "") {}

    function luckyMint() external returns (bool success) {
        if(block.timestamp % 170 == 0) {
            _mint(msg.sender , totalSupply);
            totalSupply++;
            success = true;
        } else {
            success = false;
        }
    }
}