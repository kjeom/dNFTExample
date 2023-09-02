import { HardhatRuntimeEnvironment } from "hardhat/types";
import { DeployFunction } from "hardhat-deploy/types";

const func: DeployFunction = async (hre: HardhatRuntimeEnvironment) => {
  const { deployments, getNamedAccounts } = hre;

  const { deploy } = deployments;
  const { deployer } = await getNamedAccounts();

  await deploy("KdynamicNFT", {
    from: deployer,
    gasLimit: 4000000,
    args: [],
    log: true,
  });
};

func.tags = ["KdynamicNFT"];
// func.dependencies = ["Lock"]; // this ensures Lock is deployed before Counter
export default func;
