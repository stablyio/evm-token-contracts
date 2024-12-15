import { HardhatRuntimeEnvironment } from "hardhat/types";

async function main(hre: HardhatRuntimeEnvironment) {
  // Arguments
  const newAdminAddress = "0xfC2f89F9982BE98A9672CEFc3Ea6dBBdd88bc8e9";
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

  // Grant the DEFAULT_ADMIN_ROLE to the new address
  console.log(`Granting DEFAULT_ADMIN_ROLE to ${newAdminAddress}...`);
  const tx = await contract.grantRole(DEFAULT_ADMIN_ROLE, newAdminAddress);
  await tx.wait();

  console.log(`DEFAULT_ADMIN_ROLE successfully granted to ${newAdminAddress}`);
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
