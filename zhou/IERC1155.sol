// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./34_IERC165.sol";

interface IERC1155 is IERC165 {

    event TransferSingle(address indexed operator , address indexed from , address indexed to , uint256 id , uint256 value);

    event TransferBatch(
        address indexed operator,
        address indexed from,
        address indexed to,
        uint256[] id,
        uint256[] values
    );

    event ApprovalForAll(address indexed account , address indexed operator , bool approved);

    event URI(string value , uint256 indexed id);
}