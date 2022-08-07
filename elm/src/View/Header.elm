module View.Header exposing (view)

import Html exposing (Html)
import Html.Attributes exposing (class, src, style, width)
import Html.Events exposing (onClick)
import Model.Downloader as Downloader
import Model.Model exposing (Model)
import Model.State as State exposing (State(..))
import Model.Uploader as Uploader
import Msg.Msg exposing (Msg(..))


view : Model -> Html Msg
view model =
    let
        tab_ : Args -> Html Msg
        tab_ =
            tab model
    in
    Html.nav
        [ class "is-navbar"
        ]
        [ tab_
            { state = Download Downloader.Top
            , title = "Download"
            , msg = NoOp
            }
        , tab_
            { state = Upload Uploader.Top
            , title = "Upload"
            , msg = NoOp
            }
        , Html.div
            [ style "float" "right"
            ]
            [ Html.a
                [ State.href <| Download Downloader.Top
                ]
                [ Html.img
                    [ src "images/logo/02_somos.png"
                    , width 50
                    ]
                    []
                ]
            ]
        ]


type alias Args =
    { state : State
    , title : String
    , msg : Msg
    }


tab : Model -> Args -> Html Msg
tab model args =
    Html.div
        [ style "float" "left"
        ]
        [ Html.a
            [ State.href args.state
            , onClick args.msg
            ]
            [ Html.button
                [ class (String.join " " [ "has-font-1", "is-button-1", isActive model args.state ])
                ]
                [ Html.text args.title
                ]
            ]
        ]


isActive : Model -> State -> String
isActive model state =
    let
        class_ =
            "is-active-header-tab"
    in
    case state of
        _ ->
            case model.state == state of
                True ->
                    class_

                False ->
                    ""
