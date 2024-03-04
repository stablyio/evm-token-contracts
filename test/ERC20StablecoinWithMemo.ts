"use strict";

import {
  BlockChainUser,
  Options,
  Contract,
  Config,
  rest,
  fsUtil,
  oauthUtil,
  AccessToken
} from 'blockapps-rest';
import { expect } from 'chai';

require('dotenv').config();

const axios = require('axios');
const config: Config = fsUtil.getYaml("test/ERC20StablecoinWithMemo.yaml");
const options: Options = { config };
const stablySrc: string = fsUtil.get("test/ERC20StablecoinWithMemo.SolidVM.sol");


async function upload(user: BlockChainUser, name: string, source: string, args: any):Promise<Contract> {
  return <Contract> await rest.createContract(user, {name, source, args}, options);
}

async function call(blockchainUser: BlockChainUser, method: string, contract: Contract, args: any) {
  return await rest.call(blockchainUser, {contract, method, args}, options);
}

async function state(user: BlockChainUser, contract:Contract) {
  return await rest.getState(user, contract, options);
}

async function getStratoUserFromToken(accessToken: string) {
  const KEY_ENDPOINT = "/strato/v2.3/key";
  const url = `${config.nodes[0].url}${KEY_ENDPOINT}`;
  try{
    const user = await axios
      .get(url, {
        headers: {
          Accept: "application/json",
          Authorization: `Bearer ${accessToken}`,
        },
      })
    return { status: 200, message: 'success', user:user.data }
    } catch (e: any) {
      return {
        // eslint-disable-next-line no-nested-ternary
        status: e.response
          ? e.response.status
          : e.code
            ? e.code
            : 'NO_CONNECTION',
        message: 'error while getting user - do they exist yet?',
      }
    }
}


describe('SolidVM-Compatible ERC20StablecoinWithMemo', function() {
  this.timeout(config.timeout || 600000);
  let deployer: BlockChainUser;
  let testUser: BlockChainUser;
  let ERC20StablecoinWithMemo: Contract;
  
  before(async () => {
    // loads config file necessary for tx posting
    const oauth: oauthUtil = await oauthUtil.init(config.nodes[0].oauth);

    // preliminary account fetching
    const deployerAccessToken: AccessToken = await oauth.getAccessTokenByResourceOwnerCredential(
      process.env.STRATO_USER_1_USERNAME,
      process.env.STRATO_USER_1_PASSWORD
    )
    const testUserAccessToken: AccessToken = await oauth.getAccessTokenByResourceOwnerCredential(
      process.env.STRATO_USER_2_USERNAME,
      process.env.STRATO_USER_2_PASSWORD
    )
    const deployerAddress = await getStratoUserFromToken(deployerAccessToken.token.access_token)
    const testUserAddress= await getStratoUserFromToken(testUserAccessToken.token.access_token)

    deployer = {
      token: deployerAccessToken.token.access_token,
      address: deployerAddress.user.address
    };
    testUser = {
      token: testUserAccessToken.token.access_token,
      address: testUserAddress.user.address 
    }
  })

  beforeEach(async () => {
    ERC20StablecoinWithMemo = await upload(
      deployer,
      'ERC20StablecoinWithMemo',
      stablySrc, 
      {
        name_: "Stably USD", 
        symbol_: "USDS"
      }
    );
  });

  it('should have the correct name and symbol', async () => {
    const data = await state(deployer, ERC20StablecoinWithMemo)
    expect(data._name).to.equal("Stably USD")
    expect(data._symbol).to.equal("USDS")
  })

  describe("memo transfers", function () {
    const testMemoValue = 42;

    describe("transferWithMemo", function () {
      it("should transfer and emit TransferWithMemo event", async function () {
        await call(deployer, "mint", ERC20StablecoinWithMemo, {
          to: deployer.address,
          amount: 100
        })

        // check for event emission
        await call(deployer, "transferWithMemo", ERC20StablecoinWithMemo, {
          memo: testMemoValue,
          to: testUser.address,
          value: 100,
        })
        
        // TODO
        // check TransferWithMemo event
        // expect: (owner, random1, 100, testMemoValue)
        
        await state(deployer, ERC20StablecoinWithMemo).then(state => expect(state[testUser.address] == 100))
      });

      it("a normal transfer should not emit TransferWithMemo event", async function () {
          await call(deployer, "mint", ERC20StablecoinWithMemo, {
            to: deployer.address,
            amount: 100
          })

          // TODO
          // check TransferWithMemo event
          // it should NOT exist after calling normal transfer
          
          await call(deployer, "transfer", ERC20StablecoinWithMemo, {
            to: testUser.address,
            amount: 100
          })

          await state(deployer, ERC20StablecoinWithMemo).then(state => expect(state[testUser.address] == 100))
        });
      });
    })

    describe("transferFromWithMemo", function () {
      const testMemoValue = 42;

      it("should transferFrom and emit TransferWithMemo event", async function () {
        await call(deployer, "mint", ERC20StablecoinWithMemo, {
          to: deployer.address,
          amount: 100
        })

        await call(deployer, "approve", ERC20StablecoinWithMemo, {
          amount: 100,
          spender: testUser.address,
        })
        
        await call(deployer, "transferFromWithMemo", ERC20StablecoinWithMemo, {
          from: deployer.address,
          to: testUser.address,
          value: 100,
          memo: testMemoValue
        })

        // TODO
        //   .to.emit(token, "TransferWithMemo")
        //   .withArgs(
        //     await owner.getAddress(),
        //     await random1.getAddress(),
        //     100,
        //     testMemoValue
        //   );

        await state(deployer, ERC20StablecoinWithMemo).then(state => expect(state[testUser.address] == 100))
      });

      it("a normal transferFrom should not emit TransferWithMemo event", async function () {
        await call(deployer, "mint", ERC20StablecoinWithMemo, {
          to: deployer.address,
          amount: 100
        })

        await call(deployer, "approve", ERC20StablecoinWithMemo, {
          amount: 100,
          spender: testUser.address,
        })

        // TODO
        // await expect(
        //   token
        //     .connect(random1)
        //     .transferFrom(
        //       await owner.getAddress(),
        //       await random1.getAddress(),
        //       100
        //     )
        // ).to.not.emit(token, "TransferWithMemo");
        await state(deployer, ERC20StablecoinWithMemo).then(state => expect(state[testUser.address] == 100))
      });
    });

  describe("role permissions", function () {
    describe("DEFAULT_ADMIN_ROLE", function () {
        it("should be set to deployer", async function () {
          await state(deployer, ERC20StablecoinWithMemo).then(state => {
            const DEFAULT_ADMIN_ROLE = state["DEFAULT_ADMIN_ROLE"];
            expect(state._roles[DEFAULT_ADMIN_ROLE].members[deployer.address] == true)
          })
        });

        it("should be rotatable", async function () {
          await call(deployer, "grantRole", ERC20StablecoinWithMemo, {
            role: "DEFAULT_ADMIN_ROLE",
            acct: testUser.address
          })

          await state(deployer, ERC20StablecoinWithMemo).then(state => {
            const DEFAULT_ADMIN_ROLE = state["DEFAULT_ADMIN_ROLE"];
            expect(state._roles[DEFAULT_ADMIN_ROLE].members[testUser.address] == true)
          })

          await call(testUser, "revokeRole", ERC20StablecoinWithMemo, {
            role: "DEFAULT_ADMIN_ROLE",
            acct: deployer.address
          })

          await state(deployer, ERC20StablecoinWithMemo).then(state => {
            const DEFAULT_ADMIN_ROLE = state["DEFAULT_ADMIN_ROLE"];
            expect(state._roles[DEFAULT_ADMIN_ROLE].members[deployer.address] == false)
          })
        });
      });
    });

    describe("PAUSER_ROLE", function () {
      it("should be assigned to the deployer", async function () {
          await state(deployer, ERC20StablecoinWithMemo).then(state => {
            const PAUSER_ROLE = state["PAUSER_ROLE"];
            expect(state._roles[PAUSER_ROLE].members[deployer.address] == true)
          })
      });

      it("should allow pauser to pause and unpause", async function () {
        await call(deployer, "mint", ERC20StablecoinWithMemo, {
          to: deployer.address,
          amount: 100
        })

        await call(deployer, "pause", ERC20StablecoinWithMemo, {})
        await call(deployer, "paused", ERC20StablecoinWithMemo, {}).then(paused => { expect(paused[0] == true) })

        await call(deployer, "transfer", ERC20StablecoinWithMemo, {
          to: testUser.address,
          amount: 100
        }).catch(e => { expect(e.message == "Pausable: paused") })

        await call(deployer, "unpause", ERC20StablecoinWithMemo, {})
        await call(deployer, "paused", ERC20StablecoinWithMemo, {}).then(paused => { expect(paused[0] == false) })
        await call(deployer, "transfer", ERC20StablecoinWithMemo, {
          to: testUser.address,
          amount: 100
        })

        await state(deployer, ERC20StablecoinWithMemo).then(state => expect(state[testUser.address] == 100))
      });

      it("should not allow non-pauser to pause and unpause", async function () {
        await call(testUser, "pause", ERC20StablecoinWithMemo, {}).catch(e => { expect(e.message.startsWith("Error running the transaction: revert"))})
        await call(testUser, "unpause", ERC20StablecoinWithMemo, {}).catch(e => { expect(e.message.startsWith("Error running the transaction: revert"))})
      });
    });

    describe("MINTER_ROLE", function () {
      it("should be assigned to the deployer", async function () {
        await state(deployer, ERC20StablecoinWithMemo).then(state => {
          const MINTER_ROLE = state["MINTER_ROLE"];
          expect(state._roles[MINTER_ROLE].members[deployer.address] == true)
        })
      });

      it("should allow the minter to mint", async function () {
        await call(deployer, "mint", ERC20StablecoinWithMemo, {
          to: testUser.address,
          amount: 100
        })

        await state(deployer, ERC20StablecoinWithMemo).then(state => expect(state[testUser.address] == 100))
      });

      it("should not allow non-minter to mint", async function () {
        await call(testUser, "mint", ERC20StablecoinWithMemo, {
          to: testUser.address,
          amount: 100
        }).catch(e => { expect(e.message.startsWith("Error running the transaction: revert"))})
      });
    });

    describe("COMPLIANCE_ROLE", function () {
      it("should not be assigned initially", async function () {
        await state(deployer, ERC20StablecoinWithMemo).then(state => {
          const COMPLIANCE_ROLE = state["COMPLIANCE_ROLE"];
          expect(state._roles[COMPLIANCE_ROLE] == undefined)
        })
      });

      it("should allow a compliance role to be set", async function () {
        await state(deployer, ERC20StablecoinWithMemo).then(async (state) => {
          const COMPLIANCE_ROLE = state["MINTER_ROLE"];

          await call(deployer, "grantRole", ERC20StablecoinWithMemo, {
            role: COMPLIANCE_ROLE,
            acct: testUser.address
          })
        })

        await state(deployer, ERC20StablecoinWithMemo).then(state => {
          const COMPLIANCE_ROLE = state["COMPLIANCE_ROLE"];
          expect(state._roles[COMPLIANCE_ROLE].members[testUser.address] == true)
        })
      });
    });
});