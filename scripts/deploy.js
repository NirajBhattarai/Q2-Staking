const hre = require("hardhat");

async function main() {
  const Q2Staking = await hre.ethers.getContractFactory(
    "Q2Staking"
  );
  const deployedQ2Staking = await Q2Staking.deploy(
    "0x5Fe0997a7Bc3a9faB4E4E7A5D0696A26D71Ae04B","0xDd2541e5C2e752a923962e349FceC4Fbae74DAd8"
  );

  await deployedQ2Staking.deployed();

  console.log(
    "Deployed Q2Staking Address:",
    deployedQ2Staking.address
  );
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
