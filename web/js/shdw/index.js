import {web3} from "@project-serum/anchor";
import {ShdwDrive} from "@shadow-drive/sdk";
import {version} from "./config";
import {network} from "../anchor/config";

export async function provision(wallet, file) {
    // build drive client
    console.log("build shdw client with finalized commitment");
    // build connection with finalized commitment for initial account creation
    const connection = new web3.Connection(network, "finalized");
    const drive = await new ShdwDrive(connection, wallet).init();
    // create storage account
    console.log("create storage account");
    const size = (((file.size / 1000000) + 2).toString()).split(".")[0] + "MB";
    console.log(size);
    app.ports.creatingAccount.send(wallet.publicKey.toString());
    const createStorageResponse = await drive.createStorageAccount("somos-datum", size, version)
    const account = new web3.PublicKey(createStorageResponse.shdw_bucket);
    // mark account as immutable
    console.log("mark account as immutable");
    // time out for 1 second to give RPC time to resolve account
    await new Promise(r => setTimeout(r, 1000));
    app.ports.markingAccountAsImmutable.send(wallet.publicKey.toString());
    await drive.makeStorageImmutable(account, version);
    return {drive, account}
}

export async function uploadFile(wallet, file, drive, account) {
    // upload file
    console.log("upload file");
    return (await drive.uploadFile(account, file, version)).finalized_locations[0]
}
