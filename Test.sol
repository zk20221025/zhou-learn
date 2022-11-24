// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

abstract contract Test {
    string internal contractName;
    uint256[] internal numberStore;

    address internal owner;
    address internal admin;

    event Action(string action);

    modifier onlyOwner virtual;
    modifier onlyAdmin virtual;

    constructor(string memory _name) {
        contractName = _name;
    }

    //获取合约名称
    function name() external view returns(string memory _name) {
        _name = contractName;
    }

    //现实numberStroe存储的所有数字 并释放一个 show Action事件
    function show() external view virtual returns(uint256[] memory);
    
    //向numberStore末尾添加一个数字 并释放一个 add Action事件
    function add(uint256 number) external virtual; 

    //从numberStore末尾删除一个数字 并释放一个 del Action事件 该函数只能允许owner调用
    function del() external virtual;

    //从numberStore获取指定位置对应的数字 并释放一个 get Action事件
    function get(uint256 index) external view virtual returns(uint256);

    //修改numberStore对应位置的的数字为新数字 并释放一个 edit Action事件 该函数只能允许admin调用
    function edit(uint256 index, uint256 number) external virtual;

    //设置admin 该函数只能允许owner调用
    function setAdmin(address admin) external virtual;

    //修改admin为新admin 该函数只能允许owner调用
    function changeAdmin(address newAdmin) external virtual;

    //修改owner为新owner 该函数只能允许owner调用
    function changeOwner(address newOwner) external virtual;
}
