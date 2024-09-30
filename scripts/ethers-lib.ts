import { ethers } from 'ethers';

/**
 * Fetches the contract metadata.
 * @param contractName - The name of the contract.
 * @returns The contract metadata.
 */
const getContractMetadata = async (contractName: string) => {
  const artifactsPath = `contracts/artifacts/${contractName}.json`; // Adjust this path as needed
  const fileContent = await remix.call('fileManager', 'getFile', artifactsPath);
  return JSON.parse(fileContent);
};

/**
 * Deploys a contract to the blockchain.
 * @param contractName - The name of the contract to deploy.
 * @param args - The arguments to pass to the contract constructor.
 * @param accountIndex - The index of the account to use for deployment.
 * @returns The deployed contract address.
 */
export const deploy = async (contractName: string, args: any[], accountIndex: number = 0) => {
  console.log(`Deploying ${contractName}...`);

  try {
    const metadata = await getContractMetadata(contractName);
    const provider = new ethers.providers.Web3Provider(web3Provider);
    const signer = provider.getSigner(accountIndex);
    
    // Create a ContractFactory
    const factory = new ethers.ContractFactory(metadata.abi, metadata.data.bytecode.object, signer);

    // Deploy the contract
    const contract = await factory.deploy(...args);
    // Wait for the contract to be mined
    await contract.deployed();

    // Return the deployed contract address
    console.log(`Contract deployed at address: ${contract.address}`);
    return contract.address;
  } catch (error) {
    console.error(`Failed to deploy ${contractName}:`, error);
    throw new Error(`Deployment Error: ${error.message}`);
  }
};
