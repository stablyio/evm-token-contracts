// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "@openzeppelin/contracts/access/AccessControl.sol";
import "@openzeppelin/contracts/security/Pausable.sol";

import "./bases/TRC25.sol";
import "./extensions/TRC25Permit.sol";
import "./extensions/TRC25Compliance.sol";

contract TRC25Stablecoin is
    TRC25,
    TRC25Permit,
    TRC25Compliance,
    AccessControl,
    Pausable
{
    bytes32 public constant PAUSER_ROLE = keccak256("PAUSER_ROLE");
    bytes32 public constant MINTER_ROLE = keccak256("MINTER_ROLE");
    bytes32 public constant COMPLIANCE_ROLE = keccak256("COMPLIANCE_ROLE");
    bytes32 public constant FEE_ROLE = keccak256("FEE_ROLE");

    constructor(
        string memory name,
        string memory symbol
    ) TRC25(name, symbol) EIP712(name, "1") {
        _grantRole(DEFAULT_ADMIN_ROLE, msg.sender);
        _grantRole(PAUSER_ROLE, msg.sender);
        _grantRole(MINTER_ROLE, msg.sender);
        _grantRole(FEE_ROLE, msg.sender);
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

    function supportsInterface(
        bytes4 interfaceId
    ) public view virtual override(TRC25, AccessControl) returns (bool) {
        return interfaceId == type(ITRC25).interfaceId;
    }

    function setFee(uint256 fee) external virtual onlyRole(FEE_ROLE) {
        _setFee(fee);
    }

    function _estimateFee(
        uint256
    ) internal view virtual override returns (uint256) {
        return minFee();
    }

    function _beforeTokenTransfer(
        address from,
        address to,
        uint256 amount
    ) internal override whenNotPaused whenNotFrozen(from) {
        super._beforeTokenTransfer(from, to, amount);
    }
}
