// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract BenToken {
    string public name;
    string public symbol;
    uint8 public decimals;
    uint256 private totalSupply;
    mapping(address => uint256) private balances;
    mapping(address => mapping(address => uint256)) private allowed;
    uint256 public buyTaxPercent;
    uint256 public sellTaxPercent;
    uint256 public feeConversionRate;
    
    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);
    
    constructor(
        string memory Benny,
        string memory BEN,
        uint256 _initialSupply,
        uint256 _buyTaxPercent,
        uint256 _sellTaxPercent,
        uint256 _feeConversionRate
    ) {
        name = Benny;
        symbol = BEN;
        decimals = 10;
        totalSupply = _initialSupply * 10**uint256(decimals);
        balances[msg.sender] = totalSupply;
        buyTaxPercent = _buyTaxPercent;
        sellTaxPercent = _sellTaxPercent;
        feeConversionRate = _feeConversionRate;
        emit Transfer(address(0), msg.sender, totalSupply);
    }
    
    function balanceOf(address _owner) public view returns (uint256 balance) {
        return balances[_owner];
    }
    
    function allowance(address _owner, address _spender) public view returns (uint256 remaining) {
        return allowed[_owner][_spender];
    }
    
    function transfer(address _to, uint256 _value) public returns (bool success) {
        require(_to != address(0), "Invalid address");
        require(_value <= balances[msg.sender], "Insufficient balance");
        
        uint256 fee = calculateTransferFee(_value, msg.sender);
        uint256 transferAmount = _value - fee;
        
        balances[msg.sender] -= _value;
        balances[_to] += transferAmount;
        balances[address(this)] += fee;
        
        emit Transfer(msg.sender, _to, transferAmount);
        emit Transfer(msg.sender, address(this), fee);
        
        return true;
    }
    
    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
        require(_to != address(0), "Invalid address");
        require(_value <= balances[_from], "Insufficient balance");
        require(_value <= allowed[_from][msg.sender], "Insufficient allowance");
        
        uint256 fee = calculateTransferFee(_value, _from);
        uint256 transferAmount = _value - fee;
        
        balances[_from] -= _value;
        balances[_to] += transferAmount;
        balances[address(this)] += fee;
        allowed[_from][msg.sender] -= _value;
        
        emit Transfer(_from, _to, transferAmount);
        emit Transfer(_from, address(this), fee);
        
        return true;
    }
    
    function approve(address _spender, uint256 _value) public returns (bool success) {
        allowed[msg.sender][_spender] = _value;
        emit Approval(msg.sender, _spender, _value);
        return true;
    }
    
    function calculateTransferFee(uint256 _value, address _sender) private view returns (uint256 fee) {
        uint256 taxPercent = _sender == address(this) ? 0 : (msg.sender == _sender ? buyTaxPercent : sellTaxPercent);
        return (_value * taxPercent) / 100;
    }
    
    function convertFees() public returns (bool success) {
        require(balances[address(this)] > 0, "No fees to convert");
        
        uint256 feeAmount = balances[address(this)];
        uint256 convertedAmount = feeAmount * feeConversionRate;
        
        balances[address(this)] = 0;
        balances[msg.sender] += convertedAmount;
        
        emit Transfer(address(this), msg.sender, convertedAmount);
        
        return true;
    }
}
