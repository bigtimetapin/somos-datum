import {decrypt, downloadZip} from "../lit/decrypt";
import {derivePda, fetchPda, getDatum} from "./state/datum";

export async function download(provider, program, json) {
    try {
        // derive pda datum
        const pdaDatum = await derivePda(json, program);
        // fetch pda datum
        const datum = await fetchPda(pdaDatum, program);
        // decrypt
        let zip;
        try {
            zip = await decrypt(datum)
        } catch (error) {
            const response = await getDatum(provider, program, json);
            app.ports.unauthorized.send(
                response
            )
            return null;
        }
        // download
        downloadZip(zip);
        // build response
        const response = await getDatum(provider, program, json);
        // send success to elm
        app.ports.downloadSuccess.send(
            response
        );
        // or catch error
    } catch (error) {
        console.log(error);
        app.ports.genericError.send(error.toString());
    }
}