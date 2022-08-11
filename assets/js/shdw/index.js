import {web3} from "@project-serum/anchor";
import {ShdwDrive} from "@shadow-drive/sdk";
import {version} from "./config";
import {network} from "../anchor/config";

export async function shdw(wallet, file) {
    // build drive client
    console.log("build shdw client with finalized commitment");
    // build connection with finalized commitment for initial account creation
    const connection = new web3.Connection(network, "finalized");
    const drive = await new ShdwDrive(connection, wallet).init();
    // create storage account
    console.log("create storage account");
    const size = (((file.size / 1000000) + 1).toString()).split(".")[0] + "MB";
    console.log(size);
    const createStorageResponse = await drive.createStorageAccount("somos-datum", size, version);
    const account = new web3.PublicKey(createStorageResponse.shdw_bucket);
    // mark account as immutable
    console.log("mark account as immutable");
    await drive.makeStorageImmutable(account, version);
    // upload file
    console.log("upload file");
    return (await drive.uploadFile(account, file, version)).finalized_locations[0]
}
