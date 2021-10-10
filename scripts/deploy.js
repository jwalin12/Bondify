require('dotenv').config();

async function main() {

    const [deployer] = await ethers.getSigners();
  
    console.log("Deploying contracts with the account:", deployer.address);
  
    console.log("Account balance:", (await deployer.getBalance()).toString());
  
    const Bondify = await ethers.getContractFactory("Bondify");
    const bondify = await Bondify.deploy();
  
    console.log("Bondify address:", bondify.address);
    process.env.CONTRACT_ADDR = bondify.address;
  }
  
  main()
    .then(() => process.exit(0))
    .catch((error) => {
      console.error(error);
      process.exit(1);
    });