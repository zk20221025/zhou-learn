// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "31_IERC20.sol";

contract Airdrop {

    function getSum(uint256[] calldata _arr) public pure returns(uint sum) {
        for (uint i = 0; i < _arr.length; i++)
            sum = sum + _arr[i];
    }

    function multTransferToken(
        address _token,
        address[] calldata _addresses,
        uint256[] calldata _amounts
    ) external {
        require(_addresses.length == _amounts.length , "Lengths of Addresses and Amounts NOT EQUAL");
        IERC20 token = IERC20(_token);
        uint _amountSum = getSum(_amounts);
        require(token.allowance(msg.sender , address(this)) > _amountSum , "Need Approve ERC20 token");

        for (uint256 i; i < _addresses.length; i++) {
            token.transferFrom(msg.sender , _addresses[i] , _amounts[i]);
        }
    }

    function multTransferETH (
        address payable[] calldata _addresses,
        uint256[] calldata _amounts
    ) public payable {
        require (_addresses.length == _amounts.length , "Lengths of Addresses and Amounts NOT EQUAL");
        for(uint256 i = 0; i < _addresses.length; i++) {
            _addresses[i].transfer(_amounts[i]);
        }
    }
}

contract ERC20 is IERC20 {
    mapping(address => uint256) public override balanceOf;

    mapping(address => mapping(address => uint256)) public override allowance;

    uint256 public override totalSupply;

    string public name;   
    string public symbol;
    
    uint8 public decimals = 18;

    constructor(string memory name_ , string memory symbol_) {
        name = name_;
        symbol = symbol_;
    }

    function transfer(address recipient, uint amount) external override returns (bool) {
        balanceOf[msg.sender] -= amount;
        balanceOf[recipient] += amount;
        emit Transfer(msg.sender, recipient, amount);
        return true;
    }

    function approve(address spender, uint amount) external override returns (bool) {
        allowance[msg.sender][spender] = amount;
        emit Approval(msg.sender, spender, amount);
        return true;
    }

    function transferFrom(
        address sender,
        address recipient,
        uint amount
    ) external override returns (bool) {
        allowance[sender][msg.sender] -= amount;
        balanceOf[sender] -= amount;
        balanceOf[recipient] += amount;
        emit Transfer(sender, recipient, amount);
        return true;
    }

    function mint(uint amount) external {
        balanceOf[msg.sender] += amount;
        totalSupply += amount;
        emit Transfer(address(0), msg.sender, amount);
    }

    function burn(uint amount) external {
        balanceOf[msg.sender] -= amount;
        totalSupply -= amount;
        emit Transfer(msg.sender, address(0), amount);
    }
}