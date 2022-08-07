import {getPhantom} from "phantom";
import {getPP} from "anchor/util.js";
import {upload} from "anchor/upload";
import {decrypt} from "lit/decrypt";

// get phantom
let phantom = null;
app.ports.connectSender.subscribe(async function (user) {
    // get phantom
    phantom = await getPhantom(user);
});

// get current state as soon as user logs in
app.ports.getCurrentStateSender.subscribe(async function (json) {
    // get provider & program
    const pp = getPP(phantom);
    // parse user

    // invoke state request & send response to elm

});

// upload assets
app.ports.uploadAssetsSender.subscribe(async function (userJson) {
    // get provider & program
    const pp = getPP(phantom);
    // decode user
    const user = JSON.parse(userJson);
    const more = JSON.parse(user.more);
    // invoke upload assets
});

// download
app.ports.downloadSender.subscribe(async function (userJson) {
    // get provider & program
    const pp = getPP(phantom);
    // decode json
    const user = JSON.parse(userJson);
    // invoke decrypt
});
