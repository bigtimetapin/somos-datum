module Model.Catalog exposing (Catalog, decode)

import Json.Decode as Decode
import Model.Mint exposing (Mint)
import Model.Wallet exposing (Wallet)


type alias Catalog =
    { mint: Mint
    , uploader : Wallet
    , increment : Int
    }

type alias Increment = Int


decode : Json -> Result String Catalog
decode json =
    let
        decoder =
            Decode.map3 Catalog
                (Decode.field "mint" Decode.string)
                (Decode.field "uploader" Decode.string)
                (Decode.field "increment" Decode.int)
    in
    case Decode.decodeString decoder json of
        Ok catalog ->
            Ok catalog

        Err error ->
            Err (Decode.errorToString error)


type alias Json =
    String
