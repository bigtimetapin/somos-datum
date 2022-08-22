module Sub.Sub exposing (subs)

import Msg.Admin as Admin
import Msg.Downloader as Downloader
import Msg.Generic as GenericMsg
import Msg.Msg exposing (Msg(..))
import Msg.Uploader as Uploader
import Sub.Admin as AdminSub
import Sub.Downloader as DownloaderSub
import Sub.Generic exposing (genericError)
import Sub.Uploader as UploaderSub


subs : Sub Msg
subs =
    Sub.batch
        [ -- uploader sub
          UploaderSub.connectAsUploaderSuccess
            (\json ->
                ToUploader <| Uploader.ConnectSuccess json
            )
        , UploaderSub.connectAndGetCatalogAsUploaderSuccess
            (\json ->
                ToUploader <| Uploader.ConnectAndGetCatalogSuccess json
            )
        , UploaderSub.foundCatalogAsUninitialized
            (\json ->
                ToUploader <| Uploader.FoundCatalogAsUninitialized json
            )
        , UploaderSub.initializeCatalogSuccess
            (\json ->
                ToUploader <| Uploader.InitializeCatalogSuccess json
            )
        , UploaderSub.creatingAccount
            (\json ->
                ToUploader <| Uploader.Uploading <| Uploader.CreatingAccount json
            )
        , UploaderSub.markingAccountAsImmutable
            (\json ->
                ToUploader <| Uploader.Uploading <| Uploader.MarkingAccountAsImmutable json
            )
        , UploaderSub.uploadingFile
            (\json ->
                ToUploader <| Uploader.Uploading <| Uploader.UploadingFile json
            )
        , UploaderSub.uploadingMetaData
            (\json ->
                ToUploader <| Uploader.Uploading <| Uploader.UploadingMetaData json
            )
        , UploaderSub.publishingUrl
            (\json ->
                ToUploader <| Uploader.Uploading <| Uploader.PublishingUrl json
            )
        , UploaderSub.uploadSuccess
            (\json ->
                ToUploader <| Uploader.UploadSuccess json
            )

        -- downloader sub
        , DownloaderSub.connectAsDownloaderSuccess
            (\json ->
                ToDownloader <| Downloader.ConnectSuccess json
            )
        , DownloaderSub.connectAndGetCatalogAsDownloaderSuccess
            (\json ->
                ToDownloader <| Downloader.ConnectAndGetCatalogSuccess json
            )
        , DownloaderSub.connectAndGetDatumAsDownloaderSuccess
            (\json ->
                ToDownloader <| Downloader.ConnectAndGetDatumSuccess json
            )
        , DownloaderSub.downloadSuccess
            (\json ->
                ToDownloader <| Downloader.DownloadSuccess json
            )

        -- admin sub
        , AdminSub.connectAsAdminSuccess
            (\wallet ->
                ToAdmin <| Admin.ConnectSuccess wallet
            )
        , AdminSub.initializeTariffSuccess
            (\wallet ->
                ToAdmin <| Admin.InitializeTariffSuccess wallet
            )

        -- generic error
        , genericError
            (\error ->
                FromJs <| GenericMsg.Error error
            )
        ]
