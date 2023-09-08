import "@openzeppelin/hardhat-upgrades";
import { ethers, upgrades } from "hardhat";
import { Signer } from "ethers";
import { expect } from "chai";
import { TRC25Stablecoin } from "../typechain-types/contracts/TRC25Stablecoin";

describe("TRC25Stablecoin", function () {
  let owner: Signer;
  let compliance: Signer;
  let random1: Signer;
  let random2: Signer;
  let token: TRC25Stablecoin;

  beforeEach(async function () {
    [owner, compliance, random1, random2] = await ethers.getSigners();
    const StablyTokenContract = await ethers.getContractFactory(
      "TRC25Stablecoin",
      owner
    );
    token = (await StablyTokenContract.deploy(
      "USDV",
      "USDV"
    )) as unknown as TRC25Stablecoin; // Casting to unknown first to resolve unmatched type resolution
    await token.waitForDeployment();
  });

  it("should have the correct name and symbol", async function () {
    expect(await token.name()).to.equal("USDV");
    expect(await token.symbol()).to.equal("USDV");
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
      expect(
        token.connect(random1).transfer(await random2.getAddress(), 100)
      ).to.be.revertedWith("TRC25Compliance: account is frozen");
      expect(token.connect(random1).burn(100)).to.be.revertedWith(
        "TRC25Compliance: account is frozen"
      );
    });

    it("should allow compliance to seize tokens", async function () {
      await token.mint(await random1.getAddress(), 100);
      await token.connect(compliance).seize(await random1.getAddress(), 100);
      expect(await token.balanceOf(await random1.getAddress())).to.equal(0);
    });

    it("non-compliance role cannot seize tokens", async function () {
      await token.mint(await random1.getAddress(), 100);
      expect(
        token.connect(random2).seize(await random1.getAddress(), 100)
      ).to.be.revertedWith(
        /AccessControl: account 0x[0-9a-fA-F]+ is missing role 0x442a94f1a1fac79af32856af2a64f63648cfa2ef3b98610a5bb7cbec4cee6985/
      );
    });

    it("only compliance role can freeze, unfreeze and seize", async function () {
      await token.mint(await random1.getAddress(), 100);
      expect(
        token.connect(random1).freeze(await random1.getAddress())
      ).to.be.revertedWith(
        /AccessControl: account 0x[0-9a-fA-F]+ is missing role 0x442a94f1a1fac79af32856af2a64f63648cfa2ef3b98610a5bb7cbec4cee6985/
      );
      expect(
        token.connect(random1).unfreeze(await random1.getAddress())
      ).to.be.revertedWith(
        /AccessControl: account 0x[0-9a-fA-F]+ is missing role 0x442a94f1a1fac79af32856af2a64f63648cfa2ef3b98610a5bb7cbec4cee6985/
      );
      expect(
        token.connect(random1).seize(await random1.getAddress(), 100)
      ).to.be.revertedWith(
        /AccessControl: account 0x[0-9a-fA-F]+ is missing role 0x442a94f1a1fac79af32856af2a64f63648cfa2ef3b98610a5bb7cbec4cee6985/
      );
    });
  });
});
