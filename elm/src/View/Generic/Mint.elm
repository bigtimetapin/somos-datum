module View.Generic.Mint exposing (view)

import Html exposing (Html)
import Html.Attributes exposing (class)
import Model.Mint exposing (Mint)
import Msg.Msg exposing (Msg)


view : Mint -> Html Msg
view mint =
    Html.div
        [ class "has-border-2"
        ]
        [ Html.text <|
            String.join
                " "
                [ "mint address:"
                , mint
                ]
        ]
