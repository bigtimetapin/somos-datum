module Main exposing (main)

-- MAIN

import Browser
import Browser.Navigation as Nav
import Html exposing (Html)
import Model.Administrator as Administrator
import Model.AlmostCatalog as AlmostCatalog
import Model.Catalog as Catalog
import Model.Datum as Datum
import Model.Downloader as Downloader
import Model.Lit as Lit
import Model.Model as Model exposing (Model)
import Model.State as State exposing (State(..))
import Model.Uploader as Uploader
import Msg.Admin as AdminMsg
import Msg.Downloader as DownloaderMsg
import Msg.Generic as GenericMsg
import Msg.Msg exposing (Msg(..), resetViewport)
import Msg.Uploader as UploaderMsg
import Sub.Admin as AdminCmd
import Sub.Downloader as DownloaderCmd
import Sub.Sub as Sub
import Sub.Uploader as UploaderCmd
import Url
import View.Admin.Admin
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
                -- Waiting for wallet
                UploaderMsg.Connect ->
                    ( { model | state = Upload <| Uploader.WaitingForWallet Uploader.AlmostLoggedIn }
                    , UploaderCmd.connectAsUploader ()
                    )

                UploaderMsg.ConnectAndGetCatalog almostCatalog ->
                    ( { model | state = Upload <| Uploader.WaitingForWallet Uploader.AlmostLoggedIn }
                    , UploaderCmd.connectAndGetCatalogAsUploader <| AlmostCatalog.encode almostCatalog
                    )

                -- Has wallet
                UploaderMsg.TypingMint wallet string ->
                    ( { model | state = Upload <| Uploader.HasWallet <| Uploader.TypingMint wallet string }
                    , Cmd.none
                    )

                UploaderMsg.SelectMint almostCatalog ->
                    ( { model
                        | state =
                            Upload <|
                                Uploader.HasWallet <|
                                    Uploader.WaitingForCatalog almostCatalog.uploader
                      }
                    , UploaderCmd.getCatalogAsUploader <| AlmostCatalog.encode almostCatalog
                    )

                UploaderMsg.InitializeCatalog almostCatalog ->
                    ( { model
                        | state = Upload <| Uploader.HasWallet <| Uploader.WaitingForCatalog almostCatalog.uploader
                      }
                    , UploaderCmd.initializeCatalog <| AlmostCatalog.encode almostCatalog
                    )

                UploaderMsg.Upload datum ->
                    ( { model
                        | state =
                            Upload <|
                                Uploader.HasWallet <|
                                    Uploader.WaitingForUpload <|
                                        Uploader.WaitingForEncryption datum.uploader
                      }
                    , UploaderCmd.upload <| Lit.encode datum
                    )

                UploaderMsg.SelectParameter catalog parameters uploadParameter ->
                    case uploadParameter of
                        UploaderMsg.SelectMethod method ->
                            let
                                new =
                                    { parameters | method = method }
                            in
                            ( { model | state = Upload <| Uploader.HasWallet <| Uploader.HasCatalog catalog new }
                            , Cmd.none
                            )

                        UploaderMsg.SelectComparator comparator ->
                            let
                                new =
                                    { parameters | comparator = comparator }
                            in
                            ( { model | state = Upload <| Uploader.HasWallet <| Uploader.HasCatalog catalog new }
                            , Cmd.none
                            )

                        UploaderMsg.SelectValue value ->
                            let
                                new =
                                    { parameters | value = value }
                            in
                            ( { model | state = Upload <| Uploader.HasWallet <| Uploader.HasCatalog catalog new }
                            , Cmd.none
                            )

        ToUploader to ->
            case to of
                UploaderMsg.ConnectSuccess wallet ->
                    ( { model | state = Upload <| Uploader.HasWallet <| Uploader.LoggedIn wallet }
                    , Cmd.none
                    )

                UploaderMsg.ConnectAndGetCatalogSuccess json ->
                    case Catalog.decode json of
                        Ok catalog ->
                            ( { model
                                | state =
                                    Upload <|
                                        Uploader.HasWallet <|
                                            Uploader.HasCatalog catalog Lit.defaultParameters
                              }
                            , Cmd.none
                            )

                        Err error ->
                            ( { model | state = Error error }
                            , Cmd.none
                            )

                UploaderMsg.FoundCatalogAsUninitialized json ->
                    case AlmostCatalog.decode json of
                        Ok almostCatalog ->
                            ( { model
                                | state =
                                    Upload <| Uploader.HasWallet <| Uploader.HasUninitializedCatalog almostCatalog
                              }
                            , Cmd.none
                            )

                        Err error ->
                            ( { model | state = Error error }
                            , Cmd.none
                            )

                UploaderMsg.InitializeCatalogSuccess json ->
                    case Catalog.decode json of
                        Ok catalog ->
                            ( { model
                                | state =
                                    Upload <|
                                        Uploader.HasWallet <|
                                            Uploader.HasCatalog catalog Lit.defaultParameters
                              }
                            , Cmd.none
                            )

                        Err error ->
                            ( { model | state = Error error }
                            , Cmd.none
                            )

                UploaderMsg.FoundEmptyWallet wallet ->
                    ( { model | state = Upload <| Uploader.HasWallet <| Uploader.HasEmptyWallet wallet }
                    , Cmd.none
                    )

                UploaderMsg.Uploading uploadingCheckpoint ->
                    case uploadingCheckpoint of
                        UploaderMsg.EncryptingFiles wallet ->
                            ( { model
                                | state =
                                    Upload <|
                                        Uploader.HasWallet <|
                                            Uploader.WaitingForUpload <|
                                                Uploader.WaitingForEncryption wallet
                              }
                            , Cmd.none
                            )

                        UploaderMsg.CreatingAccount wallet ->
                            ( { model
                                | state =
                                    Upload <|
                                        Uploader.HasWallet <|
                                            Uploader.WaitingForUpload <|
                                                Uploader.WaitingForCreateAccount wallet
                              }
                            , Cmd.none
                            )

                        UploaderMsg.MarkingAccountAsImmutable wallet ->
                            ( { model
                                | state =
                                    Upload <|
                                        Uploader.HasWallet <|
                                            Uploader.WaitingForUpload <|
                                                Uploader.WaitingForMakeImmutable wallet
                              }
                            , Cmd.none
                            )

                        UploaderMsg.UploadingFile wallet ->
                            ( { model
                                | state =
                                    Upload <|
                                        Uploader.HasWallet <|
                                            Uploader.WaitingForUpload <|
                                                Uploader.WaitingForFileUpload wallet
                              }
                            , Cmd.none
                            )

                        UploaderMsg.UploadingMetaData wallet ->
                            ( { model
                                | state =
                                    Upload <|
                                        Uploader.HasWallet <|
                                            Uploader.WaitingForUpload <|
                                                Uploader.WaitingForMetaDataUpload wallet
                              }
                            , Cmd.none
                            )

                        UploaderMsg.PublishingUrl wallet ->
                            ( { model
                                | state =
                                    Upload <|
                                        Uploader.HasWallet <|
                                            Uploader.WaitingForUpload <|
                                                Uploader.WaitingForUrlPublish wallet
                              }
                            , Cmd.none
                            )

                UploaderMsg.UploadSuccess json ->
                    case Datum.decode json of
                        Ok datum ->
                            ( { model | state = Upload <| Uploader.HasWallet <| Uploader.Uploaded datum }
                            , Cmd.none
                            )

                        Err error ->
                            ( { model | state = Error error }
                            , Cmd.none
                            )

        FromDownloader from ->
            case from of
                -- Waiting for wallet
                DownloaderMsg.Connect ->
                    ( { model | state = Download <| Downloader.WaitingForWallet <| Downloader.AlmostLoggedIn }
                    , DownloaderCmd.connectAsDownloader ()
                    )

                DownloaderMsg.ConnectAndGetCatalog almostCatalog ->
                    ( { model | state = Download <| Downloader.WaitingForWallet <| Downloader.AlmostLoggedIn }
                    , DownloaderCmd.connectAndGetCatalogAsDownloader <| AlmostCatalog.encode almostCatalog
                    )

                DownloaderMsg.ConnectAndGetDatum datum ->
                    ( { model | state = Download <| Downloader.WaitingForWallet <| Downloader.AlmostLoggedIn }
                    , DownloaderCmd.connectAndGetDatumAsDownloader <| Datum.encode datum
                    )

                -- Has wallet
                DownloaderMsg.TypingMint wallet string ->
                    ( { model | state = Download <| Downloader.HasWallet <| Downloader.TypingMint wallet string }
                    , Cmd.none
                    )

                DownloaderMsg.SelectMint wallet mint ->
                    ( { model | state = Download <| Downloader.HasWallet <| Downloader.HasMint wallet mint }
                    , Cmd.none
                    )

                DownloaderMsg.TypingUploaderAddress wallet mint string ->
                    ( { model
                        | state =
                            Download <| Downloader.HasWallet <| Downloader.TypingUploaderAddress wallet mint string
                      }
                    , Cmd.none
                    )

                DownloaderMsg.SelectUploaderAddress wallet mint uploaderAddress ->
                    ( { model | state = Download <| Downloader.HasWallet <| Downloader.WaitingForCatalog wallet }
                    , DownloaderCmd.getCatalogAsDownloader <|
                        AlmostCatalog.encode { mint = mint, uploader = uploaderAddress }
                    )

                DownloaderMsg.SelectIncrement wallet datum ->
                    ( { model | state = Download <| Downloader.HasWallet <| Downloader.WaitingForDatum wallet }
                    , DownloaderCmd.getDatumAsDownloader <| Datum.encode datum
                    )

                DownloaderMsg.Download wallet datum ->
                    ( { model | state = Download <| Downloader.HasWallet <| Downloader.WaitingForDownload wallet }
                    , DownloaderCmd.download <| Datum.encode datum
                    )

        ToDownloader to ->
            case to of
                DownloaderMsg.ConnectSuccess wallet ->
                    ( { model | state = Download <| Downloader.HasWallet <| Downloader.LoggedIn wallet }
                    , Cmd.none
                    )

                DownloaderMsg.ConnectAndGetCatalogSuccess json ->
                    case Catalog.decodeWithWallet json of
                        Ok withWallet ->
                            ( { model
                                | state =
                                    Download <|
                                        Downloader.HasWallet <|
                                            Downloader.HasCatalog withWallet.wallet withWallet.catalog
                              }
                            , Cmd.none
                            )

                        Err error ->
                            ( { model | state = Error error }
                            , Cmd.none
                            )

                DownloaderMsg.ConnectAndGetDatumSuccess json ->
                    case Datum.decodeWithWallet json of
                        Ok withWallet ->
                            ( { model
                                | state =
                                    Download <|
                                        Downloader.HasWallet <|
                                            Downloader.HasDatum withWallet.wallet withWallet.datum
                              }
                            , Cmd.none
                            )

                        Err error ->
                            ( { model | state = Error error }
                            , Cmd.none
                            )

                DownloaderMsg.DownloadSuccess json ->
                    case Datum.decodeWithWallet json of
                        Ok withWallet ->
                            ( { model
                                | state =
                                    Download <|
                                        Downloader.HasWallet <|
                                            Downloader.Downloaded withWallet.wallet withWallet.datum
                              }
                            , Cmd.none
                            )

                        Err error ->
                            ( { model | state = Error error }
                            , Cmd.none
                            )

        FromAdmin from ->
            case from of
                AdminMsg.Connect ->
                    ( { model | state = Admin <| Administrator.WaitingForWallet }
                    , AdminCmd.connectAsAdmin ()
                    )

                AdminMsg.InitializeTariff wallet ->
                    ( { model | state = Admin <| Administrator.WaitingForInitializeTariff wallet }
                    , AdminCmd.initializeTariff ()
                    )

        ToAdmin to ->
            case to of
                AdminMsg.ConnectSuccess wallet ->
                    ( { model | state = Admin <| Administrator.HasWallet wallet }
                    , Cmd.none
                    )

                AdminMsg.InitializeTariffSuccess wallet ->
                    ( { model | state = Admin <| Administrator.InitializedTariff wallet }
                    , Cmd.none
                    )

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

                Download downloader ->
                    hero <| View.Download.Download.body downloader

                Admin administrator ->
                    hero <| View.Admin.Admin.body administrator

                Error error ->
                    hero (View.Error.Error.body error)
    in
    { title = "datum.somos.world"
    , body =
        [ html
        ]
    }
