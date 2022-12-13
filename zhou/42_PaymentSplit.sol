// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

contract PaymentSplit {
    event PayeeAdded(address account , uint256 shares);
    event PaymentReleased(address to , uint256 amount);
    event PaymentReceived(address from , uint256 amount);

    uint256 public totalShares;
    uint256 public totalRealeased;

    mapping(address => uint256) public shares;
    mapping(address => uint256) public released;
    address[] public payees;

    constructor(address[] memory _payees , uint256[] memory _shares) payable {
        require(_payees.length == _shares.length , "PaymentSplitter: payees and shares length mismatch");
        require(_payees.length > 0 , "PaymentSplitter: no payees");
        for (uint256 i = 0; i < _payees.length; i++) {
            _addPayee(_payees[i] , _shares[i]);
        }
    }

    receive() external payable virtual {
        emit PaymentReceived(msg.sender , msg.value);
    }

    function release(address payable _account) public virtual {
        require(shares[_account] > 0 , "PaymentSplitter: no payees");
        uint256 payment = releasable(_account);
        require(payment != 0 , "PaymentSplitter: account is not due payment");
        totalRealeased += payment;
        released[_account] += payment;
        _account.transfer(payment);
        emit PaymentReceived(_account , payment);
    }

    function releasable(address _account) public view returns (uint256) {
        uint256 totalReceived = address(this).balance + totalRealeased;
        return pendingPayment(_account , totalReceived , released[_account]);
    }

    function pendingPayment(
        address _account,
        uint256 _totalReceived,
        uint256 _alreadyReleased
    ) public view returns (uint256) {
        return (_totalReceived * shares[_account]) / totalShares - _alreadyReleased;
    }

    function _addPayee(address _account , uint256 _accountShares) private {
        
    }
}