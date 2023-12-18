// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/utils/Context.sol";

/**
 * @dev Extension of {ERC20} that allows a compliance role to freeze and seize
 * tokens for compliance purposes.
 */
abstract contract ERC20Compliance is ERC20 {
    mapping(address => bool) private _frozen;

    modifier whenNotFrozen(address account) {
        require(!_frozen[account], "TRC25Compliance: account is frozen");
        _;
    }

    function _freeze(address account) internal virtual {
        _frozen[account] = true;
    }

    function _unfreeze(address account) internal virtual {
        _frozen[account] = false;
    }

    function _seize(address account, uint256 amount) internal virtual {
        _burn(account, amount);
    }
}
