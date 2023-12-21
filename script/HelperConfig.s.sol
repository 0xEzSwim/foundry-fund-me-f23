// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;
import {Script} from "forge-std/Script.sol";
import {MockV3Aggregator} from "../test/mocks/MockV3Aggregator.sol";

contract HelperConfig is Script {
    NetworkConfig public activeNetworkConfig;

    uint8 public constant DECIMALS = 8;
    int256 public constant INTIAL_PRICE = 2000 * 1e8;

    struct NetworkConfig {
        address priceFeed; // ETH/USD price feed address
    }

    constructor() {
        if (block.chainid == 11155111) {
            activeNetworkConfig = getSepoliaEthConfig();
        } else {
            activeNetworkConfig = getLocalEthConfig();
        }
    }

    function getLocalEthConfig() public returns (NetworkConfig memory) {
        if (activeNetworkConfig.priceFeed != address(0)) {
            return activeNetworkConfig;
        }

        return _createLocalEthConfig();
    }

    function _createLocalEthConfig() private returns (NetworkConfig memory) {
        vm.startBroadcast();
        MockV3Aggregator mock = new MockV3Aggregator({
            _decimals: DECIMALS,
            _initialAnswer: INTIAL_PRICE
        });
        vm.stopBroadcast();

        NetworkConfig memory localConfig = NetworkConfig({
            priceFeed: address(mock)
        });

        return localConfig;
    }

    function getSepoliaEthConfig() public view returns (NetworkConfig memory) {
        if (activeNetworkConfig.priceFeed != address(0)) {
            return activeNetworkConfig;
        }

        NetworkConfig memory sepoliaConfig = NetworkConfig({
            priceFeed: 0x694AA1769357215DE4FAC081bf1f309aDC325306
        });

        return sepoliaConfig;
    }
}
