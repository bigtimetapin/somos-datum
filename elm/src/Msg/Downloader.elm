module Msg.Downloader exposing (From(..), To(..))

import Model.AlmostCatalog exposing (AlmostCatalog)
import Model.AlmostDatum exposing (AlmostDatum)
import Model.Mint exposing (Mint)
import Model.Wallet exposing (Wallet)


type
    From
    -- connect
    = Connect
    | ConnectAndGetCatalog AlmostCatalog
    | ConnectAndGetDatum AlmostDatum
      -- select
    | TypingMint Wallet String
    | SelectMint Wallet Mint
    | TypingUploaderAddress Wallet Mint String
    | SelectUploaderAddress Wallet Mint UploaderAddress -- href
    | SelectIncrement Wallet AlmostDatum -- href
      -- download
    | Download Wallet AlmostDatum


type
    To
    -- connect
    = ConnectSuccess Wallet
    | ConnectAndGetCatalogSuccess Json
    | ConnectAndGetDatumSuccess Json
      -- download
    | DownloadSuccess Json


type alias UploaderAddress =
    String


type alias Increment =
    Int


type alias Json =
    String
