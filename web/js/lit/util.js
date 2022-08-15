import {chain} from "./config";

export function solRpcConditions(mint) {
    return [
        {
            method: "balanceOfToken",
            params: [mint],
            pdaParams: [],
            pdaInterface: { offset: 0, fields: {} },
            pdaKey: "",
            chain,
            returnValueTest: {
                key: "$.amount",
                comparator: ">",
                value: "0",
            },
        },
    ]
}
