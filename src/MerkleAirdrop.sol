//SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import {IERC20, SafeERC20} from "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import {MerkleProof} from "@openzeppelin/contracts/utils/cryptography/MerkleProof.sol";

/**
 * @title MerkleAirdrop
 * @author Cryptoineer (Ajitesh Mishra)
 * @notice MerkleAirdrop contract is used to claim masala tokens for allowed list of user in merkle tree.
 */
contract MerkleAirdrop {
    /*//////////////////////////////////////////////////////////////
                                 ERROR
    //////////////////////////////////////////////////////////////*/
    error MerkleAirdrop__InvalidProof();
    error MerkleAirdrop__AlreadyClaimed();

    /*//////////////////////////////////////////////////////////////
                                  TYPE
    //////////////////////////////////////////////////////////////*/

    using SafeERC20 for IERC20;

    /*//////////////////////////////////////////////////////////////
                            STATE VARIABLES
    //////////////////////////////////////////////////////////////*/
    IERC20 private immutable i_airdrop;
    bytes32 private immutable i_merkleRoot;
    mapping(address user => bool claimed) private hasClaimed;

    /*//////////////////////////////////////////////////////////////
                                 EVENT
    //////////////////////////////////////////////////////////////*/
    event Claimed(address indexed user, uint256 indexed amount);
    /*//////////////////////////////////////////////////////////////
                            PUBLIC FUNCTIONS
    //////////////////////////////////////////////////////////////*/
    /**
     * @param _airdrop airdrop token (Masala token)
     * @param _merkleRoot merkle root
     */

    constructor(IERC20 _airdrop, bytes32 _merkleRoot) {
        i_airdrop = _airdrop;
        i_merkleRoot = _merkleRoot;
    }

    /**
     * @param _to user address
     * @param _amount masala token amount to claim
     * @param _proof merkle proof to claim
     * @notice Follows CEI (Checks, Effect and Interaction) pattern
     */
    function claim(address _to, uint256 _amount, bytes32[] memory _proof) external payable {
        if (hasClaimed[_to]) {
            revert MerkleAirdrop__AlreadyClaimed();
        }
        bytes32 leaf = keccak256(bytes.concat(keccak256(abi.encode(_to, _amount))));
        bool isVerified = MerkleProof.verify(_proof, i_merkleRoot, leaf);
        if (!isVerified) {
            revert MerkleAirdrop__InvalidProof();
        }
        hasClaimed[_to] = true;
        emit Claimed(_to, _amount);
        i_airdrop.safeTransferFrom(msg.sender, _to, _amount);
    }

    /*//////////////////////////////////////////////////////////////
                              EXTENAL VIEW FUNCTIONS
    //////////////////////////////////////////////////////////////*/

    function getMerkleRoot() external view returns (bytes32) {
        return i_merkleRoot;
    }

    function getAirdropToken() external view returns (address airdropToken) {
        return address(i_airdrop);
    }

    function isClaimed(address _user) external view returns (bool) {
        return hasClaimed[_user];
    }
}
