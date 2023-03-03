// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/access/Ownable.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC20/ERC20.sol";

interface DelegateERC20 {
    function delegateTransfer(address to, uint256 value , address origSender) external returns (bool);
}

interface IDetectionBot {
    function handleTransaction(address user,bytes calldata msgData) external;
}

interface IForta {
    function setDetectionBot(address detectionBotAddress) external;
    function notify(address user, bytes calldata msgData) external;
    function raiseAlert(address user) external;
}

contract Forta is IForta {
    mapping(address => IDetectionBot) public usersDetectionBots;
    mapping(address => uint256) public botRaisedAlerts;

    function setDetectionBot(address detectionBotAddress) external override {
        usersDetectionBots[msg.sender] = IDetectionBot(detectionBotAddress);
    }

    function notify(address user, bytes calldata msgData) external override {
        if(address(usersDetectionBots[user]) == address(0)) return;
        try usersDetectionBots[user].handleTransaction(user , msgData) {
            return;
        } catch {}
    }

    function raiseAlert(address user) external override {
        if(address(usersDetectionBots[user]) != msg.sender) return;
        botRaisedAlerts[msg.sender] += 1;
    }
}


contract CryptoVault {
    address public sweptTokensRecipient;
    IERC20 public underlying;

    constructor(address recipient) {
        sweptTokensRecipient = recipient;
    }

    function setUnderlying(address latestToken) public {
        require(address(underlying) == address(0), "Already set");
        underlying = IERC20(latestToken);
    }


    function sweepToken(IERC20 token) public {
        require(token != underlying, "Can't transfer underlying token");
        token.transfer(sweptTokensRecipient, token.balanceOf(address(this)));
    }
}

contract LegacyToken is ERC20("LegacyToken", "LGT"), Ownable {
    DelegateERC20 public delegate;

    function mint(address to, uint256 amount) public onlyOwner {
        _mint(to, amount);
    }

    function delegateToNewContract(DelegateERC20 newContract) public onlyOwner {
        delegate = newContract;
    }

    function transfer(address to, uint256 value) public override returns (bool) {
        if (address(delegate) == address(0)) {
            return super.transfer(to, value);
        } else {
            return delegate.delegateTransfer(to, value, msg.sender);
        }
    }
}

contract DoubleEntryPoint is ERC20("DoubleEntryPointToken", "DET"), DelegateERC20, Ownable {
    address public cryptoVault;
    address public player;
    address public delegatedFrom;
    Forta public forta;

    constructor(address legacyToken, address vaultAddress, address fortaAddress, address playerAddress) {
        delegatedFrom = legacyToken;
        forta = Forta(fortaAddress);
        player = playerAddress;
        cryptoVault = vaultAddress;
        _mint(cryptoVault, 100 ether);
    }

    modifier onlyDelegateFrom() {
        require(msg.sender == delegatedFrom, "Not legacy contract");
        _;
    }

    modifier fortaNotify() {
        address detectionBot = address(forta.usersDetectionBots(player));

        // Cache old number of bot alerts
        uint256 previousValue = forta.botRaisedAlerts(detectionBot);

        // Notify Forta
        forta.notify(player, msg.data);

        // Continue execution
        _;

        // Check if alarms have been raised
        if(forta.botRaisedAlerts(detectionBot) > previousValue) revert("Alert has been triggered, reverting");
    }

    function delegateTransfer(
        address to,
        uint256 value,
        address origSender
    ) public override onlyDelegateFrom fortaNotify returns (bool) {
        _transfer(origSender, to, value);
        return true;
    }
}

//该级别具有具有特殊功能的CryptoVault，即sweepToken函数。这是一个常用的函数，用于检索卡在合同中的令牌。加密保险库使用底层令牌进行操作，该令牌不能被扫描，因为它是加密保险库的重要核心逻辑组件。任何其他令牌都可以被扫描。 
 
//底层令牌是DoubleEntryPoint合约定义中实现的DET令牌实例，CryptoVault拥有100个单位的DET令牌。此外，CryptoVault还持有100个LegacyToken LGT。 
 
//在这个级别中，您应该找出漏洞在CryptoVault中的位置，并保护它不被耗尽token。 
 
//该合同具有一个Forta合同，任何用户都可以注册自己的检测机器人合同。Forta是一个去中心化的、基于社区的监测网络，可以尽快检测到DeFi、NFT、治理、桥梁和其他Web3系统上的威胁和异常。您的工作是实现一个检测机器人，并将其注册到Forta契约中。机器人的实现需要发出正确的警报，以防止潜在的攻击或漏洞利用。 
 
//可能有帮助的事情: 双入口点对于令牌合约是如何工作的?


//漏洞在于在LegacyToken的transfer（return delegate.delegateTransfer(to, value, msg.sender)，用完的是令牌，而不是LGT。

// 通过setDetectionBot将我们的部署合约设置进去
//web3.eth.sendTransaction({from:player, to:await contract.forta(), data:web3.utils.sha3("setDetectionBot(address)").slice(0,10) + "000000000000000000000000"+ "beCBbf9903aA2083DBFE4B260dD73723c42189ac"})

//设置部署合约的cryptoVaultAddr地址
//web3.eth.sendTransaction({from:player, to:"0xbeCBbf9903aA2083DBFE4B260dD73723c42189ac", data:web3.utils.sha3("setCryptoVaultAddr(address)").slice(0,10) + "000000000000000000000000" + (await contract.cryptoVault()).slice(2)})

