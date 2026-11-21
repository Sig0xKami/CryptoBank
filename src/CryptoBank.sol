// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

/// @notice Multi-user ether bank with a per-user deposit cap set by the admin.
contract CryptoBank {
    uint256 public maxBalance;
    address public admin;
    mapping(address => uint256) public userBalance;

    event Deposited(address indexed user, uint256 amount);
    event Withdrawn(address indexed user, uint256 amount);

    modifier onlyAdmin() {
        require(msg.sender == admin, "Not allowed");
        _;
    }

    constructor(uint256 maxBalance_, address admin_) {
        maxBalance = maxBalance_;
        admin = admin_;
    }

    function depositEther() external payable {
        require(
            userBalance[msg.sender] + msg.value <= maxBalance,
            "MaxBalance reached"
        );
        userBalance[msg.sender] += msg.value;
        emit Deposited(msg.sender, msg.value);
    }

    function withdrawEther(uint256 amount_) external {
        require(amount_ <= userBalance[msg.sender], "Not enough ether");

        // checks-effects-interactions: update state before the external call
        userBalance[msg.sender] -= amount_;

        (bool success, ) = msg.sender.call{value: amount_}("");
        require(success, "ETH transfer failed");
        emit Withdrawn(msg.sender, amount_);
    }

    function modifyMaxBalance(uint256 newMaxBalance_) external onlyAdmin {
        maxBalance = newMaxBalance_;
    }
}
