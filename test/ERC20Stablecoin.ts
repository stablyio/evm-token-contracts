import "@openzeppelin/hardhat-upgrades";
import { ethers, upgrades } from "hardhat";
import { Signer } from "ethers";
import { expect } from "chai";
import { ERC20StablecoinUpgradeable } from "../typechain-types/contracts/ERC20StablecoinUpgradeable";

describe("ERC20Stablecoin", function () {
  let owner: Signer;
  let compliance: Signer;
  let random1: Signer;
  let random2: Signer;
  let token: ERC20StablecoinUpgradeable;

  beforeEach(async function () {
    [owner, compliance, random1, random2] = await ethers.getSigners();
    const StablyTokenContract = await ethers.getContractFactory(
      "ERC20StablecoinUpgradeable",
      owner
    );
    token = (await upgrades.deployProxy(
      StablyTokenContract
    )) as unknown as ERC20StablecoinUpgradeable; // Casting to unknown first to resolve unmatched type resolution
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

  describe("role permissions", function () {
    describe("DEFAULT_ADMIN_ROLE", function () {
      it("should be set to deployer", async function () {
        expect(
          await token.hasRole(await token.DEFAULT_ADMIN_ROLE(), owner)
        ).to.equal(true);
      });

      it("should be rotatable", async function () {
        await token.grantRole(
          await token.DEFAULT_ADMIN_ROLE(),
          await random1.getAddress()
        );
        expect(
          await token.hasRole(await token.DEFAULT_ADMIN_ROLE(), random1)
        ).to.equal(true);
        await token.revokeRole(
          await token.DEFAULT_ADMIN_ROLE(),
          await owner.getAddress()
        );
        expect(
          await token.hasRole(await token.DEFAULT_ADMIN_ROLE(), owner)
        ).to.equal(false);
      });
    });

    describe("PAUSER_ROLE", function () {
      it("should be assigned to the deployer", async function () {
        expect(await token.hasRole(await token.PAUSER_ROLE(), owner)).to.equal(
          true
        );
      });

      it("should allow pauser to pause and unpause", async function () {
        await token.mint(await owner.getAddress(), 100);

        await token.pause();
        expect(await token.paused()).to.equal(true);
        await expect(
          token.transfer(await random1.getAddress(), 100)
        ).to.be.revertedWith("Pausable: paused");

        await token.unpause();
        expect(await token.paused()).to.equal(false);
        await token.transfer(await random1.getAddress(), 100);
        expect(await token.balanceOf(await random1.getAddress())).to.equal(100);
      });

      it("should not allow non-pauser to pause and unpause", async function () {
        await expect(token.connect(random1).pause()).to.be.revertedWith(
          /AccessControl: account 0x[0-9a-fA-F]+ is missing role 0x65d7a28e3265b37a6474929f336521b332c1681b933f6cb9f3376673440d862a/
        );
        await expect(token.connect(random1).unpause()).to.be.revertedWith(
          /AccessControl: account 0x[0-9a-fA-F]+ is missing role 0x65d7a28e3265b37a6474929f336521b332c1681b933f6cb9f3376673440d862a/
        );
      });
    });

    describe("MINTER_ROLE", function () {
      it("should be assigned to the deployer", async function () {
        expect(await token.hasRole(await token.MINTER_ROLE(), owner)).to.equal(
          true
        );
      });

      it("should allow the minter to mint", async function () {
        await token.mint(await random1.getAddress(), 100);
        expect(await token.balanceOf(await random1.getAddress())).to.equal(100);
      });

      it("should not allow non-minter to mint", async function () {
        await expect(
          token.connect(random1).mint(await random1.getAddress(), 100)
        ).to.be.revertedWith(
          /AccessControl: account 0x[0-9a-fA-F]+ is missing role 0x9f2df0fed2c77648de5860a4cc508cd0818c85b8b8a1ab4ceeef8d981c8956a6/
        );
      });
    });

    describe("COMPLIANCE_ROLE", function () {
      it("should not be assigned initially", async function () {
        expect(
          await token.hasRole(await token.COMPLIANCE_ROLE(), owner)
        ).to.equal(false);
      });
    });
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
      ).to.be.revertedWith("ERC20Compliance: account is frozen");
      expect(token.connect(random1).burn(100)).to.be.revertedWith(
        "ERC20Compliance: account is frozen"
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
