// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

interface IERC20WithMemo is IERC20 {
    event TransferWithMemo(
        address indexed from,
        address indexed to,
        uint256 value,
        uint256 memo
    );

    function transferWithMemo(
        address to,
        uint256 value,
        uint256 memo
    ) external returns (bool);

    function transferFromWithMemo(
        address from,
        address to,
        uint256 value,
        uint256 memo
    ) external returns (bool);
}
