import { HardhatRuntimeEnvironment } from "hardhat/types";

async function main(hre: HardhatRuntimeEnvironment) {
  // Arguments
  const adminToRevokeAddress = "0x0f5e3D9AEe7Ab5fDa909Af1ef147D98a7f4B3022";
  const contractAddress = "0x788D96f655735f52c676A133f4dFC53cEC614d4A";

  // Get the signer
  const [signer] = await hre.ethers.getSigners();

  // Get the contract instance
  const contract = await hre.ethers.getContractAt(
    "ERC20StablecoinUpgradeable",
    contractAddress,
    signer
  );

  // Get the DEFAULT_ADMIN_ROLE
  const DEFAULT_ADMIN_ROLE = await contract.DEFAULT_ADMIN_ROLE();

  // Revoke the DEFAULT_ADMIN_ROLE from the address
  console.log(`Revoking DEFAULT_ADMIN_ROLE from ${adminToRevokeAddress}...`);
  const tx = await contract.revokeRole(
    DEFAULT_ADMIN_ROLE,
    adminToRevokeAddress
  );
  await tx.wait();

  console.log(
    `DEFAULT_ADMIN_ROLE successfully revoked from ${adminToRevokeAddress}`
  );
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