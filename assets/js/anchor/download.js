import {web3} from "@project-serum/anchor";
import {decrypt, downloadZip} from "../lit/decrypt";

export async function download(provider, program, json) {
    try {
        // get user wallet
        const publicKey = provider.wallet.publicKey.toString();
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
        // fetch pda datum
        const datum = await program.account.datum.fetch(
            pdaDatum
        );
        // decrypt
        const zip = await decrypt(datum)
        // download
        downloadZip(zip);
        // build response
        const withWallet = {
            wallet: publicKey,
            datum: parsed
        }
        // send success to elm
        app.ports.downloadSuccess.send(
            JSON.stringify(withWallet)
        );
        // or catch error
    } catch (error) {
        console.log(error);
        app.ports.genericError.send(error.toString());
    }
}