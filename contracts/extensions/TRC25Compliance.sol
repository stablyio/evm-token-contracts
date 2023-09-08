// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "../bases/TRC25.sol";
import "@openzeppelin/contracts-upgradeable/utils/ContextUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";

/**
 * @dev Extension of {ERC20} that allows a compliance role to freeze and seize
 * tokens for compliance purposes.
 */
abstract contract TRC25Compliance is TRC25 {
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
