//SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import {IERC20, SafeERC20} from "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import {MerkleProof} from "@openzeppelin/contracts/utils/cryptography/MerkleProof.sol";
import {EIP712} from "@openzeppelin/contracts/utils/cryptography/EIP712.sol";
import {ECDSA} from "@openzeppelin/contracts/utils/cryptography/ECDSA.sol";

/**
 * @title MerkleAirdrop
 * @author Cryptoineer (Ajitesh Mishra)
 * @notice MerkleAirdrop contract is used to claim masala tokens for allowed list of user in merkle tree.
 */
contract MerkleAirdrop is EIP712 {
    /*//////////////////////////////////////////////////////////////
                                 ERROR
    //////////////////////////////////////////////////////////////*/
    error MerkleAirdrop__InvalidProof();
    error MerkleAirdrop__AlreadyClaimed();
    error MerkleAirdrop__InvalidSignature();

    /*//////////////////////////////////////////////////////////////
                                  TYPE
    //////////////////////////////////////////////////////////////*/

    using SafeERC20 for IERC20;

    struct AirdropClaim {
        address user;
        uint256 amount;
    }

    /*//////////////////////////////////////////////////////////////
                            STATE VARIABLES
    //////////////////////////////////////////////////////////////*/
    string private constant NAME = "Masala Airdrop";
    string private constant VERSION = "1";
    bytes32 private constant TYPE_HASH = keccak256("AirdropClaim(address,uint256)");
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

    constructor(IERC20 _airdrop, bytes32 _merkleRoot) EIP712(NAME, VERSION) {
        i_airdrop = _airdrop;
        i_merkleRoot = _merkleRoot;
    }

    /**
     * @param _to user address
     * @param _amount masala token amount to claim
     * @param _proof merkle proof to claim
     * @notice Follows CEI (Checks, Effect and Interaction) pattern
     */
    function claim(address _to, uint256 _amount, bytes32[] memory _proof, uint8 v, bytes32 r, bytes32 s)
        external
        payable
    {
        if (hasClaimed[_to]) {
            revert MerkleAirdrop__AlreadyClaimed();
        }
        if (!_isValidSignature(_to, getMessageHash(_to, _amount), v, r, s)) {
            revert MerkleAirdrop__InvalidSignature();
        }
        bytes32 leaf = keccak256(bytes.concat(keccak256(abi.encode(_to, _amount))));
        bool isVerified = MerkleProof.verify(_proof, i_merkleRoot, leaf);
        if (!isVerified) {
            revert MerkleAirdrop__InvalidProof();
        }
        hasClaimed[_to] = true;
        emit Claimed(_to, _amount);
        i_airdrop.safeTransfer(_to, _amount);
    }

    /*//////////////////////////////////////////////////////////////
                            PRIVATE & INTERNAL FUNCTIONS
    //////////////////////////////////////////////////////////////*/

    function _isValidSignature(address _user, bytes32 _message, uint8 _v, bytes32 _r, bytes32 _s)
        internal
        pure
        returns (bool)
    {
        (address signer,,) = ECDSA.tryRecover(_message, _v, _r, _s);
        return signer == _user;
    }

    /*//////////////////////////////////////////////////////////////
                              EXTENAL VIEW FUNCTIONS
    //////////////////////////////////////////////////////////////*/

    function getMessageHash(address _account, uint256 _amount) public view returns (bytes32) {
        return _hashTypedDataV4(keccak256(abi.encode(TYPE_HASH, AirdropClaim({user: _account, amount: _amount}))));
    }

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
