import {getPhantom} from "./phantom";
import {getPP} from "./anchor/util";
import {catalogAsUploader} from "./anchor/state/catalog";
import {init} from "./anchor/init"
import {upload} from "./anchor/upload";

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
        // get provider & program
        const pp = getPP(phantom);
        // invoke get catalog as uploader
        await catalogAsUploader(pp.provider, pp.program, json);
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
        // get provider & program
        const pp = getPP(phantom);
        // invoke get catalog as uploader
        await catalogAsUploader(pp.provider, pp.program, json);
        // or report error to elm
    } catch (error) {
        console.log(error);
        app.ports.genericError.send(error.toString());
    }
});

// initialize catalog
app.ports.initializeCatalog.subscribe(async function (json) {
    try {
        // get provider & program
        const pp = getPP(phantom);
        // invoke init
        const catalog = await init(pp.provider, pp.program, json);
        // send catalog to elm
        app.ports.initializeCatalogSuccess.send(JSON.stringify(catalog));
        // or report error to elm
    } catch (error) {
        console.log(error);
        app.ports.genericError.send(error.toString());
    }
});

// upload assets
app.ports.upload.subscribe(async function (json) {
    // get provider & program
    const pp = getPP(phantom);
    // invoke upload assets
    await upload(pp.program, pp.provider, json);
});

// download
app.ports.downloadSender.subscribe(async function (userJson) {
    // get provider & program
    const pp = getPP(phantom);
    // decode json
    const user = JSON.parse(userJson);
    // invoke decrypt
});
