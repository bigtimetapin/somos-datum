module Model.Catalog exposing (Catalog, decode, encode)

import Json.Decode as Decode
import Json.Encode as Encode
import Model.Mint exposing (Mint)
import Model.Wallet exposing (Wallet)


type alias Catalog =
    { uploader : Wallet
    , uploads : List Mint
    }


encode : Mint -> Wallet -> Json
encode mint uploader =
    let
        encoder =
            Encode.object
                [ ( "mint", Encode.string mint )
                , ( "uploader", Encode.string uploader )
                ]
    in
    Encode.encode 0 encoder


decode : Json -> Result String Catalog
decode json =
    let
        decoder =
            Decode.map2 Catalog
                (Decode.field "uploader" Decode.string)
                (Decode.field "uploads" (Decode.list Decode.string))
    in
    case Decode.decodeString decoder json of
        Ok catalog ->
            Ok catalog

        Err error ->
            Err (Decode.errorToString error)


type alias Json =
    String
