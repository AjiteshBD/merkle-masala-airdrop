# MerkleAirdrop Project

![Airdrop](https://media.giphy.com/media/l0Exk8EUzSLsrErEQ/giphy.gif)

## Overview

The `MerkleAirdrop` project allows users to claim Masala tokens if they are part of an allowed list defined by a Merkle tree. This project leverages Merkle proofs and EIP-712 signatures to ensure secure and verified token distribution.



Foundry consists of:

-   **Forge**: Ethereum testing framework (like Truffle, Hardhat and DappTools).
-   **Cast**: Swiss army knife for interacting with EVM smart contracts, sending transactions and getting chain data.
-   **Anvil**: Local Ethereum node, akin to Ganache, Hardhat Network.
-   **Chisel**: Fast, utilitarian, and verbose solidity REPL.

## Documentation

https://book.getfoundry.sh/

## Usage

### Build

```shell
$ forge build
```

### Test

```shell
$ forge test
```

### Format

```shell
$ forge fmt
```

### Gas Snapshots

```shell
$ forge snapshot
```

### Anvil

```shell
$ anvil
```

### Deploy

```shell
$ forge script script/MasalaToken.s.sol:MasalaToken --rpc-url <your_rpc_url> --account <your_keystore-account>
```

### Cast

```shell
$ cast <subcommand>
```

### Help

```shell
$ forge --help
$ anvil --help
$ cast --help
```
