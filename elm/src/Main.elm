module Main exposing (main)

-- MAIN

import Browser
import Browser.Navigation as Nav
import Html exposing (Html)
import Model.Catalog as Catalog
import Model.Datum as Datum
import Model.Downloader as Downloader
import Model.Mint as Mint
import Model.Model as Model exposing (Model)
import Model.Role as Role
import Model.State as State exposing (State(..))
import Model.Uploader as Uploader
import Msg.Anchor exposing (ToAnchorMsg(..))
import Msg.Generic as GenericMsg
import Msg.Msg exposing (Msg(..), resetViewport)
import Msg.Phantom exposing (ToPhantomMsg(..))
import Sub.Anchor exposing (..)
import Sub.Generic exposing (downloadSender, getCatalogSender)
import Sub.Phantom exposing (..)
import Sub.Sub as Sub
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

        ToPhantom toPhantomMsg ->
            case toPhantomMsg of
                Connect json ->
                    ( model
                    , connectSender json
                    )

        FromPhantom fromPhantomMsg ->
            case fromPhantomMsg of
                Msg.Phantom.ErrorOnConnection string ->
                    ( { model | state = State.Error string }
                    , Cmd.none
                    )

        ToAnchor toAnchorMsg ->
            case toAnchorMsg of
                UploadAssets wallet mint ->
                    ( { model | state = State.Upload <| Uploader.HasWallet <| Uploader.WaitingForUpload wallet }
                    , uploadAssetsSender <| Role.encode Role.Uploader (Mint.encode mint)
                    )

        FromAnchor fromAnchorMsg ->
            case fromAnchorMsg of
                -- init state lookup loop
                Msg.Anchor.GetCurrentState json ->
                    -- TODO; decode json
                    ( model
                    , Cmd.none
                    )

                -- state lookup
                Msg.Anchor.SuccessOnStateLookup json ->
                    -- TODO; decode json
                    ( model
                    , Cmd.none
                    )

        ToJs toJsMsg ->
            case toJsMsg of
                GenericMsg.Download wallet datum ->
                    ( { model | state = State.Download <| Downloader.WaitingForDownload wallet }
                    , downloadSender <| Datum.encode datum
                    )

                GenericMsg.TypingMint wallet string ->
                    ( { model | state = State.Upload <| Uploader.HasWallet <| Uploader.TypingMint wallet string }
                    , Cmd.none
                    )

                GenericMsg.SelectMint wallet mint ->
                    ( { model | state = State.Upload <| Uploader.HasWallet <| Uploader.HasMint wallet mint }
                    , Cmd.none
                    )

                GenericMsg.ViewCatalog wallet mint ->
                    ( { model | state = State.Upload <| Uploader.HasWallet <| Uploader.WaitingForCatalog wallet }
                    , getCatalogSender <| Role.encode Role.Uploader (Catalog.encode mint wallet)
                    )

        FromJs fromJsMsg ->
            case fromJsMsg of
                GenericMsg.DownloadSuccess json ->
                    -- TODO; decode json
                    ( model
                    , Cmd.none
                    )

                GenericMsg.Error string ->
                    ( { model | state = Error string }
                    , Cmd.none
                    )

                GenericMsg.GetCatalogSuccess json ->
                    case Catalog.decode json of
                        Ok catalog ->
                            ( { model | state = State.Upload <| Uploader.HasWallet <| Uploader.HasCatalog catalog }
                            , Cmd.none
                            )

                        Err error ->
                            ( { model | state = State.Error error }
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
