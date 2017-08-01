pragma solidity ^0.4.0;
contract Checkbook {

    struct Check {
    	uint expirationDate;
    	uint lastChecked; 
    	uint maxTotal;
    	uint runningTotal; //starts at 0
    	uint maxSingleUse; 
    	uint8 numberOfUses; //0 is unlimited
    	uint8 usesCount; //starts at 0
    	uint waitTimeout; //timeout between checkouts
    	address fixedReceiver; //0 is open check
    	address publicKey;
    }	

    bytes32 public name;
    address owner;
    Check[] checks;
    
    function Checkbook(bytes32 _name) payable {
        name = _name;
        owner = msg.sender;
    }
    
    function withdrawAll() {
        require(msg.sender == owner);
        owner.transfer(this.balance);
    }
    
    function addCheck(uint expirationDate, uint lastChecked, uint maxTotal, uint maxSingleUse,
    	              uint8 numberOfUses,	uint waitTimeout, address fixedReciever, address publicKey) returns (uint) {
    	require(msg.sender == owner);
    	require(publicKey != 0);
    	checks.push(Check(expirationDate, lastChecked, maxTotal, 0, maxSingleUse, numberOfUses, 0, waitTimeout, fixedReciever, publicKey));
    	return checks.length - 1;
    }
    
    function() payable { }
    
    function checkOut(uint check, uint amount, address receiver, uint8 sig_v, bytes32 sig_r, bytes32 sig_s)
    {
        require(check < checks.length);
        require(amount <= this.balance);
        Check storage current = checks[check];
        require( (current.numberOfUses == 0) || (current.usesCount < current.numberOfUses) );
        require(current.runningTotal + amount <= current.maxTotal); //improbable integer overflow bug
        require( (current.fixedReceiver == 0) || (current.fixedReceiver == receiver) );
        require(amount <= current.maxSingleUse);
        require( (now < current.expirationDate) && (now < current.lastChecked + current.waitTimeout) );
        var hash = sha3(check, amount, receiver);
        require(ecrecover(hash, sig_v, sig_r, sig_s) == checks[check].publicKey);
        current.lastChecked = now;
        current.runningTotal += amount;
        current.usesCount += 1;
        receiver.transfer(amount);
    }
}
