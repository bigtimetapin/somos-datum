import {getPhantom} from "./phantom";
import {getPP} from "./anchor/util";
import {catalogAsUploader} from "./anchor/state/catalog";

// init phantom
let phantom = null;

// connect as uploader
app.ports.connectAsUploader.subscribe(async function () {
    // get phantom
    phantom = await getPhantom();
    const publicKey = phantom.connection.publicKey.toString();
    // send to elm
    app.ports.connectAsUploaderSuccess.send(
        publicKey
    );
});

// connect as uploader and get catalog
app.ports.connectAndGetCatalogAsUploader.subscribe(async function (json) {
    // get phantom
    phantom = await getPhantom();
    // get catalog
    try {
        // invoke get catalog as uploader
        await catalogAsUploader(phantom, json);
        // or report error to elm
    } catch (error) {
        console.log(error);
        app.ports.genericError.send(error.toString());
    }
});

// get catalog as uploader
app.ports.getCatalogAsUploader.subscribe(async function (json) {
    // get catalog
    try {
        // invoke get catalog as uploader
        await catalogAsUploader(phantom, json);
        // or report error to elm
    } catch (error) {
        console.log(error);
        app.ports.genericError.send(error.toString());
    }
});

// initialize catalog
app.ports.initializeCatalog.subscribe(async function (json) {
    ///
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
