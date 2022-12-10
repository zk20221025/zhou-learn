// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./34_IERC165.sol";

interface IERC1155Receiver is IERC165 {
    function onERC721Received(
        address operator,
        address from,
        uint256 id,
        uint256 value,
        bytes calldata data
    ) external returns (bytes4);

    function onERC1155BatchReceived(
        address operator,
        address from,
        uint256[] calldata ids,
        uint256[] calldata values,
        bytes calldata data
    ) external returns (bytes4);
}