pragma solidity ^0.4.24;

contract Fundraiser {
    address public owner;
    //Target fundraising value
    uint public target;
    // time that Fundraiser ends
    uint public endTime;
    // List of contributors
    Contributor[] contributors;
    
    struct Contributor{
        address userAddress;
        uint contribution;
    }
    
    constructor(uint _target, uint duration) public payable {
        owner = msg.sender;
        target = _target;
        endTime = now + duration;
    }
    
    function contribute() public payable {
        //require that Fundraiser hasn't ended yet
        require(now < endTime);
        // add to list of contributors
        contributors.push(Contributor(msg.sender,msg.value));
    }
    
    function collect() public{
        //once target is met, owner can collect funds
        require(address(this).balance >= target);
        require(msg.sender == owner);
        selfdestruct(owner);
    }
    
    function refund() public{
        // allow refunds once time has ended if goal isn't met
        require(now > endTime);
        require(address(this).balance < target);
        //refund contributions
        for(uint i; i<contributors.length;i++){
            contributors[i].userAddress.transfer(contributors[i].contribution);
        }
    }
    
    function balance() public view returns(uint) {
        return address(this).balance;
    }
}
