// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "./34_IERC721.sol";
import "./34_IERC721Receiver.sol";
import "./34_WTFApe.sol";

contract NFTSwap is IERC721Receiver {
    event List(address indexed seller, address indexed nftAddr, uint256 indexed tokenId, uint256 price);
    event Purchase(address indexed buyer, address indexed nftAddr, uint256 indexed tokenId, uint256 price);
    event Revoke(address indexed seller, address indexed nftAddr, uint256 indexed tokenId);    
    event Update(address indexed seller, address indexed nftAddr, uint256 indexed tokenId, uint256 newPrice);

    struct Order {
        address owner;
        uint256 price;
    }

    mapping(address => mapping(uint256 => Order)) public nftList;

    fallback() external payable{}

    function onERC721Received(
        address operator,
        address from,
        uint tokenId,
        bytes calldata data
    ) external override returns (bytes4) {
        return IERC721Receiver.onERC721Received.selector;
    }

    function list(address _nftAddr , uint256 _tokenId , uint256 _price) public {
        IERC721 _nft = IERC721(_nftAddr);
        require(_nft.getApproved(_tokenId) == address(this) , "Need Approval");
        require(_price > 0);

        Order storage _order = nftList[_nftAddr][_tokenId];
        _order.owner = msg.sender;
        _order.price = _price;
        _nft.safeTransferFrom(msg.sender , address(this) , _tokenId);
        emit List(msg.sender , _nftAddr , _tokenId , _price);
    }
}