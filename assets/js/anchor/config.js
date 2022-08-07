import {web3} from "@project-serum/anchor";

export const preflightCommitment = "processed";
export const programID = new web3.PublicKey("HGfrweUKP7gEE7bGwvZaAEFHhQLAjpd4ZK1nTQKN6CKW");
// const localnet = "http://127.0.0.1:8899";
// const devnet = web3.clusterApiUrl("devnet");
const mainnet = web3.clusterApiUrl("mainnet-beta");
export const network = mainnet;
