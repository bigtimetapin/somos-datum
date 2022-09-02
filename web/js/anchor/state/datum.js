import {web3} from "@project-serum/anchor";
import {getMetaData} from "./meta";
import {textDecoder} from "../util";

export async function getDatum(provider, program, json) {
    // grab wallet
    const wallet = provider.wallet.publicKey.toString();
    // parse json
    const parsed = JSON.parse(json);
    // derive pda
    const pdaDatum = await derivePda(json, program);
    // fetch pda
    const datum = await fetchPda(pdaDatum, program);
    // get url for meta-data
    const url = getUrl(datum);
    // fetch meta-data
    const metaData = await getMetaData(url);
    // build response
    const withWallet = {
        wallet: wallet,
        datum: {
            mint: parsed.mint,
            uploader: parsed.uploader,
            increment: parsed.increment,
            title: metaData.title,
        }
    }
    return JSON.stringify(
        withWallet,
        function (k, v) {
            return v === undefined ? null : v;
        } // preserve nulls
    )
}

export async function derivePda(json, program) {
    // parse uploader
    const parsed = JSON.parse(json);
    const uploader = new web3.PublicKey(parsed.uploader);
    const mint = new web3.PublicKey(parsed.mint);
    // derive pda datum
    let pdaDatum, _;
    [pdaDatum, _] = await web3.PublicKey.findProgramAddress(
        [
            mint.toBuffer(),
            uploader.toBuffer(),
            Buffer.from([parsed.increment])
        ],
        program.programId
    );
    return pdaDatum
}

export async function fetchPda(pdaDatum, program) {
    return await program.account.datum.fetch(
        pdaDatum
    );
}

export function getUrl(datum) {
    return textDecoder.decode(new Uint8Array(datum.url));
}
