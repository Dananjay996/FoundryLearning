//SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

import {Script} from "forge-std/Script.sol";
import {MockV3Aggregator} from "../test/mocks/MockV3Aggregator.sol";

contract HelperConfig is Script {

    struct NetworkConfig {
        address pricefeed;
    }

    NetworkConfig public activeNetworkConfig;

    constructor() {
        if(block.chainid == 11155111) {
            activeNetworkConfig = sepoliaEthUsdPriceFeed();
        }else {
            activeNetworkConfig = anvilEthUsdPriceFeed();
        }
    }

    function sepoliaEthUsdPriceFeed() public pure returns(NetworkConfig memory) {
        NetworkConfig memory sepoliaEthUsdPriceFeedAddress = NetworkConfig({pricefeed: 0x694AA1769357215DE4FAC081bf1f309aDC325306});
        return sepoliaEthUsdPriceFeedAddress;
    }

    function anvilEthUsdPriceFeed() public returns(NetworkConfig memory) {

        if(activeNetworkConfig.pricefeed != address(0)) {
            return activeNetworkConfig;
        }
        
        vm.startBroadcast();
        MockV3Aggregator mockV3Aggregator = new MockV3Aggregator(8, 2000e8);
        vm.stopBroadcast();

        NetworkConfig memory anvilEthUsdPriceFeedAddress = NetworkConfig({pricefeed: address(mockV3Aggregator)});
        return anvilEthUsdPriceFeedAddress;
    }
}