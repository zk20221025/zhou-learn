// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

contract OtherContract {
    uint256 private _x = 0;
    event Log(uint amount , uint gas);
    
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

contract Call {
    event Response(bool success , bytes data);

    function callSetX(address payable _addr , uint256 x) public payable {
        (bool success , bytes memory data) = _addr.call {value : msg.value }(
            abi.encodeWithSignature("getX()"));
        
        emit Response(success , data);
    }

    function callGetX(address _addr) external returns(uint256) {
        (bool success , bytes memory data) = _addr.call(
            abi.encodeWithSignature("getX()")
        );

        emit Response(success , data);
        return abi.decode(data , (uint256));
    }

    function callNonExist(address _addr) external {
        (bool success , bytes memory data) = _addr.call(
            abi.encodeWithSignature("foo(uint256")
        );

        emit Response(success , data);
    }
}

contract Fund {
    mapping(address => uint) shares;
    function withdraw() public {
        if (payable(msg.sender).call.value(shares[msg.sender])())
            shares[msg.sender] = 0;
    }
}