module View.Upload.Upload exposing (body)

import Html exposing (Html)
import Html.Attributes exposing (class, href, id, multiple, placeholder, style, target, type_)
import Html.Events exposing (onClick, onInput)
import Model.Datum as Datum
import Model.Lit as Lit
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
                        [ class "has-border-2 px-2 pt-2 pb-6 pb-6"
                        ]
                        [ Html.button
                            [ class "is-button-1"
                            , onClick <| FromUploader <| UploaderMsg.Connect
                            , style "float" "right"
                            ]
                            [ Html.text "Connect"
                            ]
                        , header
                        , Html.button
                            [ class "is-button-1"
                            , onClick <| FromUploader <| UploaderMsg.Connect
                            ]
                            [ Html.text "Connect"
                            ]
                        , Html.text
                            """ to upload
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
                            """ files for your
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

                HasWallet hasWalletUploader ->
                    case hasWalletUploader of
                        Uploader.LoggedIn wallet ->
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
                                [ class "has-border-2 px-2 pt-2 pb-6"
                                ]
                                [ View.Generic.Wallet.view almostCatalog.uploader
                                , header
                                , Html.div
                                    [ class "has-border-2 px-2 pt-2"
                                    ]
                                    [ Html.div
                                        []
                                        [ Html.text <|
                                            String.join " "
                                                [ "This is your first time uploading with ⬇️"
                                                ]
                                        ]
                                    , Html.div
                                        [ class "has-border-2 px-1 py-1 my-2"
                                        ]
                                        [ Html.text "mint: "
                                        , Html.a
                                            [ class "has-sky-blue-text"
                                            , Html.Attributes.href <|
                                                String.concat
                                                    [ "https://solscan.io/token/"
                                                    , almostCatalog.mint
                                                    ]
                                            , target "_blank"
                                            ]
                                            [ Html.text almostCatalog.mint
                                            ]
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
                                [ class "has-border-2 px-2 pt-2 pb-6"
                                ]
                                [ View.Generic.Wallet.view wallet
                                , header
                                , Html.div
                                    [ class "my-2 is-loading"
                                    ]
                                    []
                                ]

                        Uploader.HasCatalog catalog parameters ->
                            let
                                f : UploaderMsg.UploadParameter -> Msg
                                f msg =
                                    FromUploader <| UploaderMsg.SelectParameter catalog parameters msg

                                method =
                                    case parameters.method of
                                        Lit.Collection ->
                                            [ Html.button
                                                [ class "is-button-1"
                                                , onClick <| f (UploaderMsg.SelectMethod Lit.Token)
                                                ]
                                                [ Html.text "Token"
                                                ]
                                            , Html.button
                                                [ class "is-button-1 is-active-button"
                                                ]
                                                [ Html.text "Metaplex Collection"
                                                ]
                                            ]

                                        Lit.Token ->
                                            [ Html.button
                                                [ class "is-button-1 is-active-button"
                                                ]
                                                [ Html.text "Token"
                                                ]
                                            , Html.button
                                                [ class "is-button-1"
                                                , onClick <| f (UploaderMsg.SelectMethod Lit.Collection)
                                                ]
                                                [ Html.text "Metaplex Collection"
                                                ]
                                            ]

                                comparator =
                                    case parameters.comparator of
                                        Lit.GreaterThan ->
                                            [ Html.button
                                                [ class "is-button-1"
                                                , onClick <| f (UploaderMsg.SelectComparator Lit.GreaterThanOrEqualTo)
                                                ]
                                                [ Html.text <| Lit.comparatorToString Lit.GreaterThanOrEqualTo
                                                ]
                                            , Html.button
                                                [ class "is-button-1 is-active-button"
                                                ]
                                                [ Html.text <| Lit.comparatorToString Lit.GreaterThan
                                                ]
                                            ]

                                        Lit.GreaterThanOrEqualTo ->
                                            [ Html.button
                                                [ class "is-button-1 is-active-button"
                                                ]
                                                [ Html.text <| Lit.comparatorToString Lit.GreaterThanOrEqualTo
                                                ]
                                            , Html.button
                                                [ class "is-button-1"
                                                , onClick <| f (UploaderMsg.SelectComparator Lit.GreaterThan)
                                                ]
                                                [ Html.text <| Lit.comparatorToString Lit.GreaterThan
                                                ]
                                            ]

                                value_ =
                                    case parameters.value of
                                        Lit.Deciding string ->
                                            let
                                                onClickMsg =
                                                    case String.toInt string of
                                                        Just int ->
                                                            UploaderMsg.SelectValue <| Lit.Decided int

                                                        Nothing ->
                                                            UploaderMsg.SelectValue <| Lit.InvalidInt string
                                            in
                                            Html.div
                                                [ class "has-border-2"
                                                ]
                                                [ Html.div
                                                    []
                                                    [ Html.div
                                                        [ class "icon-text"
                                                        ]
                                                        [ Html.span
                                                            [ class "icon has-text-info"
                                                            , style "margin-top" "2px"
                                                            , style "margin-left" "2px"
                                                            ]
                                                            [ Html.i
                                                                [ class "fas fa-coins"
                                                                ]
                                                                []
                                                            ]
                                                        , Html.span
                                                            []
                                                            [ Html.input
                                                                [ style "height" "30px"
                                                                , style "width" "13rem"
                                                                , type_ "text"
                                                                , placeholder "Minimum Token Value Required"
                                                                , onInput <|
                                                                    \s ->
                                                                        f <|
                                                                            UploaderMsg.SelectValue <|
                                                                                Lit.Deciding s
                                                                ]
                                                                []
                                                            ]
                                                        , Html.button
                                                            [ class "is-button-1"
                                                            , onClick <| f <| onClickMsg
                                                            ]
                                                            [ Html.text "Select"
                                                            ]
                                                        ]
                                                    ]
                                                ]

                                        Lit.InvalidInt string ->
                                            Html.div
                                                [ class "has-border-2 pl-2"
                                                ]
                                                [ Html.text <|
                                                    String.join
                                                        " "
                                                        [ "Invalid integer value:"
                                                        , string
                                                        ]
                                                , Html.button
                                                    [ class "is-button-1 ml-2"
                                                    , onClick <| f <| UploaderMsg.SelectValue <| Lit.Deciding string
                                                    ]
                                                    [ Html.text "Refresh"
                                                    ]
                                                ]

                                        Lit.Decided int ->
                                            Html.div
                                                [ class "has-border-2 pl-2"
                                                ]
                                                [ Html.text <|
                                                    String.concat
                                                        [ "Min token-balance required:"
                                                        , " "
                                                        , Lit.comparatorToString parameters.comparator
                                                        , String.fromInt int
                                                        ]
                                                , Html.button
                                                    [ class "is-button-1 ml-2"
                                                    , onClick <| f <| UploaderMsg.SelectValue <| Lit.Deciding ""
                                                    ]
                                                    [ Html.text "New"
                                                    ]
                                                ]

                                upload_ =
                                    case parameters.value of
                                        Lit.Decided int ->
                                            let
                                                decided =
                                                    { method = parameters.method
                                                    , comparator = parameters.comparator
                                                    , value = int
                                                    }
                                            in
                                            Html.button
                                                [ class "is-button-2 mb-2"
                                                , style "width" "100%"
                                                , onClick <|
                                                    FromUploader <|
                                                        UploaderMsg.Upload (Datum.fromCatalog catalog) decided
                                                ]
                                                [ Html.text "Upload"
                                                ]

                                        _ ->
                                            Html.div
                                                []
                                                []
                            in
                            Html.div
                                [ class "has-border-2 px-2 pt-2 pb-6"
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
                                , Html.div
                                    [ class "my-2"
                                    ]
                                    [ Html.nav
                                        [ class "level"
                                        ]
                                        [ Html.div
                                            [ class "level-left"
                                            ]
                                            [ Html.div
                                                [ class "level-item"
                                                ]
                                                [ Html.div
                                                    []
                                                    method
                                                ]
                                            , Html.div
                                                [ class "level-item"
                                                ]
                                                [ Html.div
                                                    []
                                                    comparator
                                                ]
                                            , Html.div
                                                [ class "level-item"
                                                ]
                                                [ Html.div
                                                    []
                                                    [ value_
                                                    ]
                                                ]
                                            ]
                                        ]
                                    ]
                                , upload_
                                , View.Generic.Catalog.view catalog.uploader catalog
                                ]

                        Uploader.HasEmptyWallet wallet ->
                            Html.div
                                [ class "has-border-2 px-2 pt-2 pb-6"
                                ]
                                [ View.Generic.Wallet.view wallet
                                , header
                                , Html.div
                                    [ class "has-border-2 px-2 pt-2 pb-2"
                                    ]
                                    [ Html.text
                                        """Caught exception creating storage on
                                        """
                                    , Html.a
                                        [ class "has-sky-blue-text"
                                        , href "https://shdw.genesysgo.com/shadow-infrastructure-overview/shadow-drive-overview"
                                        , target "_blank"
                                        ]
                                        [ Html.text "ShdwDrive"
                                        ]
                                    , Html.text
                                        """. It's likely that your wallet does not have
                                        """
                                    , Html.a
                                        [ class "has-sky-blue-text"
                                        , href "https://solscan.io/token/SHDWyBxihqiCj6YekG2GUr7wqKLeLAMK1gHZck9pL6y"
                                        , target "_blank"
                                        ]
                                        [ Html.text "$SHDW"
                                        ]
                                    , Html.text
                                        """, the native spl-token that powers decentralized storage.
                                        """
                                    ]
                                , Html.div
                                    [ class "has-border-2 px-2 pt-2 pb-2"
                                    ]
                                    [ Html.text
                                        """For reference, 1GB of storage translates to
                                        """
                                    , Html.a
                                        [ class "has-sky-blue-text"
                                        , href "https://shdw.genesysgo.com/shadow-infrastructure-overview/shadow-drive-overview/the-shadow-drive-storage-stack/the-shadow-drive-overlay/the-shadow-drive-smart-contracts"
                                        , target "_blank"
                                        ]
                                        [ Html.text "0.25"
                                        ]
                                    , Html.text
                                        """ $SHDW. So you don't need much & will find the token to be very affordable.
                                        """
                                    ]
                                , Html.div
                                    [ class "has-border-2 px-2 pt-2 pb-2"
                                    ]
                                    [ Html.text
                                        """You can quickly swap $SOL --> $SHDW on
                                        """
                                    , Html.a
                                        [ class "has-sky-blue-text"
                                        , href "https://jup.ag/swap/SOL-SHDW"
                                        , target "_blank"
                                        ]
                                        [ Html.text "Jupiter Exchange"
                                        ]
                                    , Html.text
                                        """
                                        .😁
                                        """
                                    ]
                                ]

                        Uploader.WaitingForUpload uploading ->
                            let
                                waiting =
                                    Html.div
                                        [ class "mr-1 is-loading-tiny"
                                        , style "float" "left"
                                        ]
                                        []
                            in
                            case uploading of
                                Uploader.WaitingForEncryption wallet ->
                                    Html.div
                                        [ class "has-border-2 px-2 pt-2 pb-6"
                                        ]
                                        [ View.Generic.Wallet.view wallet
                                        , header
                                        , Html.div
                                            [ class "has-border-2 px-2 py-2"
                                            ]
                                            [ Html.text
                                                """Encrypting Files
                                                """
                                            , waiting
                                            ]
                                        , Html.div
                                            [ class "has-border-2 px-2 py-2"
                                            ]
                                            [ Html.text
                                                """Creating Shdw Storage Account
                                                """
                                            , waiting
                                            ]
                                        , Html.div
                                            [ class "has-border-2 px-2 py-2"
                                            ]
                                            [ Html.text
                                                """Marking Shdw Storage Account as Immutable
                                                """
                                            , waiting
                                            ]
                                        , Html.div
                                            [ class "has-border-2 px-2 py-2"
                                            ]
                                            [ Html.text
                                                """Uploading Encrypted Zip File to Shdw Drive
                                                """
                                            , waiting
                                            ]
                                        , Html.div
                                            [ class "has-border-2 px-2 py-2"
                                            ]
                                            [ Html.text
                                                """Uploading MetaData to Shdw Drive
                                                """
                                            , waiting
                                            ]
                                        , Html.div
                                            [ class "has-border-2 px-2 py-2"
                                            ]
                                            [ Html.text
                                                """Publishing URL On-Chain
                                                """
                                            , waiting
                                            ]
                                        ]

                                Uploader.WaitingForCreateAccount wallet ->
                                    Html.div
                                        [ class "has-border-2 px-2 pt-2 pb-6"
                                        ]
                                        [ View.Generic.Wallet.view wallet
                                        , header
                                        , Html.div
                                            [ class "has-border-2 px-2 py-2"
                                            ]
                                            [ Html.text
                                                """Files Encrypted ☑️
                                                """
                                            ]
                                        , Html.div
                                            [ class "has-border-2 px-2 py-2"
                                            ]
                                            [ Html.text
                                                """Creating Shdw Storage Account
                                                """
                                            , waiting
                                            ]
                                        , Html.div
                                            [ class "has-border-2 px-2 py-2"
                                            ]
                                            [ Html.text
                                                """Marking Shdw Storage Account as Immutable
                                                """
                                            , waiting
                                            ]
                                        , Html.div
                                            [ class "has-border-2 px-2 py-2"
                                            ]
                                            [ Html.text
                                                """Uploading Encrypted Zip File to Shdw Drive
                                                """
                                            , waiting
                                            ]
                                        , Html.div
                                            [ class "has-border-2 px-2 py-2"
                                            ]
                                            [ Html.text
                                                """Uploading MetaData to Shdw Drive
                                                """
                                            , waiting
                                            ]
                                        , Html.div
                                            [ class "has-border-2 px-2 py-2"
                                            ]
                                            [ Html.text
                                                """Publishing URL On-Chain
                                                """
                                            , waiting
                                            ]
                                        ]

                                Uploader.WaitingForMakeImmutable wallet ->
                                    Html.div
                                        [ class "has-border-2 px-2 pt-2 pb-6"
                                        ]
                                        [ View.Generic.Wallet.view wallet
                                        , header
                                        , Html.div
                                            [ class "has-border-2 px-2 py-2"
                                            ]
                                            [ Html.text
                                                """Files Encrypted ☑️
                                                """
                                            ]
                                        , Html.div
                                            [ class "has-border-2 px-2 py-2"
                                            ]
                                            [ Html.text
                                                """Shdw Storage Account Created ☑️
                                                """
                                            ]
                                        , Html.div
                                            [ class "has-border-2 px-2 py-2"
                                            ]
                                            [ Html.text
                                                """Marking Shdw Storage Account as Immutable
                                                """
                                            , waiting
                                            ]
                                        , Html.div
                                            [ class "has-border-2 px-2 py-2"
                                            ]
                                            [ Html.text
                                                """Uploading Encrypted Zip File to Shdw Drive
                                                """
                                            , waiting
                                            ]
                                        , Html.div
                                            [ class "has-border-2 px-2 py-2"
                                            ]
                                            [ Html.text
                                                """Uploading MetaData to Shdw Drive
                                                """
                                            , waiting
                                            ]
                                        , Html.div
                                            [ class "has-border-2 px-2 py-2"
                                            ]
                                            [ Html.text
                                                """Publishing URL On-Chain
                                                """
                                            , waiting
                                            ]
                                        ]

                                Uploader.WaitingForFileUpload wallet ->
                                    Html.div
                                        [ class "has-border-2 px-2 pt-2 pb-6"
                                        ]
                                        [ View.Generic.Wallet.view wallet
                                        , header
                                        , Html.div
                                            [ class "has-border-2 px-2 py-2"
                                            ]
                                            [ Html.text
                                                """Files Encrypted ☑️
                                                """
                                            ]
                                        , Html.div
                                            [ class "has-border-2 px-2 py-2"
                                            ]
                                            [ Html.text
                                                """Shdw Storage Account Created ☑️
                                                """
                                            ]
                                        , Html.div
                                            [ class "has-border-2 px-2 py-2"
                                            ]
                                            [ Html.text
                                                """Shdw Storage Account Marked as Immutable ☑️
                                                """
                                            ]
                                        , Html.div
                                            [ class "has-border-2 px-2 py-2"
                                            ]
                                            [ Html.text
                                                """Uploading Encrypted Zip File to Shdw Drive
                                                """
                                            , waiting
                                            ]
                                        , Html.div
                                            [ class "has-border-2 px-2 py-2"
                                            ]
                                            [ Html.text
                                                """Uploading MetaData to Shdw Drive
                                                """
                                            , waiting
                                            ]
                                        , Html.div
                                            [ class "has-border-2 px-2 py-2"
                                            ]
                                            [ Html.text
                                                """Publishing URL On-Chain
                                                """
                                            , waiting
                                            ]
                                        ]

                                Uploader.WaitingForMetaDataUpload wallet ->
                                    Html.div
                                        [ class "has-border-2 px-2 pt-2 pb-6"
                                        ]
                                        [ View.Generic.Wallet.view wallet
                                        , header
                                        , Html.div
                                            [ class "has-border-2 px-2 py-2"
                                            ]
                                            [ Html.text
                                                """Files Encrypted ☑️
                                                """
                                            ]
                                        , Html.div
                                            [ class "has-border-2 px-2 py-2"
                                            ]
                                            [ Html.text
                                                """Shdw Storage Account Created ☑️
                                                """
                                            ]
                                        , Html.div
                                            [ class "has-border-2 px-2 py-2"
                                            ]
                                            [ Html.text
                                                """Shdw Storage Account Marked as Immutable ☑️
                                                """
                                            ]
                                        , Html.div
                                            [ class "has-border-2 px-2 py-2"
                                            ]
                                            [ Html.text
                                                """Encrypted Zip File Uploaded to Shdw Drive ☑️
                                                """
                                            ]
                                        , Html.div
                                            [ class "has-border-2 px-2 py-2"
                                            ]
                                            [ Html.text
                                                """Uploading MetaData to Shdw Drive
                                                """
                                            , waiting
                                            ]
                                        , Html.div
                                            [ class "has-border-2 px-2 py-2"
                                            ]
                                            [ Html.text
                                                """Publishing URL On-Chain
                                                """
                                            , waiting
                                            ]
                                        ]

                                Uploader.WaitingForUrlPublish wallet ->
                                    Html.div
                                        [ class "has-border-2 px-2 pt-2 pb-6"
                                        ]
                                        [ View.Generic.Wallet.view wallet
                                        , header
                                        , Html.div
                                            [ class "has-border-2 px-2 py-2"
                                            ]
                                            [ Html.text
                                                """Files Encrypted ☑️
                                                """
                                            ]
                                        , Html.div
                                            [ class "has-border-2 px-2 py-2"
                                            ]
                                            [ Html.text
                                                """Shdw Storage Account Created ☑️
                                                """
                                            ]
                                        , Html.div
                                            [ class "has-border-2 px-2 py-2"
                                            ]
                                            [ Html.text
                                                """Shdw Storage Account Marked as Immutable ☑️
                                                """
                                            ]
                                        , Html.div
                                            [ class "has-border-2 px-2 py-2"
                                            ]
                                            [ Html.text
                                                """Encrypted Zip File Uploaded to Shdw Drive ☑️
                                                """
                                            ]
                                        , Html.div
                                            [ class "has-border-2 px-2 py-2"
                                            ]
                                            [ Html.text
                                                """MetaData Uploaded to Shdw Drive ☑️
                                                """
                                            ]
                                        , Html.div
                                            [ class "has-border-2 px-2 py-2"
                                            ]
                                            [ Html.text
                                                """Publishing URL On-Chain
                                                """
                                            , waiting
                                            ]
                                        ]

                        Uploader.Uploaded datum ->
                            Html.div
                                [ class "has-border-2 px-2 pt-2 pb-6"
                                ]
                                [ View.Generic.Wallet.view datum.uploader
                                , header
                                , Html.h2
                                    [ class "mb-2"
                                    ]
                                    [ Html.text "Successful Upload 🤩"
                                    ]
                                , View.Generic.Datum.view datum.uploader datum
                                ]

                WaitingForWallet waitingForWalletUploader ->
                    case waitingForWalletUploader of
                        Uploader.AlmostLoggedIn ->
                            Html.div
                                [ class "has-border-2 px-2 pt-2 pb-6"
                                ]
                                [ header
                                , Html.div
                                    [ class "my-2 is-loading"
                                    ]
                                    []
                                ]

                        Uploader.AlmostHasCatalog almostCatalog ->
                            Html.div
                                [ class "has-border-2 px-2 pt-2 pb-6 pb-6 "
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
                                , Html.text
                                    """ to upload
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
                                    """ files associated with ⬇️
                                        """
                                , Html.div
                                    [ class "has-border-2 px-1 py-1 my-2"
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
            [ Html.text "Upload Console"
            ]
        ]
