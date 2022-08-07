import {solRpcConditions} from "./util";
import {textDecoder} from "../anchor/util";
import {chain} from "./config";
import LitJsSdk from "lit-js-sdk";
import JSZip from "jszip";
import {saveAs} from "file-saver";

export async function decrypt(program, ledger, userJson) {
    try {
        const _state = await program.account.ledger.fetch(ledger);
        // build client
        const client = new LitJsSdk.LitNodeClient();
        // await for connection
        console.log("connecting to LIT network");
        await client.connect();
        // client signature
        console.log("invoking signature request");
        const authSig = await LitJsSdk.checkAndSignAuthMessage({chain: chain});
        // get encryption key
        console.log("getting key from networking");
        // Note, below we convert the encryptedSymmetricKey from a UInt8Array to a hex string.
        // This is because we obtained the encryptedSymmetricKey from "saveEncryptionKey" which returns a UInt8Array.
        // But the getEncryptionKey method expects a hex string.
        const uintArray = new Uint8Array(_state.assets.key); // buffer from anchor borsh codec
        const encryptedHexKey = LitJsSdk.uint8arrayToString(uintArray, "base16");
        const retrievedSymmetricKey = await client.getEncryptionKey({
            solRpcConditions: solRpcConditions(_state.auth.toString()),
            toDecrypt: encryptedHexKey,
            chain,
            authSig
        });
        // get encrypted zip
        console.log("fetching encrypted zip");
        const url = textDecoder.decode(new Uint8Array(_state.assets.url));
        const encryptedZip = await fetch(url + "encrypted.zip")
            .then(response => response.blob());
        // decrypt file
        console.log("decrypting zip file");
        const decrypted = await LitJsSdk.decryptZip(
            encryptedZip,
            retrievedSymmetricKey
        );
        // convert back to zip
        const zip = new JSZip();
        zip.files = decrypted;
        // download
        console.log("download file")
        zip.generateAsync({type: "blob"})
            .then(function (blob) {
                saveAs(blob, "decrypted.zip");
            });
        // send success to elm
        app.ports.downloadSuccessListener.send(userJson);
        // or catch error
    } catch (error) {
        const msg = error.toString();
        console.log(msg);
        app.ports.genericErrorListener.send(msg);
    }
}
