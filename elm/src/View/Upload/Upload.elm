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
                        [ header
                        , Html.button
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
                                                                Uploader.AlmostHasCatalog
                                                                    { mint = string, uploader = wallet }
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
                                , header
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
                                , header
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
                                , header
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
                                    [ class "is-button-1 mb-2"
                                    , onClick <| FromUploader <| UploaderMsg.Upload <| Datum.fromCatalog catalog
                                    ]
                                    [ Html.text "Upload"
                                    ]
                                , View.Generic.Catalog.view catalog.uploader catalog
                                ]

                        Uploader.WaitingForUpload uploading ->
                            case uploading of
                                Uploader.WaitingForEncryption wallet ->
                                    Html.div
                                        [ class "pl-2 has-border-2"
                                        ]
                                        [ View.Generic.Wallet.view wallet
                                        , header
                                        , Html.div
                                            []
                                            [ Html.text
                                                """Encrypting Files
                                                """
                                            , Html.div
                                                [ class "mr-1 is-loading-tiny"
                                                , style "float" "left"
                                                ]
                                                []
                                            ]
                                        , Html.div
                                            []
                                            [ Html.text
                                                """Creating Shdw Storage Account
                                                """
                                            , Html.div
                                                [ class "mr-1 is-loading-tiny"
                                                , style "float" "left"
                                                ]
                                                []
                                            ]
                                        , Html.div
                                            []
                                            [ Html.text
                                                """Marking Shdw Storage Account as Immutable
                                                """
                                            , Html.div
                                                [ class "mr-1 is-loading-tiny"
                                                , style "float" "left"
                                                ]
                                                []
                                            ]
                                        , Html.div
                                            []
                                            [ Html.text
                                                """Uploading Encrypted Zip File
                                                """
                                            , Html.div
                                                [ class "mr-1 is-loading-tiny"
                                                , style "float" "left"
                                                ]
                                                []
                                            ]
                                        ]

                                Uploader.WaitingForCreateAccount wallet ->
                                    Html.div
                                        [ class "pl-2 has-border-2"
                                        ]
                                        [ View.Generic.Wallet.view wallet
                                        , header
                                        , Html.div
                                            []
                                            [ Html.text
                                                """Files Encrypted ☑️
                                                """
                                            ]
                                        , Html.div
                                            []
                                            [ Html.text
                                                """Creating Shdw Storage Account
                                                """
                                            , Html.div
                                                [ class "mr-1 is-loading-tiny"
                                                , style "float" "left"
                                                ]
                                                []
                                            ]
                                        , Html.div
                                            []
                                            [ Html.text
                                                """Marking Shdw Storagte Account as Immutable
                                                """
                                            , Html.div
                                                [ class "mr-1 is-loading-tiny"
                                                , style "float" "left"
                                                ]
                                                []
                                            ]
                                        , Html.div
                                            []
                                            [ Html.text
                                                """Uploading Encrypted Zip File
                                                """
                                            , Html.div
                                                [ class "mr-1 is-loading-tiny"
                                                , style "float" "left"
                                                ]
                                                []
                                            ]
                                        ]

                                Uploader.WaitingForMakeImmutable wallet ->
                                    Html.div
                                        [ class "pl-2 has-border-2"
                                        ]
                                        [ View.Generic.Wallet.view wallet
                                        , header
                                        , Html.div
                                            []
                                            [ Html.text
                                                """Files Encrypted ☑️
                                                """
                                            ]
                                        , Html.div
                                            []
                                            [ Html.text
                                                """Shdw Storage Account Created ☑️
                                                """
                                            ]
                                        , Html.div
                                            []
                                            [ Html.text
                                                """Marking Shdw Storagte Account as Immutable
                                                """
                                            , Html.div
                                                [ class "mr-1 is-loading-tiny"
                                                , style "float" "left"
                                                ]
                                                []
                                            ]
                                        , Html.div
                                            []
                                            [ Html.text
                                                """Uploading Encrypted Zip File
                                                """
                                            , Html.div
                                                [ class "mr-1 is-loading-tiny"
                                                , style "float" "left"
                                                ]
                                                []
                                            ]
                                        ]

                                Uploader.WaitingForFileUpload wallet ->
                                    Html.div
                                        [ class "pl-2 has-border-2"
                                        ]
                                        [ View.Generic.Wallet.view wallet
                                        , header
                                        , Html.div
                                            []
                                            [ Html.text
                                                """Files Encrypted ☑️
                                                """
                                            ]
                                        , Html.div
                                            []
                                            [ Html.text
                                                """Shdw Storage Account Created ☑️
                                                """
                                            ]
                                        , Html.div
                                            []
                                            [ Html.text
                                                """Shw Storage Account Marked as Immutable ☑️
                                                """
                                            ]
                                        , Html.div
                                            []
                                            [ Html.text
                                                """Uploading Encrypted Zip File
                                                """
                                            , Html.div
                                                [ class "mr-1 is-loading-tiny"
                                                , style "float" "left"
                                                ]
                                                []
                                            ]
                                        ]

                        Uploader.Uploaded datum ->
                            Html.div
                                [ class "has-border-2"
                                ]
                                [ View.Generic.Wallet.view datum.uploader
                                , header
                                , Html.h2
                                    []
                                    [ Html.text "Successful Upload"
                                    ]
                                , View.Generic.Datum.view datum.uploader datum
                                ]

                WaitingForWallet waitingForWalletUploader ->
                    case waitingForWalletUploader of
                        Uploader.AlmostLoggedIn ->
                            Html.div
                                [ class "has-border-2"
                                ]
                                [ header
                                , Html.div
                                    [ class "my-2 is-loading"
                                    ]
                                    []
                                ]

                        Uploader.AlmostHasCatalog almostCatalog ->
                            Html.div
                                [ class "has-border-2 pl-2 pb-6 "
                                ]
                                [ Html.button
                                    [ class "is-button-1 mr-2 mt-2"
                                    , onClick <| FromUploader <| UploaderMsg.ConnectAndGetCatalog almostCatalog
                                    , style "float" "right"
                                    ]
                                    [ Html.text "Connect"
                                    ]
                                , header
                                , Html.button
                                    [ class "is-button-1"
                                    , onClick <| FromUploader <| UploaderMsg.ConnectAndGetCatalog almostCatalog
                                    ]
                                    [ Html.text "Connect"
                                    ]
                                , Html.text <|
                                    String.join " " <|
                                        [ ""
                                        , "& then proceed to uploading to"
                                        , "mint:"
                                        , almostCatalog.mint
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
        [ class "mt-2 mb-3"
        ]
        [ Html.h2
            []
            [ Html.text "Upload Console"
            ]
        ]
