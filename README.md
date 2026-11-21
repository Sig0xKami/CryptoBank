# CryptoBank

A multi-user ether bank contract built with Foundry. Users can deposit and withdraw ETH up to a per-user cap that the admin can adjust.

## Rules

- Multiple users can hold a balance in the same contract.
- Users can only withdraw ether they previously deposited.
- Each user's balance is capped (default: 5 ether).
- The admin can change the cap at any time.

## Contract

`src/CryptoBank.sol` — tracks each user's balance in a mapping, enforces the deposit cap, and follows the checks-effects-interactions pattern on withdrawal to guard against reentrancy.

## Usage

```shell
forge install    # fetch dependencies
forge build
forge test
```

## Deploy

```shell
forge script script/DeployCryptoBank.s.sol --rpc-url <RPC_URL> --private-key <PRIVATE_KEY> --broadcast
```
