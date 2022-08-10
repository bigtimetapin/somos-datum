module View.Upload.Upload exposing (body)

import Html exposing (Html)
import Html.Attributes exposing (class, id, multiple, placeholder, style, type_)
import Html.Events exposing (onClick, onInput)
import Model.Datum as Datum
import Model.State as State exposing (State(..))
import Model.Uploader as Uploader exposing (Uploader(..))
import Msg.Msg exposing (Msg(..))
import Msg.Uploader as UploaderMsg
import View.Generic.Catalog
import View.Generic.Datum
import View.Generic.Wallet


body : Uploader -> Html Msg
body uploader =
    let
        html =
            case uploader of
                Top ->
                    Html.div
                        [ class "has-border-2"
                        ]
                        [ Html.button
                            [ class "is-button-1"
                            , onClick <| FromUploader UploaderMsg.Connect
                            ]
                            [ Html.text "Connect"
                            ]
                        ]

                HasWallet hasWalletUploader ->
                    case hasWalletUploader of
                        Uploader.LoggedIn wallet ->
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
                                            , onInput <| \s -> FromUploader <| UploaderMsg.TypingMint wallet s
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

                        Uploader.TypingMint wallet string ->
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
                                                        FromUploader <|
                                                            UploaderMsg.SelectMint { mint = string, uploader = wallet }
                                                    , State.href <|
                                                        Upload <|
                                                            Uploader.WaitingForWallet <|
                                                                Uploader.AlmostHasCatalog { mint = string, uploader = wallet }
                                                    ]
                                                    [ Html.div
                                                        [ class "is-button-1"
                                                        ]
                                                        [ Html.text <|
                                                            String.join " " <|
                                                                [ "Proceed with mint:", string ]
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
                                            , placeholder "Mint Address"
                                            , onInput <| \s -> FromUploader <| UploaderMsg.TypingMint wallet s
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

                        Uploader.HasUninitializedCatalog almostCatalog ->
                            Html.div
                                [ class "has-border-2"
                                ]
                                [ View.Generic.Wallet.view almostCatalog.uploader
                                , Html.div
                                    []
                                    [ Html.text <|
                                        String.join " "
                                            [ "This is your first time uploading to mint:"
                                            , almostCatalog.mint
                                            ]
                                    ]
                                , Html.div
                                    []
                                    [ Html.button
                                        [ class "is-button-1"
                                        , style "width" "100%"
                                        , onClick <| FromUploader <| UploaderMsg.InitializeCatalog almostCatalog
                                        ]
                                        [ Html.text "Initialize Catalog"
                                        ]
                                    ]
                                ]

                        Uploader.WaitingForCatalog wallet ->
                            Html.div
                                [ class "has-border-2"
                                ]
                                [ View.Generic.Wallet.view wallet
                                , Html.div
                                    [ class "my-2 is-loading"
                                    ]
                                    []
                                ]

                        Uploader.HasCatalog catalog ->
                            Html.div
                                [ class "has-border-2"
                                ]
                                [ View.Generic.Wallet.view catalog.uploader
                                , Html.form
                                    []
                                    [ Html.input
                                        [ id "gg-sd-zip"
                                        , type_ "file"
                                        , multiple True
                                        ]
                                        []
                                    ]
                                , Html.button
                                    [ class "is-button-1"
                                    , onClick <| FromUploader <| UploaderMsg.Upload <| Datum.fromCatalog catalog
                                    ]
                                    [ Html.text "Upload"
                                    ]
                                , View.Generic.Catalog.view catalog
                                ]

                        Uploader.WaitingForUpload wallet ->
                            Html.div
                                [ class "has-border-2"
                                ]
                                [ View.Generic.Wallet.view wallet
                                , Html.div
                                    [ class "my-2 is-loading"
                                    ]
                                    []
                                ]

                        Uploader.Uploaded datum ->
                            Html.div
                                [ class "has-border-2"
                                ]
                                [ View.Generic.Wallet.view datum.uploader
                                , Html.h2
                                    []
                                    [ Html.text "Successful Upload"
                                    ]
                                , View.Generic.Datum.view datum

                                -- TODO; href to download
                                ]

                WaitingForWallet waitingForWalletUploader ->
                    case waitingForWalletUploader of
                        Uploader.AlmostLoggedIn ->
                            Html.div
                                [ class "has-border-2"
                                ]
                                [ Html.div
                                    [ class "my-2 is-loading"
                                    ]
                                    []
                                ]

                        Uploader.AlmostHasCatalog almostCatalog ->
                            Html.div
                                []
                                [ Html.button
                                    [ class "is-button-1"
                                    , onClick <| FromUploader <| UploaderMsg.ConnectAndGetCatalog almostCatalog
                                    ]
                                    [ Html.text "Connect"
                                    ]
                                , Html.div
                                    []
                                    [ Html.text <|
                                        String.join " " <|
                                            [ "& then proceed to uploading to"
                                            , "mint:"
                                            , almostCatalog.mint
                                            , "as uploader:"
                                            , almostCatalog.uploader
                                            ]
                                    ]
                                ]
    in
    Html.div
        [ class "container"
        ]
        [ html
        ]
