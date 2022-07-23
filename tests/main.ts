import assert from "assert";
import * as anchor from "@project-serum/anchor";
import {
    provider,
    program,
    createUser
} from "./util.ts";

describe("somos-datum", () => {
    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    // UPLOAD ASSETS ///////////////////////////////////////////////////////////////////////////////////////////////////
    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    // init
    it("upload assets", async () => {
        // instantiate mint
        const mint = await createUser();
        // create assets
        const key = Buffer.from("k".repeat(184));
        const url = Buffer.from("u".repeat(78));
        // derive increment
        let pdaIncrement, _;
        [pdaIncrement, _] = await anchor.web3.PublicKey.findProgramAddress(
            [
                mint.key.publicKey.toBuffer(),
                provider.wallet.publicKey.toBuffer(),
            ],
            program.programId
        );
        // derive datum one
        let pdaOne;
        let seedOne = Buffer.from([1]);
        [pdaOne, _] = await anchor.web3.PublicKey.findProgramAddress(
            [
                mint.key.publicKey.toBuffer(),
                provider.wallet.publicKey.toBuffer(),
                seedOne
            ],
            program.programId
        );
        // invoke rpc
        await program.methods
            .publishAssets(seedOne, key, url)
            .accounts({
                datum: pdaOne,
                increment: pdaIncrement,
                mint: mint.key.publicKey,
                payer: provider.wallet.publicKey,
                systemProgram: anchor.web3.SystemProgram.programId,

            }).rpc();
        // fetch accounts
        const actualIncrement = await program.account.increment.fetch(
            pdaIncrement
        );
        const actualOne = await program.account.datum.fetch(
            pdaOne
        );
        // assertions
        assert.ok(actualIncrement.increment === 1);
        assert.ok(actualOne.seed[0] === 1);
        assert.ok(actualOne.seed.length === 1);
        // invoke again & fail
        let requiredError;
        try {
            // invoke rpc
            await program.methods
                .publishAssets(seedOne, key, url)
                .accounts({
                    datum: pdaOne,
                    increment: pdaIncrement,
                    mint: mint.key.publicKey,
                    payer: provider.wallet.publicKey,
                    systemProgram: anchor.web3.SystemProgram.programId,

                }).rpc();
        } catch (error) {
            requiredError = true;
            console.log(error.code);
        }
        assert(requiredError);
    });
});
