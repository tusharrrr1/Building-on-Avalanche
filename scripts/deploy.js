const hre = require("hardhat");

async function main() {
  // Get the Points smart contract
  const Points = await hre.ethers.getContractFactory("DegenToken",["0x7cA7786274196888f65B2710a6Be7b2C0Bf24693"]);

  // Specify the initial owner address
  const [deployer] = await hre.ethers.getSigners();

  // Deploy it with the initial owner address
  const points = await Points.deploy(deployer.address);
  await points.waitForDeployment();

  console.log("transaction hash:", points.deploymentTransaction().hash);
  console.log(`Points token deployed to ${await points.getAddress()}`);
  // Mint the initial supply
  console.log('minting tokens to deployer...');
  const initialSupply = hre.ethers.parseUnits('1000', 18); // For example, 1000 tokens with 18 decimals
 const minitng =  await points.mint(deployer.address, initialSupply)
  await minitng.wait();
  console.log('minted tokens to deployer...');

  // Display the contract address

}

// Hardhat recommends this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
