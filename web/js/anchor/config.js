import {web3} from "@project-serum/anchor";

export const preflightCommitment = "processed";
export const programID = new web3.PublicKey("3sDHnRG7GMJCjeNkxcTQMySbn1UF26CuW211NrWCRdVW");
export const boss = new web3.PublicKey("DEuG4JnzvMVxMFPoBVvf2GH38mn3ybunMxtfmVU3ms86");
// const localnet = "http://127.0.0.1:8899";
// const devnet = web3.clusterApiUrl("devnet");
const mainnet = web3.clusterApiUrl("mainnet-beta");
export const network = mainnet;
