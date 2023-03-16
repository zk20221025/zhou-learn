pragma solidity ^0.4.21;

contract Winner {
    mapping(string=>uint8) _mapActions;
    mapping(address=>bool) _AllAccounts;
    mapping(address=>uint8) _AccountsActions;
    bool start; 
    
    // 这个是构造函数 在合约第一次创建时执行
    constructor() public {
        _mapActions["scissors"] = 1;
        _mapActions["hammer"] = 2;
        _mapActions["cloth"] = 3;
        
        _AllAccounts[0x5B38Da6a701c568545dCfcB03FcB875f56beddC4] = true;  // xiaomi
        _AllAccounts[0xAb8483F64d9C6d1EcF9b849Ae677dD3315835cb2] = true; // xiaoming
        _AllAccounts[0x4B20993Bc481177ec7E8f571ceCaE8A9e22C02db] = true; // xiaogang
        
        _AccountsActions[0x5B38Da6a701c568545dCfcB03FcB875f56beddC4] = 0;
        _AccountsActions[0xAb8483F64d9C6d1EcF9b849Ae677dD3315835cb2] = 0;
        _AccountsActions[0x4B20993Bc481177ec7E8f571ceCaE8A9e22C02db] = 0;
    }
    
    // 设置执行动作  要求只能是scissors hammer cloth 
    // 并且要求只能是上述要求的三个以太坊地址
    function setAction( string action) public  returns (bool) {
        if (_mapActions[action] == 0 ) {
            return false;
        }
    
        if (!_AllAccounts[msg.sender]) {
            return false;
        }
        _AccountsActions[msg.sender] = _mapActions[action];
        return true;
    }
    
    function reset() private {
        _AccountsActions[0x5B38Da6a701c568545dCfcB03FcB875f56beddC4] = 0;
        _AccountsActions[0xAb8483F64d9C6d1EcF9b849Ae677dD3315835cb2] = 0;
        _AccountsActions[0x4B20993Bc481177ec7E8f571ceCaE8A9e22C02db] = 0;
    }
    
    function whoIsWinner() public returns (string, bool) {
        if (
            _AccountsActions[0x5B38Da6a701c568545dCfcB03FcB875f56beddC4] == 0 ||
            _AccountsActions[0xAb8483F64d9C6d1EcF9b849Ae677dD3315835cb2] == 0 ||
            _AccountsActions[0x4B20993Bc481177ec7E8f571ceCaE8A9e22C02db] == 0
            ) {
                reset();
                return ("", false);
            }
        uint8  xiaomi = _AccountsActions[0x5B38Da6a701c568545dCfcB03FcB875f56beddC4];
        uint8  xiaoming = _AccountsActions[0xAb8483F64d9C6d1EcF9b849Ae677dD3315835cb2];
        uint8  xiaogang = _AccountsActions[0x4B20993Bc481177ec7E8f571ceCaE8A9e22C02db];
        if (xiaomi != xiaoming && xiaomi != xiaogang && xiaoming != xiaogang) {
            reset();
            return ("", false);
        }
        
        if (xiaomi == xiaoming) {
            if (winCheck(xiaomi, xiaogang)) {
                return ("小刚", true);
            }else{
                reset();
                return ("", false);
            }
        }
        if (xiaomi == xiaogang) {
            if (winCheck(xiaomi, xiaoming)) {
                return ("小明", true);
            }else{
                reset();
                return ("", false);
            }
        } 
        if (xiaoming == xiaogang) {
            if (winCheck(xiaoming, xiaomi)) {
                return ("小米", true);
            }else{
                reset();
                return ("", false);
            }
        }
        reset();
        return ("", false);
    }
    
    function winCheck(uint8 a, uint8 b ) private returns( bool) {
        if(a == 1 && b==3) {
            return true;
        }else if (a==2 && b==1) {
            return true;
        }else if (a==3 && b==2) {
            return true;
        }
        return false;
    }
    
}