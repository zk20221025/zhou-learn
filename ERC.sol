// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "./34_IERC165.sol";
import "./34_IERC721.sol";
import "./34_IERC721Receiver.sol";
import "./34_IERC721Metadata.sol";
import "./34_Address.sol";
import "./34_String.sol";

contract ERC721 is IERC721Metadata , IERC721 {
    using Address for address;
    using Strings for uint256;


    string public override name;
    string public override symbol;
    mapping(uint => address) private _owners;
    mapping(address => uint) private _balances;
    mapping(uint => address) private _tokenApprovals;
    mapping(address => mapping(address => bool)) private _operatorApprovals;

    constructor(string memory name_ , string memory symbol_) {
        name = name_;
        symbol = symbol_;
    }

    function supportsInterface(bytes4 interfaceId) external pure returns (bool) {
        return
        interfaceId == type(IERC721).interfaceId ||
        interfaceId == type(IERC721Metadata).interfaceId ||
        interfaceId == type(IERC165).interfaceId;
    }

    function balanceOf(address owner) public view override returns (uint256 ) {
        require(owner != address(0) , "Zero Address");
        return _balances[owner];
    }

    function ownerOf(uint tokenId) public view override returns (address owner) {
        owner = _owners[tokenId];
        require(owner != address(0) , "Zero Address");
    }

    function _isApprovedOrOwner(address owner , address spender , uint tokenId) private view returns (bool) {
        return spender == owner || _tokenApprovals[tokenId] == spender || _operatorApprovals[owner][spender];
    }

    function _approve(address owner , address to , uint tokenId) private {
        _tokenApprovals[tokenId] = to;
        emit Approval(owner , to , tokenId);
    }

    function approve(address to , uint256 tokenId) external override {
        address owner = _owners[tokenId];
        require(msg.sender == owner || _operatorApprovals[owner][msg.sender]);
        _approve(owner , to , tokenId);
    }

    function _transfer(address owner , address from , address to , uint tokenId) private {
        require(from == owner , "");
        require(to != address(0) , "Zero Address");
        _approve(owner , to , tokenId);
        _balances[from] -= 1;
        _balances[to] += 1;
        _owners[tokenId] = to;
        emit Transfer(from , to , tokenId);
    }

    function _safeTransfer(address owner , address from , address to , uint tokenId , bytes memory _data) private {
        _transfer(owner , from , to , tokenId);
        require(_checkOnERC721Received(from , to , tokenId , _data));
    } 

    function _checkOnERC721Received(
        address from,
        address to,
        uint tokenId,
        bytes memory _data
    ) private returns (bool) {
        if(to.isContract()) {
            return 
            IERC721Receiver(to).onERC721Received(msg.sender , from , tokenId , _data) 
            == IERC721Receiver.onERC721Received.selector;
        } else {
            return true;
        }
    }

    function safeTransferFrom (
        address from,
        address to,
        uint256 tokenId,
        bytes memory _data
    ) public override {
        address owner = ownerOf(tokenId) ;
        require(_isApprovedOrOwner(owner , msg.sender , tokenId));
        _safeTransfer(owner, from , to , tokenId , _data);
    }

    function safeTransferFrom (
        address from,
        address to,
        uint256 tokenId
    ) external override {
        safeTransferFrom(from , to , tokenId , "");
    }

    function transferFrom (
        address from,
        address to,
        uint256 tokenId
    ) external override {
        address owner = ownerOf(tokenId);
        require(_isApprovedOrOwner(owner , msg.sender , tokenId) , "");
        _transfer(owner , from , to , tokenId);
    }

    function setApprovalForAll(address operator , bool _approved) external override {
        _operatorApprovals[msg.sender][operator] = _approved;
        emit ApprovalForAll(msg.sender , operator , _approved);
    }

    function getApproved(uint256 tokenId) external view override returns (address operator) {
        require(_owners[tokenId] != address(0) , "Zero Address");
        return _tokenApprovals[tokenId];
    }

    function isApprovedForAll(address owner , address operator) external view override returns (bool) {
        return _operatorApprovals[owner][operator];
    }

    function _mint(address to , uint tokenId) internal virtual {
        require(to != address(0) , "");
        _owners[tokenId] = address(0);
        _balances[to] += 1;
        _owners[tokenId] = to;
        emit Transfer(to , address(0) , tokenId);
    }

    function _burn(uint tokenId) internal virtual {
        address owner = ownerOf(tokenId);
        require(msg.sender == owner);
        _approve(owner , address(0) , tokenId);
        _balances[owner] -= 1;
        delete _owners[tokenId];
    }

    function tokenURI(uint256 tokenId) external view override returns (string memory) {
        require(_owners[tokenId] != address(0));
        string memory baseURI = _baseURI();
        return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
    }

    function _baseURI() internal view virtual returns (string memory) {
        return "";
    }
}