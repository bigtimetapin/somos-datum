import {chain} from "./config";

export function solRpcConditions(args) {
    return [
        {
            method: args.method,
            params: [args.mint],
            pdaParams: [],
            pdaInterface: {offset: 0, fields: {}},
            pdaKey: "",
            chain,
            returnValueTest: {
                key: args.returnValueTest.key, // "$.amount"
                comparator: args.returnValueTest.comparator, // ">"
                value: args.returnValueTest.value, // "0"
            },
        },
    ]
}
