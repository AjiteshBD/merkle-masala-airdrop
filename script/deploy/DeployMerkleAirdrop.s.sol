//SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import {Script} from "forge-std/Script.sol";
import {MerkleAirdrop} from "../../src/MerkleAirdrop.sol";
import {MasalaToken} from "../../src/MasalaToken.sol";
import {CodeConstant} from "../utils/CodeConstant.s.sol";

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
