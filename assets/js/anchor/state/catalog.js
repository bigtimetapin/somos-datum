import {web3} from "@project-serum/anchor";
import {getPP} from "../util";

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

export async function catalogAsUploader(phantom, json) {
    // get user wallet
    const publicKey = phantom.connection.publicKey.toString();
    // get provider & program
    const pp = getPP(phantom);
    // parse uploader
    const parsed = JSON.parse(json);
    // TODO; validate uploader as existing account info
    const uploader = new web3.PublicKey(parsed.uploader);
    // TODO; validate mint as existing spl-mint
    const mint = new web3.PublicKey(parsed.mint);
    // assert requested uploader is current user
    if (publicKey !== uploader.toString()) {
        const msg = "current wallet does not match requested uploader address";
        console.log(msg);
        app.ports.genericError.send(msg);
    }
    // get catalog
    try {
        // invoke get catalog
        const catalog_ = await catalog(pp.program, mint, uploader);
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
