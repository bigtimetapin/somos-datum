module View.Generic.Datum exposing (view)

import Html exposing (Html)
import Html.Attributes exposing (class)
import Model.Datum exposing (Datum)
import Msg.Msg exposing (Msg)


view : Datum -> Html Msg
view datum =
    Html.div
        [ class "has-border-2"
        ]
        [ Html.div
            []
            [ Html.text <|
                String.join
                    " "
                    [ "mint address:"
                    , datum.mint
                    ]
            ]
        , Html.div
            []
            [ Html.text <|
                String.join
                    " "
                    [ "uploader address:"
                    , datum.uploader
                    ]
            ]
        , Html.div
            []
            [ Html.text <|
                String.join
                    " "
                    [ "unique increment:"
                    , String.fromInt datum.increment
                    ]
            ]
        ]
