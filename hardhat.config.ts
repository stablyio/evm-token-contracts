import "@openzeppelin/hardhat-upgrades";
import "@nomicfoundation/hardhat-toolbox";
import { HardhatUserConfig } from "hardhat/config";
import "hardhat-deploy";
import "dotenv/config";
import { getMnemonic } from "./utils/accounts";

const config: HardhatUserConfig = {
  solidity: "0.8.19",
  networks: {
    tomochain_testnet: {
      url: "https://rpc.testnet.tomochain.com",
      deploy: ["deploy/tomochain/"],
      accounts: {
        mnemonic: getMnemonic("tomochain_testnet"),
      },
    },
  },
  namedAccounts: {
    deployer: {
      default: 0, // here this will by default take the first account as deployer
      tomochain_testnet: "0x7f195FDdf37D48aCD075db34B62E7e13118A1BC1",
    },
    minter: {
      default: 1, // here this will by default take the second account as feeCollector (so in the test this will be a different account than the deployer)
      tomochain_testnet: "0x7f195FDdf37D48aCD075db34B62E7e13118A1BC1",
    },
    feeRole: {
      default: 2, // here this will by default take the third account as feeCollector (so in the test this will be a different account than the deployer)
      tomochain_testnet: "0x7f195FDdf37D48aCD075db34B62E7e13118A1BC1",
    },
  },
};

export default config;
