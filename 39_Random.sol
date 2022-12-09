// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "./ERC721.sol";
import "@chainlink/contracts/src/v0.8/VRFConsumerBase.sol";

contract RabdonNumber is ERC721 , VRFConsumerBase {
    function getRandomOnchain() public view returns(uint256) {
        bytes32 randomBytes = keccak256(abi.encodePacked(blockhash(block.number-1) , msg.sender , block.timestamp));
        return uint256(randomBytes);
    }
}