// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./IERC1155.sol";
import "./IERC1155Receiver.sol";
import "./IERC1155MetadataURI.sol";
import "../34_Address.sol";
import "../34_String.sol";
import "./34_IERC165.sol";

contract ERC1155 is IERC165 , IERC1155 , IERC1155MetadataURI {
    using Address for address;
    using Strings for uint256;

    string public name;
    string public symbol;

    mapping(uint256 => mapping(address => uint256)) private _balances;
    mapping(address => mapping(address => bool)) private _operatorApprovals;

    constructor(string memory name_ , string memory symbol_) {
        name = name_;
        symbol = symbol_;
    }

    function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
        return
        interfaceId == type(IERC1155).interfaceId ||
        interfaceId == type(IERC1155MetadataURI).interfaceId ||
        interfaceId == type(IERC165).interfaceId;
    }

    function balanceOf(address account , uint256 id) public view virtual override returns (uint256) {
        require(account != address(0), "ERC1155: address zero is not a valid owner");
        return _balances[id][account];
    }

    function balanceOfBatch(address[] memory accounts , uint256[] memory ids)
    public view virtual override
    returns (uint256[] memory)
    {
        require(accounts.length == ids.length , "ERC1155: accounts and ids length mismatch");
        uint256[] memory batchBalances = new uint256[](accounts.length);
        for (uint256 i = 0; i < accounts.length; ++i) {
            batchBalances[i] = balanceOf(accounts[i] , ids[i]);
        }
        return batchBalances;
    }

    function setApprovalForAll(address operator , bool approved) public virtual override {
        require(msg.sender != operator , "ERC1155: setting approval status for srlf");
        _operatorApprovals[msg.sender][operator] = approved;
        emit ApprovalForAll(msg.sender , operator , approved);
    }

    function isApprovedForAll(address account , address operator) public view virtual override returns (bool) {
        return _operatorApprovals[account][operator];
    }

    function safeTransferFrom(
        address from,
        address to,
        uint256 id,
        uint256 amount,
        bytes memory data
    ) public virtual override {
        address operator = msg.sender;
        require(
            from == operator || isApprovedForAll(from , operator),
            "ERC1155: caller is not token owner nor approved"
        );
        require(to != address(0), "ERC1155: transfer to the zero address");

        uint256 fromBalance = _balances[id][from];
    }
}