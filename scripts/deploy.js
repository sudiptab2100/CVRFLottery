async function main() {
    const [deployer] = await ethers.getSigners();
  
    console.log("Deploying contracts with the account:", deployer.address);
  
    console.log("Account balance:", (await deployer.getBalance()).toString());
  
    const VRFLottery = await ethers.getContractFactory("VRFLottery");
    const vrf = await VRFLottery.deploy();
  
    console.log("Contract address:", vrf.address);
  }
  
  main()
    .then(() => process.exit(0))
    .catch((error) => {
      console.error(error);
      process.exit(1);
    });