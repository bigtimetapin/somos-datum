module Model.Role exposing (Role(..), decode, encode, encode0)

import Json.Decode as Decode
import Json.Encode as Encode

-- TODO; delete?
type Role
    = Uploader
    | Downloader


type alias WithMore =
    { role : Role
    , more : Json
    }


encode : Role -> Json -> Json
encode role more =
    let
        encoder =
            Encode.object
                [ ( "role", Encode.string <| toString role )
                , ( "more", Encode.string more )
                ]
    in
    Encode.encode 0 encoder


encode0 : Role -> Json
encode0 role =
    let
        encoder =
            Encode.object
                [ ( "role", Encode.string <| toString role )
                ]
    in
    Encode.encode 0 encoder


decode : String -> Result String WithMore
decode string =
    let
        decoder : Decode.Decoder (Maybe Role)
        decoder =
            Decode.field "role" <| Decode.map fromString Decode.string
    in
    case Decode.decodeString decoder string of
        Ok maybeRole ->
            case maybeRole of
                Just role ->
                    case Decode.decodeString (Decode.field "more" Decode.string) string of
                        Ok more ->
                            Ok { role = role, more = more }

                        Err error ->
                            Err <| Decode.errorToString error

                Nothing ->
                    Err <| String.join " " [ "Could not decode Role in JSON:", string ]

        Err error ->
            Err <| Decode.errorToString error


toString : Role -> String
toString role =
    case role of
        Uploader ->
            "uploader"

        Downloader ->
            "downloader"


fromString : String -> Maybe Role
fromString string =
    case string of
        "uploader" ->
            Just Uploader

        "downloader" ->
            Just Downloader

        _ ->
            Nothing


type alias Json =
    String
