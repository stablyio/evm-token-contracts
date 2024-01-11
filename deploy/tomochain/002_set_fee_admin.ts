import { HardhatRuntimeEnvironment } from "hardhat/types";
import { DeployFunction } from "hardhat-deploy/types";

const func: DeployFunction = async function (hre: HardhatRuntimeEnvironment) {
  // Do nothing, on mainnet we used this deployment to set the fee admin
  // Leaving this here as a placeholder for deployment 2
};
export default func;
func.tags = ["TRC25Stablecoin"];
