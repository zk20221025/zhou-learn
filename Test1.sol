// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;
import "./Test.sol";
contract Test1 is Test {
    modifier onlyOwner virtual override {
        require(msg.sender == owner); 
        _;
    }

    modifier onlyAdmin virtual override {
        require(msg.sender == admin); 
        _;
    }
    
    constructor() Test("Test1") {
        owner = msg.sender;
    }


    //现实numberStroe存储的所有数字 并释放一个 show Action事件
    function show() external view virtual override returns(uint256[] memory _numberStore){    
        _numberStore = numberStore;
    }
    
    //向numberStore末尾添加一个数字 并释放一个 add Action事件
    function add(uint256 number) external virtual override {
        numberStore.push(number);
        emit Action("add");
    }

    //从numberStore末尾删除一个数字 并释放一个 del Action事件 该函数只能允许owner调用
    function del() external virtual override onlyOwner {
        numberStore.pop();
        emit Action("del");
    }

    //从numberStore获取指定位置对应的数字 并释放一个 get Action事件
    function get(uint256 index) external view virtual override returns(uint256 _number){
        _number = numberStore[index];
    }

    //修改numberStore对应位置的的数字为新数字 并释放一个 edit Action事件 该函数只能允许admin调用
    function edit(uint256 index, uint256 number) external virtual override onlyAdmin {
        numberStore[index] = number;
        emit Action("edit");
    }

    //设置admin 该函数只能允许owner调用
    function setAdmin(address newAdmin) external virtual override onlyOwner{
        admin = newAdmin;
    }

    //修改admin为新admin 该函数只能允许owner调用
    function changeAdmin(address newAdmin) external virtual override onlyOwner {
        admin = newAdmin;
    }

    //修改owner为新owner 该函数只能允许owner调用
    function changeOwner(address newOwner) external virtual override onlyOwner {
        owner = newOwner;
    }

}