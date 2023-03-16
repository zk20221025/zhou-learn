// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "@openzeppelin/contracts/access/Ownable.sol";
import "./34_ERC721.sol";

contract DutchAuction is Ownable , ERC721 {
    uint256 public constant COLLECTOIN_SIZE = 10000;
    uint256 public constant AUCTION_START_PRICE = 1 ether; 
    uint256 public constant AUCTION_END_PRICE = 0.1 ether; 
    uint256 public constant AUCTION_TIME = 10 minutes; 
    uint256 public constant AUCTION_DROP_INTERVAL = 1 minutes; 
    uint256 public constant AUCTION_DROP_PER_STEP =
        (AUCTION_START_PRICE - AUCTION_END_PRICE) /
        (AUCTION_TIME / AUCTION_DROP_INTERVAL); 

    uint256 public auctionStartTime;
    string private _baseTokenURI;
    uint256[] private _allTokens;

    constructor() ERC721("WTF Dutch Auctoin" , "WTF DUtch Auction") {
        auctionStartTime = block.timestamp;
    }

    function totalSupply() public view virtual returns (uint256) {
        return _allTokens.length;
    }

    function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
        _allTokens.push(tokenId);
    }
    
    function auctionMint(uint256 quantity) external payable {
        uint256 _saleStartTime = uint256(auctionStartTime);
        require(
            _saleStartTime != 0 && block.timestamp >= _saleStartTime,
            "sale has not started yet"
        );
        require(
            totalSupply() + quantity <= COLLECTOIN_SIZE,
            "not enough remaining reserved for auction to support dersired mint amount"
        );

        uint256 totalCost = getAuctionPrice() * quantity;
        require(msg.value >= totalCost, "Need to send more ETH.");

        for(uint256 i = 0 ; i < quantity ; i++) {
            uint256 mintIndex = totalSupply();
            _mint(msg.sender , mintIndex);
            _addTokenToAllTokensEnumeration(mintIndex);
        }

        if (msg.value > totalCost) {
            payable(msg.sender).transfer(msg.value - totalCost);
        }
    }

    function getAuctionPrice()
    public
    view
    returns (uint256) 
    {
        if (block.timestamp < auctionStartTime) {
            return AUCTION_START_PRICE;
        } else if (block.timestamp - auctionStartTime >= AUCTION_TIME) {
            return AUCTION_END_PRICE;
        } else {
            uint256 steps = (block.timestamp - auctionStartTime) /
            AUCTION_DROP_INTERVAL;
            return AUCTION_START_PRICE - (steps * AUCTION_DROP_PER_STEP);
        }
    }

    function setAuctionStartTime(uint32 timestamp) external onlyOwner {
        auctionStartTime = timestamp;
    }

    function _baseURI() internal view virtual override returns (string memory ) {
        return _baseTokenURI;
    }

    function setBaseURI(string calldata baseURI) external onlyOwner {
        _baseTokenURI = baseURI;
    }

    function withdrawMoney() external onlyOwner {
        (bool success, ) = msg.sender.call{value: address(this).balance}("");
        require(success , "Trabsfer failed.");
    }
}