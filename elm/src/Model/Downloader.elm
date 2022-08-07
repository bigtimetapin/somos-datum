module Model.Downloader exposing (Downloader(..))

import Model.Datum exposing (Datum)
import Model.Wallet exposing (Wallet)


type Downloader
    = Top
    | HasWallet Wallet
    | WaitingForDownload Wallet
    | Done Wallet Datum
