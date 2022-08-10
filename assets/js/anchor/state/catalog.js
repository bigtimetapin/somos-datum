import {web3} from "@project-serum/anchor";
import {connection} from "../util";
import {preflightCommitment} from "../config";
import {getMint} from "@solana/spl-token";

export async function catalog(program, mint, uploader) {
    // derive pda
    let pda, _;
    [pda, _] = await web3.PublicKey.findProgramAddress(
        [
            mint.toBuffer(),
            uploader.toBuffer(),
        ],
        program.programId
    );
    // get pda
    return await program.account.increment.fetch(pda)
}

export async function catalogAsUploader(provider, program, json) {
    // get user wallet
    const publicKey = provider.wallet.publicKey.toString();
    // parse uploader
    const parsed = JSON.parse(json);
    // validate uploader
    const uploader = new web3.PublicKey(parsed.uploader);
    if (publicKey !== uploader.toString()) {
        const msg = "current wallet does not match requested uploader address";
        console.log(msg);
        app.ports.genericError.send(msg);
        return null
    }
    // validate mint
    const mint = new web3.PublicKey(parsed.mint);
    try {
        await getMint(connection, mint, preflightCommitment);
    } catch (error) {
        console.log(error);
        app.ports.genericError.send(error.toString());
        return null
    }
    // get catalog
    try {
        // invoke get catalog
        const catalog_ = await catalog(program, mint, uploader);
        // send to elm
        app.ports.connectAndGetCatalogAsUploaderSuccess.send(
            JSON.stringify(catalog_)
        );
        // or catch
    } catch (error) {
        console.log(error);
        const DNE = "error: account does not exist";
        if (error.toString().toLowerCase().startsWith(DNE)) {
            app.ports.foundCatalogAsUninitialized.send(
                json
            );
        } else {
            app.ports.genericError.send(error.toString());
        }
    }
}
