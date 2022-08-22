import {web3} from "@project-serum/anchor";

export async function initTariff(provider, program) {
    // derive tariff
    let pdaTariff, _;
    [pdaTariff, _] = await web3.PublicKey.findProgramAddress(
        [
            Buffer.from("tarifftariff")
        ],
        program.programId
    )
    // invoke init tariff
    await program.methods
        .initializeTariff()
        .accounts({
            tariff: pdaTariff,
            payer: provider.wallet.publicKey,
        }).rpc();
    // fetch account
    let tariff = await program.account.tariff.fetch(
        pdaTariff
    );
    console.log(tariff);
    // send success to elm
    app.ports.initializeTariffSuccess.send(
        provider.wallet.publicKey.toString()
    );
}
