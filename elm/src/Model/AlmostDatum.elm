module Model.AlmostDatum exposing (AlmostDatum, encode, parser)

import Json.Encode as Encode
import Model.Mint exposing (Mint)
import Model.Wallet exposing (Wallet)
import Url.Parser as UrlParser exposing ((</>))


type alias AlmostDatum =
    { mint : Mint
    , uploader : Wallet
    }


encode : AlmostDatum -> String
encode datum =
    let
        encoder =
            Encode.object
                [ ( "mint", Encode.string datum.mint )
                , ( "uploader", Encode.string datum.uploader )
                ]
    in
    Encode.encode 0 encoder


parser : UrlParser.Parser (AlmostDatum -> c) c
parser =
    UrlParser.map AlmostDatum parser_


parser_ : UrlParser.Parser (Mint -> Wallet -> a) a
parser_ =
    UrlParser.s "uploader" </> UrlParser.string </> UrlParser.string
