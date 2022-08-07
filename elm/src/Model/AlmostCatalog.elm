module Model.AlmostCatalog exposing (AlmostCatalog, encode, parser)

import Json.Encode as Encode
import Model.Mint exposing (Mint)
import Model.Wallet exposing (Wallet)
import Url.Parser as UrlParser exposing ((</>))


type alias AlmostCatalog =
    { mint : Mint
    , uploader : Wallet
    }


encode : AlmostCatalog -> String
encode almostCatalog =
    let
        encoder =
            Encode.object
                [ ( "mint", Encode.string almostCatalog.mint )
                , ( "uploader", Encode.string almostCatalog.uploader )
                ]
    in
    Encode.encode 0 encoder


parser : UrlParser.Parser (AlmostCatalog -> c) c
parser =
    UrlParser.map AlmostCatalog parser_


parser_ : UrlParser.Parser (Mint -> Wallet -> a) a
parser_ =
    UrlParser.string </> UrlParser.string
