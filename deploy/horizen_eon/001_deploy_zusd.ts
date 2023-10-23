import { HardhatRuntimeEnvironment } from "hardhat/types";
import { DeployFunction } from "hardhat-deploy/types";

const func: DeployFunction = async function (hre: HardhatRuntimeEnvironment) {
  const { deployments, getNamedAccounts } = hre;
  const { deploy } = deployments;

  const { deployer, minter } = await getNamedAccounts();

  // Deploy the upgrade infra and token
  const deployed = await deploy("ERC20StablecoinUpgradeable", {
    from: deployer,
    proxy: {
      execute: {
        init: {
          methodName: "initialize",
          args: ["ZEN USD", "ZUSD"],
        },
      },
      proxyContract: "OpenZeppelinTransparentProxy",
    },
    log: true,
    autoMine: true, // speed up deployment on local network (ganache, hardhat), no effect on live networks
  });

  // Set the minter role
  const zusd = await hre.ethers.getContractAt(
    "ERC20StablecoinUpgradeable",
    deployed.address
  );
  await zusd.grantRole(await zusd.MINTER_ROLE(), minter);
};
export default func;
func.tags = ["ERC20StablecoinUpgradeable"];
