module Model.Catalog exposing (Catalog, WithWallet, decode, decodeWithWallet)

import Json.Decode as Decode
import Model.Mint exposing (Mint)
import Model.Wallet exposing (Wallet)


type alias Catalog =
    { mint : Mint
    , uploader : Wallet
    , increment : Int
    }


type alias WithWallet =
    { wallet : Wallet
    , catalog : Catalog
    }


type alias Increment =
    Int


decode : Json -> Result String Catalog
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
                (Decode.field "catalog" decoder_)
    in
    case Decode.decodeString decoder json of
        Ok catalog ->
            Ok catalog

        Err error ->
            Err (Decode.errorToString error)


decoder_ : Decode.Decoder Catalog
decoder_ =
    Decode.map3 Catalog
        (Decode.field "mint" Decode.string)
        (Decode.field "uploader" Decode.string)
        (Decode.field "increment" Decode.int)


type alias Json =
    String
