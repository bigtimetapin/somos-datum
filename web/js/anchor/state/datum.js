export async function getDatum(provider, program, json) {
    const wallet = provider.wallet.publicKey.toString();
    const datum = JSON.parse(json);
    const withWallet = {
        wallet: wallet,
        datum: datum
    }
    app.ports.connectAndGetDatumAsDownloaderSuccess.send(
        JSON.stringify(withWallet)
    );
}
