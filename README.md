# Vault

This README is structured with:

✅ **Overview**

🧱 **Smart Contracts**

🚀 **Deployment order**

⚙️ **How it works**

🧪 **Testing**

🔐 **Security notes**


📘 Project: On-Chain Vault + Stock Price Oracle
A modular DeFi system containing:

Vault Contract (ERC4626-based): Allows users to deposit ERC20 tokens and earn yield via external strategy contracts.

StockPriceOracle: An on-chain price oracle for stocks using Chainlink Price Feeds.

🧱 **Smart Contracts**
🏦 Vault Contract (Vault.sol)
A secure, upgradeable vault based on ERC4626, designed to:

Accept deposits and issue yield-bearing vault shares.

Forward funds to a yield-generating strategy (TestStrategy or Aave).

Allow secure withdrawals by redeeming shares.

Pause operations in emergencies.

Use OpenZeppelin standards (Ownable, Pausable, ReentrancyGuard).

📈 Stock Oracle Contract (StocksOracle.sol)
Provides live stock prices on-chain via Chainlink Price Feeds:

Maps stock tickers (TSLA, AAPL, etc.) to Chainlink aggregators.

Allows reading latestPrice() and latestRoundData().

Admin-configurable by owner.



🧭 **Deployment Order**
1. 🧪 Deploy TestERC20 (for testing Vault)
A simple test token like USDC or DAI.

2. 📊 Deploy TestStrategy or your custom strategy
Accepts tokens from Vault

Simulates yield

Required to test Vault behavior

3. 🏦 Deploy Vault.sol
Pass the token address, vault name, and symbol:

```
new Vault(tokenAddress, "Yield Vault", "yTOKEN")
```

Optional: Set the strategy:


```
vault.setYieldStrategy(mockStrategyAddress)
```

4. 📈 Deploy StockPriceOracle.sol
Pass a valid Chainlink feed address on supported networks (Ethereum mainnet, etc.):

```
new StockPriceOracle("0xFeedAddressForTSLA")
```

⚙️ **How It Works**
🏦 Vault
deposit(amount) → Mints shares and optionally sends funds to strategy.

redeem(shares) → Withdraws funds, including yield, if any.

_generateYield() / _redeemYield() → Hook points to interact with strategy.

ERC4626 handles share pricing, total assets, and accounting.

Admin can pause/unpause operations using Ownable + Pausable.

📈 Stock Oracle
Stores a mapping of symbols to Chainlink Aggregators.

Owner sets feed using:

```
setPriceFeed("TSLA", 0x...);
```

External users fetch price with:

```
getLatestPrice("TSLA");
```

Useful for DeFi protocols needing stock collateral pricing.

🧪 **Testing Flow (Remix or Local Hardhat)**
Deploy TestERC20 and mint tokens to yourself.

Deploy TestStrategy using token address.

Deploy Vault and set TestStrategy.

Approve Vault to spend your tokens.

Call deposit() and check balances.

Call withdraw() and verify returns from strategy.

🔐 **Security Notes**
Vault uses ReentrancyGuard, Pausable, and Ownable for safe access control.

Only the Vault can call MockStrategy deposit/withdraw.

Oracle reads are view-only and can't be manipulated (if using Chainlink).

Strategy contracts must be audited before deployment on mainnet.

🌐 Supported Networks
Contract	Network	Notes
Vault	Any EVM chain	Works with any ERC20 token
Stock Oracle	Ethereum Mainnet	Only place Chainlink stock feeds exist
TestStrategy	Local/Testnets	Not for production use

