module View.Generic.Wallet exposing (view)

import Html exposing (Html)
import Html.Attributes exposing (class, style)
import Model.Wallet as Wallet exposing (Wallet)
import Msg.Msg exposing (Msg)


view : Wallet -> Html Msg
view wallet =
    Html.div
        [ class "has-border-2 px-2 py-2"
        , style "float" "right"
        ]
        [ Html.text (Wallet.slice wallet)
        ]
