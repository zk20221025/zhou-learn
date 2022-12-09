// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "./ERC721.sol";
import "@chainlink/contracts/src/v0.8/VRFConsumerBase.sol";

contract RabdonNumber is ERC721 , VRFConsumerBase {
    uint256 public totalSupply = 100;
    uint256[100] public ids;
    uint256 public mintCount;
    bytes32 internal keyHash;
    uint256 internal fee;

    mapping(bytes32 => address) public requestToSender;

    constructor()
    VRFConsumerBase(
        0xb3dCcb4Cf7a26f6cf6B120Cf5A73875B7BBc655B,
        0x01BE23585060835E02B77ef475b0Cc51aA1e0709
    )
    ERC721("WTF Random" , "WTF")
    {
        keyHash = 0x2ed0feb3e7fd2022120aa84fab1945545a9f2ffc9076fd6156fa96eaff4c1311;
        fee = 0.1 * 10 ** 18;
    }

    
    function getRandomOnchain() public view returns(uint256) {
        bytes32 randomBytes = keccak256(abi.encodePacked(blockhash(block.number-1) , msg.sender , block.timestamp));
        return uint256(randomBytes);
    }

    function pickRandomUniqueId(uint256 random) private returns (uint256 tokenId) {
        uint256 len = totalSupply - mintCount++;
        require(len > 0 , "mint close");
        uint256 randomIndex = random & len;
        tokenId = ids[randomIndex] != 0 ? ids[randomIndex] : randomIndex;
        ids[randomIndex] = ids[len - 1] == 0 ? len - 1 : ids[len - 1];
        ids[len - 1] = 0;
    }

}