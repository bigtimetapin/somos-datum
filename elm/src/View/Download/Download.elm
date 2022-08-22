module View.Download.Download exposing (body)

import Html exposing (Html)
import Html.Attributes exposing (class, href, placeholder, style, target, type_)
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
                        [ class "has-border-2 px-2 pt-2 pb-6"
                        ]
                        [ Html.button
                            [ class "is-button-1 mr-2 mt-2"
                            , onClick <| FromDownloader <| DownloaderMsg.Connect
                            , style "float" "right"
                            ]
                            [ Html.text "Connect"
                            ]
                        , header
                        , Html.button
                            [ class "is-button-1"
                            , onClick <| FromDownloader <| DownloaderMsg.Connect
                            ]
                            [ Html.text "Connect"
                            ]
                        , Html.text
                            """ to download
                            """
                        , Html.a
                            [ class "has-sky-blue-text"
                            , href "https://litprotocol.com/"
                            , target "_blank"
                            ]
                            [ Html.text "token-gated"
                            ]
                        , Html.text "-"
                        , Html.a
                            [ class "has-sky-blue-text"
                            , href "https://shdw.genesysgo.com/shadow-infrastructure-overview/shadow-drive-overview"
                            , target "_blank"
                            ]
                            [ Html.text "decentralized"
                            ]
                        , Html.text
                            """ data from your
                            """
                        , Html.a
                            [ class "has-sky-blue-text"
                            , href "https://spl.solana.com/token"
                            , target "_blank"
                            ]
                            [ Html.text "spl-token"
                            ]
                        , Html.text
                            """ community. 😎
                            """
                        ]

                Downloader.HasWallet hasWalletDownloader ->
                    case hasWalletDownloader of
                        Downloader.LoggedIn wallet ->
                            Html.div
                                [ class "has-border-2 px-2 pt-2 pb-6"
                                ]
                                [ View.Generic.Wallet.view wallet
                                , header
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
                                [ class "has-border-2 px-2 pt-2 pb-6"
                                ]
                                [ View.Generic.Wallet.view wallet
                                , header
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
                                [ class "has-border-2 px-2 pt-2 pb-6"
                                ]
                                [ View.Generic.Wallet.view wallet
                                , header
                                , Html.div
                                    [ class "has-border-2 px-1 py-1 mb-2"
                                    ]
                                    [ Html.text "mint selected: "
                                    , Html.a
                                        [ class "has-sky-blue-text"
                                        , href <|
                                            String.concat
                                                [ "https://solscan.io/token/"
                                                , mint
                                                ]
                                        , target "_blank"
                                        ]
                                        [ Html.text mint
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
                                [ class "has-border-2 px-2 pt-2 pb-6"
                                ]
                                [ View.Generic.Wallet.view wallet
                                , header
                                , Html.div
                                    [ class "has-border-2 px-1 py-1 mb-2"
                                    ]
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
                                    , select
                                    ]
                                ]

                        Downloader.WaitingForCatalog wallet ->
                            Html.div
                                [ class "has-border-2 px-2 pt-2 pb-6"
                                ]
                                [ View.Generic.Wallet.view wallet
                                , header
                                , Html.div
                                    [ class "my-2 is-loading"
                                    ]
                                    []
                                ]

                        Downloader.HasCatalog wallet catalog ->
                            Html.div
                                [ class "has-border-2 px-2 pt-2 pb-6"
                                ]
                                [ View.Generic.Wallet.view wallet
                                , header
                                , View.Generic.Catalog.view wallet catalog
                                ]

                        Downloader.WaitingForDatum wallet ->
                            Html.div
                                [ class "has-border-2 px-2 pt-2 pb-6"
                                ]
                                [ View.Generic.Wallet.view wallet
                                , header
                                , Html.div
                                    [ class "my-2 is-loading"
                                    ]
                                    []
                                ]

                        Downloader.HasDatum wallet datum ->
                            Html.div
                                [ class "has-border-2 px-2 pt-2 pb-6"
                                ]
                                [ View.Generic.Wallet.view wallet
                                , header
                                , Html.div
                                    []
                                    [ Html.button
                                        [ class "is-button-2"
                                        , style "width" "100%"
                                        , onClick <| FromDownloader <| DownloaderMsg.Download wallet datum
                                        ]
                                        [ Html.text <|
                                            String.join " "
                                                [ "download"
                                                ]
                                        ]
                                    ]
                                , Html.div
                                    [ class "has-border-2 px-1 py-1 mb-2 mt-2"
                                    ]
                                    [ Html.text "mint: "
                                    , Html.a
                                        [ class "has-sky-blue-text"
                                        , href <|
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
                                    [ class "has-border-2 px-1 py-1 mb-2"
                                    ]
                                    [ Html.text "uploader: "
                                    , Html.a
                                        [ class "has-sky-blue-text"
                                        , href <|
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
                                    [ class "has-border-2 px-1 py-1 mb-2"
                                    ]
                                    [ Html.text <|
                                        String.join " "
                                            [ "with unique asset id:"
                                            , String.fromInt datum.increment
                                            ]
                                    ]
                                ]

                        Downloader.WaitingForDownload wallet ->
                            Html.div
                                [ class "has-border-2 px-2 pt-2 pb-6"
                                ]
                                [ View.Generic.Wallet.view wallet
                                , header
                                , Html.div
                                    [ class "my-2 is-loading"
                                    ]
                                    []
                                ]

                        Downloader.Downloaded wallet _ ->
                            Html.div
                                [ class "has-border-2 px-2 pt-2 pb-6"
                                ]
                                [ View.Generic.Wallet.view wallet
                                , header
                                , Html.div
                                    []
                                    [ Html.text
                                        """Download Successful 😎
                                        """
                                    ]
                                ]

                Downloader.WaitingForWallet waitingForWalletDownloader ->
                    case waitingForWalletDownloader of
                        Downloader.AlmostLoggedIn ->
                            Html.div
                                [ class "has-border-2 px-2 pt-2 pb-6"
                                ]
                                [ header
                                , Html.div
                                    [ class "my-2 is-loading"
                                    ]
                                    []
                                ]

                        Downloader.AlmostHasCatalog almostCatalog ->
                            Html.div
                                [ class "has-border-2 px-2 pt-2 pb-6"
                                ]
                                [ Html.button
                                    [ class "is-button-1 mr-2 mt-2"
                                    , onClick <| FromDownloader <| DownloaderMsg.ConnectAndGetCatalog almostCatalog
                                    , style "float" "right"
                                    ]
                                    [ Html.text "Connect"
                                    ]
                                , header
                                , Html.button
                                    [ class "is-button-1"
                                    , onClick <| FromDownloader <| DownloaderMsg.ConnectAndGetCatalog almostCatalog
                                    ]
                                    [ Html.text "Connect"
                                    ]
                                , Html.text
                                    """ to download
                                    """
                                , Html.a
                                    [ class "has-sky-blue-text"
                                    , href "https://litprotocol.com/"
                                    , target "_blank"
                                    ]
                                    [ Html.text "token-gated"
                                    ]
                                , Html.text "-"
                                , Html.a
                                    [ class "has-sky-blue-text"
                                    , href "https://shdw.genesysgo.com/shadow-infrastructure-overview/shadow-drive-overview"
                                    , target "_blank"
                                    ]
                                    [ Html.text "decentralized"
                                    ]
                                , Html.text
                                    """ data associated with ⬇️
                                        """
                                , Html.div
                                    [ class "has-border-2 px-1 py-1 mb-2 mt-2"
                                    ]
                                    [ Html.text "mint: "
                                    , Html.a
                                        [ class "has-sky-blue-text"
                                        , href <|
                                            String.concat
                                                [ "https://solscan.io/token/"
                                                , almostCatalog.mint
                                                ]
                                        , target "_blank"
                                        ]
                                        [ Html.text almostCatalog.mint
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
                                                , almostCatalog.uploader
                                                ]
                                        , target "_blank"
                                        ]
                                        [ Html.text almostCatalog.uploader
                                        ]
                                    ]
                                ]

                        Downloader.AlmostHasDatum datum ->
                            Html.div
                                [ class "has-border-2 px-2 pt-2 pb-6"
                                ]
                                [ Html.button
                                    [ class "is-button-1 mr-2 mt-2"
                                    , onClick <| FromDownloader <| DownloaderMsg.ConnectAndGetDatum datum
                                    , style "float" "right"
                                    ]
                                    [ Html.text "Connect"
                                    ]
                                , header
                                , Html.button
                                    [ class "is-button-1"
                                    , onClick <| FromDownloader <| DownloaderMsg.ConnectAndGetDatum datum
                                    ]
                                    [ Html.text "Connect"
                                    ]
                                , Html.text
                                    """ to download
                                    """
                                , Html.a
                                    [ class "has-sky-blue-text"
                                    , href "https://litprotocol.com/"
                                    , target "_blank"
                                    ]
                                    [ Html.text "token-gated"
                                    ]
                                , Html.text "-"
                                , Html.a
                                    [ class "has-sky-blue-text"
                                    , href "https://shdw.genesysgo.com/shadow-infrastructure-overview/shadow-drive-overview"
                                    , target "_blank"
                                    ]
                                    [ Html.text "decentralized"
                                    ]
                                , Html.text
                                    """ data associated with ⬇️
                                        """
                                , Html.div
                                    [ class "has-border-2 px-1 py-1 mb-2 mt-2"
                                    ]
                                    [ Html.text "mint: "
                                    , Html.a
                                        [ class "has-sky-blue-text"
                                        , href <|
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
                                    [ class "has-border-2 px-1 py-1 mb-2"
                                    ]
                                    [ Html.text "uploader: "
                                    , Html.a
                                        [ class "has-sky-blue-text"
                                        , href <|
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
                                    [ class "has-border-2 px-1 py-1 mb-2"
                                    ]
                                    [ Html.text <|
                                        String.join " "
                                            [ "with unique asset id:"
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


header : Html Msg
header =
    Html.div
        [ class "is-family-secondary mt-2 mb-5"
        ]
        [ Html.h2
            []
            [ Html.text "Download Console"
            ]
        ]
