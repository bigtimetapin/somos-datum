module Model.AlmostCatalog exposing (AlmostCatalog, decode, encode, parser)

import Json.Decode as Decode
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


decode : Json -> Result String AlmostCatalog
decode json =
    case Decode.decodeString decoder_ json of
        Ok catalog ->
            Ok catalog

        Err error ->
            Err (Decode.errorToString error)


decoder_ : Decode.Decoder AlmostCatalog
decoder_ =
    Decode.map2 AlmostCatalog
        (Decode.field "mint" Decode.string)
        (Decode.field "uploader" Decode.string)


parser : String -> UrlParser.Parser (AlmostCatalog -> c) c
parser sub =
    UrlParser.map AlmostCatalog <| parser_ sub


parser_ : String -> UrlParser.Parser (Mint -> Wallet -> a) a
parser_ sub =
    UrlParser.s sub </> UrlParser.string </> UrlParser.string


type alias Json =
    String
