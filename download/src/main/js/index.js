// Handler
import * as nacl from "tweetnacl";
import {Buffer} from "buffer";
import {web3, Wallet, Program} from "@project-serum/anchor";
import idl from "./idl.json";

// generate keypair
const keyPair = web3.Keypair.generate()
// build wallet
const wallet = new Wallet(keyPair)
// build provider
const preflightCommitment = "processed";
const devnet = web3.clusterApiUrl("devnet"); // const mainnet = clusterApiUrl("mainnet-beta");
const connection = new web3.Connection(devnet, preflightCommitment);
const provider = new Provider(connection, wallet, preflightCommitment);
// build program
const programID = new web3.PublicKey(idl.metadata.address);
const program = new Program(idl, programID, provider);
// get program public key
const textEncoder = new TextEncoder()
const ACCOUNT_SEED = "hancock"
let statePublicKey, bump = null;
async function getStatePubKeyAndBump() {
    [statePublicKey, bump] = await web3.PublicKey.findProgramAddress(
        [textEncoder.encode(ACCOUNT_SEED)],
        programID
    );
}
// get ledger state
async function getPurchasedList() {
    await getStatePubKeyAndBump()
    const state = await program.account.ledger.fetch(statePublicKey);
    return state.purchased.map(_publicKey => _publicKey.toString());
}

exports.handler = async function (event, context) {
    console.log('## ENVIRONMENT VARIABLES: ' + serialize(process.env))
    console.log('## CONTEXT: ' + serialize(context))
    console.log('## EVENT: ' + serialize(event))
    // const _verified = verify(JSON.parse(event.body))
    const purchasedList = await getPurchasedList();
    try {
        return formatResponse(serialize({purchased : purchasedList.toString()}))
    } catch (error) {
        return formatError(error)
    }
}

let formatResponse = function (body) {
    return {
        "statusCode": 200,
        "headers": {
            "Content-Type": "application/json"
        },
        "isBase64Encoded": false,
        "multiValueHeaders": {
            "Access-Control-Allow-Origin": ["*"],
        },
        "body": body
    }
}

let formatError = function (error) {
    return {
        "statusCode": error.statusCode,
        "headers": {
            "Content-Type": "text/plain",
            "x-amzn-ErrorType": error.code
        },
        "isBase64Encoded": false,
        "body": error.code + ": " + error.message
    }
}

let serialize = function (object) {
    return JSON.stringify(object, null, 2)
}

function decodeBase64(b64) {
    return new Uint8Array(Buffer.from(b64, 'base64'))
}

let verify = function (signedMessage) {
    return nacl.sign.detached.verify(decodeBase64(signedMessage.message), decodeBase64(signedMessage.signature), decodeBase64(signedMessage.user))
}