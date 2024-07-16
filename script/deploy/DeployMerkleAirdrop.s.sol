//SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import {Script} from "forge-std/Script.sol";
import {MerkleAirdrop} from "../../src/MerkleAirdrop.sol";
import {MasalaToken} from "../../src/MasalaToken.sol";

contract CodeConstant {
    bytes32 public constant ROOT = 0x7cdb6c21ef22a6cb5726d348e677f3e10032127425d425c5028965a30a71556e;
    uint256 AMOUT_TO_CLAIM = 25 * 1e18;
    uint256 MINT_AMOUNT = 4 * AMOUT_TO_CLAIM;
}

contract DeployMerkleAirdrop is Script, CodeConstant {
    function deployerAirdrop() public returns (MasalaToken masalaToken, MerkleAirdrop merkleAirdrop) {
        vm.startBroadcast();
        masalaToken = new MasalaToken();
        merkleAirdrop = new MerkleAirdrop(masalaToken, ROOT);
        masalaToken.mint(masalaToken.owner(), MINT_AMOUNT);
        masalaToken.transfer(address(merkleAirdrop), MINT_AMOUNT);
        vm.stopBroadcast();
        return (masalaToken, merkleAirdrop);
    }

    function run() public returns (MasalaToken masalaToken, MerkleAirdrop merkleAirdrop) {
        return deployerAirdrop();
    }
}
