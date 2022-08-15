import {Program, AnchorProvider, web3} from "@project-serum/anchor";
import {network, preflightCommitment, programID} from "./config.js";
import {PhantomWallet} from "./wallet";
import idl from "./idl.json";

export const textEncoder = new TextEncoder();
export const textDecoder = new TextDecoder();
export const connection = new web3.Connection(network, preflightCommitment);

// get provider & program
export function getPP(_phantom) {
    // build wallet
    const wallet = new PhantomWallet(_phantom)
    // set provider
    const provider = new AnchorProvider(connection, wallet, preflightCommitment);
    // fetch current state of program
    // program
    const program = new Program(idl, programID, provider);
    return {provider: provider, program: program}
}

export function encodeBase64(u8) {
    return Buffer.from(u8).toString('base64')
}

export function decodeBase64(b64) {
    return new Uint8Array(Buffer.from(b64, 'base64'))
}
