module Model.Datum exposing (Datum, WithWallet, decode, decodeWithWallet, titleToString)

import Json.Decode as Decode
import Model.Mint exposing (Mint)
import Model.Wallet exposing (Wallet)


type alias Datum =
    { mint : Mint
    , uploader : Wallet
    , increment : Increment
    , title : Maybe String
    }


type alias WithWallet =
    { wallet : Wallet
    , datum : Datum
    }


type alias Increment =
    Int


titleToString : Maybe String -> String
titleToString maybeTitle =
    case maybeTitle of
        Just title ->
            title

        Nothing ->
            "untitled"


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
    Decode.map4 Datum
        (Decode.field "mint" Decode.string)
        (Decode.field "uploader" Decode.string)
        (Decode.field "increment" Decode.int)
        (Decode.field "title" <| Decode.maybe Decode.string)


type alias Json =
    String
