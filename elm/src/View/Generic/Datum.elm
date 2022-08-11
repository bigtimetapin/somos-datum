module View.Generic.Datum exposing (href, view)

import Html exposing (Html)
import Html.Attributes exposing (class)
import Html.Events exposing (onClick)
import Model.Datum exposing (Datum)
import Model.Downloader as Downloader
import Model.State as State exposing (State(..))
import Model.Wallet exposing (Wallet)
import Msg.Downloader as DownloaderMsg
import Msg.Msg exposing (Msg(..))


view : Wallet -> Datum -> Html Msg
view wallet datum =
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
            [ href wallet datum
            ]
        ]


href : Wallet -> Datum -> Html Msg
href wallet datum =
    Html.a
        [ onClick <|
            FromDownloader <|
                DownloaderMsg.SelectIncrement wallet datum
        , State.href <|
            Download <|
                Downloader.WaitingForWallet <|
                    Downloader.AlmostHasDatum datum
        ]
        [ Html.div
            [ class "is-button-1"
            ]
            [ Html.text <| String.fromInt datum.increment
            ]
        ]
