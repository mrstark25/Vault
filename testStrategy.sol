// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract TestStrategy {
    IERC20 public token;
    address public vault;

    constructor(address _token) {
        token = IERC20(_token);
        vault = msg.sender;
    }

    function deposit(uint256 amount) external {
        require(msg.sender == vault, "Only vault");
        token.transferFrom(msg.sender, address(this), amount);
    }

    function withdraw(uint256 amount) external {
        require(msg.sender == vault, "Only vault");
        token.transfer(msg.sender, amount);
    }

    function balance() external view returns (uint256) {
        return token.balanceOf(address(this));
    }
}
