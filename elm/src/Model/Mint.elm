module Model.Mint exposing (Mint, encode)

import Json.Encode as Encode


type alias Mint =
    String


encode : Mint -> String
encode mint =
    let
        encoder =
            Encode.object
                [ ( "mint", Encode.string mint )
                ]
    in
    Encode.encode 0 encoder
