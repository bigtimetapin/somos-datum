import {web3} from "@project-serum/anchor";
import {ACCOUNT_SEED_01, ACCOUNT_SEED_02, programID} from "./config";
import {getPP} from "./util.js";
import {getPhantom} from "../phantom";
import {getLedger, sendLedgers} from "./state";
import {init} from "./init";
import {primary} from "./purchase/primary";
import {remove, submit} from "./escrow";
import {secondary} from "./purchase/secondary";
import {upload} from "./upload";
import {decrypt} from "../lit/decrypt";


// TODO; move this file to root
// get phantom
let phantom = null;
let release01PubKey, _ = null;
let release02PubKey, __ = null;
app.ports.connectSender.subscribe(async function (user) {
    // get program public key 01
    [release01PubKey, _] = await web3.PublicKey.findProgramAddress(
        [ACCOUNT_SEED_01],
        programID
    );
    // get program public key 02
    [release02PubKey, __] = await web3.PublicKey.findProgramAddress(
        [ACCOUNT_SEED_02],
        programID
    );
    // get phantom
    phantom = await getPhantom(user);
});

// get current state as soon as user logs in
app.ports.getCurrentStateSender.subscribe(async function (user) {
    // get provider & program
    const pp = getPP(phantom);
    // invoke state request & send response to elm
    const ledgerOne = await getLedger(pp.program, release01PubKey, 1);
    //const ledgerTwo = await getLedger(pp.program, release02PubKey, 2);
    await sendLedgers(user, ledgerOne);
});

// init program
app.ports.initProgramSender.subscribe(async function (userJson) {
    // get provider & program
    const pp = getPP(phantom);
    // decode user
    const user = JSON.parse(userJson);
    const more = JSON.parse(user.more);
    // invoke init: release 01
    if (more.release === 1) {
        await init(pp.program, pp.provider, release01PubKey, ACCOUNT_SEED_01, userJson, 10, 0.025, 0.05);
        // invoke init: release 02
    } else if (more.release === 2) {
        await init(pp.program, pp.provider, release02PubKey, ACCOUNT_SEED_02, userJson, 1, 0.055, 0.05);
        // unsupported release
    } else {
        const msg = "could not init with release: " + more.release.toString();
        app.ports.initProgramFailureListener.send(msg);
    }
});

// upload assets
app.ports.uploadAssetsSender.subscribe(async function (userJson) {
    // get provider & program
    const pp = getPP(phantom);
    // decode user
    const user = JSON.parse(userJson);
    const more = JSON.parse(user.more);
    // invoke upload assets: release 01
    if (more.release === 1) {
        await upload(pp.program, pp.provider, release01PubKey);
        // invoke upload assets: release 02
    } else if (more.release === 2) {
        await upload(pp.program, pp.provider, release02PubKey);
        // unsupported release
    } else {
        const msg = "could not upload assets with release: " + more.release.toString();
        app.ports.genericErrorListener.send(msg);
    }
});

// primary purchase
app.ports.purchasePrimarySender.subscribe(async function (userJson) {
    // get provider & program
    const pp = getPP(phantom);
    // decode user
    const user = JSON.parse(userJson);
    const more = JSON.parse(user.more);
    // invoke purchase request: release 01
    if (more.release === 1) {
        await primary(pp.program, pp.provider, more.recipient, release01PubKey, ACCOUNT_SEED_01, userJson);
        // invoke purchase request: release 02
    } else if (more.release === 2) {
        await primary(pp.program, pp.provider, more.recipient, release02PubKey, ACCOUNT_SEED_02, userJson);
        // unsupported release
    } else {
        const msg = "could not purchase primary with release: " + more.release.toString();
        app.ports.purchasePrimaryFailureListener.send(msg);
    }
});

// submit to escrow
app.ports.submitToEscrowSender.subscribe(async function (userJson) {
    // get provider & program
    const pp = getPP(phantom);
    // decode user
    const user = JSON.parse(userJson);
    const more = JSON.parse(user.more);
    // invoke submit to escrow request: release 01
    if (more.release === 1) {
        await submit(pp.program, pp.provider, release01PubKey, userJson);
        // invoke submit to escrow request: release 02
    } else if (more.release === 2) {
        await submit(pp.program, pp.provider, release02PubKey, userJson);
        // unsupported release
    } else {
        const msg = "could not submit to escrow with release: " + more.release.toString();
        app.ports.submitToEscrowFailureListener.send(msg);
    }
});

// remove from escrow
app.ports.removeFromEscrowSender.subscribe(async function (userJson) {
    // get provider & program
    const pp = getPP(phantom);
    // decode user
    const user = JSON.parse(userJson);
    const more = JSON.parse(user.more);
    // invoke remove from escrow request: release 01
    if (more.release === 1) {
        await remove(pp.program, pp.provider, release01PubKey, userJson);
        // invoke remove from escrow request: release 02
    } else if (more.release === 2) {
        await remove(pp.program, pp.provider, release02PubKey, userJson);
        // unsupported release
    } else {
        const msg = "could not remove from release with release: " + more.release.toString();
        app.ports.genericErrorListener.send(msg);
    }
});

// secondary purchase
app.ports.purchaseSecondarySender.subscribe(async function (userJson) {
    // get provider & program
    const pp = getPP(phantom);
    // decode user
    const user = JSON.parse(userJson);
    const more = JSON.parse(user.more);
    // invoke purchase request: release 01
    if (more.release === 1) {
        await secondary(pp.program, pp.provider, release01PubKey, userJson);
        // invoke purchase request: release 02
    } else if (more.release === 2) {
        await secondary(pp.program, pp.provider, release02PubKey, userJson);
        // unsupported release
    } else {
        const msg = "could not purchase secondary with release: " + more.release.toString();
        app.ports.purchaseSecondaryFailureListener.send(msg);
    }
});

// download
app.ports.downloadSender.subscribe(async function (userJson) {
    // get provider & program
    const pp = getPP(phantom);
    // decode json
    const user = JSON.parse(userJson);
    // invoke decrypt
    if (user.release === 1) {
        await decrypt(pp.program, release01PubKey, userJson);
    } else if (user.release === 2) {
        await decrypt(pp.program, release02PubKey, userJson);
    } else {
        const msg = "could not invoke download of release: " + more.release.toString();
        app.ports.genericErrorListener(msg);
    }
});
