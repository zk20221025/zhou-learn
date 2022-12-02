// SPDX-License-Identifier: MIT

pragma solidity ^0.8.4;

import "./34_IERC165.sol";
import "./34_IERC721.sol";
import "./34_IERC721Receiver.sol";
import "./34_IERC721Metadata.sol";
import "./34_Address.sol";
import "./34_String.sol";

contract ERC721 is IERC721 , IERC721Metadata {
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

    function supportsInterface(bytes4 interfaceId)
        external
        pure
        override
        returns (bool)
    {
        return
            interfaceId == type(IERC721).interfaceId ||
            interfaceId == type(IERC165).interfaceId ||
            interfaceId == type(IERC721Metadata).interfaceId;
    }

    function balanceOf(address owner) external view override returns (uint) {
        require(owner != address(0) , "owner = zero address");
        return _balances[owner];
    }

    function ownerof(uint tokenId) public view override returns (address owner) {
        owner = _owners[tokenId];
        require(owner != address(0) , "token doesn't exist");
    }

    function isApprovedForAll(address owner , address operator) external view override returns (bool) {
        return _operatorApprovals[owner][operator];
    }

    function setApprovalForAll(address operator , bool approved) external override {
        _operatorApprovals[msg.sender][operator] = approved;
        emit ApprovalForAll(msg.sender , operator , approved);
    }

    function getApproved(uint tokenId) external view override returns (address) {
        require(_owners[tokenId] != address(0) , "token does't exist");
        return _tokenApprovals[tokenId];
    }

    function _approve(address owner , address to , uint tokenId ) private {
        _tokenApprovals[tokenId] = to;
        emit Approval(owner , to , tokenId);
    }

    function approve(address to , uint tokenId) external override {
        address owner = _owners[tokenId];
        require(
            msg.sender == owner || _operatorApprovals[owner][msg.sender],
            "not owner nor approved for all"
        );
    }

    function _isApprovedOrOwner(
        address owner,
        address spender,
        uint tokenId
    ) private view returns (bool) {
        return (spender == owner || _tokenApprovals[tokenId] == spender || _operatorApprovals[owner][spender]);
    }

    function _transfer (
        address owner,
        address from,
        address to,
        uint tokenId
    ) private {
        require (from == owner , "not owner");
        require (to != address(0) , "tranfer to the zero address");

        _approve(owner , address(0) , tokenId);

        _balances[from] -= 1;
        _balances[to] += 1;
        _owners[tokenId] = to;
        
        emit Transfer(from , to , tokenId);
    }

    function transferFrom(
        address from,
        address to,
        uint tokenId
    ) external override {
        address owner = ownerof(tokenId);
        require(
            _isApprovedOrOwner(owner,msg.sender , tokenId),
            "not owner nor approves"
        );
        _transfer(owner , from ,to , tokenId);
    }

    function _safeTransfer(
        address owner,
        address from,
        address to,
        uint tokenId,
        bytes memory _data
    ) private {
        _transfer(owner , from ,to , tokenId);
        require(_checkOnERC721eceived(from , to , tokenId , _data) , "not ERC721Receiver");
    }

    function safeTransferFrom(
        address from,
        address to,
        uint tokenId,
        bytes memory _data
    ) public override {
        address owner = ownerof(tokenId);
        require(
            _isApprovedOrOwner(owner , msg.sender , tokenId),
            "not owner nor approved"
        );
        _safeTransfer(owner , from ,to ,tokenId ,_data);
    }

    function safeTransferFrom(
        address from,
        address to,
        uint tokenId
    ) external override {
        safeTransferFrom(from , to , tokenId , "");
    }

    function _mint(address to , uint tokenId) internal virtual {
        require(to != address(0), "mint to zero address");
        require(_owners[tokenId] == address(0), "token already minted");

        _balances[to] += 1;
        _owners[tokenId] = to;

        emit Transfer(address(0) , to , tokenId);
    }

    function _burn(uint tokenId) internal virtual {
        address owner = ownerof(tokenId);
        require(msg.sender == owner , "not owner of token");

        _approve(owner , address(0) , tokenId);

        _balances[owner] -= 1;
        delete _owners[tokenId];

        emit Transfer(owner , address(0) , tokenId);
    }

    function _checkOnERC721eceived(
        address from,
        address to,
        uint tokenId,
        bytes memory _data
    ) private returns (bool) {
        if (to.isContract()) {
            return
                IERC721Receiver(to).onERC721Received(
                    msg.sender,
                    from,
                    tokenId,
                    _data
                ) == IERC721Receiver.onERC721Received.selector;
        } else {
            return true;
        }
    }

    function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
        require(_owners[tokenId] != address(0) , "Token Not Exist");

        string memory baseURI = _baseURI();
        return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI , tokenId.toString())) : "";
    }

    function _baseURI() internal view virtual returns (string memory) {
        return "";
    }
}