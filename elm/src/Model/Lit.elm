module Model.Lit exposing (Comparator(..), DecidedParameters, Method(..), Parameters, Value(..), comparatorToString, defaultParameters, encode)

import Json.Encode as Encode
import Model.AlmostDatum exposing (AlmostDatum)


type alias Parameters =
    { method : Method
    , comparator : Comparator
    , value : Value
    }


type alias DecidedParameters =
    { method : Method
    , comparator : Comparator
    , value : Int
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


encode : AlmostDatum -> DecidedParameters -> String
encode almostDatum decided =
    let
        returnValueTestEncoder =
            Encode.object
                [ ( "key", Encode.string <| methodToKey decided.method )
                , ( "comparator", Encode.string <| comparatorToString decided.comparator )
                , ( "value", Encode.string <| String.fromInt decided.value )
                ]

        litEncoder =
            Encode.object
                [ ( "mint", Encode.string almostDatum.mint )
                , ( "method", Encode.string <| methodToName decided.method )
                , ( "returnValueTest", returnValueTestEncoder )
                ]

        encoder =
            Encode.object
                [ ( "uploader", Encode.string almostDatum.uploader )
                , ( "increment", Encode.int almostDatum.increment )
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
