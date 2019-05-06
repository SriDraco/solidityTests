pragma solidity ^0.4.24;

contract TimedPiggyBank {
    // owner of piggybank
    address public owner;
    // time that funds can be withdrawn
    uint public endTime;
    
    constructor(uint duration) public {
        // set owner
        owner = msg.sender;
        // set endTime
        endTime = now + duration;
    }
    
    // payable function that can be used to deposit into the piggybank
    // no need to have code, we're just adding money
    function deposit() public payable {}
    
    function withdraw() public {
        // make sure message sender is owner
        require(msg.sender == owner);
        // make sure current time is after endTime
        require(now > endTime);
        // send funds to owner and destroy contract
        selfdestruct(owner);
    }
    
    // function to allow balance checking
    function balance() public view returns(uint){
        return address(this).balance;
    }
}
