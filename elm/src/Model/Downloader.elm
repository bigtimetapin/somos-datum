module Model.DownloadStatus exposing (DownloadStatus(..))

import Model.Datum exposing (Datum)
import Model.Wallet exposing (Wallet)


type DownloadStatus
    = InvokedAndWaiting Wallet
    | Done Wallet Datum
