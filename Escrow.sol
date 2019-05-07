pragma solidity^0.4.24;

contract Escrow {
    // creator of contract and sender of funds
    address payer;
    // receiver of funds, party that must finish terms
    address payee;
    // third party that determines when terms are met
    address agent;
    // time after which sender can void the contract
    uint expirationTime;
    
    constructor(address _payee, address _agent, uint timeBeforeExpiration) public payable {
        payee = _payee;
        agent = _agent;
        payer = msg.sender;
        expirationTime = now + timeBeforeExpiration;
    }
    
    function voidContract() public {
        // make sure message sender is the payer
        require(msg.sender == payer);
        // make sure contract has expired
        require(now > expirationTime);
        // destroy contract and return funds to payer
        selfdestruct(payer);
    }
    
    function confirmCompletion() public {
        // make sure agent is message sender
        require(msg.sender == agent);
        // destroy contract and send funds to payee
        selfdestruct(payee);
    }
    
    function balance() public view returns(uint) {
        return address(this).balance;
    }
}
