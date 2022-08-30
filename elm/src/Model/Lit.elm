module Model.Lit exposing (Comparator(..), Method(..), Parameters, Value(..), defaultParameters, encode)

import Json.Encode as Encode
import Model.Datum exposing (Datum)
import Model.Mint exposing (Mint)

-- todo
type alias Lit =
    { mint : Mint
    , method : String
    , returnValueTest : ReturnValueTest
    }

-- todo
type alias ReturnValueTest =
    { key : String
    , comparator : String
    , value : String
    }


type alias Parameters =
    { method : Method
    , comparator : Comparator
    , value : Value
    }


type Method
    = Collection
    | Token


type Comparator
    = GreaterThan
    | GreaterThanOrEqualTo


type Value
    = Deciding String
    | InvalidInt String
    | Decided Int


defaultParameters : Parameters
defaultParameters =
    { method = Token
    , comparator = GreaterThan
    , value = Decided 0
    }


encode : Datum -> String
encode datum =
    let
        returnValueTestEncoder =
            Encode.object
                [ ( "key", Encode.string <| methodToKey Token )
                , ( "comparator", Encode.string <| comparatorToString GreaterThan )
                , ( "value", Encode.string <| String.fromInt 0 )
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


comparatorToString : Comparator -> String
comparatorToString comparator =
    case comparator of
        GreaterThan ->
            ">"

        GreaterThanOrEqualTo ->
            ">="


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
