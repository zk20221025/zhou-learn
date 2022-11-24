// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;
contract Overload {
    function saySomething() public pure returns(string memory) {
        return ("Nothing");
    }
    function saySomething(string memory something) public pure returns (string memory) {
        return (something);
    }
}
