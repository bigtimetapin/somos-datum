module View.Upload.Upload exposing (body)

import Html exposing (Html)
import Html.Attributes exposing (accept, class, id, multiple, placeholder, style, type_)
import Html.Events exposing (onClick, onInput)
import Model.Role as Role
import Model.Uploader exposing (Uploader(..))
import Msg.Anchor as ToAnchorMsg
import Msg.Generic as Generic
import Msg.Msg exposing (Msg(..))
import Msg.Phantom as ToPhantomMsg
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
                            , onClick <| ToPhantom <| ToPhantomMsg.Connect <| Role.encode0 Role.Uploader
                            ]
                            [ Html.text "Connect"
                            ]
                        ]

                HasWallet hasWalletUploader ->
                    case hasWalletUploader of
                        Model.Uploader.LoggedIn wallet ->
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
                                            , onInput <| \s -> ToJs <| Generic.TypingMint wallet s
                                            ]
                                            []
                                        , Html.span
                                            [ class "icon is-left"
                                            ]
                                            [ Html.i
                                                [ class "fa-solid fa-coins"
                                                ]
                                                []
                                            ]
                                        ]
                                    ]
                                ]

                        Model.Uploader.TypingMint wallet string ->
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
                                            , onInput <| \s -> ToJs <| Generic.TypingMint wallet s
                                            ]
                                            []
                                        , Html.span
                                            [ class "icon is-left"
                                            ]
                                            [ Html.i
                                                [ class "fa-solid fa-coins"
                                                ]
                                                []
                                            ]
                                        ]
                                    , Html.div
                                        []
                                        [ Html.button
                                            [ class "is-button-1"
                                            , style "width" "100%"
                                            , onClick <| ToJs <| Generic.SelectMint wallet string
                                            ]
                                            [ Html.text <|
                                                String.join " " <|
                                                    [ "Select:", string ]
                                            ]
                                        ]
                                    ]
                                ]

                        Model.Uploader.HasMint wallet mint ->
                            Html.div
                                [ class "has-border-2"
                                ]
                                [ View.Generic.Wallet.view wallet
                                , Html.form
                                    []
                                    [ Html.input
                                        [ id "gg-sd-zip"
                                        , type_ "file"
                                        , multiple True
                                        , accept <|
                                            String.join
                                                ", "
                                                [ ".mp3", ".wav", ".png", ".jpeg", "jpg" ]
                                        ]
                                        []
                                    ]
                                , Html.button
                                    [ class "is-button-1"
                                    , onClick (ToAnchor <| ToAnchorMsg.UploadAssets wallet mint)
                                    ]
                                    [ Html.text "Upload"
                                    ]
                                ]

                        Model.Uploader.WaitingForUpload wallet ->
                            Html.div
                                [ class "is-loading"
                                ]
                                [ View.Generic.Wallet.view wallet
                                ]

                        Model.Uploader.Uploaded wallet datum ->
                            Html.div
                                [ class "has-border-2"
                                ]
                                [ View.Generic.Wallet.view wallet
                                , Html.h2
                                    []
                                    [ Html.text "Successful Upload"
                                    ]
                                , View.Generic.Datum.view datum
                                , Html.div
                                    [ class "is-button-1"
                                    ]
                                    [ Html.a
                                        []
                                        []
                                    ]
                                ]

                        Model.Uploader.WaitingForCatalog wallet ->
                            Html.div
                                [ class "is-loading"
                                ]
                                [ View.Generic.Wallet.view wallet
                                ]

                        Model.Uploader.HasCatalog catalog ->
                            Html.div
                                [ class "has-border-2"
                                ]
                                [ View.Generic.Wallet.view catalog.uploader
                                , View.Generic.Catalog.view catalog
                                ]

                WaitingForWallet waitingForWalletUploader ->
                    Html.div
                        []
                        [ Html.text "todo;"
                        ]
    in
    Html.div
        [ class "container"
        ]
        [ html
        ]
