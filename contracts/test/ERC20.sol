// SPDX-License-Identifier: GPL-3.0-or-later

pragma solidity =0.8.4;

import {QryptSwapERC20} from "../QryptSwapERC20.sol";

contract ERC20 is QryptSwapERC20 {
    constructor(uint256 _totalSupply) {
        _mint(msg.sender, _totalSupply);
    }
}
