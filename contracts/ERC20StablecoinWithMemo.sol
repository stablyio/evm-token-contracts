// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0;

import "./interfaces/IERC20WithMemo.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol";
import "@openzeppelin/contracts/security/Pausable.sol";
import "@openzeppelin/contracts/access/AccessControl.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Permit.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20FlashMint.sol";

import "./extensions/ERC20Compliance.sol";

contract ERC20StablecoinWithMemo is
    ERC20Compliance,
    ERC20Burnable,
    Pausable,
    AccessControl,
    ERC20Permit,
    ERC20FlashMint,
    IERC20WithMemo
{
    bytes32 public constant PAUSER_ROLE = keccak256("PAUSER_ROLE");
    bytes32 public constant MINTER_ROLE = keccak256("MINTER_ROLE");
    bytes32 public constant COMPLIANCE_ROLE = keccak256("COMPLIANCE_ROLE");

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

    function mint(address to, uint256 amount) public onlyRole(MINTER_ROLE) {
        _mint(to, amount);
    }

    function freeze(address account) public virtual onlyRole(COMPLIANCE_ROLE) {
        _freeze(account);
    }

    function unfreeze(
        address account
    ) public virtual onlyRole(COMPLIANCE_ROLE) {
        _unfreeze(account);
    }

    function seize(
        address account,
        uint256 amount
    ) public virtual onlyRole(COMPLIANCE_ROLE) {
        _seize(account, amount);
    }

    function transferWithMemo(
        address to,
        uint256 value,
        uint256 memo
    ) external override returns (bool) {
        _transfer(msg.sender, to, value);
        emit TransferWithMemo(msg.sender, to, value, memo);
        return true;
    }

    function transferFromWithMemo(
        address from,
        address to,
        uint256 value,
        uint256 memo
    ) external override returns (bool) {
        _transfer(from, to, value);
        emit TransferWithMemo(from, to, value, memo);
        return true;
    }

    function _beforeTokenTransfer(
        address from,
        address to,
        uint256 amount
    ) internal override whenNotPaused whenNotFrozen(from) {
        super._beforeTokenTransfer(from, to, amount);
    }
}
