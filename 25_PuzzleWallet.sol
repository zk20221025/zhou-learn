// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
pragma experimental ABIEncoderV2;

import "./UpgradeableProxy.sol";

contract PuzzleProxy is UpgradeableProxy {
    address public pendingAdmin;
    address public admin;

    constructor(address _admin, address _implementation, bytes memory _initData) UpgradeableProxy(_implementation, _initData) {
        admin = _admin;
    }

    modifier onlyAdmin {
      require(msg.sender == admin, "Caller is not the admin");
      _;
    }

    function proposeNewAdmin(address _newAdmin) external {
        pendingAdmin = _newAdmin;
    }

    function approveNewAdmin(address _expectedAdmin) external onlyAdmin {
        require(pendingAdmin == _expectedAdmin, "Expected new admin by the current admin is not the pending admin");
        admin = pendingAdmin;
    }

    function upgradeTo(address _newImplementation) external onlyAdmin {
        _upgradeTo(_newImplementation);
    }
}

contract PuzzleWallet {
    address public owner;
    uint256 public maxBalance;
    mapping(address => bool) public whitelisted;
    mapping(address => uint256) public balances;

    function init(uint256 _maxBalance) public {
        require(maxBalance == 0, "Already initialized");
        maxBalance = _maxBalance;
        owner = msg.sender;
    }

    modifier onlyWhitelisted {
        require(whitelisted[msg.sender], "Not whitelisted");
        _;
    }

    function setMaxBalance(uint256 _maxBalance) external onlyWhitelisted {
      require(address(this).balance == 0, "Contract balance is not 0");
      maxBalance = _maxBalance;
    }

    function addToWhitelist(address addr) external {
        require(msg.sender == owner, "Not the owner");
        whitelisted[addr] = true;
    }

    function deposit() external payable onlyWhitelisted {
      require(address(this).balance <= maxBalance, "Max balance reached");
      balances[msg.sender] += msg.value;
    }

    function execute(address to, uint256 value, bytes calldata data) external payable onlyWhitelisted {
        require(balances[msg.sender] >= value, "Insufficient balance");
        balances[msg.sender] -= value;
        (bool success, ) = to.call{ value: value }(data);
        require(success, "Execution failed");
    }

    function multicall(bytes[] calldata data) external payable onlyWhitelisted {
        bool depositCalled = false;
        for (uint256 i = 0; i < data.length; i++) {
            bytes memory _data = data[i];
            bytes4 selector;
            assembly {
                selector := mload(add(_data, 32))
            }
            if (selector == this.deposit.selector) {
                require(!depositCalled, "Deposit can only be called once");
                // Protect against reusing msg.value
                depositCalled = true;
            }
            (bool success, ) = address(this).delegatecall(data[i]);
            require(success, "Error while delegating call");
        }
    }
}

//事实上，现在为DeFi操作付费是不可能的。 
 
//一群朋友发现了如何通过将多个交易批处理在一个交易中来略微降低执行多个交易的成本，因此他们为此开发了一个智能合约。 
 
//他们需要这个合同是可升级的，以防代码包含错误，他们还想防止小组外的人使用它。为此，他们投票并分配了两个在系统中具有特殊角色的人:管理员，它具有更新智能合约逻辑的能力。所有者，它控制允许使用合同的地址白名单。合同被部署，该集团被列入白名单。每个人都为他们战胜邪恶矿工的成绩而欢呼。 
 
//他们一点也不知道，他们的午餐钱正处于危险之中…… 
 
//您需要劫持这个钱包才能成为代理的管理员。 
 
//可能有帮助的事情: 理解委托调用如何工作以及msg如何工作。发件人和msg.Value在执行一个时的行为。 了解代理模式及其处理存储变量的方式。

//0x29bb6a661052967023760b875e88c7401ed6912a

//await web3.eth.call({from:player, to:"0x29bb6a661052967023760b875e88c7401ed6912a", data:web3.utils.sha3("whitelisted(address)").slice(0,10) + "000000000000000000000000" + player.slice(2)})


//0x2314cecfb5544bc18d05f2c31a0c60c54b4ed02610acb38b52682c8ab8318a68

//await web3.eth.getStorageAt(instance, "0x2314cecfb5544bc18d05f2c31a0c60c54b4ed02610acb38b52682c8ab8318a68") 
// 代理合约

//await web3.eth.getStorageAt("0x29bb6a661052967023760b875e88c7401ed6912a", "0x2314cecfb5544bc18d05f2c31a0c60c54b4ed02610acb38b52682c8ab8318a68")//执行合约

