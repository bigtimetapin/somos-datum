module Model.Datum exposing (Datum, encode, parser)

import Json.Encode as Encode
import Model.Mint exposing (Mint)
import Model.Wallet exposing (Wallet)
import Url.Parser as UrlParser exposing ((</>))


type alias Datum =
    { mint : Mint
    , uploader : Wallet
    , increment : Increment
    }


type alias Increment =
    Int


encode : Datum -> String
encode datum =
    let
        encoder =
            Encode.object
                [ ( "mint", Encode.string datum.mint )
                , ( "uploader", Encode.string datum.uploader )
                , ( "increment", Encode.int datum.increment )
                ]
    in
    Encode.encode 0 encoder


parser : UrlParser.Parser (Datum -> c) c
parser =
    UrlParser.map Datum parser_


parser_ : UrlParser.Parser (Mint -> Wallet -> Increment -> a) a
parser_ =
    UrlParser.string </> UrlParser.string </> UrlParser.int
