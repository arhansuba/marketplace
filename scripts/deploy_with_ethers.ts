import { deploy } from './ethers-lib';

(async () => {
  try {
    // Specify the contract name and any constructor arguments
    const contractName = 'NFTMarketplace'; // Change to the desired contract name
    const args: any[] = ['My NFT Marketplace', 'MNFT', 'https://api.mynft.com/metadata/']; // Adjust constructor args

    const contract = await deploy(contractName, args);
    console.log(`Contract deployed successfully! Address: ${contract.address}`);
  } catch (e) {
    console.error('Deployment failed:', e.message);
  }
})();
