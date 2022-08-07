module Sub.Sub exposing (subs)

import Msg.Generic as GenericMsg
import Msg.Msg exposing (Msg(..))
import Msg.Uploader as Uploader
import Msg.Downloader as Downloader
import Sub.Generic exposing (genericError)
import Sub.Uploader as UploaderSub
import Sub.Downloader as DownloaderSub

subs : Sub Msg
subs =
    Sub.batch
        [
        -- uploader sub
        UploaderSub.connectAsUploaderSuccess
            (\json ->
                (ToUploader <| Uploader.ConnectSuccess json)
            )

        , UploaderSub.connectAndGetDatumAsUploaderSuccess
            (\json ->
                (ToUploader <| Uploader.ConnectAndGetDatumSuccess json)
            )

        , UploaderSub.uploadSuccess
            (\json ->
                (ToUploader <| Uploader.UploadSuccess json)
            )
        -- downloader sub
        , DownloaderSub.connectAsDownloaderSuccess
            (\json ->
                (ToDownloader <| Downloader.ConnectSuccess json)
            )
        , DownloaderSub.connectAndGetCatalogAsDownloaderSuccess
            (\json ->
                (ToDownloader <| Downloader.ConnectAndGetCatalogSuccess json)
            )
        , DownloaderSub.connectAndGetDatumAsDownloaderSuccess
            (\json ->
                (ToDownloader <| Downloader.ConnectAndGetDatumSuccess json)
            )
        , DownloaderSub.getCatalogAsDownloaderSuccess
            (\json ->
                (ToDownloader <| Downloader.GetCatalogSuccess json)
            )
        , DownloaderSub.downloadSuccess
            (\json ->
                (ToDownloader <| Downloader.DownloadSuccess json)
            )
        -- generic error
        , genericError
            (\error ->
                FromJs <| GenericMsg.Error error
            )
        ]
