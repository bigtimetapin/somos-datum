import {chain} from "./config";

export function solRpcConditions(mint) {
    return [
        {
            method: "balanceOfToken",
            params: [mint],
            chain,
            returnValueTest: {
                key: "$.amount",
                comparator: ">",
                value: "0",
            },
        },
    ]
}
