// SPDX-License-Identifier: GPL-3.0-or-later

pragma solidity =0.8.4;

import {IQryptSwapFactory} from "./interfaces/IQryptSwapFactory.sol";
import {IQryptSwapPair} from "./interfaces/IQryptSwapPair.sol";
import {QryptSwapPair} from "./QryptSwapPair.sol";

contract QryptSwapFactory is IQryptSwapFactory {
    bytes32 public constant PAIR_HASH =
        keccak256(type(QryptSwapPair).creationCode);

    address public override feeTo;
    address public override feeToSetter;

    mapping(address => mapping(address => address)) public override getPair;
    address[] public override allPairs;

    constructor(address _feeToSetter) {
        feeToSetter = _feeToSetter;
    }

    function allPairsLength() external view override returns (uint256) {
        return allPairs.length;
    }

    function createPair(
        address tokenA,
        address tokenB
    ) external override returns (address pair) {
        require(tokenA != tokenB, "QryptSwap: IDENTICAL_ADDRESSES");
        (address token0, address token1) = tokenA < tokenB
            ? (tokenA, tokenB)
            : (tokenB, tokenA);
        require(token0 != address(0), "QryptSwap: ZERO_ADDRESS");
        require(
            getPair[token0][token1] == address(0),
            "QryptSwap: PAIR_EXISTS"
        ); // single check is sufficient

        pair = address(
            new QryptSwapPair{
                salt: keccak256(abi.encodePacked(token0, token1))
            }()
        );
        IQryptSwapPair(pair).initialize(token0, token1);
        getPair[token0][token1] = pair;
        getPair[token1][token0] = pair; // populate mapping in the reverse direction
        allPairs.push(pair);
        emit PairCreated(token0, token1, pair, allPairs.length);
    }

    function setFeeTo(address _feeTo) external override {
        require(msg.sender == feeToSetter, "QryptSwap: FORBIDDEN");
        feeTo = _feeTo;
    }

    function setFeeToSetter(address _feeToSetter) external override {
        require(msg.sender == feeToSetter, "QryptSwap: FORBIDDEN");
        feeToSetter = _feeToSetter;
    }
}
