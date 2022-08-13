module View.Generic.Catalog exposing (view)

import Html exposing (Html)
import Html.Attributes exposing (class)
import Model.Catalog exposing (Catalog)
import Model.Datum exposing (Datum)
import Model.Wallet exposing (Wallet)
import Msg.Msg exposing (Msg(..))
import View.Generic.Datum


view : Wallet -> Catalog -> Html Msg
view wallet catalog =
    let
        uploads : List Int
        uploads =
            case catalog.increment of
                0 ->
                    []

                increment ->
                    List.range 1 increment
    in
    Html.div
        [ class "has-border-2"
        ]
        [ Html.div
            [ class "has-border-2 px-1 py-1 mb-2"
            ]
            [ Html.text <|
                String.join " "
                    [ "uploader address:"
                    , catalog.uploader
                    ]
            ]
        , Html.div
            [ class "has-border-2 px-1 py-1 mb-2"
            ]
            [ Html.text <|
                String.join
                    " "
                    [ "mint address:"
                    , catalog.mint
                    ]
            ]
        , Html.div
            [ class "has-border-2 px-1 py-1 mb-2"
            ]
            [ Html.text <|
                String.join " "
                    [ "total uploads:"
                    , String.fromInt catalog.increment
                    ]
            ]
        , Html.div
            [ class "columns"
            ]
          <|
            List.map
                (\i ->
                    Html.div
                        [ class "column"
                        ]
                        [ View.Generic.Datum.href wallet (toDatum i catalog)
                        ]
                )
                uploads
        ]


toDatum : Int -> Catalog -> Datum
toDatum increment catalog =
    { mint = catalog.mint
    , uploader = catalog.uploader
    , increment = increment
    }
