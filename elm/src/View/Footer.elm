module View.Footer exposing (view)

import Html exposing (Html)
import Html.Attributes exposing (class, href, target)
import Msg.Msg exposing (Msg)


view : Html Msg
view =
    Html.footer
        [ class "level has-right"
        ]
        [ Html.div
            [ class "level-item"
            ]
            [ Html.a
                [ href "https://twitter.com/bigtimetapin"
                , target "_blank"
                ]
                [ Html.span
                    [ class "icon is-medium"
                    ]
                    [ Html.i
                        [ class "fab fa-sm fa-twitter"
                        ]
                        []
                    ]
                ]
            ]
        , Html.div
            [ class "level-item"
            ]
            [ Html.a
                [ href "https://github.com/bigtimetapin/somos-datum"
                , target "_blank"
                ]
                [ Html.span
                    [ class "icon is-medium"
                    ]
                    [ Html.i
                        [ class "fab fa-sm fa-github"
                        ]
                        []
                    ]
                ]
            ]
        , Html.div
            [ class "level-item"
            ]
            [ Html.a
                [ class "icon is-medium"
                , href "mailto:bigtimetapin@gmail.com"
                , target "_blank"
                ]
                [ Html.i
                    [ class "far fa-sm fa-envelope"
                    ]
                    []
                ]
            ]
        ]
