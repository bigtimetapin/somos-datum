import {solRpcConditions} from "./util";
import {chain} from "./config";
import LitJsSdk from "lit-js-sdk";
import JSZip from "jszip";
import {saveAs} from "file-saver";
import {getMetaData} from "../anchor/state/meta";
import {getUrl} from "../anchor/state/datum";

export async function decrypt(datum) {
    // get url
    const url = getUrl(datum);
    // fetch meta data
    const metaData = await getMetaData(url);
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
    const uintArray = new Uint8Array(Object.values(metaData.key));
    const encryptedHexKey = LitJsSdk.uint8arrayToString(uintArray, "base16");
    const retrievedSymmetricKey = await client.getEncryptionKey({
        solRpcConditions: solRpcConditions(metaData.lit),
        toDecrypt: encryptedHexKey,
        chain,
        authSig
    });
    // get encrypted zip
    console.log("fetching encrypted zip");
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
    return zip
}

export function downloadZip(zip) {
    // download
    console.log("download file")
    zip.generateAsync({type: "blob"})
        .then(function (blob) {
            saveAs(blob, "decrypted.zip");
        });
}
