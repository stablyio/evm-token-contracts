import { HardhatRuntimeEnvironment } from "hardhat/types";

async function main(hre: HardhatRuntimeEnvironment) {
  // Arguments
  const newMinterAddress = "0x823fd0227CE89Dc6694A213e9F9D3d64F5d4715C";
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

  // Grant the MINTER_ROLE to the new address
  console.log(`Granting MINTER_ROLE to ${newMinterAddress}...`);
  const tx = await contract.grantRole(MINTER_ROLE, newMinterAddress);
  await tx.wait();

  console.log(`MINTER_ROLE successfully granted to ${newMinterAddress}`);
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
