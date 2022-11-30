// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

abstract contract Proxy {

    //新建一个数字仓库
    function newStore(uint256[] calldata data) external  virtual returns(uint256 storeId, address storeAddress);
    //向特定的数字仓库增加元素
    function add(uint256 storeId, uint256 number) external virtual; 

    //删除特定的数字仓库的末尾元素
    function del(uint256 storeId) external virtual;

    //从特定的数字仓库里获取特定位置的数值
    function get(uint256 storeId, uint256 index) external view virtual returns(uint256);

    //修改特定数字仓库里特定位置的元素为新数值
    function edit(uint256 storeId, uint256 index, uint256 number) external virtual;
}