// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;
abstract contract InsertionSort {
    function insertionSort(uint[] memory a) public pure virtual returns(uint[] memory);
}
import "@openzeppelin/contracts/utils/introspection/IERC165.sol";
interface IERC721 is IERC165 {
    event Transfer(address indexed from , address  indexed to , uint256 indexed TokenId);
    event Approval(address indexed owner , address indexed approved , uint256 indexed TokenId);
    event ApprovalForAll(address indexed owner , address indexed operator , bool approved);
    function balanceOf(address owner) external view returns(uint256 balance);
    function ownerOf(uint256 TokenId) external view returns(address owner);
    function safeTransferFrom(address from , address to , uint256 TokenId) external;
    function transferFrom(address from , address to , uint256 TokenId) external;
    function approve(address to , uint256 TokenId) external;
    function getApproved(uint256 TokenId) external view returns(address operator);
    function setApprovalForAll(address operator , bool _approve) external;
    function isApprovalForAll(address owner , address operator) external view returns(bool);
    function safeTransferFrom(address form , address to , uint256 TokenId , bytes calldata data) external;
}