// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

contract Call {
    // 定义Response事件，输出call返回的结果success和data
    event Response(bool success , bytes data);

    function callSetX(address payable _addr , uint256 x) public payable {
        // call setX()，同时可以发送ETH
        (bool success , bytes memory data) = _addr.call {value : msg.value }(
            abi.encodeWithSignature("setX(uint256)", x));
        
        emit Response(success , data);//释放事件
    }

    function callGetX(address _addr) external returns(uint256) {
        // call getX()
        (bool success , bytes memory data) = _addr.call(
            abi.encodeWithSignature("getX()")
        );

        emit Response(success , data);//释放事件
        return abi.decode(data , (uint256));
    }

    function callNonExist(address _addr) external {
        (bool success , bytes memory data) = _addr.call(
            abi.encodeWithSignature("foo(uint256)")
        );

        emit Response(success , data);
    }
}

// 定义Response事件，输出call返回的结果success和data
// call setX()，同时可以发送ETH,并释放事件；
// call getX()，并释放事件，用abi.decode来解码call的返回值data，并读出数值。
// 用call调用不存在的合约，会出发fallback；能执行成功并返回success
//目标合约地址.call(abi.encodeWithSignature("函数签名", 逗号分隔的具体参数));
//目标合约地址.call{value:发送数额, gas:gas数额}(二进制编码);

contract Call1 {

    event Response(bool success , bytes data);

    function callSetX(address payable _addr , uint x) public payable {
        (bool success , bytes memory data) = _addr.call{value : msg.value}(abi.encodeWithSignature("setX(uint256)" , x ));
        emit Response(success , data);
    }

    function callGetX(address _addr) external returns(uint256) {
        (bool success , bytes memory data) = _addr.call(abi.encodeWithSignature("getX()"));
        emit Response(success , data);
        return abi.decode(data , (uint256));
    }

    function callNonExist(address _addr) external {
        (bool success , bytes memory data) = _addr.call(abi.encodeWithSignature("foo(uint2560"));
        emit Response(success , data);
    }
}

contract OtherContract {
    uint256 private _x = 0;
    event Log (uint amount , uint gas);
    
    fallback() external payable {}

    function getBalance() view public returns(uint) {
        return address(this).balance;
    }

    function setX(uint256 x) external payable {
        _x = x;
        if (msg.value > 0) {
            emit Log(msg.value , gasleft());
        }
    }

    function getX() external view returns(uint x) {
        x = _x;
    }
}