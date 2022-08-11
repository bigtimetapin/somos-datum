import {getPhantom} from "./phantom";
import {getPP} from "./anchor/util";
import {catalogAsDownloader, catalogAsUploader} from "./anchor/state/catalog";
import {init} from "./anchor/init"
import {upload} from "./anchor/upload";
import {getDatum} from "./anchor/state/datum";
import {download} from "./anchor/download";

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

// connect as downloader
app.ports.connectAsDownloader.subscribe(async function () {
    // get phantom
    phantom = await getPhantom();
    const publicKey = phantom.connection.publicKey.toString();
    // send to elm
    app.ports.connectAsDownloaderSuccess.send(
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

// connect as downloader and get catalog
app.ports.connectAndGetCatalogAsDownloader.subscribe(async function (json) {
    // get phantom
    phantom = await getPhantom();
    // get catalog
    try {
        // get provider & program
        const pp = getPP(phantom);
        // invoke get catalog as downloader
        await catalogAsDownloader(pp.provider, pp.program, json);
        // or report error to elm
    } catch (error) {
        console.log(error);
        app.ports.genericError.send(error.toString());
    }
});

// connect as downloader and get datum
app.ports.connectAndGetDatumAsDownloader.subscribe(async function (json) {
    // get phantom
    phantom = await getPhantom();
    // get catalog
    try {
        // get provider & program
        const pp = getPP(phantom);
        // invoke get datum
        await getDatum(pp.provider, pp.program, json)
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

// get catalog as downloader
app.ports.getCatalogAsDownloader.subscribe(async function (json) {
    // get catalog
    try {
        // get provider & program
        const pp = getPP(phantom);
        // invoke get catalog as downloader
        await catalogAsDownloader(pp.provider, pp.program, json);
        // or report error to elm
    } catch (error) {
        console.log(error);
        app.ports.genericError.send(error.toString());
    }
});

// get datum as downloader
app.ports.getDatumAsDownloader.subscribe(async function (json) {
    // get catalog
    try {
        // get provider & program
        const pp = getPP(phantom);
        // invoke get datum
        await getDatum(pp.provider, pp.program, json)
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

// download assets
app.ports.download.subscribe(async function (json) {
    // get provider & program
    const pp = getPP(phantom);
    // invoke download assets
    await download(pp.provider, pp.program, json)
});
