import {encrypt} from "../lit/encrypt";
import {shdw} from "../shdw";
import {textEncoder} from "./util";

export async function upload(program, provider, ledger) {
    try {
        // fetch mint for encryption auth
        const _state = await program.account.ledger.fetch(ledger);
        const mint = _state.auth.toString();
        // // select files
        const files = document.getElementById("gg-sd-zip").files;
        // invoke encryption
        const encrypted = await encrypt(mint, files);
        // upload blob to shdw drive
        const fileName = "encrypted.zip"
        const file = new File([encrypted.encryptedZip], fileName)
        const url = await shdw(provider.wallet, file);
        const prefix = url.replace(fileName, "");
        // invoke rpc
        const encodedPrefix = textEncoder.encode(prefix);
        await program.rpc.publishAssets(Buffer.from(encrypted.encryptedSymmetricKey), Buffer.from(encodedPrefix), {
            accounts: {
                ledger: ledger,
                boss: provider.wallet.publicKey,
            }
        });
        console.log("publish assets success");
        // or catch error
    } catch (error) {
        console.log(error)
        app.ports.genericErrorListener.send(error.toString());
    }
}
