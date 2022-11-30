// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;
import"/Proxy.sol";
contract Test2 is Proxy {
    address[] cunchus;
        //新建一个数字仓库
    function newStore(uint256[] calldata data) external  virtual override returns(uint256 storeId, address storeAddress) {
        Cunchu cunchu = new Cunchu(data);
        storeAddress = address(cunchu);
        cunchus.push(storeAddress);
        storeId = cunchus.length-1;
    }
    
    //向特定的数字仓库增加元素
    function add(uint256 storeId, uint256 number) external virtual override {
        Cunchu cunchu = Cunchu(cunchus[storeId]);
        cunchu.save(number);
    } 

    //删除特定的数字仓库的末尾元素
    function del(uint256 storeId) external virtual override {
        Cunchu cunchu = Cunchu(cunchus[storeId]);
        cunchu.del();
    }

    //从特定的数字仓库里获取特定位置的数值
    function get(uint256 storeId, uint256 index) external view virtual override returns(uint256) {
        Cunchu cunchu = Cunchu(cunchus[storeId]);
        return cunchu.get(index);
    }

    //修改特定数字仓库里特定位置的元素为新数值
    function edit(uint256 storeId, uint256 index, uint256 number) external virtual override {
        Cunchu cunchu = Cunchu(cunchus[storeId]);
        cunchu.edit(index,number);
    }
}

contract Cunchu {
    uint256[] private array1;

    constructor(uint256[] memory _nums) {
        array1 = _nums;
    }

    function save(uint _num) public {
        array1.push(_num);
    }

    function show() external view returns(uint256[] memory array2){    
        array2 = array1;
    }    

    function add(uint256 number) external {
        array1.push(number);      
    }

    function del() external  {
        array1.pop();    
    }

    function get(uint256 index) external view returns(uint256 _number){
        _number = array1[index];
    }

    function edit(uint256 index, uint256 number) external  {
        array1[index] = number;      
    }
}

