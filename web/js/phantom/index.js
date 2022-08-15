/*! https://docs.phantom.app/ */

export async function getPhantom() {
    try {
        // connect
        const connection = await window.solana.connect();
        console.log("phantom wallet connected");
        // return state to js
        return {windowSolana: window.solana, connection: connection}
    } catch (err) {
        console.log(err.message)
        // validate phantom install
        const isPhantomInstalled = window.solana && window.solana.isPhantom;
        if (!isPhantomInstalled) {
            // if phantom not intall open download link in new tab
            window.open("https://phantom.app/", "_blank");
        } else {
            // send err to elm
            app.ports.genericError.send(err.message)
        }
    }
}
