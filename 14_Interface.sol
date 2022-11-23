// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;
abstract contract InsertionSort {
    function insertionSort(uint[] memory a) public pure virtual returns(uint[] memory);
}
import "@openzeppelin/contracts/utils/introspection/IERC165.sol";
interface IERC721 is IERC165 {

}