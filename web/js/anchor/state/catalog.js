import {web3} from "@project-serum/anchor";
import {connection} from "../util";
import {preflightCommitment} from "../config";

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
        await connection.getAccountInfo(mint, preflightCommitment);
    } catch (error) {
        console.log(error);
        app.ports.genericError.send(error.toString());
        return null
    }
    // get catalog
    try {
        // invoke get increment
        const increment = await getIncrement(program, mint, uploader);
        // build catalog
        const catalog = {
            mint: mint,
            uploader: uploader,
            increment: increment.increment
        }
        // send to elm
        app.ports.connectAndGetCatalogAsUploaderSuccess.send(
            JSON.stringify(catalog)
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

export async function catalogAsDownloader(provider, program, json) {
    // get user wallet
    const publicKey = provider.wallet.publicKey.toString();
    // parse uploader
    const parsed = JSON.parse(json);
    // validate uploader
    const uploader = new web3.PublicKey(parsed.uploader);
    try {
        await connection.getAccountInfo(uploader, preflightCommitment);
    } catch (error) {
        console.log(error);
        app.ports.genericError.send(error.toString());
        return null
    }
    // validate mint
    const mint = new web3.PublicKey(parsed.mint);
    try {
        await connection.getAccountInfo(mint, preflightCommitment);
    } catch (error) {
        console.log(error);
        app.ports.genericError.send(error.toString());
        return null
    }
    // invoke get increment
    const increment = await getIncrement(program, mint, uploader);
    // build catalog
    const catalog = {
        mint: mint,
        uploader: uploader,
        increment: increment.increment
    }
    // build with wallet
    const withWallet = {
        wallet: publicKey,
        catalog: catalog
    }
    // send to elm
    app.ports.connectAndGetCatalogAsDownloaderSuccess.send(
        JSON.stringify(withWallet)
    );
}

export async function manyCatalogAsDownloader(provider, program, json) {
    // get user wallet
    const publicKey = provider.wallet.publicKey.toString();
    // parse json
    const array = JSON.parse(json);
    // unpack mint
    const mint = new web3.PublicKey(array[0].mint);
    // get pda for every uploader
    const many = await Promise.all(
        array.map(async obj =>
            await getIncrementForMany(program, mint, obj.uploader)
        )
    )
    // build with wallet
    const withWallet = {
        wallet: publicKey,
        many: many.filter(Boolean)
    }
    // send to elm
    app.ports.connectAndGetManyCatalogsAsDownloaderSuccess.send(
        JSON.stringify(withWallet)
    );
}

async function getIncrement(program, mint, uploader) {
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

async function getIncrementForMany(program, mint, uploader) {
    // build public-key
    const publicKey = new web3.PublicKey(uploader);
    // fetch increment
    let response;
    try {
        const increment = await getIncrement(program, mint, publicKey);
        response = {
            mint: mint.toString(),
            uploader: uploader,
            increment: increment.increment
        }
    } catch (error) {
        console.log("could not find pda-increment with uploader: " + uploader);
        response = null
    }
    return response
}
