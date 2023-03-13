// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

// 0xd018db3e0000000000000000000000002c44b726adf1963ca47af88b284c06f30380fc78
//前4个字节为函数选择器selector：0xd018db3e
//后面32个字节为输入的参数：0x0000000000000000000000002c44b726adf1963ca47af88b284c06f30380fc78
//
contract Selector {
    // event 返回msg.data
    event Log(bytes data);

    function attack(address) external {
        emit Log(msg.data);
    }
// 当selector与method id相匹配时,即表示调用该函数
    function mintSelector() external pure returns (bytes4 mSelector) {
        return bytes4(keccak256("attack(address)"));
    }

    function callWithSignature() external returns (bool , bytes memory) {
        (bool success , bytes memory data) = address(this).call(abi.encodeWithSelector(0xd018db3e, "0x2c44b726ADF1963cA47Af88B284C06f30380fC78"));
        return(success , data);
    }
}

