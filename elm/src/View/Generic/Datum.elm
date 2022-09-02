module View.Generic.Datum exposing (href, view)

import Html exposing (Html)
import Html.Attributes exposing (class, target)
import Html.Events exposing (onClick)
import Model.AlmostDatum as AlmostDatum exposing (AlmostDatum)
import Model.Datum exposing (Datum)
import Model.Downloader as Downloader
import Model.State as State exposing (State(..))
import Model.Wallet exposing (Wallet)
import Msg.Downloader as DownloaderMsg
import Msg.Msg exposing (Msg(..))


view : Wallet -> Datum -> Html Msg
view wallet datum =
    Html.div
        []
        [ Html.div
            [ class "has-border-2 px-1 py-1 my-2"
            ]
            [ Html.text "mint: "
            , Html.a
                [ class "has-sky-blue-text"
                , Html.Attributes.href <|
                    String.concat
                        [ "https://solscan.io/token/"
                        , datum.mint
                        ]
                , target "_blank"
                ]
                [ Html.text datum.mint
                ]
            ]
        , Html.div
            [ class "has-border-2 px-1 py-1 my-2"
            ]
            [ Html.text "uploader: "
            , Html.a
                [ class "has-sky-blue-text"
                , Html.Attributes.href <|
                    String.concat
                        [ "https://solscan.io/account/"
                        , datum.uploader
                        ]
                , target "_blank"
                ]
                [ Html.text datum.uploader
                ]
            ]
        , Html.div
            [ class "has-border-2 px-1 py-1 my-2"
            ]
            [ Html.div
                [ class "mb-2"
                ]
                [ Html.text "follow link to view in download console ⬇️"
                ]
            , href wallet <| AlmostDatum.fromDatum datum
            ]
        ]


href : Wallet -> AlmostDatum -> Html Msg
href wallet almostDatum =
    Html.a
        [ onClick <|
            FromDownloader <|
                DownloaderMsg.SelectIncrement wallet almostDatum
        , State.href <|
            Download <|
                Downloader.WaitingForWallet <|
                    Downloader.AlmostHasDatum almostDatum
        ]
        [ Html.div
            [ class "is-button-1"
            ]
            [ Html.text <| String.fromInt almostDatum.increment
            ]
        ]
