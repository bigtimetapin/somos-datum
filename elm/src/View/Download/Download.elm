module View.Download.Download exposing (body)

import Html exposing (Html)
import Html.Attributes exposing (class, placeholder, style, type_)
import Html.Events exposing (onClick, onInput)
import Model.Downloader as Downloader exposing (Downloader)
import Model.State as State exposing (State(..))
import Msg.Downloader as DownloaderMsg
import Msg.Msg exposing (Msg(..))
import View.Generic.Catalog
import View.Generic.Wallet


body : Downloader -> Html Msg
body downloader =
    let
        html =
            case downloader of
                Downloader.Top ->
                    Html.div
                        [ class "has-border-2"
                        ]
                        [ Html.button
                            [ class "is-button-1"
                            , onClick <| FromDownloader DownloaderMsg.Connect
                            ]
                            [ Html.text "Connect"
                            ]
                        ]

                Downloader.HasWallet hasWalletDownloader ->
                    case hasWalletDownloader of
                        Downloader.LoggedIn wallet ->
                            Html.div
                                [ class "has-border-2"
                                ]
                                [ View.Generic.Wallet.view wallet
                                , Html.h2
                                    [ class "px-2 py-2"
                                    ]
                                    [ Html.text "Download Console"
                                    ]
                                , Html.div
                                    [ class "field"
                                    ]
                                    [ Html.p
                                        [ class "control has-icons-left"
                                        ]
                                        [ Html.input
                                            [ class "input"
                                            , type_ "text"
                                            , placeholder "Mint Address"
                                            , onInput <| \s -> FromDownloader <| DownloaderMsg.TypingMint wallet s
                                            ]
                                            []
                                        , Html.span
                                            [ class "icon is-left"
                                            ]
                                            [ Html.i
                                                [ class "fas fa-coins"
                                                ]
                                                []
                                            ]
                                        ]
                                    ]
                                ]

                        Downloader.TypingMint wallet string ->
                            let
                                select =
                                    case string of
                                        "" ->
                                            Html.div
                                                []
                                                []

                                        _ ->
                                            Html.div
                                                []
                                                [ Html.button
                                                    [ class "is-button-1"
                                                    , style "width" "100%"
                                                    , onClick <|
                                                        FromDownloader <|
                                                            DownloaderMsg.SelectMint wallet string
                                                    ]
                                                    [ Html.text <|
                                                        String.join " " <|
                                                            [ "Proceed with mint:", string ]
                                                    ]
                                                ]
                            in
                            Html.div
                                [ class "has-border-2"
                                ]
                                [ View.Generic.Wallet.view wallet
                                , Html.div
                                    [ class "field"
                                    ]
                                    [ Html.p
                                        [ class "control has-icons-left"
                                        ]
                                        [ Html.input
                                            [ class "input"
                                            , type_ "text"
                                            , placeholder "Mint Address"
                                            , onInput <| \s -> FromDownloader <| DownloaderMsg.TypingMint wallet s
                                            ]
                                            []
                                        , Html.span
                                            [ class "icon is-left"
                                            ]
                                            [ Html.i
                                                [ class "fas fa-coins"
                                                ]
                                                []
                                            ]
                                        ]
                                    , select
                                    ]
                                ]

                        Downloader.HasMint wallet mint ->
                            Html.div
                                [ class "has-border-2"
                                ]
                                [ View.Generic.Wallet.view wallet
                                , Html.div
                                    []
                                    [ Html.text <|
                                        String.join " "
                                            [ "mint selected:"
                                            , mint
                                            ]
                                    ]
                                , Html.div
                                    [ class "field"
                                    ]
                                    [ Html.p
                                        [ class "control has-icons-left"
                                        ]
                                        [ Html.input
                                            [ class "input"
                                            , type_ "text"
                                            , placeholder "Uploader Address"
                                            , onInput <|
                                                \s ->
                                                    FromDownloader <|
                                                        DownloaderMsg.TypingUploaderAddress wallet mint s
                                            ]
                                            []
                                        , Html.span
                                            [ class "icon is-left"
                                            ]
                                            [ Html.i
                                                [ class "fas fa-at"
                                                ]
                                                []
                                            ]
                                        ]
                                    ]
                                ]

                        Downloader.TypingUploaderAddress wallet mint string ->
                            let
                                select =
                                    case string of
                                        "" ->
                                            Html.div
                                                []
                                                []

                                        _ ->
                                            Html.div
                                                []
                                                [ Html.a
                                                    [ onClick <|
                                                        FromDownloader <|
                                                            DownloaderMsg.SelectUploaderAddress wallet mint string
                                                    , State.href <|
                                                        Download <|
                                                            Downloader.WaitingForWallet <|
                                                                Downloader.AlmostHasCatalog
                                                                    { mint = mint, uploader = string }
                                                    ]
                                                    [ Html.div
                                                        [ class "is-button-1"
                                                        ]
                                                        [ Html.text <|
                                                            String.join " " <|
                                                                [ "Proceed with uploader address:", string ]
                                                        ]
                                                    ]
                                                ]
                            in
                            Html.div
                                [ class "has-border-2"
                                ]
                                [ View.Generic.Wallet.view wallet
                                , Html.div
                                    [ class "field"
                                    ]
                                    [ Html.p
                                        [ class "control has-icons-left"
                                        ]
                                        [ Html.input
                                            [ class "input"
                                            , type_ "text"
                                            , placeholder "Uploader Address"
                                            , onInput <|
                                                \s ->
                                                    FromDownloader <|
                                                        DownloaderMsg.TypingUploaderAddress wallet mint s
                                            ]
                                            []
                                        , Html.span
                                            [ class "icon is-left"
                                            ]
                                            [ Html.i
                                                [ class "fas fa-at"
                                                ]
                                                []
                                            ]
                                        ]
                                    , select
                                    ]
                                ]

                        Downloader.WaitingForCatalog wallet ->
                            Html.div
                                [ class "has-border-2"
                                ]
                                [ View.Generic.Wallet.view wallet
                                , Html.div
                                    [ class "my-2 is-loading"
                                    ]
                                    []
                                ]

                        Downloader.HasCatalog wallet catalog ->
                            Html.div
                                [ class "has-border-2"
                                ]
                                [ View.Generic.Wallet.view wallet
                                , View.Generic.Catalog.view wallet catalog
                                ]

                        Downloader.WaitingForDatum wallet ->
                            Html.div
                                [ class "has-border-2"
                                ]
                                [ View.Generic.Wallet.view wallet
                                , Html.div
                                    [ class "my-2 is-loading"
                                    ]
                                    []
                                ]

                        Downloader.HasDatum wallet datum ->
                            Html.div
                                [ class "has-border-2"
                                ]
                                [ View.Generic.Wallet.view wallet
                                , Html.div
                                    []
                                    [ Html.text <|
                                        String.join " "
                                            [ "download:"
                                            , String.fromInt datum.increment
                                            ]
                                    ]
                                ]

                        Downloader.WaitingForDownload wallet ->
                            Html.div
                                []
                                []

                        Downloader.Downloaded wallet datum ->
                            Html.div
                                []
                                []

                Downloader.WaitingForWallet waitingForWalletDownloader ->
                    case waitingForWalletDownloader of
                        Downloader.AlmostLoggedIn ->
                            Html.div
                                [ class "has-border-2"
                                ]
                                [ Html.div
                                    [ class "my-2 is-loading"
                                    ]
                                    []
                                ]

                        Downloader.AlmostHasCatalog almostCatalog ->
                            Html.div
                                []
                                [ Html.button
                                    [ class "is-button-1"
                                    , onClick <| FromDownloader <| DownloaderMsg.ConnectAndGetCatalog almostCatalog
                                    ]
                                    [ Html.text "Connect"
                                    ]
                                , Html.div
                                    []
                                    [ Html.text <|
                                        String.join " " <|
                                            [ "& then proceed to downloading with"
                                            , "mint:"
                                            , almostCatalog.mint
                                            , "from uploader:"
                                            , almostCatalog.uploader
                                            ]
                                    ]
                                ]

                        Downloader.AlmostHasDatum datum ->
                            Html.div
                                []
                                [ Html.button
                                    [ class "is-button-1"
                                    , onClick <| FromDownloader <| DownloaderMsg.ConnectAndGetDatum datum
                                    ]
                                    [ Html.text "Connect"
                                    ]
                                , Html.div
                                    []
                                    [ Html.text
                                        """& then proceed with downloading with
                                        """
                                    ]
                                , Html.div
                                    []
                                    [ Html.text <|
                                        String.join " "
                                            [ "mint:"
                                            , datum.mint
                                            ]
                                    ]
                                , Html.div
                                    []
                                    [ Html.text <|
                                        String.join " "
                                            [ "uploader:"
                                            , datum.uploader
                                            ]
                                    ]
                                , Html.div
                                    []
                                    [ Html.text <|
                                        String.join " "
                                            [ "downloadable asset id:"
                                            , String.fromInt datum.increment
                                            ]
                                    ]
                                ]
    in
    Html.div
        [ class "container"
        ]
        [ html
        ]
