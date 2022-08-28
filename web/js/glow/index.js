/*! https://github.com/glow-xyz/glow-js/tree/master/packages/glow-client */

import {GlowClient} from "@glow-xyz/glow-client";
import {web3} from "@project-serum/anchor";

export async function getGlow() {
    const glowClient = new GlowClient();
    const address = await glowClient.connect();
    const publicKey = new web3.PublicKey(address.toString());
    console.log("glow wallet connected");
    return {glowClient, publicKey}
}
