// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

contract Proxy {
    // 逻辑合约地址。implementation合约同一个位置的状态变量类型必须和Proxy合约的相同，不然会报错。
    address public implementation;
/**
     * @dev 初始化逻辑合约地址
     */
    constructor(address implementation_) {
        implementation = implementation_;
    }

    fallback() external payable {
        _delegate();
    }

/**
* calldatacopy(t, f, s)：将calldata（输入数据）从位置f开始复制s字节到mem（内存）的位置t。
* delegatecall(g, a, in, insize, out, outsize)：调用地址a的合约，输入为mem[in..(in+insize)) ，输出为mem[out..(out+outsize))， 提供gwei的以太坊gas。这个操作码在错误时返回0，在成功时返回1。
* returndatacopy(t, f, s)：将returndata（输出数据）从位置f开始复制s字节到mem（内存）的位置t。
* switch：基础版if/else，不同的情况case返回不同值。可以有一个默认的default情况。
* return(p, s)：终止函数执行, 返回数据mem[p..(p+s))。
* revert(p, s)：终止函数执行, 回滚状态，返回数据mem[p..(p+s))。
*/

    function _delegate() internal {
        assembly {
            let _implementation := sload(0)
            calldatacopy(0 , 0 , calldatasize())
            let result := delegatecall(gas() , _implementation , 0 , calldatasize() , 0 , 0)
            returndatacopy(0 , 0 , returndatasize())
            switch result
            case 0 {
                revert(0 , returndatasize())
            }
            default {
                return(0 , returndatasize())
            }
        }
    }
/**
* @dev 回调函数，将本合约的调用委托给 `implementation` 合约
* 通过assembly，让回调函数也能有返回值
*/
    fallback() external payable {
        address _implementation = implementation;
        assembly {
        // 将msg.data拷贝到内存里
        // calldatacopy操作码的参数: 内存起始位置，calldata起始位置，calldata长度
            calldatacopy(0, 0, calldatasize())

        // 利用delegatecall调用implementation合约
        // delegatecall操作码的参数：gas, 目标合约地址，input mem起始位置，input mem长度，output area mem起始位置，output area mem长度
        // output area起始位置和长度位置，所以设为0
        // delegatecall成功返回1，失败返回0
            let result := delegatecall(gas(), _implementation, 0, calldatasize(), 0, 0)

        // 将return data拷贝到内存
        // returndata操作码的参数：内存起始位置，returndata起始位置，returndata长度
            returndatacopy(0, 0, returndatasize())

            switch result
        // 如果delegate call失败，revert
            case 0 {
                revert(0, returndatasize())
            }
        // 如果delegate call成功，返回mem起始位置为0，长度为returndatasize()的数据（格式为bytes）
            default {
                return(0, returndatasize())
            }
        }
    }
}

/**
 * @dev 逻辑合约，执行被委托的调用
 */
contract Logic {
    address public implementation; // 与Proxy保持一致，防止插槽冲突
    uint public x = 99; 
    event CallSuccess(); // 调用成功事件

    // 这个函数会释放CallSuccess事件并返回一个uint。
    // 函数selector: 0xd09de08a
    function increment() external returns(uint) {
        emit CallSuccess();
        return x + 1;
    }
}

/**
 * @dev Caller合约，调用代理合约，并获取执行结果
 */
contract Caller{
    address public proxy; // 代理合约地址

    constructor(address proxy_){
        proxy = proxy_;
    }

    // 通过代理合约调用increment()函数
    function increment() external returns(uint) {
        ( , bytes memory data) = proxy.call(abi.encodeWithSignature("increment()"));
        return abi.decode(data,(uint));
    }
}