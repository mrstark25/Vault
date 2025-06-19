// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @notice Interface for Chainlink Aggregator
interface AggregatorV3Interface {
    function latestRoundData()
        external
        view
        returns (
            uint80 roundId,
            int256 answer,
            uint256 startedAt,
            uint256 updatedAt,
            uint80 answeredInRound
        );

    function decimals() external view returns (uint8);
}

contract StockPriceOracle {
    AggregatorV3Interface public immutable priceFeed;

    /// @param _priceFeed The Chainlink price feed address for the stock (e.g., TSLA/USD)
    constructor(address _priceFeed) {
        require(_priceFeed != address(0), "Invalid feed address");
        priceFeed = AggregatorV3Interface(_priceFeed);
    }

    /// @notice Returns latest stock price and decimals
    function getLatestPrice() external view returns (int256 price, uint8 decimals) {
        (, price, , , ) = priceFeed.latestRoundData();
        decimals = priceFeed.decimals();
    }

    /// @notice Returns full Chainlink round data
    function getLatestRoundData()
        external
        view
        returns (
            uint80 roundId,
            int256 answer,
            uint256 startedAt,
            uint256 updatedAt,
            uint80 answeredInRound,
            uint8 decimals
        )
    {
        (roundId, answer, startedAt, updatedAt, answeredInRound) = priceFeed.latestRoundData();
        decimals = priceFeed.decimals();
    }
}
