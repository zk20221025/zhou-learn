// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

// 状态变量_x
// 收到eth的事件，记录amount和gas
// 返回合约ETH余额
// 可以调整状态变量_x的函数，并且可以往合约转ETH (payable)
// 如果转入ETH，则释放Log事件
// 读取_x
contract OtherContract {
    uint256 private _x = 0;

    event Log(uint amount , uint gas);

    function getBalance() external view returns (uint) {
        address(this).balance;
    }

    function getX() external view returns (uint x) {
        x = _x;
    }



    function setX(uint256 x) external payable {
        _x = x;
        if (msg.value > 0) {
            emit Log(msg.value , gasleft());
        }
    }
}

//传入已部署好的OtherContract合约地址_Address和setX的参数x,调用目标函数setx callSetX() _Name(_Address).f()
//调用getx函数获取x,callGetX()，传入合约地址，获取x
//调用getx callGetX2() 创建合约变量oc,将合约地址赋值给oc
//setXTransferETH()，传入OtherContract合约地址和x，转账 _Name(_Address).f{amount}()
contract CallContract2 {
    function callSetX(address _Address , uint x) external {
        OtherContract(_Address).setX(x);
    }

    function callGetX(OtherContract _Address) external view returns(uint x) {
        x = _Address.getX();
    }

    function callGetX2(address _Address) external view returns(uint x) {
        OtherContract oc = OtherContract(_Address);
        x = oc.getX();
    }

    function setXTransferETH(address _Address , uint256 x) external payable {
        OtherContract(_Address).setX{value : msg.value}(x);
    }
}

contract CallContract{
    function callSetX(address _Address, uint256 x) external{
        OtherContract(_Address).setX(x);
    }

    function callGetX(OtherContract _Address) external view returns(uint x){
        x = _Address.getX();
    }



    function callGetX2(address _Address) external view returns(uint x){
        OtherContract oc = OtherContract(_Address);
        x = oc.getX();
    }

    function setXTransferETH(address otherContract, uint256 x) payable external{
        OtherContract(otherContract).setX{value: msg.value}(x);
    }


}



//传入已部署好的OtherContract合约地址_Address和setX的参数x,调用目标函数setx callSetX() _Name(_Address).f()
//调用getx函数获取x,callGetX()，传入合约地址，获取x
//调用getx callGetX2() 创建合约变量oc,将合约地址赋值给oc
//setXTransferETH()，传入OtherContract合约地址和x，转账 _Name(_Address).f{amount}()
contract CallContract1 {
    function callSetX(address _Address , uint x) external  {
        OtherContract(_Address).setX(x);
    }

    function callGetX(OtherContract _Address) external view returns(uint x) {
        x = _Address.getX();
    }

    function callGetX2(address _Address) external view returns(uint x) {
        OtherContract oc = OtherContract(_Address);
        x = oc.getX();
    }

    function setXTransferETH(address otherContract , uint256 x ) external payable {
        OtherContract(otherContract).setX{value : msg.value}(x);
    }
}
