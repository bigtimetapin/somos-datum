import {encrypt} from "../lit/encrypt";
import {provision, uploadFile} from "../shdw";
import {textEncoder} from "./util";
import {web3} from "@project-serum/anchor";

export async function upload(program, provider, json) {
    try {
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
        // build mint
        const mint = new web3.PublicKey(parsed.lit.mint);
        // // select files
        const files = document.getElementById("gg-sd-zip").files;
        // invoke encryption
        console.log(parsed.lit);
        const encrypted = await encrypt(files, parsed.lit);
        // provision shdw drive
        const fileName = "encrypted.zip"
        const file = new File([encrypted.encryptedZip], fileName)
        const provisioned = await provision(provider.wallet, file);
        // upload blob to shdw drive
        app.ports.uploadingFile.send(provider.wallet.publicKey.toString());
        const url = await uploadFile(provider.wallet, file, provisioned.drive, provisioned.account);
        console.log(provisioned);
        console.log(url);
        // upload meta data to shdw drive
        app.ports.uploadingMetaData.send(provider.wallet.publicKey.toString());
        const metaData = buildMetaData(parsed.lit);
        console.log(metaData);
        const url2 = await uploadFile(provider.wallet, metaData, provisioned.drive, provisioned.account);
        console.log(url2);
        // derive pda increment
        app.ports.publishingUrl.send(provider.wallet.publicKey.toString());
        let pdaIncrement, _;
        [pdaIncrement, _] = await web3.PublicKey.findProgramAddress(
            [
                mint.toBuffer(),
                provider.wallet.publicKey.toBuffer(),
            ],
            program.programId
        );
        // derive pda datum
        let pdaDatum;
        [pdaDatum, _] = await web3.PublicKey.findProgramAddress(
            [
                mint.toBuffer(),
                provider.wallet.publicKey.toBuffer(),
                Buffer.from([parsed.increment])
            ],
            program.programId
        );
        // build upload url
        const prefix = url.replace(fileName, "");
        const encodedPrefix = textEncoder.encode(prefix);
        console.log(prefix);
        console.log(prefix.length);
        console.log(encodedPrefix);
        console.log(encodedPrefix.length);
        // invoke rpc
        await program.methods
            .publishAssets(parsed.increment, Buffer.from(encrypted.encryptedSymmetricKey), Buffer.from(encodedPrefix))
            .accounts({
                datum: pdaDatum,
                increment: pdaIncrement,
                mint: mint,
                payer: provider.wallet.publicKey,
                systemProgram: web3.SystemProgram.programId
            })
            .rpc();
        // report to elm
        app.ports.uploadSuccess.send(json);
        console.log("publish assets success");
        // or catch error
    } catch (error) {
        console.log(error)
        app.ports.genericError.send(error.toString());
    }
}

function buildMetaData(lit) {
    // build meta data
    const meta = {
        "lit": lit
    }
    const json = JSON.stringify(meta);
    const bytes = textEncoder.encode(json);
    const blob = new Blob([bytes], {
        type: "application/json;charset=utf-8"
    });
    return new File([blob], "meta.json");
}
