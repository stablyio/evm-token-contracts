import "@openzeppelin/hardhat-upgrades";
import { ethers, upgrades } from "hardhat";
import { Signer } from "ethers";
import { expect } from "chai";
import { StablyToken } from "../typechain-types/contracts/USDS.sol";

describe("StablyToken", function () {
  let owner: Signer;
  let token: StablyToken;

  beforeEach(async function () {
    [owner] = await ethers.getSigners();
    const StablyTokenContract = await ethers.getContractFactory(
      "StablyToken",
      owner
    );
    token = (await upgrades.deployProxy(
      StablyTokenContract
    )) as unknown as StablyToken; // Casting to unknown first to resolve unmatched type resolution
    await token.waitForDeployment();
  });

  it("should have the correct name and symbol", async function () {
    expect(await token.name()).to.equal("Stably USD");
    expect(await token.symbol()).to.equal("USDS");
  });
});
