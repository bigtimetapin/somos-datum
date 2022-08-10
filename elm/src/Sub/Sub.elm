module Sub.Sub exposing (subs)

import Msg.Downloader as Downloader
import Msg.Generic as GenericMsg
import Msg.Msg exposing (Msg(..))
import Msg.Uploader as Uploader
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
        , UploaderSub.uploadSuccess
            (\json ->
                ToUploader <| Uploader.UploadSuccess json
            )
        , UploaderSub.foundCatalogAsUninitialized
            (\json ->
                ToUploader <| Uploader.FoundCatalogAsUninitialized json
            )
        , UploaderSub.initializeCatalogSuccess
            (\json ->
                ToUploader <| Uploader.InitializeCatalogSuccess json
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

        -- generic error
        , genericError
            (\error ->
                FromJs <| GenericMsg.Error error
            )
        ]
