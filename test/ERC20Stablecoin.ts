import "@openzeppelin/hardhat-upgrades";
import { ethers, upgrades } from "hardhat";
import { Signer } from "ethers";
import { expect } from "chai";
import { ERC20Stablecoin } from "../typechain-types/contracts/ERC20Stablecoin";

describe("ERC20Stablecoin", function () {
  let owner: Signer;
  let compliance: Signer;
  let random1: Signer;
  let random2: Signer;
  let token: ERC20Stablecoin;

  beforeEach(async function () {
    [owner, compliance, random1, random2] = await ethers.getSigners();
    const StablyTokenContract = await ethers.getContractFactory(
      "ERC20Stablecoin",
      owner
    );
    token = (await upgrades.deployProxy(
      StablyTokenContract
    )) as unknown as ERC20Stablecoin; // Casting to unknown first to resolve unmatched type resolution
    await token.waitForDeployment();
  });

  it("should have the correct name and symbol", async function () {
    expect(await token.name()).to.equal("Stably USD");
    expect(await token.symbol()).to.equal("USDS");
  });

  it("should allow a compliance role to be set", async function () {
    await token.grantRole(
      await token.COMPLIANCE_ROLE(),
      await owner.getAddress()
    );
    expect(await token.hasRole(await token.COMPLIANCE_ROLE(), owner)).to.equal(
      true
    );
  });

  describe("compliance capabilities", function () {
    this.beforeEach(async function () {
      await token.grantRole(
        await token.COMPLIANCE_ROLE(),
        await compliance.getAddress()
      );
    });

    it("should allow the compliance role to be set", async function () {
      expect(
        await token.hasRole(await token.COMPLIANCE_ROLE(), compliance)
      ).to.equal(true);
    });

    it("should allow the compliance role to be revoked", async function () {
      await token.revokeRole(
        await token.COMPLIANCE_ROLE(),
        compliance.getAddress()
      );
      expect(
        await token.hasRole(await token.COMPLIANCE_ROLE(), compliance)
      ).to.equal(false);
    });

    it("should not allow frozen addresses to transfer or burn", async function () {
      await token.mint(await random1.getAddress(), 100);
      await token.connect(compliance).freeze(await random1.getAddress());
      await expect(
        token.connect(random1).transfer(await random2.getAddress(), 100)
      ).to.be.revertedWith("ERC20Compliance: account is frozen");
      await expect(token.connect(random1).burn(100)).to.be.revertedWith(
        "ERC20Compliance: account is frozen"
      );
    });
  });
});
