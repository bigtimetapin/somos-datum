import * as anchor from "@project-serum/anchor";
import {IDL, SomosDatum} from "../target/types/somos_datum"
import {Program} from "@project-serum/anchor";

// Configure the client
export const provider = anchor.AnchorProvider.env();
anchor.setProvider(provider);
// fetch program
export const program = anchor.workspace.SomosDatum as Program<SomosDatum>;
// export const user02 = await createUser();
// export const program02 = programForUser(user02)

// create 2nd (or more) user
export async function createUser() {
    const airdropBalance = 10 * anchor.web3.LAMPORTS_PER_SOL;
    let user = anchor.web3.Keypair.generate();
    let sig = await provider.connection.requestAirdrop(user.publicKey, airdropBalance);
    await provider.connection.confirmTransaction(sig);

    let wallet = new anchor.Wallet(user);
    let userProvider = new anchor.AnchorProvider(provider.connection, wallet, provider.opts);

    return {
        key: user,
        wallet,
        provider: userProvider,
    };
}

// create program from secondary user
export function programForUser(user) {
    return new anchor.Program(IDL, program.programId, user.provider);
}

export function encodeBase64(u8) {
    return Buffer.from(u8).toString('base64')
}
