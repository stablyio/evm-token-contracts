import { HardhatRuntimeEnvironment } from "hardhat/types";
import { DeployFunction } from "hardhat-deploy/types";

const func: DeployFunction = async function (hre: HardhatRuntimeEnvironment) {
  const { deployments, getNamedAccounts } = hre;
  const { deploy } = deployments;

  const { deployer, minter, feeRole } = await getNamedAccounts();

  const deployed = await deploy("TRC25Stablecoin", {
    from: deployer,
    args: ["USDV", "USDV"],
    log: true,
    autoMine: true, // speed up deployment on local network (ganache, hardhat), no effect on live networks
  });
  // Set the minter role
  const usdv = await hre.ethers.getContractAt(
    "TRC25Stablecoin",
    deployed.address
  );
  await usdv.grantRole(await usdv.MINTER_ROLE(), minter, {
    // Need to hard-code a gasLimit due to not supporting modern `eth_estimateGas`
    // See: https://github.com/NomicFoundation/hardhat/issues/4010
    gasLimit: "0x10000",
  });
  // Set the fee role
  await usdv.grantRole(await usdv.FEE_ROLE(), feeRole, {
    gasLimit: "0x10000",
  });
};
export default func;
func.tags = ["TRC25Stablecoin"];
