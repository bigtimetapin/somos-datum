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
    Encode.encode 0 <| encoder_ almostCatalog


encoder_ : AlmostCatalog -> Encode.Value
encoder_ almostCatalog =
    Encode.object
        [ ( "mint", Encode.string almostCatalog.mint )
        , ( "uploader", Encode.string almostCatalog.uploader )
        ]


parser : String -> UrlParser.Parser (AlmostCatalog -> c) c
parser sub =
    UrlParser.map AlmostCatalog <| parser_ sub


parser_ : String -> UrlParser.Parser (Mint -> Wallet -> a) a
parser_ sub =
    UrlParser.s sub </> UrlParser.string </> UrlParser.string
