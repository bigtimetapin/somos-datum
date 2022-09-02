module Model.Lit exposing (Comparator(..), DecidedParameters, Method(..), Parameters, Title(..), Value(..), comparatorToString, defaultParameters, encode)

import Json.Encode as Encode
import Model.AlmostDatum exposing (AlmostDatum)


type alias Parameters =
    { method : Method
    , comparator : Comparator
    , value : Value
    , title : Title
    }


type alias DecidedParameters =
    { method : Method
    , comparator : Comparator
    , value : Int
    , title : String
    }


type Method
    = Collection
    | Token


type Comparator
    = GreaterThan
    | GreaterThanOrEqualTo


type Value
    = DecidingValue String
    | InvalidInt String
    | DecidedValue Int


type Title
    = DecidingTitle String
    | DecidedTitle String


defaultParameters : Parameters
defaultParameters =
    { method = Token
    , comparator = GreaterThan
    , value = DecidedValue 0
    , title = DecidedTitle "untitled"
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
                , ( "title", Encode.string decided.title )
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
