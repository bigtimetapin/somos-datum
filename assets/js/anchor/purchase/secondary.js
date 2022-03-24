import {web3, BN} from "@project-serum/anchor";
import {getCurrentState} from "../state";
import {BOSS} from "../config";

export async function secondary(program, provider, ledger, userJson) {
    // decode user
    const user = JSON.parse(userJson);
    const more = JSON.parse(user.more);
    const seller = new web3.PublicKey(more.seller)
    const escrowItem = {price: new BN(more.price), seller: seller};
    // rpc
    try {
        await program.rpc.purchaseSecondary(escrowItem, {
            accounts: {
                buyer: provider.wallet.publicKey,
                seller: seller,
                boss: BOSS,
                ledger: ledger,
                systemProgram: web3.SystemProgram.programId,
            },
        });
        // get state after transaction
        await getCurrentState(program, ledger, userJson);
        // log success
        console.log("secondary purchase success");
    } catch (error) {
        // log error
        console.log(error.toString());
        // send error to elm
        app.ports.purchaseSecondaryFailureListener.send(error.message)
    }
}
