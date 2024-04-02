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
      url: "https://rpc-testnet.viction.xyz",
      deploy: ["deploy/tomochain/"],
      accounts: {
        mnemonic: getMnemonic("tomochain_testnet"),
      },
    },
    tomochain_mainnet: {
      url: "https://rpc.viction.xyz",
      deploy: ["deploy/tomochain/"],
      accounts: {
        mnemonic: getMnemonic("tomochain_mainnet"),
        path: "m/44'/889'/0'/0", // Trustwallet HDW path
      },
    },
    horizen_eon_testnet: {
      url: "https://gobi-rpc.horizenlabs.io/ethv1",
      deploy: ["deploy/horizen_eon/"],
      accounts: {
        mnemonic: getMnemonic("horizen_eon_testnet"),
      },
    },
    horizen_eon_mainnet: {
      url: "https://eon-rpc.horizenlabs.io/ethv1",
      deploy: ["deploy/horizen_eon/"],
      accounts: {
        mnemonic: getMnemonic("horizen_eon_mainnet"),
      },
    },
    fraxtal_testnet: {
      url: "https://rpc.testnet.frax.com",
      deploy: ["deploy/fraxtal/"],
      accounts: {
        mnemonic: getMnemonic("fraxtal_testnet"),
      },
    },
    fraxtal_mainnet: {
      url: "https://rpc.frax.com",
      deploy: ["deploy/fraxtal/"],
      accounts: {
        mnemonic: getMnemonic("fraxtal_mainnet"),
      },
    },
    fraxtal_testnet_usds: {
      url: "https://rpc.testnet.frax.com",
      deploy: ["deploy/fraxtal_usds/"],
      accounts: {
        mnemonic: getMnemonic("fraxtal_testnet"),
      },
    },
    fraxtal_mainnet_usds: {
      url: "https://rpc.frax.com",
      deploy: ["deploy/fraxtal_usds/"],
      accounts: {
        mnemonic: getMnemonic("fraxtal_mainnet"),
      },
    },
  },
  // For more readable deploy scripts
  namedAccounts: {
    deployer: {
      default: 0, // here this will by default take the first account as deployer
      // TomoChain
      tomochain_testnet: "0x7f195FDdf37D48aCD075db34B62E7e13118A1BC1",
      tomochain_mainnet: "0x6fC35BFd8A82d44Cd33b637B9e6888735cBe9051",
      // Horizen
      horizen_eon_testnet: "0x7f195FDdf37D48aCD075db34B62E7e13118A1BC1",
      horizen_eon_mainnet: "0xB46c23C5102dd7458152bEB9f223e2F2B1d826Ef",
      // Fraxtal
      fraxtal_testnet: "0x7f195FDdf37D48aCD075db34B62E7e13118A1BC1",
      fraxtal_mainnet: "0x0f5e3D9AEe7Ab5fDa909Af1ef147D98a7f4B3022",
    },
    minter: {
      default: 1, // here this will by default take the second account as feeCollector (so in the test this will be a different account than the deployer)
      // TomoChain
      tomochain_testnet: "0x7f195FDdf37D48aCD075db34B62E7e13118A1BC1",
      tomochain_mainnet: "0x314a20b4D07875c7f2A9Fd168702DA749742A143",
      // Horizen
      horizen_eon_testnet: "0xbF464732Fa68466D3f2f67d3E7704859292363BC",
      horizen_eon_mainnet: "0x81ef98BccAB82B94c72992aBC98E340b12e43C74",
      // Fraxtal
      fraxtal_testnet: "0xbF464732Fa68466D3f2f67d3E7704859292363BC",
      fraxtal_mainnet: "0xcc2B17Aa1b532581781a45A54C0F05196cd30551",
    },
    // Only for TRC25
    feeRole: {
      default: 2, // here this will by default take the third account as feeCollector (so in the test this will be a different account than the deployer)
      // TomoChain
      tomochain_testnet: "0x7f195FDdf37D48aCD075db34B62E7e13118A1BC1",
      tomochain_mainnet: "0x68436Daf37393854d93448b6f123e6225C416825",
    },
  },
  // For contract source verification
  etherscan: {
    apiKey: {
      tomochain_mainnet: "tomoscan2023",
    },
    customChains: [
      {
        network: "tomochain_mainnet",
        chainId: 88, // for mainnet
        urls: {
          apiURL: "https://tomoscan.io/api/contract/hardhat/verify", // for mainnet
          browserURL: "https://tomoscan.io", // for mainnet
        },
      },
    ],
  },
};

export default config;
