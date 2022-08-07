module Msg.Generic exposing (FromJsMsg(..), ToJsMsg(..))

import Model.Datum exposing (Datum)
import Model.Mint exposing (Mint)
import Model.Wallet exposing (Wallet)



-- TODO; uploader / downloader


type ToJsMsg
    = TypingMint Wallet String
    | SelectMint Wallet Mint
    | ViewCatalog Wallet Mint
    | Download Wallet Datum


type FromJsMsg
    = DownloadSuccess Json
    | GetCatalogSuccess Json
    | Error String


type alias Json =
    String
