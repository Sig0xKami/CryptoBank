// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

import {Script} from "forge-std/Script.sol";
import {CryptoBank} from "../src/CryptoBank.sol";

contract DeployCryptoBank is Script {
    uint256 constant MAX_BALANCE = 5 ether;

    function run() external returns (CryptoBank) {
        vm.startBroadcast();
        CryptoBank cryptoBank = new CryptoBank(MAX_BALANCE, msg.sender);
        vm.stopBroadcast();
        return cryptoBank;
    }
}
