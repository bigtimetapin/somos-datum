module Main exposing (main)

-- MAIN

import Browser
import Browser.Navigation as Nav
import Html exposing (Html)
import Model.AlmostCatalog as AlmostCatalog
import Model.AlmostDatum as AlmostDatum
import Model.Catalog as Catalog
import Model.Datum as Datum
import Model.Downloader as Downloader
import Model.Mint as Mint
import Model.Model as Model exposing (Model)
import Model.State as State exposing (State(..))
import Model.Uploader as Uploader
import Msg.Generic as GenericMsg
import Msg.Msg exposing (Msg(..), resetViewport)
import Msg.Uploader as UploaderMsg
import Sub.Sub as Sub
import Sub.Uploader as UploaderCmd
import Url
import View.Download.Download
import View.Error.Error
import View.Hero
import View.Upload.Upload


main : Program () Model Msg
main =
    Browser.application
        { init = Model.init
        , view = view
        , update = update
        , subscriptions = \_ -> Sub.subs
        , onUrlChange = UrlChanged
        , onUrlRequest = LinkClicked
        }



-- UPDATE


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        NoOp ->
            ( model, Cmd.none )

        UrlChanged url ->
            ( { model
                | state = State.parse url
                , url = url
              }
            , resetViewport
            )

        LinkClicked urlRequest ->
            case urlRequest of
                Browser.Internal url ->
                    ( model, Nav.pushUrl model.key (Url.toString url) )

                Browser.External href ->
                    ( model, Nav.load href )

        FromUploader from ->
            case from of
                UploaderMsg.Connect ->
                    ( { model | state = Upload <| Uploader.WaitingForWallet Uploader.AlmostLoggedIn }
                    , UploaderCmd.connectAsUploader ()
                    )


                UploaderMsg.ConnectAndGetDatum almostDatum ->
                    ( { model | state = Upload <| Uploader.WaitingForWallet Uploader.AlmostLoggedIn }
                    , UploaderCmd.connectAndGetDatumAsUploader <| AlmostDatum.encode almostDatum
                    )


                UploaderMsg.TypingMint wallet string ->
                    ( { model | state = Upload <| Uploader.HasWallet <| Uploader.TypingMint wallet string }
                    , Cmd.none
                    )


                UploaderMsg.SelectMint almostCatalog ->
                    ( { model | state = Upload <| Uploader.HasWallet
                        <| Uploader.WaitingForCatalog almostCatalog.uploader
                        }
                    , UploaderCmd.getCatalogAsUploader <| AlmostCatalog.encode almostCatalog
                    )


                UploaderMsg.Upload almostDatum ->
                    ( { model | state = Upload <| Uploader.HasWallet <| Uploader.WaitingForUpload almostDatum.uploader }
                    , UploaderCmd.upload <| AlmostDatum.encode almostDatum
                    )



        ToUploader to ->
            case to of
                UploaderMsg.ConnectSuccess wallet ->
                    ( { model | state = Upload <| Uploader.HasWallet <| Uploader.LoggedIn wallet }
                    , Cmd.none
                    )

                -- TODO; decode
                UploaderMsg.ConnectAndGetDatumSuccess json ->
                    ( model, Cmd.none)

                UploaderMsg.UploadSuccess json ->
                    ( model, Cmd.none )


        FromDownloader from ->


        ToDownloader to ->

        FromJs fromJsMsg ->
            case fromJsMsg of
                GenericMsg.Error string ->
                    ( { model | state = Error string }
                    , Cmd.none
                    )




-- VIEW


view : Model -> Browser.Document Msg
view model =
    let
        hero : Html Msg -> Html Msg
        hero =
            View.Hero.view model

        html =
            case model.state of
                Upload uploader ->
                    hero <| View.Upload.Upload.body uploader

                Download _ ->
                    hero <| View.Download.Download.body

                Error error ->
                    hero (View.Error.Error.body error)
    in
    { title = "datum.somos.world"
    , body =
        [ html
        ]
    }
