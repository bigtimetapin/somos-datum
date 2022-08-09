module Model.Datum exposing (Datum, WithWallet, encode, parser, decode, decodeWithWallet)

import Json.Encode as Encode
import Json.Decode as Decode
import Model.Mint exposing (Mint)
import Model.Wallet exposing (Wallet)
import Url.Parser as UrlParser exposing ((</>))


type alias Datum =
    { mint : Mint
    , uploader : Wallet
    , increment : Increment
    }


type alias WithWallet =
    { wallet : Wallet
    , datum : Datum
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


decode : Json -> Result String Datum
decode json =
    case Decode.decodeString decoder_ json of
        Ok catalog ->
            Ok catalog

        Err error ->
            Err (Decode.errorToString error)

decodeWithWallet : Json -> Result String WithWallet
decodeWithWallet json =
    let
        decoder =
            Decode.map2 WithWallet
                (Decode.field "wallet" Decode.string)
                (Decode.field "datum" decoder_)
    in
    case Decode.decodeString decoder json of
        Ok withWallet ->
            Ok withWallet


        Err error ->
            Err (Decode.errorToString error)


decoder_ : Decode.Decoder Datum
decoder_ =
    Decode.map3 Datum
        (Decode.field "mint" Decode.string)
        (Decode.field "uploader" Decode.string)
        (Decode.field "increment" Decode.int)

parser : UrlParser.Parser (Datum -> c) c
parser =
    UrlParser.map Datum parser_


parser_ : UrlParser.Parser (Mint -> Wallet -> Increment -> a) a
parser_ =
    UrlParser.s "download" </> UrlParser.string </> UrlParser.string </> UrlParser.int

type alias Json = String
