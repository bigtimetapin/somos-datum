module Model.Lit exposing (Lit, encode)

import Json.Encode as Encode
import Model.Datum exposing (Datum)
import Model.Mint exposing (Mint)


type alias Lit =
    { mint : Mint
    , method : Method
    , returnValueTest : ReturnValueTest
    }


type alias ReturnValueTest =
    { key : String
    , comparator : String
    , value : String
    }


type Method
    = Collection
    | Token


encode : Datum -> String
encode datum =
    let
        returnValueTestEncoder =
            Encode.object
                [ ( "key", Encode.string <| methodToKey Token )
                , ( "comparator", Encode.string ">" )
                , ( "value", Encode.string "0" )
                ]

        litEncoder =
            Encode.object
                [ ( "mint", Encode.string datum.mint )
                , ( "method", Encode.string <| methodToName Token )
                , ( "returnValueTest", returnValueTestEncoder )
                ]

        encoder =
            Encode.object
                [ ( "uploader", Encode.string datum.uploader )
                , ( "increment", Encode.int datum.increment )
                , ( "lit", litEncoder )
                ]
    in
    Encode.encode 0 encoder


methodToName : Method -> String
methodToName method =
    case method of
        Collection ->
            "balanceOfMetaplexCollection"

        Token ->
            "balanceOfToken"


methodToKey : Method -> String
methodToKey method =
    case method of
        Collection ->
            ""

        Token ->
            "$.amount"
