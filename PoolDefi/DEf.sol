pragma solidity ^0.8.0;

contract Pool {
    // The address of the contract owner
    address public owner;

    // The total balance of the pool
    uint public totalBalance;

    // The pool's earnings, in percentage points
    uint public earningsRate;

    // The current epoch (a timestamp representing the current time)
    uint public currentEpoch;

    // The mapping of addresses to their balances in the pool
    mapping(address => uint) public balances;

    // The event that is emitted when a user deposits funds
    event Deposit(address indexed user, uint amount);

    // The event that is emitted when a user withdraws funds
    event Withdrawal(address indexed user, uint amount);

    // The constructor sets the contract owner and earnings rate
    constructor(uint _earningsRate) public {
        owner = msg.sender;
        earningsRate = _earningsRate;
        currentEpoch = now;
    }

    // Allows the owner to update the earnings rate
    function updateEarningsRate(uint _earningsRate) public {
        require(msg.sender == owner, "Only the owner can update the earnings rate");
        earningsRate = _earningsRate;
    }

    // Allows users to deposit funds into the pool
    function deposit() public payable {
        require(msg.value > 0, "Cannot deposit zero or negative value");
        balances[msg.sender] += msg.value;
        totalBalance += msg.value;
        emit Deposit(msg.sender, msg.value);
    }

    // Allows users to withdraw their share of the pool's earnings
    function withdraw() public {
        uint earnings = calculateEarnings();
        require(balances[msg.sender] >= earnings, "Insufficient balance");
        balances[msg.sender] -= earnings;
        totalBalance -= earnings;
        msg.sender.transfer(earnings);
        emit Withdrawal(msg.sender, earnings);
    }

    // Calculates the user's share of the pool's earnings
    function calculateEarnings() public view returns (uint) {
        uint elapsed = now - currentEpoch;
        return (balances[msg.sender] * earningsRate * elapsed) / 1e180;
    }
}
