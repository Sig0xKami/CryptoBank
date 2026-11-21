// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

import "forge-std/Test.sol";
import {CryptoBank} from "../src/CryptoBank.sol";

contract CryptoBankTest is Test {
    CryptoBank bank;

    address admin = makeAddr("admin");
    address userA = makeAddr("userA");
    address userB = makeAddr("userB");

    uint256 constant MAX_BALANCE = 5 ether;

    function setUp() public {
        bank = new CryptoBank(MAX_BALANCE, admin);
        vm.deal(userA, 10 ether);
        vm.deal(userB, 10 ether);
    }

    function test_DepositRecordsBalance() public {
        vm.prank(userA);
        bank.depositEther{value: 2 ether}();

        assertEq(bank.userBalance(userA), 2 ether);
        assertEq(address(bank).balance, 2 ether);
    }

    function test_DepositRevertsAboveMaxBalance() public {
        vm.prank(userA);
        vm.expectRevert("MaxBalance reached");
        bank.depositEther{value: MAX_BALANCE + 1}();
    }

    function test_MultipleUsersTrackSeparateBalances() public {
        vm.prank(userA);
        bank.depositEther{value: 3 ether}();

        vm.prank(userB);
        bank.depositEther{value: 1 ether}();

        assertEq(bank.userBalance(userA), 3 ether);
        assertEq(bank.userBalance(userB), 1 ether);
        assertEq(address(bank).balance, 4 ether);
    }

    function test_WithdrawTransfersEtherAndUpdatesBalance() public {
        vm.prank(userA);
        bank.depositEther{value: 2 ether}();

        uint256 balanceBefore = userA.balance;

        vm.prank(userA);
        bank.withdrawEther(1 ether);

        assertEq(bank.userBalance(userA), 1 ether);
        assertEq(userA.balance, balanceBefore + 1 ether);
    }

    function test_WithdrawRevertsAboveUserBalance() public {
        vm.prank(userA);
        bank.depositEther{value: 1 ether}();

        vm.prank(userA);
        vm.expectRevert("Not enough ether");
        bank.withdrawEther(2 ether);
    }

    function test_OnlyAdminCanModifyMaxBalance() public {
        vm.prank(admin);
        bank.modifyMaxBalance(10 ether);
        assertEq(bank.maxBalance(), 10 ether);
    }

    function test_ModifyMaxBalanceRevertsForNonAdmin() public {
        vm.prank(userA);
        vm.expectRevert("Not allowed");
        bank.modifyMaxBalance(10 ether);
    }
}
