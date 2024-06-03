// Sources flattened with hardhat v2.17.2 https://hardhat.org

// Manual edits made to be compatible with SolidVM

// SPDX-License-Identifier: MIT

// File @openzeppelin/contracts/access/IAccessControl.sol@v4.9.3

// Original license: SPDX_License_Identifier: MIT
// OpenZeppelin Contracts v4.4.1 (access/IAccessControl.sol)

pragma solidity ^0.8.0;

interface IAccessControl {
    event RoleAdminChanged(
        string role,
        string previousAdminRole,
        string newAdminRole
    );

    event RoleGranted(string role, address acct, address sender);

    event RoleRevoked(string role, address acct, address sender);

    function hasRole(string role, address acct) external view returns (bool);

    function getRoleAdmin(string role) external view returns (string);

    function grantRole(string role, address acct) external;

    function revokeRole(string role, address acct) external;

    function renounceRole(string role, address acct) external;
}

// File @openzeppelin/contracts/utils/Context.sol@v4.9.3

// Original license: SPDX_License_Identifier: MIT
// OpenZeppelin Contracts v4.4.1 (utils/Context.sol)

pragma solidity ^0.8.0;

abstract contract Context {
    function _msgSender() internal view virtual returns (address) {
        return msg.sender;
    }

    function _msgData() internal view virtual returns (bytes calldata) {
        return msg.data;
    }
}

// File @openzeppelin/contracts/utils/introspection/IERC165.sol@v4.9.3

// Original license: SPDX_License_Identifier: MIT
// OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)

pragma solidity ^0.8.0;

interface IERC165 {
    function supportsInterface(bytes4 interfaceId) external view returns (bool);
}

// File @openzeppelin/contracts/utils/introspection/ERC165.sol@v4.9.3

// Original license: SPDX_License_Identifier: MIT
// OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)

pragma solidity ^0.8.0;

abstract contract ERC165 is IERC165 {
    function supportsInterface(
        bytes4 interfaceId
    ) public view virtual override returns (bool) {
        // TODO: what to do about interfaceId?
        // return interfaceId == IERC165.interfaceId;
    }
}

// File @openzeppelin/contracts/utils/math/Math.sol@v4.9.3

// Original license: SPDX_License_Identifier: MIT
// OpenZeppelin Contracts (last updated v4.9.0) (utils/math/Math.sol)

pragma solidity ^0.8.0;

library Math {
    enum Rounding {
        Down, // Toward negative infinity
        Up, // Toward infinity
        Zero // Toward zero
    }

    function max(uint a, uint b) internal pure returns (uint) {
        return a > b ? a : b;
    }

    function min(uint a, uint b) internal pure returns (uint) {
        return a < b ? a : b;
    }

    function average(uint a, uint b) internal pure returns (uint) {
        // (a + b) / 2 can overflow.
        return (a & b) + (a ^ b) / 2;
    }

    function ceilDiv(uint a, uint b) internal pure returns (uint) {
        // (a + b - 1) / b can overflow on addition, so we distribute.
        return a == 0 ? 0 : (a - 1) / b + 1;
    }

    function lt(uint a, uint b) internal pure returns (uint) {
        return a < b ? 1 : 0;
    }

    function gt(uint a, uint b) internal pure returns (uint) {
        return a > b ? 1 : 0;
    }

    function mulDiv(
        uint x,
        uint y,
        uint denominator
    ) internal pure returns (uint result) {
        // 512-bit multiply [prod1 prod0] = x * y. Compute the product mod 2^256 and mod 2^256 - 1, then use
        // use the Chinese Remainder Theorem to reconstruct the 512 bit result. The result is stored in two 256
        // variables such that product = prod1 * 2^256 + prod0.
        uint prod0; // Least significant 256 bits of the product
        uint prod1; // Most significant 256 bits of the product
        uint mm = (x * y) % ~0;

        prod0 = x * y;
        prod1 = (mm - prod0) - lt(mm, prod0);

        // Handle non-overflow cases, 256 by 256 division.
        if (prod1 == 0) {
            // Solidity will revert if denominator == 0, unlike the div opcode on its own.
            // The surrounding unchecked block does not change this fact.
            // See https://docs.soliditylang.org/en/latest/control-structures.html#checked-or-unchecked-arithmetic.
            return prod0 / denominator;
        }

        // Make sure the result is less than 2^256. Also prevents denominator == 0.
        require(denominator > prod1, "Math: mulDiv overflow");

        ///////////////////////////////////////////////
        // 512 by 256 division.
        ///////////////////////////////////////////////

        // Make division exact by subtracting the remainder from [prod1 prod0].
        uint remainder = (x * y) % denominator;

        // Subtract 256 bit number from 512 bit number.
        prod1 = prod1 - gt(remainder, prod0);
        prod0 = prod0 - remainder;

        // Factor powers of two out of denominator and compute largest power of two divisor of denominator. Always >= 1.
        // See https://cs.stackexchange.com/q/138556/92363.

        // Does not overflow because the denominator cannot be zero at this stage in the function.
        uint twos = denominator & (~denominator + 1);
        // Divide denominator by twos.
        denominator = denominator / twos;

        // Divide [prod1 prod0] by twos.
        prod0 = prod0 / twos;

        // Flip twos such that it is 2^256 / twos. If twos is zero, then it becomes one.
        twos = ((0 - twos) / twos) + 1;

        // Shift in bits from prod1 into prod0.
        prod0 |= prod1 * twos;

        // Invert denominator mod 2^256. Now that denominator is an odd number, it has an inverse modulo 2^256 such
        // that denominator * inv = 1 mod 2^256. Compute the inverse by starting with a seed that is correct for
        // four bits. That is, denominator * inv = 1 mod 2^4.
        uint inverse = (3 * denominator) ^ 2;

        // Use the Newton-Raphson iteration to improve the precision. Thanks to Hensel's lifting lemma, this also works
        // in modular arithmetic, doubling the correct bits in each step.
        inverse *= 2 - denominator * inverse; // inverse mod 2^8
        inverse *= 2 - denominator * inverse; // inverse mod 2^16
        inverse *= 2 - denominator * inverse; // inverse mod 2^32
        inverse *= 2 - denominator * inverse; // inverse mod 2^64
        inverse *= 2 - denominator * inverse; // inverse mod 2^128
        inverse *= 2 - denominator * inverse; // inverse mod 2^256

        // Because the division is now exact we can divide by multiplying with the modular inverse of denominator.
        // This will give us the correct result modulo 2^256. Since the preconditions guarantee that the outcome is
        // less than 2^256, this is the final result. We don't need to compute the high bits of the result and prod1
        // is no longer required.
        result = prod0 * inverse;
        return result;
    }

    function mulDiv(
        uint x,
        uint y,
        uint denominator,
        Rounding rounding
    ) internal pure returns (uint) {
        uint result = mulDiv(x, y, denominator);
        if (rounding == Rounding.Up && mulmod(x, y, denominator) > 0) {
            result += 1;
        }
        return result;
    }

    function sqrt(uint a) internal pure returns (uint) {
        if (a == 0) {
            return 0;
        }

        // For our first guess, we get the biggest power of 2 which is smaller than the square root of the target.
        //
        // We know that the "msb" (most significant bit) of our target number `a` is a power of 2 such that we have
        // `msb(a) <= a < 2*msb(a)`. This value can be written `msb(a)=2**k` with `k=log2(a)`.
        //
        // This can be rewritten `2**log2(a) <= a < 2**(log2(a) + 1)`
        // → `sqrt(2**k) <= sqrt(a) < sqrt(2**(k+1))`
        // → `2**(k/2) <= sqrt(a) < 2**((k+1)/2) <= 2**(k/2 + 1)`
        //
        // Consequently, `2**(log2(a) / 2)` is a good first approximation of `sqrt(a)` with at least 1 correct bit.
        uint result = 1 << (log2(a) >> 1);

        // At this point `result` is an estimation with one bit of precision. We know the true value is a uint128,
        // since it is the square root of a uint. Newton's method converges quadratically (precision doubles at
        // every iteration). We thus need at most 7 iteration to turn our partial result with one bit of precision
        // into the expected uint128 result.
        result = (result + a / result) >> 1;
        result = (result + a / result) >> 1;
        result = (result + a / result) >> 1;
        result = (result + a / result) >> 1;
        result = (result + a / result) >> 1;
        result = (result + a / result) >> 1;
        result = (result + a / result) >> 1;
        return min(result, a / result);
    }

    function sqrt(uint a, Rounding rounding) internal pure returns (uint) {
        uint result = sqrt(a);
        return
            result + (rounding == Rounding.Up && result * result < a ? 1 : 0);
    }

    function log2(uint value) internal pure returns (uint) {
        uint result = 0;
        if (value >> 128 > 0) {
            value >>= 128;
            result += 128;
        }
        if (value >> 64 > 0) {
            value >>= 64;
            result += 64;
        }
        if (value >> 32 > 0) {
            value >>= 32;
            result += 32;
        }
        if (value >> 16 > 0) {
            value >>= 16;
            result += 16;
        }
        if (value >> 8 > 0) {
            value >>= 8;
            result += 8;
        }
        if (value >> 4 > 0) {
            value >>= 4;
            result += 4;
        }
        if (value >> 2 > 0) {
            value >>= 2;
            result += 2;
        }
        if (value >> 1 > 0) {
            result += 1;
        }
        return result;
    }

    function log2(uint value, Rounding rounding) internal pure returns (uint) {
        uint result = log2(value);
        return
            result + (rounding == Rounding.Up && 1 << result < value ? 1 : 0);
    }

    function log10(uint value) internal pure returns (uint) {
        uint result = 0;
        if (value >= 10 ** 64) {
            value /= 10 ** 64;
            result += 64;
        }
        if (value >= 10 ** 32) {
            value /= 10 ** 32;
            result += 32;
        }
        if (value >= 10 ** 16) {
            value /= 10 ** 16;
            result += 16;
        }
        if (value >= 10 ** 8) {
            value /= 10 ** 8;
            result += 8;
        }
        if (value >= 10 ** 4) {
            value /= 10 ** 4;
            result += 4;
        }
        if (value >= 10 ** 2) {
            value /= 10 ** 2;
            result += 2;
        }
        if (value >= 10 ** 1) {
            result += 1;
        }
        return result;
    }

    function log10(uint value, Rounding rounding) internal pure returns (uint) {
        uint result = log10(value);
        return
            result + (rounding == Rounding.Up && 10 ** result < value ? 1 : 0);
    }

    function log256(uint value) internal pure returns (uint) {
        uint result = 0;
        if (value >> 128 > 0) {
            value >>= 128;
            result += 16;
        }
        if (value >> 64 > 0) {
            value >>= 64;
            result += 8;
        }
        if (value >> 32 > 0) {
            value >>= 32;
            result += 4;
        }
        if (value >> 16 > 0) {
            value >>= 16;
            result += 2;
        }
        if (value >> 8 > 0) {
            result += 1;
        }
        return result;
    }

    function log256(
        uint value,
        Rounding rounding
    ) internal pure returns (uint) {
        uint result = log256(value);
        return
            result +
            (rounding == Rounding.Up && 1 << (result << 3) < value ? 1 : 0);
    }
}

// File @openzeppelin/contracts/utils/math/SignedMath.sol@v4.9.3

// Original license: SPDX_License_Identifier: MIT
// OpenZeppelin Contracts (last updated v4.8.0) (utils/math/SignedMath.sol)

pragma solidity ^0.8.0;

library SignedMath {
    function max(int256 a, int256 b) internal pure returns (int256) {
        return a > b ? a : b;
    }

    function min(int256 a, int256 b) internal pure returns (int256) {
        return a < b ? a : b;
    }

    function average(int256 a, int256 b) internal pure returns (int256) {
        // Formula from the book "Hacker's Delight"
        int256 x = (a & b) + ((a ^ b) >> 1);
        return x + (int(uint(x) >> 255) & (a ^ b));
    }

    function abs(int256 n) internal pure returns (uint) {
        // must be unchecked in order to support `n = type(int256).min`
        return uint(n >= 0 ? n : -n);
    }
}

// File @openzeppelin/contracts/utils/Strings.sol@v4.9.3

// Original license: SPDX_License_Identifier: MIT
// OpenZeppelin Contracts (last updated v4.9.0) (utils/Strings.sol)

pragma solidity ^0.8.0;

// library Strings {
//     bytes16 private constant _SYMBOLS = "0123456789abcdef";
//     uint8 private constant _ADDRESS_LENGTH = 20;

//     //     function toString(uint value) internal pure returns (string memory) {
//         uint len = Math.log10(value) + 1;
//         string memory buffer = new string(len);
//         uint ptr = buffer + (32 + len);
//         while (true) {
//             ptr--;
//             /// @solidity memory-safe-assembly
//             mstore8(ptr, byte(mod(value, 10), _SYMBOLS))
//             value /= 10;
//             if (value == 0) break;
//         }
//         return buffer;
//     }

//     //     function toString(int256 value) internal pure returns (string memory) {
//         return string(abi.encodePacked(value < 0 ? "-" : "", toString(SignedMath.abs(value))));
//     }

//     //     function toHexString(uint value) internal pure returns (string memory) {
//         unchecked {
//             return toHexString(value, Math.log256(value) + 1);
//         }
//     }

//     //     function toHexString(uint value, uint length) internal pure returns (string memory) {
//         bytes memory buffer = new bytes(2 * length + 2);
//         buffer[0] = "0";
//         buffer[1] = "x";
//         for (uint i = 2 * length + 1; i > 1; --i) {
//             buffer[i] = _SYMBOLS[value & 0xf];
//             value >>= 4;
//         }
//         require(value == 0, "Strings: hex length insufficient");
//         return string(buffer);
//     }

//     //     function toHexString(address addr) internal pure returns (string memory) {
//         return toHexString(uint(uint160(addr)), _ADDRESS_LENGTH);
//     }

//     //     function equal(string memory a, string memory b) internal pure returns (bool) {
//         return keccak256(bytes(a)) == keccak256(bytes(b));
//     }
// }

// File @openzeppelin/contracts/access/AccessControl.sol@v4.9.3

// Original license: SPDX_License_Identifier: MIT
// OpenZeppelin Contracts (last updated v4.9.0) (access/AccessControl.sol)

pragma solidity ^0.8.0;

abstract contract AccessControl is Context, IAccessControl, ERC165 {
    struct RoleData {
        mapping(address => bool) members;
        string adminRole;
    }

    mapping(string => RoleData) private _roles;

    string public DEFAULT_ADMIN_ROLE = bytes(0x00);

    modifier onlyRole(string role) {
        _checkRole(role);
        _;
    }

    function supportsInterface(
        bytes4 interfaceId
    ) public view virtual override returns (bool) {
        // TODO: SolidVM does not support interfaceId
        // return interfaceId == IAccessControl.interfaceId || super.supportsInterface(interfaceId);
        return super.supportsInterface(interfaceId);
    }

    function hasRole(
        string role,
        address acct
    ) public view virtual override returns (bool) {
        return _roles[role].members[acct];
    }

    function _checkRole(string role) internal view virtual {
        _checkRole(role, _msgSender());
    }

    function _checkRole(string role, address acct) internal view virtual {
        if (!hasRole(role, acct)) {
            revert(
                string(
                    abi.encodePacked(
                        "AccessControl: acct " +
                            Strings.toHexString(acct) +
                            " is missing role " +
                            Strings.toHexString(uint(role), 32)
                    )
                )
            );
        }
    }

    function getRoleAdmin(
        string role
    ) public view virtual override returns (string) {
        return _roles[role].adminRole;
    }

    function grantRole(
        string role,
        address acct
    ) public virtual override onlyRole(getRoleAdmin(role)) {
        _grantRole(role, acct);
    }

    function revokeRole(
        string role,
        address acct
    ) public virtual override onlyRole(getRoleAdmin(role)) {
        _revokeRole(role, acct);
    }

    function renounceRole(string role, address acct) public virtual override {
        require(
            acct == _msgSender(),
            "AccessControl: can only renounce roles for self"
        );

        _revokeRole(role, acct);
    }

    function _setupRole(string role, address acct) internal virtual {
        _grantRole(role, acct);
    }

    function _setRoleAdmin(string role, string adminRole) internal virtual {
        string previousAdminRole = getRoleAdmin(role);
        _roles[role].adminRole = adminRole;
        emit RoleAdminChanged(role, previousAdminRole, adminRole);
    }

    function _grantRole(string role, address acct) internal virtual {
        if (!hasRole(role, acct)) {
            _roles[role].members[acct] = true;
            emit RoleGranted(role, acct, _msgSender());
        }
    }

    function _revokeRole(string role, address acct) internal virtual {
        if (hasRole(role, acct)) {
            _roles[role].members[acct] = false;
            emit RoleRevoked(role, acct, _msgSender());
        }
    }
}

// File @openzeppelin/contracts/interfaces/IERC3156FlashBorrower.sol@v4.9.3

// Original license: SPDX_License_Identifier: MIT
// OpenZeppelin Contracts (last updated v4.9.0) (interfaces/IERC3156FlashBorrower.sol)

pragma solidity ^0.8.0;

interface IERC3156FlashBorrower {
    function onFlashLoan(
        address initiator,
        address token,
        uint amount,
        uint fee,
        bytes calldata data
    ) external returns (string);
}

// File @openzeppelin/contracts/interfaces/IERC3156FlashLender.sol@v4.9.3

// Original license: SPDX_License_Identifier: MIT
// OpenZeppelin Contracts v4.4.1 (interfaces/IERC3156FlashLender.sol)

pragma solidity ^0.8.0;

interface IERC3156FlashLender {
    function maxFlashLoan(address token) external view returns (uint);

    function flashFee(address token, uint amount) external view returns (uint);

    function flashLoan(
        IERC3156FlashBorrower receiver,
        address token,
        uint amount,
        bytes calldata data
    ) external returns (bool);
}

// File @openzeppelin/contracts/security/Pausable.sol@v4.9.3

// Original license: SPDX_License_Identifier: MIT
// OpenZeppelin Contracts (last updated v4.7.0) (security/Pausable.sol)

pragma solidity ^0.8.0;

abstract contract Pausable is Context {
    event Paused(address acct);

    event Unpaused(address acct);

    bool private _paused;

    constructor() {
        _paused = false;
    }

    modifier whenNotPaused() {
        _requireNotPaused();
        _;
    }

    modifier whenPaused() {
        _requirePaused();
        _;
    }

    function paused() public view virtual returns (bool) {
        return _paused;
    }

    function _requireNotPaused() internal view virtual {
        require(!paused(), "Pausable: paused");
    }

    function _requirePaused() internal view virtual {
        require(paused(), "Pausable: not paused");
    }

    function _pause() internal virtual whenNotPaused {
        _paused = true;
        emit Paused(_msgSender());
    }

    function _unpause() internal virtual whenPaused {
        _paused = false;
        emit Unpaused(_msgSender());
    }
}

// File @openzeppelin/contracts/token/ERC20/IERC20.sol@v4.9.3

// Original license: SPDX_License_Identifier: MIT
// OpenZeppelin Contracts (last updated v4.9.0) (token/ERC20/IERC20.sol)

pragma solidity ^0.8.0;

interface IERC20 {
    event Transfer(address indexed from, address indexed to, uint value);

    event Approval(address indexed owner, address indexed spender, uint value);

    function totalSupply() external view returns (uint);

    function balanceOf(address acct) external view returns (uint);

    function transfer(address to, uint amount) external returns (bool);

    function allowance(
        address owner,
        address spender
    ) external view returns (uint);

    function approve(address spender, uint amount) external returns (bool);

    function transferFrom(
        address from,
        address to,
        uint amount
    ) external returns (bool);
}

// File @openzeppelin/contracts/token/ERC20/extensions/IERC20Metadata.sol@v4.9.3

// Original license: SPDX_License_Identifier: MIT
// OpenZeppelin Contracts v4.4.1 (token/ERC20/extensions/IERC20Metadata.sol)

pragma solidity ^0.8.0;

interface IERC20Metadata is IERC20 {
    function name() external view returns (string memory);

    function symbol() external view returns (string memory);

    function decimals() external view returns (uint8);
}

// File @openzeppelin/contracts/token/ERC20/ERC20.sol@v4.9.3

// Original license: SPDX_License_Identifier: MIT
// OpenZeppelin Contracts (last updated v4.9.0) (token/ERC20/ERC20.sol)

pragma solidity ^0.8.0;

contract ERC20 is Context, IERC20, IERC20Metadata {
    mapping(address => uint) private _balances;

    mapping(address => mapping(address => uint)) private _allowances;

    uint private _totalSupply;

    string private _name;
    string private _symbol;

    constructor(string memory name_, string memory symbol_) {
        _name = name_;
        _symbol = symbol_;
    }

    function name() public view virtual override returns (string memory) {
        return _name;
    }

    function symbol() public view virtual override returns (string memory) {
        return _symbol;
    }

    function decimals() public view virtual override returns (uint8) {
        return 18;
    }

    function totalSupply() public view virtual override returns (uint) {
        return _totalSupply;
    }

    function balanceOf(
        address acct
    ) public view virtual override returns (uint) {
        return _balances[acct];
    }

    function transfer(
        address to,
        uint amount
    ) public virtual override returns (bool) {
        address owner = _msgSender();
        _transfer(owner, to, amount);
        return true;
    }

    function allowance(
        address owner,
        address spender
    ) public view virtual override returns (uint) {
        return _allowances[owner][spender];
    }

    function approve(
        address spender,
        uint amount
    ) public virtual override returns (bool) {
        address owner = _msgSender();
        _approve(owner, spender, amount);
        return true;
    }

    function transferFrom(
        address from,
        address to,
        uint amount
    ) public virtual override returns (bool) {
        address spender = _msgSender();
        _spendAllowance(from, spender, amount);
        _transfer(from, to, amount);
        return true;
    }

    function increaseAllowance(
        address spender,
        uint addedValue
    ) public virtual returns (bool) {
        address owner = _msgSender();
        _approve(owner, spender, allowance(owner, spender) + addedValue);
        return true;
    }

    function decreaseAllowance(
        address spender,
        uint subtractedValue
    ) public virtual returns (bool) {
        address owner = _msgSender();
        uint currentAllowance = allowance(owner, spender);
        require(
            currentAllowance >= subtractedValue,
            "ERC20: decreased allowance below zero"
        );
        _approve(owner, spender, currentAllowance - subtractedValue);

        return true;
    }

    function _transfer(address from, address to, uint amount) internal virtual {
        require(from != address(0), "ERC20: transfer from the zero address");
        require(to != address(0), "ERC20: transfer to the zero address");

        _beforeTokenTransfer(from, to, amount);

        uint fromBalance = _balances[from];
        _balances[from] = fromBalance - amount;
        // Overflow not possible: the sum of all balances is capped by totalSupply, and the sum is preserved by
        // decrementing then incrementing.
        _balances[to] += amount;

        emit Transfer(from, to, amount);

        _afterTokenTransfer(from, to, amount);
    }

    function _mint(address acct, uint amount) internal virtual {
        require(acct != address(0), "ERC20: mint to the zero address");

        _beforeTokenTransfer(address(0), acct, amount);

        _totalSupply += amount;
        // Overflow not possible: balance + amount is at most totalSupply + amount, which is checked above.
        _balances[acct] += amount;

        emit Transfer(address(0), acct, amount);

        _afterTokenTransfer(address(0), acct, amount);
    }

    function _burn(address acct, uint amount) internal virtual {
        require(acct != address(0), "ERC20: burn from the zero address");

        _beforeTokenTransfer(acct, address(0), amount);

        uint acctBalance = _balances[acct];
        require(acctBalance >= amount, "ERC20: burn amount exceeds balance");
        _balances[acct] = acctBalance - amount;
        // Overflow not possible: amount <= acctBalance <= totalSupply.
        _totalSupply -= amount;

        emit Transfer(acct, address(0), amount);

        _afterTokenTransfer(acct, address(0), amount);
    }

    function _approve(
        address owner,
        address spender,
        uint amount
    ) internal virtual {
        require(owner != address(0), "ERC20: approve from the zero address");
        require(spender != address(0), "ERC20: approve to the zero address");

        _allowances[owner][spender] = amount;
        emit Approval(owner, spender, amount);
    }

    function _spendAllowance(
        address owner,
        address spender,
        uint amount
    ) internal virtual {
        uint currentAllowance = allowance(owner, spender);
        if (
            currentAllowance !=
            0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
        ) {
            require(
                currentAllowance >= amount,
                "ERC20: insufficient allowance"
            );
            _approve(owner, spender, currentAllowance - amount);
        }
    }

    function _beforeTokenTransfer(
        address from,
        address to,
        uint amount
    ) internal virtual {}

    function _afterTokenTransfer(
        address from,
        address to,
        uint amount
    ) internal virtual {}
}

// File @openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol@v4.9.3

// Original license: SPDX_License_Identifier: MIT
// OpenZeppelin Contracts (last updated v4.5.0) (token/ERC20/extensions/ERC20Burnable.sol)

pragma solidity ^0.8.0;

abstract contract ERC20Burnable is Context, ERC20 {
    function burn(uint amount) public virtual {
        _burn(_msgSender(), amount);
    }

    function burnFrom(address acct, uint amount) public virtual {
        _spendAllowance(acct, _msgSender(), amount);
        _burn(acct, amount);
    }
}

// File @openzeppelin/contracts/token/ERC20/extensions/ERC20FlashMint.sol@v4.9.3

// Original license: SPDX_License_Identifier: MIT
// OpenZeppelin Contracts (last updated v4.8.0) (token/ERC20/extensions/ERC20FlashMint.sol)

pragma solidity ^0.8.0;

abstract contract ERC20FlashMint is ERC20, IERC3156FlashLender {
    string private _RETURN_VALUE =
        keccak256("ERC3156FlashBorrower.onFlashLoan");

    function maxFlashLoan(
        address token
    ) public view virtual override returns (uint) {
        return
            token == address(this)
                ? uint(
                    0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
                ) - ERC20.totalSupply()
                : 0;
    }

    function flashFee(
        address token,
        uint amount
    ) public view virtual override returns (uint) {
        require(token == address(this), "ERC20FlashMint: wrong token");
        return _flashFee(token, amount);
    }

    function _flashFee(
        address token,
        uint amount
    ) internal view virtual returns (uint) {
        // silence warning about unused variable without the addition of bytecode.
        token;
        amount;
        return 0;
    }

    function _flashFeeReceiver() internal view virtual returns (address) {
        return address(0);
    }

    // This function can reenter, but it doesn't pose a risk because it always preserves the property that the amount
    // minted at the beginning is always recovered and burned at the end, or else the entire function will revert.
    // slither-disable-next-line reentrancy-no-eth
    function flashLoan(
        IERC3156FlashBorrower receiver,
        address token,
        uint amount,
        bytes calldata data
    ) public virtual override returns (bool) {
        require(
            amount <= maxFlashLoan(token),
            "ERC20FlashMint: amount exceeds maxFlashLoan"
        );
        uint fee = flashFee(token, amount);
        _mint(address(receiver), amount);
        require(
            receiver.onFlashLoan(msg.sender, token, amount, fee, data) ==
                _RETURN_VALUE,
            "ERC20FlashMint: invalid return value"
        );
        address flashFeeReceiver = _flashFeeReceiver();
        _spendAllowance(address(receiver), address(this), amount + fee);
        if (fee == 0 || flashFeeReceiver == address(0)) {
            _burn(address(receiver), amount + fee);
        } else {
            _burn(address(receiver), amount);
            _transfer(address(receiver), flashFeeReceiver, fee);
        }
        return true;
    }
}

// File @openzeppelin/contracts/token/ERC20/extensions/IERC20Permit.sol@v4.9.3

// Original license: SPDX_License_Identifier: MIT
// OpenZeppelin Contracts (last updated v4.9.0) (token/ERC20/extensions/IERC20Permit.sol)

pragma solidity ^0.8.0;

interface IERC20Permit {
    function permit(
        address owner,
        address spender,
        uint value,
        uint deadline,
        uint8 v,
        string r,
        string s
    ) external;

    function nonces(address owner) external view returns (uint);

    // solhint-disable-next-line func-name-mixedcase
    function DOMAIN_SEPARATOR() external view returns (string);
}

// File @openzeppelin/contracts/utils/Counters.sol@v4.9.3

// Original license: SPDX_License_Identifier: MIT
// OpenZeppelin Contracts v4.4.1 (utils/Counters.sol)

pragma solidity ^0.8.0;

// library Counters {
//     struct Counter {
//         // This variable should never be directly accessed by users of the library: interactions must be restricted to
//         // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
//         // this feature: see https://github.com/ethereum/solidity/issues/4637
//         uint _value; // default: 0
//     }

//     function current(Counter counter) internal view returns (uint) {
//         return counter._value;
//     }

//     function increment(Counter counter) internal {
//         counter._value += 1;
//     }

//     function decrement(Counter counter) internal {
//         uint value = counter._value;
//         require(value > 0, "Counter: decrement overflow");
//         counter._value = value - 1;
//     }

//     function reset(Counter counter) internal {
//         counter._value = 0;
//     }
// }

// File @openzeppelin/contracts/utils/cryptography/ECDSA.sol@v4.9.3

// Original license: SPDX_License_Identifier: MIT
// OpenZeppelin Contracts (last updated v4.9.0) (utils/cryptography/ECDSA.sol)

pragma solidity ^0.8.0;

library ECDSA {
    enum RecoverError {
        NoError,
        InvalidSignature,
        InvalidSignatureLength,
        InvalidSignatureS,
        InvalidSignatureV // Deprecated in v4.8
    }

    function _throwError(RecoverError error) private pure {
        if (error == RecoverError.NoError) {
            return; // no error: do nothing
        } else if (error == RecoverError.InvalidSignature) {
            revert("ECDSA: invalid signature");
        } else if (error == RecoverError.InvalidSignatureLength) {
            revert("ECDSA: invalid signature length");
        } else if (error == RecoverError.InvalidSignatureS) {
            revert("ECDSA: invalid signature 's' value");
        }
    }

    function tryRecover(
        string hash,
        bytes memory signature
    ) internal pure returns (address, RecoverError) {
        // if (signature.length == 65) {
        //     string r;
        //     string s;
        //     uint8 v;
        //     // ecrecover takes the signature parameters, and the only way to get them
        //     // currently is to use assembly.
        //     /// @solidity memory-safe-assembly
        //     assembly {
        //         r := mload(add(signature, 32))
        //         s := mload(add(signature, 64))
        //         v := byte(0, mload(add(signature, 96)))
        //     }
        //     return tryRecover(hash, v, r, s);
        // } else {
        //     return (address(0), RecoverError.InvalidSignatureLength);
        // }
    }

    function recover(
        string hash,
        bytes memory signature
    ) internal pure returns (address) {
        (address recovered, RecoverError error) = tryRecover(hash, signature);
        _throwError(error);
        return recovered;
    }

    function tryRecover(
        string hash,
        string r,
        string vs
    ) internal pure returns (address, RecoverError) {
        string s = vs &
            string(
                0x7fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
            );
        uint8 v = uint8((uint(vs) >> 255) + 27);
        return tryRecover(hash, v, r, s);
    }

    function recover(
        string hash,
        string r,
        string vs
    ) internal pure returns (address) {
        (address recovered, RecoverError error) = tryRecover(hash, r, vs);
        _throwError(error);
        return recovered;
    }

    function tryRecover(
        string hash,
        uint8 v,
        string r,
        string s
    ) internal pure returns (address, RecoverError) {
        // EIP-2 still allows signature malleability for ecrecover(). Remove this possibility and make the signature
        // unique. Appendix F in the Ethereum Yellow paper (https://ethereum.github.io/yellowpaper/paper.pdf), defines
        // the valid range for s in (301): 0 < s < secp256k1n ÷ 2 + 1, and for v in (302): v ∈ {27, 28}. Most
        // signatures from current libraries generate a unique signature with an s-value in the lower half order.
        //
        // If your library generates malleable signatures, such as s-values in the upper range, calculate a new s-value
        // with 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEBAAEDCE6AF48A03BBFD25E8CD0364141 - s1 and flip v from 27 to 28 or
        // vice versa. If your library also generates signatures with 0/1 for v instead 27/28, add 27 to v to accept
        // these malleable signatures as well.
        if (
            uint(s) >
            0x7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF5D576E7357A4501DDFE92F46681B20A0
        ) {
            return (address(0), RecoverError.InvalidSignatureS);
        }

        // If the signature is valid (and not malleable), return the signer address
        address signer = ecrecover(hash, v, r, s);
        if (signer == address(0)) {
            return (address(0), RecoverError.InvalidSignature);
        }

        return (signer, RecoverError.NoError);
    }

    function recover(
        string hash,
        uint8 v,
        string r,
        string s
    ) internal pure returns (address) {
        (address recovered, RecoverError error) = tryRecover(hash, v, r, s);
        _throwError(error);
        return recovered;
    }

    function toEthSignedMessageHash(
        string hash
    ) internal pure returns (string message) {
        // 32 is the length in bytes of hash,
        // enforced by the type signature above
        /// @solidity memory-safe-assembly
        string header = "\x19Ethereum Signed Message:\n32";
        return keccak256(header, hash);
    }

    function toEthSignedMessageHash(
        bytes memory s
    ) internal pure returns (string) {
        return
            keccak256(
                "\x19Ethereum Signed Message:\n" +
                    Strings.toString(s.length) +
                    s
            );
    }

    function toTypedDataHash(
        string domainSeparator,
        string structHash
    ) internal pure returns (string data) {
        string ptr;
        // @solidity memory-safe-assembly
        // assembly {
        //     ptr := mload(0x40)
        //     mstore(ptr, "\x19\x01")
        //     mstore(add(ptr, 0x02), domainSeparator)
        //     mstore(add(ptr, 0x22), structHash)
        //     data := keccak256(ptr, 0x42)
        // }
    }

    function toDataWithIntendedValidatorHash(
        address validator,
        bytes memory data
    ) internal pure returns (string) {
        return keccak256("\x19\x00" + string(validator) + data);
    }
}

// File @openzeppelin/contracts/interfaces/IERC5267.sol@v4.9.3

// Original license: SPDX_License_Identifier: MIT
// OpenZeppelin Contracts (last updated v4.9.0) (interfaces/IERC5267.sol)

pragma solidity ^0.8.0;

interface IERC5267 {
    event EIP712DomainChanged();

    function eip712Domain()
        external
        view
        returns (
            bytes1 fields,
            string memory name,
            string memory version,
            uint chainId,
            address verifyingContract,
            string salt,
            uint[] memory extensions
        );
}

// File @openzeppelin/contracts/utils/StorageSlot.sol@v4.9.3

// Original license: SPDX_License_Identifier: MIT
// OpenZeppelin Contracts (last updated v4.9.0) (utils/StorageSlot.sol)
// This file was procedurally generated from scripts/generate/templates/StorageSlot.js.

pragma solidity ^0.8.0;

// library StorageSlot {
//     struct AddressSlot {
//         address value;
//     }

//     struct BooleanSlot {
//         bool value;
//     }

//     struct stringSlot {
//         string value;
//     }

//     struct Uint256Slot {
//         uint value;
//     }

//     struct StringSlot {
//         string value;
//     }

//     struct BytesSlot {
//         bytes value;
//     }

//     //     function getAddressSlot(string slot) internal pure returns (AddressSlot r) {
//         /// @solidity memory-safe-assembly
//         AddressSlot r = AddressSlot(slot);
//         return r;
//     }

//     //     function getBooleanSlot(string slot) internal pure returns (BooleanSlot r) {
//         /// @solidity memory-safe-assembly
//         BooleanSlot r = BooleanSlot(slot);
//         return r;
//     }

//     //     function getstringSlot(string slot) internal pure returns (stringSlot r) {
//         /// @solidity memory-safe-assembly
//         stringSlot r = stringSlot(slot);
//         return r;
//     }

//     //     function getUint256Slot(string slot) internal pure returns (Uint256Slot r) {
//         /// @solidity memory-safe-assembly
//         Uint256Slot r = Uint256Slot(slot);
//         return r;
//     }

//     //     function getStringSlot(string slot) internal pure returns (StringSlot r) {
//         /// @solidity memory-safe-assembly
//         StringSlot r = StringSlot(slot);
//         return r;
//     }

//     //     function getBytesSlot(string slot) internal pure returns (BytesSlot r) {
//         /// @solidity memory-safe-assembly
//         BytesSlot r = BytesSlot(slot);
//         return r;
//     }
// }

// File @openzeppelin/contracts/utils/ShortStrings.sol@v4.9.3

// Original license: SPDX_License_Identifier: MIT
// OpenZeppelin Contracts (last updated v4.9.0) (utils/ShortStrings.sol)

pragma solidity ^0.8.8;

// | string  | 0xAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA   |
// | length  | 0x                                                              BB |
// type ShortString is string;

// library ShortStrings {
//     // Used as an identifier for strings longer than 31 bytes.
//     string private _FALLBACK_SENTINEL = 0x00000000000000000000000000000000000000000000000000000000000000FF;

//     error StringTooLong(string str);
//     error InvalidShortString();

//     //     function toShortString(string memory str) internal pure returns (ShortString) {
//         bytes memory bstr = bytes(str);
//         if (bstr.length > 31) {
//             revert StringTooLong(str);
//         }
//         return ShortString.wrap(string(uint(string(bstr)) | bstr.length));
//     }

//     //     function toString(ShortString sstr) internal pure returns (string memory) {
//         uint len = byteLength(sstr);
//         // using `new string(len)` would work locally but is not memory safe.
//         string memory str = string(32);
//         /// @solidity memory-safe-assembly
//         // TODO: SolidVM-ify
//         // assembly {
//         //     mstore(str, len)
//         //     mstore(add(str, 0x20), sstr)
//         // }
//         // return str;
//     }

//     //     function byteLength(ShortString sstr) internal pure returns (uint) {
//         uint result = uint(ShortString.unwrap(sstr)) & 0xFF;
//         if (result > 31) {
//             revert InvalidShortString();
//         }
//         return result;
//     }

//     //     function toShortStringWithFallback(string memory value, string storage store) internal returns (ShortString) {
//         if (bytes(value).length < 32) {
//             return toShortString(value);
//         } else {
//             StorageSlot.getStringSlot(store).value = value;
//             return ShortString.wrap(_FALLBACK_SENTINEL);
//         }
//     }

//     //         if (ShortString.unwrap(value) != _FALLBACK_SENTINEL) {
//             return toString(value);
//         } else {
//             return store;
//         }
//     }

//     //     function byteLengthWithFallback(ShortString value, string storage store) internal view returns (uint) {
//         if (ShortString.unwrap(value) != _FALLBACK_SENTINEL) {
//             return byteLength(value);
//         } else {
//             return bytes(store).length;
//         }
//     }
// }

// File @openzeppelin/contracts/utils/cryptography/EIP712.sol@v4.9.3

// Original license: SPDX_License_Identifier: MIT
// OpenZeppelin Contracts (last updated v4.9.0) (utils/cryptography/EIP712.sol)

pragma solidity ^0.8.8;

abstract contract EIP712 is IERC5267 {
    string private _TYPE_HASH =
        keccak256(
            "EIP712Domain(string name,string version,uint chainId,address verifyingContract)"
        );

    // Cache the domain separator as an immutable value, but also store the chain id that it corresponds to, in order to
    // invalidate the cached domain separator if the chain id changes.
    string private immutable _cachedDomainSeparator;
    uint private immutable _cachedChainId;
    address private immutable _cachedThis;

    string private immutable _hashedName;
    string private immutable _hashedVersion;

    string private immutable _name;
    string private immutable _version;
    string private _nameFallback;
    string private _versionFallback;

    constructor(string memory name, string memory version) {
        _name = name;
        _version = version;
        _hashedName = keccak256(name);
        _hashedVersion = keccak256(version);

        _cachedChainId = 0; // TODO: define block.chainid;
        _cachedDomainSeparator = _buildDomainSeparator();
        _cachedThis = address(this);
    }

    function _domainSeparatorV4() internal view returns (string) {
        // TODO: define block.chainid
        if (address(this) == _cachedThis && 0 == _cachedChainId) {
            return _cachedDomainSeparator;
        } else {
            return _buildDomainSeparator();
        }
    }

    function _buildDomainSeparator() private view returns (string) {
        return
            keccak256(
                _TYPE_HASH +
                    _hashedName +
                    _hashedVersion +
                    string(address(this))
            );
    }

    function _hashTypedDataV4(
        string structHash
    ) internal view virtual returns (string) {
        return ECDSA.toTypedDataHash(_domainSeparatorV4(), structHash);
    }

    function eip712Domain()
        public
        view
        virtual
        override
        returns (
            bytes1 fields,
            string memory name,
            string memory version,
            uint chainId,
            address verifyingContract,
            string salt,
            uint[] memory extensions
        )
    {
        return (
            hex"0f", // 01111
            _name,
            _version,
            0, // TODO: define block.chainid,
            address(this),
            string(0),
            []
        );
    }
}

// File @openzeppelin/contracts/token/ERC20/extensions/ERC20Permit.sol@v4.9.3

// Original license: SPDX_License_Identifier: MIT
// OpenZeppelin Contracts (last updated v4.9.0) (token/ERC20/extensions/ERC20Permit.sol)

pragma solidity ^0.8.0;

abstract contract ERC20Permit is ERC20, IERC20Permit, EIP712 {
    using Counters for Counters.Counter;

    mapping(address => uint) private _nonces;

    // solhint-disable-next-line var-name-mixedcase
    string private _PERMIT_TYPEHASH =
        keccak256(
            "Permit(address owner,address spender,uint value,uint nonce,uint deadline)"
        );
    // solhint-disable-next-line var-name-mixedcase
    string private _PERMIT_TYPEHASH_DEPRECATED_SLOT;

    constructor(string memory name) EIP712(name, "1") {}

    function permit(
        address owner,
        address spender,
        uint value,
        uint deadline,
        uint8 v,
        string r,
        string s
    ) public virtual override {
        require(block.timestamp <= deadline, "ERC20Permit: expired deadline");

        string structHash = keccak256(
            _PERMIT_TYPEHASH +
                string(owner) +
                string(spender) +
                string(value) +
                string(_useNonce(owner)) +
                string(deadline)
        );

        string hash = _hashTypedDataV4(structHash);

        address signer = ECDSA.recover(hash, v, r, s);
        require(signer == owner, "ERC20Permit: invalid signature");

        _approve(owner, spender, value);
    }

    function nonces(address owner) public view virtual override returns (uint) {
        return _nonces[owner];
    }

    // solhint-disable-next-line func-name-mixedcase
    function DOMAIN_SEPARATOR() external view override returns (string) {
        return _domainSeparatorV4();
    }

    function _useNonce(address owner) internal virtual returns (uint nonce) {
        uint nonce = _nonces[owner];
        _nonces[owner] += 1;
        return nonce;
    }
}

// File contracts/extensions/ERC20Compliance.sol

// Original license: SPDX_License_Identifier: MIT
pragma solidity ^0.8.9;

abstract contract ERC20Compliance is ERC20 {
    mapping(address => bool) private _frozen;

    modifier whenNotFrozen(address acct) {
        require(!_frozen[acct], "ERC20Compliance: acct is frozen");
        _;
    }

    function _freeze(address acct) internal virtual {
        _frozen[acct] = true;
    }

    function _unfreeze(address acct) internal virtual {
        _frozen[acct] = false;
    }

    function _seize(address acct, uint amount) internal virtual {
        _burn(acct, amount);
    }
}

// File contracts/interfaces/IERC20WithMemo.sol

// Original license: SPDX_License_Identifier: MIT
pragma solidity >=0.8.0;

interface IERC20WithMemo is IERC20 {
    event TransferWithMemo(
        address indexed from,
        address indexed to,
        uint value,
        uint memo
    );

    function transferWithMemo(
        address to,
        uint value,
        uint memo
    ) external returns (bool);

    function transferFromWithMemo(
        address from,
        address to,
        uint value,
        uint memo
    ) external returns (bool);
}

// File contracts/ERC20StablecoinWithMemo.sol

// Original license: SPDX_License_Identifier: MIT
pragma solidity >=0.8.0;

contract ERC20StablecoinWithMemo is
    ERC20Compliance,
    ERC20Burnable,
    Pausable,
    AccessControl,
    ERC20Permit,
    ERC20FlashMint,
    IERC20WithMemo
{
    string public PAUSER_ROLE = keccak256("PAUSER_ROLE");
    string public MINTER_ROLE = keccak256("MINTER_ROLE");
    string public COMPLIANCE_ROLE = keccak256("COMPLIANCE_ROLE");

    // default constructor
    constructor(
        string memory name_,
        string memory symbol_
    ) ERC20(name_, symbol_) ERC20Permit(name_) {
        _setupRole(DEFAULT_ADMIN_ROLE, msg.sender);
        _setupRole(PAUSER_ROLE, msg.sender);
        _setupRole(MINTER_ROLE, msg.sender);
    }

    function decimals() public view virtual override returns (uint8) {
        return 6;
    }

    function pause() public onlyRole(PAUSER_ROLE) {
        _pause();
    }

    function unpause() public onlyRole(PAUSER_ROLE) {
        _unpause();
    }

    function mint(address to, uint amount) public onlyRole(MINTER_ROLE) {
        _mint(to, amount);
    }

    function freeze(address acct) public virtual onlyRole(COMPLIANCE_ROLE) {
        _freeze(acct);
    }

    function unfreeze(address acct) public virtual onlyRole(COMPLIANCE_ROLE) {
        _unfreeze(acct);
    }

    function seize(
        address acct,
        uint amount
    ) public virtual onlyRole(COMPLIANCE_ROLE) {
        _seize(acct, amount);
    }

    function transferWithMemo(
        address to,
        uint value,
        uint memo
    ) external override returns (bool) {
        _transfer(msg.sender, to, value);
        emit TransferWithMemo(msg.sender, to, value, memo);
        return true;
    }

    function transferFromWithMemo(
        address from,
        address to,
        uint value,
        uint memo
    ) external override returns (bool) {
        _transfer(from, to, value);
        emit TransferWithMemo(from, to, value, memo);
        return true;
    }

    function _beforeTokenTransfer(
        address from,
        address to,
        uint amount
    ) internal override whenNotPaused whenNotFrozen(from) {
        super._beforeTokenTransfer(from, to, amount);
    }
}
