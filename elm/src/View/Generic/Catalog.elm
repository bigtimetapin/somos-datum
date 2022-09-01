module View.Generic.Catalog exposing (view)

import Html exposing (Html)
import Html.Attributes exposing (class, href, target)
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
        [ class "mt-6"
        ]
        [ Html.div
            [ class "has-border-2 px-1 py-1 mb-2"
            ]
            [ Html.text "mint: "
            , Html.a
                [ class "has-sky-blue-text"
                , href <|
                    String.concat
                        [ "https://solscan.io/token/"
                        , catalog.mint
                        ]
                , target "_blank"
                ]
                [ Html.text catalog.mint
                ]
            ]
        , Html.div
            [ class "has-border-2 px-1 py-1 mb-2"
            ]
            [ Html.text "uploader: "
            , Html.a
                [ class "has-sky-blue-text"
                , href <|
                    String.concat
                        [ "https://solscan.io/account/"
                        , catalog.uploader
                        ]
                , target "_blank"
                ]
                [ Html.text catalog.uploader
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
            [ class "columns is-multiline"
            ]
          <|
            List.map
                (\i ->
                    Html.div
                        [ class "column is-2"
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
