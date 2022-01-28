import {web3} from "@project-serum/anchor";
import {ACCOUNT_SEED, programID} from "./config";
import {getPP, textEncoder} from "./util.js";
import {getPhantom} from "../phantom";
import {getCurrentState} from "./state";
import {primary} from "./purchase/primary";

// get program public key
let statePublicKey, bump = null;
[statePublicKey, bump] = await web3.PublicKey.findProgramAddress(
    [textEncoder.encode(ACCOUNT_SEED)],
    programID
);

// get phantom
let phantom = null;
app.ports.connectSender.subscribe(async function () {
    phantom = await getPhantom()
});

// get current state as soon as user logs in
app.ports.isConnectedSender.subscribe(async function () {
    // get provider & program
    const pp = getPP(phantom)
    // invoke state request & send response to elm
    await getCurrentState(pp.program, statePublicKey)
});

// primary purchase
app.ports.purchasePrimarySender.subscribe(async function () {
    // get provider & program
    const pp = getPP(phantom)
    // invoke purchase request
    await primary(pp.program, pp.provider, statePublicKey)
});