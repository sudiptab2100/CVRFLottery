const { assert, expect } = require("chai")
const chai = require("chai")
chai.use(require('chai-as-promised'))

function timeout(s) {
  return new Promise(resolve => setTimeout(resolve, s * 1000));
}

describe("VRFLottery contract", function () {

  let owner, VRFLottery, vrf
  beforeEach(async () => {
    [owner] = await ethers.getSigners();

    VRFLottery = await ethers.getContractFactory("VRFLottery");

    vrf = await VRFLottery.deploy();
  })
  it("Initial tests", async function () {

    expect(await vrf.isLive()).to.equal(false);
    expect(await vrf.isInitialized()).to.equal(false);

  });

  it("Participation Test", async function () {

    var initTime = Math.floor(Date.now() / 1000) + 4;
    var duration = 100; // event duration 100 seconds
    await vrf.initialize(initTime, duration);

    expect(await vrf.isInitialized()).to.equal(true); // initialized
    expect(await vrf.isLive()).to.equal(false); // not live yet

    await timeout(10)

    // first participation
    await vrf.participate({from: owner.address, value: "100000000000000000"});
    expect(await vrf.partCount()).to.equal(1);
    
    expect(await vrf.isLive()).to.equal(true); // now live

    /* 
      multiple participation 
      from same address rejected
    */
    await expect(
      vrf.participate({from: owner.address, value: "100000000000000000"})
    ).to.be.rejected
  });
});