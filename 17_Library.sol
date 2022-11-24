// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;
contract Strings {
    bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
    function tpString(uint256 Value) public pure returns (string memory) {
        if (Value == 0) {
            return "0";
        }
        uint256 temp = Value;
        uint256 digits;
        while (temp != 0){
            digits++;
            temp /= 10;
        }
        bytes memory buffer = new bytes(digits);
        while (Value != 0){
            digits -= 1;
            buffer[digits] = bytes1(uint8(48 + uint256(Value / 10)));
        }
        return string (buffer);
    }
}