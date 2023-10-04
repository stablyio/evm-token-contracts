import { HardhatRuntimeEnvironment } from "hardhat/types";
import { DeployFunction } from "hardhat-deploy/types";

const func: DeployFunction = async function (hre: HardhatRuntimeEnvironment) {
  const { deployments, getNamedAccounts } = hre;
  const { deploy } = deployments;

  const { deployer, minter, feeRole } = await getNamedAccounts();

  const cusd = await hre.ethers.getContractAt(
    "TRC25Stablecoin",
    "0xb3008E7156Ae2312b49B5200C3E1C3e80E529feb"
  );
  await cusd.grantRole(await cusd.FEE_ROLE(), feeRole, {
    // Need to hard-code a gasLimit due to not supporting modern `eth_estimateGas`
    // See: https://github.com/NomicFoundation/hardhat/issues/4010
    gasLimit: "0x10000",
  });
};
export default func;
func.tags = ["TRC25Stablecoin"];
