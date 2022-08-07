module Model.State exposing (State(..), href, parse)

import Html
import Html.Attributes
import Model.AlmostCatalog as AlmostCatalog
import Model.Datum as Datum
import Model.Downloader as Downloader exposing (Downloader)
import Model.Uploader as Uploader exposing (Uploader)
import Url
import Url.Parser as UrlParser exposing ((</>))


type State
    = Upload Uploader
    | Download Downloader
    | Error String


urlParser : UrlParser.Parser (State -> c) c
urlParser =
    UrlParser.oneOf
        [ UrlParser.map (Download Downloader.Top) UrlParser.top
        , UrlParser.map (Download Downloader.Top) (UrlParser.s "download")
        , UrlParser.map (Upload Uploader.Top) (UrlParser.s "upload")
        , UrlParser.map (\d -> Upload (Uploader.WaitingForWallet (Uploader.AlmostHasDatum d))) Datum.parser
        , UrlParser.map (\c -> Upload (Uploader.WaitingForWallet (Uploader.AlmostHasCatalog c))) AlmostCatalog.parser
        ]


parse : Url.Url -> State
parse url =
    let
        target =
            -- The RealWorld spec treats the fragment like a path.
            -- This makes it *literally* the path, so we can proceed
            -- with parsing as if it had been a normal path all along.
            { url | path = Maybe.withDefault "" url.fragment, fragment = Nothing }
    in
    case UrlParser.parse urlParser target of
        Just state ->
            state

        Nothing ->
            Error "404; Invalid Path"


path : State -> String
path state =
    case state of
        Upload uploader ->
            case uploader of
                Uploader.Top ->
                    "#/upload"

                Uploader.HasWallet _ ->
                    path (Upload Uploader.Top)

                Uploader.WaitingForWallet waitingForWalletUploader ->
                    case waitingForWalletUploader of
                        Uploader.AlmostHasDatum datum ->
                            String.concat [ "#/", datum.mint, datum.uploader, String.fromInt datum.increment ]

                        Uploader.AlmostHasCatalog almostCatalog ->
                            String.concat [ "#/", almostCatalog.mint, almostCatalog.uploader ]

        Download _ ->
            "#/download"

        Error _ ->
            "#/invalid"


href : State -> Html.Attribute msg
href state =
    Html.Attributes.href (path state)
