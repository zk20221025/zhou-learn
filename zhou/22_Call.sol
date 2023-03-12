// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

//call 是address类型的低级成员函数，它用来与其他合约交互。它的返回值为(bool, data)，分别对应call是否成功以及目标函数的返回值。
//call是solidity官方推荐的通过触发fallback或receive函数发送ETH的方法。
//不推荐用call来调用另一个合约，因为当你调用不安全合约的函数时，你就把主动权交给了它。推荐的方法仍是声明合约变量后调用函数
//当我们不知道对方合约的源代码或ABI，就没法生成合约变量；这时，我们仍可以通过call调用对方合约的函数。


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
        (bool success , bytes memory data) = _addr.call{value : msg.value}(abi.encodeWithSignature("setX(uint256)" , x));

        emit Response(success , data);
    }

    function callGetX(address _addr) external returns(uint x) {
        (bool success , bytes memory data) = _addr.call(abi.encodeWithSignature("getX()"));

        emit Response(success , data);

        return abi.decode(data , (uint256));
    }

    function callNonExist(address _addr) external {
        (bool success , bytes memory data) = _addr.call(abi.encodeWithSignature("foo(uint256)"));

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