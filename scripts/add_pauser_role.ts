import { HardhatRuntimeEnvironment } from "hardhat/types";

async function main(hre: HardhatRuntimeEnvironment) {
  // Arguments
  const newPauserAddress = "0xfC2f89F9982BE98A9672CEFc3Ea6dBBdd88bc8e9";
  const contractAddress = "0x788D96f655735f52c676A133f4dFC53cEC614d4A";

  // Get the signer
  const [signer] = await hre.ethers.getSigners();

  // Get the contract instance
  const contract = await hre.ethers.getContractAt(
    "ERC20StablecoinUpgradeable",
    contractAddress,
    signer
  );

  // Get the PAUSER_ROLE
  const PAUSER_ROLE = await contract.PAUSER_ROLE();

  // Grant the PAUSER_ROLE to the new address
  console.log(`Granting PAUSER_ROLE to ${newPauserAddress}...`);
  const tx = await contract.grantRole(PAUSER_ROLE, newPauserAddress);
  await tx.wait();

  console.log(`PAUSER_ROLE successfully granted to ${newPauserAddress}`);
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
