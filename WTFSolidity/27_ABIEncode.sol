// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;
contract ABIEncode {

    uint x = 10;
    address addr = 0x7A58c0Be72BE218B41C608b7Fe7C5bB630736C71;
    string name = "0xAA";
    uint[2] array = [5,6];

    function encode() public view returns (bytes memory result) {
        result = abi.encode(x , addr , name , array);
    }

    function encodePacked() public view returns (bytes memory result) {
        result = abi.encodePacked(x , addr , name , array);
    }

    function encodeWithSignature() public view returns (bytes memory result) {
        result = abi.encodeWithSignature("foo(uint256 , address , string , uint256[2])" , x , addr , name , array);
    }

    function encodeWithSelector() public view returns (bytes memory result) {
        result = abi.encodeWithSelector(bytes4(keccak256("foo(uint256 , address , string , uint256[2])")), x , addr , name , array);
    } 

    function decode(bytes memory data) public pure returns(uint dx , address daddr , string memory dname , uint[2] memory darray) {
        (dx , daddr , dname , darray) = abi.decode(data , (uint , address , string , uint[2]));
    }

    function decode() public view returns (bytes memory result) {
        result = abi.encodeWithSelector(bytes4(keccak256("string")), name );
    } 
}

/**
* abi.encodePacked是按顺序压缩打包
* 其余的编码方式会是把变长的数据 会依次放在定长的数据 后面
* 例如encode(uint256,string,uint256,string). 实际出来的数据就是 uint256 uint256 string string
* string由 uint256 字符串长度值 + 字符串本身的数据组成
*  "0xAA" 就是 uint256(4) + 30 78 41 41
* 字符串编码对应的数值 遵循ASCII标准
* 单独编码string 中的02是（uint256 字符串长度值 + 字符串本身的数据）的长度
*/