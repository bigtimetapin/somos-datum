module View.Generic.Catalog exposing (view)

import Html exposing (Html)
import Html.Attributes exposing (class)
import Model.Catalog exposing (Catalog)
import Msg.Msg exposing (Msg)
import View.Generic.Mint



-- TODO; map thru increment with href


view : Catalog -> Html Msg
view catalog =
    Html.div
        [ class "has-border-2"
        ]
        [ Html.div
            []
            [ Html.text <|
                String.join " "
                    [ "uploader address:"
                    , catalog.uploader
                    ]
            ]
        , Html.div
            []
            (List.map
                View.Generic.Mint.view
                [ catalog.mint ]
            )
        ]