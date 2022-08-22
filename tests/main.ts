import assert from "assert";
import * as anchor from "@project-serum/anchor";
import {
    provider,
    program,
    createUser, programForUser
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
        const url = Buffer.from("u".repeat(78));
        // derive tariff
        let pdaTariff, _;
        [pdaTariff, _] = await anchor.web3.PublicKey.findProgramAddress(
            [
                Buffer.from("tarifftariff")
            ],
            program.programId
        )
        // derive increment
        let pdaIncrement;
        [pdaIncrement, _] = await anchor.web3.PublicKey.findProgramAddress(
            [
                mint.key.publicKey.toBuffer(),
                provider.wallet.publicKey.toBuffer(),
            ],
            program.programId
        );
        // derive datum one
        let pdaOne;
        [pdaOne, _] = await anchor.web3.PublicKey.findProgramAddress(
            [
                mint.key.publicKey.toBuffer(),
                provider.wallet.publicKey.toBuffer(),
                Buffer.from([1])
            ],
            program.programId
        );
        // invoke init tariff
        await program.methods
            .initializeTariff()
            .accounts({
                tariff: pdaTariff,
                payer: provider.wallet.publicKey,
                systemProgram: anchor.web3.SystemProgram.programId
            }).rpc();
        // fetch account
        const actualTariff = await program.account.tariff.fetch(
            pdaTariff
        );
        // assertions
        assert.ok(actualTariff.tariff.toNumber() === 0);
        // invoke init increment
        await program.methods
            .initializeIncrement()
            .accounts({
                increment: pdaIncrement,
                mint: mint.key.publicKey,
                payer: provider.wallet.publicKey,
                systemProgram: anchor.web3.SystemProgram.programId
            }).rpc();
        // invoke publish assets
        await program.methods
            .publishAssets(1, url)
            .accounts({
                datum: pdaOne,
                increment: pdaIncrement,
                mint: mint.key.publicKey,
                tariff: pdaTariff,
                payer: provider.wallet.publicKey,
                systemProgram: anchor.web3.SystemProgram.programId
            }).rpc();
        // fetch accounts
        let actualIncrement = await program.account.increment.fetch(
            pdaIncrement
        );
        const actualOne = await program.account.datum.fetch(
            pdaOne
        );
        // assertions
        assert.ok(actualIncrement.increment === 1);
        assert.ok(actualOne.seed === 1);
        // invoke again & fail
        let requiredError;
        try {
            // invoke publish assets
            await program.methods
                .publishAssets(1, url)
                .accounts({
                    datum: pdaOne,
                    increment: pdaIncrement,
                    mint: mint.key.publicKey,
                    tariff: pdaTariff,
                    payer: provider.wallet.publicKey,
                    systemProgram: anchor.web3.SystemProgram.programId,

                }).rpc();
        } catch (error) {
            requiredError = true;
        }
        assert(requiredError);
        // invoke with skipped seed
        // derive datum three
        let pdaThree;
        [pdaThree, _] = await anchor.web3.PublicKey.findProgramAddress(
            [
                mint.key.publicKey.toBuffer(),
                provider.wallet.publicKey.toBuffer(),
                Buffer.from([3])
            ],
            program.programId
        );
        requiredError = false;
        try {
            // invoke publish assets
            await program.methods
                .publishAssets(3, url)
                .accounts({
                    datum: pdaThree,
                    increment: pdaIncrement,
                    mint: mint.key.publicKey,
                    tariff: pdaTariff,
                    payer: provider.wallet.publicKey,
                    systemProgram: anchor.web3.SystemProgram.programId,

                }).rpc();
        } catch (error) {
            requiredError = true;
        }
        assert(requiredError);
        // invoke next seed
        // derive datum two
        let pdaTwo;
        [pdaTwo, _] = await anchor.web3.PublicKey.findProgramAddress(
            [
                mint.key.publicKey.toBuffer(),
                provider.wallet.publicKey.toBuffer(),
                Buffer.from([2])
            ],
            program.programId
        );
        // invoke publish assets
        await program.methods
            .publishAssets(2, url)
            .accounts({
                datum: pdaTwo,
                increment: pdaIncrement,
                mint: mint.key.publicKey,
                tariff: pdaTariff,
                payer: provider.wallet.publicKey,
                systemProgram: anchor.web3.SystemProgram.programId,

            }).rpc();
        // fetch accounts
        actualIncrement = await program.account.increment.fetch(
            pdaIncrement
        );
        const actualTwo = await program.account.datum.fetch(
            pdaTwo
        );
        // assertions
        assert.ok(actualIncrement.increment === 2);
        assert.ok(actualTwo.seed === 2);
        // transfer tariff authority
        const user02 = await createUser();
        await program.methods
            .transferTariffAuthority()
            .accounts({
                tariff: pdaTariff,
                from: provider.wallet.publicKey,
                to: user02.key.publicKey
            })
            .rpc()
        // fetch account
        const actualTariff2 = await program.account.tariff.fetch(
            pdaTariff
        );
        // assertions
        assert.ok(actualTariff2.authority.toString() === user02.key.publicKey.toString());
        assert.ok(actualTariff2.tariff.toNumber() === 0);
    });
});
