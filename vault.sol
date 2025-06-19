// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/extensions/ERC4626.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";
import "@openzeppelin/contracts/security/Pausable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract Vault is ERC4626, ReentrancyGuard, Pausable, Ownable {
    // External strategy contract to generate yield (optional)
    address public yieldStrategy;

    constructor(
        IERC20 asset_,
        string memory name_,
        string memory symbol_
    ) ERC20(name_, symbol_) ERC4626(asset_) Ownable(msg.sender)
 {}

    // --- Admin functions ---
    function setYieldStrategy(address _strategy) external onlyOwner {
        yieldStrategy = _strategy;
    }

    function pause() external onlyOwner {
        _pause();
    }

    function unpause() external onlyOwner {
        _unpause();
    }

    // --- Core Vault Hooks for Yield Logic ---
  function _deposit(address caller, address receiver, uint256 assets, uint256 shares)
    internal
    virtual
    override
{
    super._deposit(caller, receiver, assets, shares);
    _generateYield(assets); // Send funds to strategy
}


 function _withdraw(address caller, address receiver, address owner, uint256 assets, uint256 shares)
    internal
    virtual
    override
{
    _redeemYield(assets); // Get funds back from strategy
    super._withdraw(caller, receiver, owner, assets, shares);
}

    // --- (Strategy Placeholder) ---
    function _generateYield(uint256 amount) internal {
        // Example:
        // IERC20(asset()).approve(yieldStrategy, amount);
        // IStrategy(yieldStrategy).deposit(amount);
    }

    function _redeemYield(uint256 amount) internal {
        // Example:
        // IStrategy(yieldStrategy).withdraw(amount);
    }

    // --- Override Vault Functions with Security ---
    function deposit(uint256 assets, address receiver)
        public
        override
        whenNotPaused
        nonReentrant
        returns (uint256 shares)
    {
        return super.deposit(assets, receiver);
    }

    function mint(uint256 shares, address receiver)
        public
        override
        whenNotPaused
        nonReentrant
        returns (uint256 assets)
    {
        return super.mint(shares, receiver);
    }

    function withdraw(uint256 assets, address receiver, address owner)
        public
        override
        whenNotPaused
        nonReentrant
        returns (uint256 shares)
    {
        return super.withdraw(assets, receiver, owner);
    }

    function redeem(uint256 shares, address receiver, address owner)
        public
        override
        whenNotPaused
        nonReentrant
        returns (uint256 assets)
    {
        return super.redeem(shares, receiver, owner);
    }
}
