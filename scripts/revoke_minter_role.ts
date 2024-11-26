import { HardhatRuntimeEnvironment } from "hardhat/types";

async function main(hre: HardhatRuntimeEnvironment) {
  // Arguments
  const minterToRevokeAddress = "0x0f5e3D9AEe7Ab5fDa909Af1ef147D98a7f4B3022";
  const contractAddress = "0x788D96f655735f52c676A133f4dFC53cEC614d4A";

  // Get the signer
  const [signer] = await hre.ethers.getSigners();

  // Get the contract instance
  const contract = await hre.ethers.getContractAt(
    "ERC20StablecoinUpgradeable",
    contractAddress,
    signer
  );

  // Get the MINTER_ROLE
  const MINTER_ROLE = await contract.MINTER_ROLE();

  // Revoke the MINTER_ROLE from the address
  console.log(`Revoking MINTER_ROLE from ${minterToRevokeAddress}...`);
  const tx = await contract.revokeRole(MINTER_ROLE, minterToRevokeAddress);
  await tx.wait();

  console.log(`MINTER_ROLE successfully revoked from ${minterToRevokeAddress}`);
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
if (require.main === module) {
  import("hardhat").then(async (hre) => {
    try {
      await main(hre);
      process.exit(0);
    } catch (error) {
      console.error(error);
      process.exit(1);
    }
  });
}
