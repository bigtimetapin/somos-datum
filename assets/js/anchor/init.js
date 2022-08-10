import {web3} from "@project-serum/anchor";

export async function init(provider, program, json) {
    // get user wallet
    const publicKey = provider.wallet.publicKey.toString();
    // parse uploader
    const parsed = JSON.parse(json);
    // validate uploader
    const uploader = new web3.PublicKey(parsed.uploader);
    if (publicKey !== uploader.toString()) {
        const msg = "current wallet does not match requested uploader address";
        console.log(msg);
        app.ports.genericError.send(msg);
        return null
    }
    // build mint
    const mint = new web3.PublicKey(parsed.mint);
    // derive pda
    let pda, _;
    [pda, _] = await web3.PublicKey.findProgramAddress(
        [
            mint.toBuffer(),
            provider.wallet.publicKey.toBuffer(),
        ],
        program.programId
    );
    // invoke rpc
    console.log(pda)
    console.log(mint)
    console.log(provider.wallet.publicKey)
    console.log(web3.SystemProgram.programId)
    await program.methods
        .initializeIncrement()
        .accounts({
            increment: pda,
            mint: mint,
            payer: provider.wallet.publicKey,
            systemProgram: web3.SystemProgram.programId
        }).rpc();
    // build catalog
    return {
        mint: parsed.mint,
        uploader: publicKey,
        increment: 0
    }
}
