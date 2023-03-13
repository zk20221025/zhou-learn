pragma solidity ^0.6.0;
pragma experimental "v0.5.0";

// 导入外部包  此包中主要是一些
// 安全的数学运算 
// 因为在一些场景 出现了数据溢出没有考虑的问题导致了
// 一些ico币直接归零
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/v3.1.0/contracts/math/SafeMath.sol";

contract PAXImplementation {

    using SafeMath for uint256;
    bool private initialized = false;

    // 定义了ERC20规定的代币名称 符号 精度
    mapping(address => uint256) internal balances;
    uint256 internal totalSupply_;
    string public constant name = "PAX"; // solium-disable-line uppercase
    string public constant symbol = "PAX"; // solium-disable-line uppercase
    uint8 public constant decimals = 18; // solium-disable-line uppercase

    // ERC20 DATA
    mapping (address => mapping (address => uint256)) internal allowed;

    // OWNER DATA
    address public owner;

    // PAUSABILITY DATA
    bool public paused = false;

    // LAW ENFORCEMENT DATA
    address public lawEnforcementRole;
    mapping(address => bool) internal frozen;

    // SUPPLY CONTROL DATA
    address public supplyController;

    // 定义触发时间  当转账或者授权别人转账时 调用此事件  当调用时 其实质会在以太坊节点区块上写入日志。
    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(
        address indexed owner,
        address indexed spender,
        uint256 value
    );

    // OWNABLE EVENTS
    event OwnershipTransferred(
        address indexed oldOwner,
        address indexed newOwner
    );

    // PAUSABLE EVENTS
    event Pause();
    event Unpause();

    // LAW ENFORCEMENT EVENTS
    event AddressFrozen(address indexed addr);
    event AddressUnfrozen(address indexed addr);
    event FrozenAddressWiped(address indexed addr);
    event LawEnforcementRoleSet (
        address indexed oldLawEnforcementRole,
        address indexed newLawEnforcementRole
    );

    // SUPPLY CONTROL EVENTS
    event SupplyIncreased(address indexed to, uint256 value);
    event SupplyDecreased(address indexed from, uint256 value);
    event SupplyControllerSet(
        address indexed oldSupplyController,
        address indexed newSupplyController
    );

    /**
     * FUNCTIONALITY
     */

    // INITIALIZATION FUNCTIONALITY

    /**
    合约部署时的初始化过程
    设置合约拥有者为部署合约的账户
    设置总供应量为0
    并保证此函数只会被调用一次
     */
    function initialize() public {
        require(!initialized, "already initialized");
        owner = msg.sender;
        lawEnforcementRole = address(0);
        totalSupply_ = 0;
        supplyController = msg.sender;
        initialized = true;
    }

    /**
    合约的构造函数 调用上面的初始化函数 并且设置暂停交易 
     */
    constructor() public {
        initialize();
        pause();
    }

    // ERC20 BASIC FUNCTIONALITY

    /**
    ERC20接口 返回总的供应量
    */
    function totalSupply() public view returns (uint256) {
        return totalSupply_;
    }

    /*
    转账函数 实现将调用者的token转给其他人
    msg.sender 即为合约的调用者 
    并且此函数要求必须是非暂停状态  即whenNotPaused返回真
    
    这个函数有需要验证条件 
    1.交易没有被暂停
    2.接收方地址不能是0
    3.接收方和发起方均不可以是冻结地址
    4.转账的token余额要足够。
    */
    function transfer(address _to, uint256 _value) public whenNotPaused returns (bool) {
        require(_to != address(0), "cannot transfer to address zero");
        require(!frozen[_to] && !frozen[msg.sender], "address frozen");
        require(_value <= balances[msg.sender], "insufficient funds");

        balances[msg.sender] = balances[msg.sender].sub(_value);
        balances[_to] = balances[_to].add(_value);
        emit Transfer(msg.sender, _to, _value);
        return true;
    }

    /**
    ERC20接口 返回某个账户的token余额
    */
    function balanceOf(address _addr) public view returns (uint256) {
        return balances[_addr];
    }

    // ERC20 FUNCTIONALITY

    /*
      ERC20接口 实现了 _from地址下容许调用方可以转出金额到其他_to
      此函数要求必须是非暂停状态
     */
    function transferFrom(
        address _from,
        address _to,
        uint256 _value
    )
    public
    whenNotPaused
    returns (bool)
    {
        require(_to != address(0), "cannot transfer to address zero");
        require(!frozen[_to] && !frozen[_from] && !frozen[msg.sender], "address frozen");
        require(_value <= balances[_from], "insufficient funds");
        require(_value <= allowed[_from][msg.sender], "insufficient allowance");

        balances[_from] = balances[_from].sub(_value);
        balances[_to] = balances[_to].add(_value);
        allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
        emit Transfer(_from, _to, _value);
        return true;
    }

    /**
      ERC20接口 实现调用方容许_spender 可以从我的账户转出的金额  这个函数和上面的函数是相对应的。
      只有一个账户容许了其他账户能从我的账户转出的金额 上述的函数才能转账成功。
     */
    function approve(address _spender, uint256 _value) public whenNotPaused returns (bool) {
        require(!frozen[_spender] && !frozen[msg.sender], "address frozen");
        allowed[msg.sender][_spender] = _value;
        emit Approval(msg.sender, _spender, _value);
        return true;
    }

    /**
    ERC20接口 返回_owner账户容许_spender账户从自己名下转移出去的资产数量
     */
    function allowance(
        address _owner,
        address _spender
    )
    public
    view
    returns (uint256)
    {
        return allowed[_owner][_spender];
    }

    // OWNER FUNCTIONALITY

    /**
     这个函数被称为修饰函数 上面的whenNotPaused 也是一个修饰函数  实质是一种断言。 只有
     断言通过 才会执行函数内部的内容
     */
    modifier onlyOwner() {
        require(msg.sender == owner, "onlyOwner");
        _;
    }

    /*
    将只能合约的拥有者转给别人
     */
    function transferOwnership(address _newOwner) public onlyOwner {
        require(_newOwner != address(0), "cannot transfer ownership to address zero");
        emit OwnershipTransferred(owner, _newOwner);
        owner = _newOwner;
    }

    // PAUSABILITY FUNCTIONALITY

    /**
     *  修饰函数 要求处于非暂停交易状态
     */
    modifier whenNotPaused() {
        require(!paused, "whenNotPaused");
        _;
    }

    /**
     * 只有合约的拥有者才可以设置暂停交易
     */
    function pause() public onlyOwner {
        require(!paused, "already paused");
        paused = true;
        emit Pause();
    }

    /**
     * 只有合约的拥有者才能取消暂停交易
     */
    function unpause() public onlyOwner {
        require(paused, "already unpaused");
        paused = false;
        emit Unpause();
    }

    // LAW ENFORCEMENT FUNCTIONALITY

    /**
     设置一个法定的的强制角色 这个角色可以冻结或者解冻别人账户的token
     设置一个这样的角色要求首先调用方要么是合约的拥有者 要么自己已经是法定的强制者
     * @param _newLawEnforcementRole The new address allowed to freeze/unfreeze addresses and seize their tokens.
     */
    function setLawEnforcementRole(address _newLawEnforcementRole) public {
        require(msg.sender == lawEnforcementRole || msg.sender == owner, "only lawEnforcementRole or Owner");
        emit LawEnforcementRoleSet(lawEnforcementRole, _newLawEnforcementRole);
        lawEnforcementRole = _newLawEnforcementRole;
    }

    // 断言函数 要求调用方必须是强制者角色
    modifier onlyLawEnforcementRole() {
        require(msg.sender == lawEnforcementRole, "onlyLawEnforcementRole");
        _;
    }

    /**
      冻结某个账户的token  使用了断言 onlyLawEnforcementRole 也是只有调用方角色是
      法定强制者才有权限冻结别人的token
     */
    function freeze(address _addr) public onlyLawEnforcementRole {
        require(!frozen[_addr], "address already frozen");
        frozen[_addr] = true;
        emit AddressFrozen(_addr);
    }

    /**
        解冻某个账户的token  使用了断言 onlyLawEnforcementRole 也是只有调用方角色是
      法定强制者才有权限解冻别人的token
     */
    function unfreeze(address _addr) public onlyLawEnforcementRole {
        require(frozen[_addr], "address already unfrozen");
        frozen[_addr] = false;
        emit AddressUnfrozen(_addr);
    }

    /**
    摧毁冻结账户的token 也就是说如果这个地址是一个冻结地址调用这个函数会把这个地址的token销毁同时总供应数量也会被减少
    当然这个函数也不是谁都可以调用的 只有法定的强制者才有权限
     */
    function wipeFrozenAddress(address _addr) public onlyLawEnforcementRole {
        require(frozen[_addr], "address is not frozen");
        uint256 _balance = balances[_addr];
        balances[_addr] = 0;
        totalSupply_ = totalSupply_.sub(_balance);
        emit FrozenAddressWiped(_addr);
        emit SupplyDecreased(_addr, _balance);
        emit Transfer(_addr, address(0), _balance);
    }

    /**
    用于检查某个地址是否被冻结了
    */
    function isFrozen(address _addr) public view returns (bool) {
        return frozen[_addr];
    }

    // SUPPLY CONTROL FUNCTIONALITY

    /**
    设置token供应量的控制着 在合约初始化时 token供应量是合约发起则  调用这个函数可以更改
    这个函数只有调用方已经是token供应量控制着或者整个合约的拥有者才能调用成功
    也就是在整个合约中 合约的拥有者实质是可以控制一切权限的。 它能更改法定强制者 更改总token
    供应量的控制者。
     */
    function setSupplyController(address _newSupplyController) public {
        require(msg.sender == supplyController || msg.sender == owner, "only SupplyController or Owner");
        require(_newSupplyController != address(0), "cannot set supply controller to address zero");
        emit SupplyControllerSet(supplyController, _newSupplyController);
        supplyController = _newSupplyController;
    }

    modifier onlySupplyController() {
        require(msg.sender == supplyController, "onlySupplyController");
        _;
    }

    /**
    增加总的token供应量 并把新增供应量加到supplyController这个账户的名下。
     */
    function increaseSupply(uint256 _value) public onlySupplyController returns (bool success) {
        totalSupply_ = totalSupply_.add(_value);
        balances[supplyController] = balances[supplyController].add(_value);
        emit SupplyIncreased(supplyController, _value);
        emit Transfer(address(0), supplyController, _value);
        return true;
    }

    /**
    减少总的token供应量 待减少供应量从supplyController这个账户的名下减掉 。
    这个函数要求supplyController 
     */
    function decreaseSupply(uint256 _value) public onlySupplyController returns (bool success) {
        require(_value <= balances[supplyController], "not enough supply");
        balances[supplyController] = balances[supplyController].sub(_value);
        totalSupply_ = totalSupply_.sub(_value);
        emit SupplyDecreased(supplyController, _value);
        emit Transfer(supplyController, address(0), _value);
        return true;
    }
}
