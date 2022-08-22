import {network} from "../anchor/config";

export let chain = null;
if (network === "https://ssc-dao.genesysgo.net/") {
    chain = "solana";
} else if (network === "https://devnet.genesysgo.net/") {
    chain = "solanaDevnet";
} else if (network === "http://127.0.0.1:8899") {
    console.log("configuring lit network with solana-devnet");
    chain = "solanaDevnet";
} else {
    const msg = "could not configure lit chain with solana network: " + network
    app.ports.genericError.send(msg);
}
