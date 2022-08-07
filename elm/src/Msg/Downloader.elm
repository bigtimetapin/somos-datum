module Msg.Downloader exposing (From(..), To(..))

import Model.AlmostCatalog exposing (AlmostCatalog)
import Model.Datum exposing (Datum)
import Model.Mint exposing (Mint)
import Model.Wallet exposing (Wallet)

type From
    -- connect
    = Connect
    | ConnectAndGetCatalog AlmostCatalog
    | ConnectAndGetDatum Datum
    -- select
    | TypingMint Wallet String
    | SelectMint Wallet Mint
    | TypingUploaderAddress Wallet Mint String
    | SelectUploaderAddress Wallet Mint UploaderAddress
    | TypingIncrement Wallet Mint UploaderAddress String
    | SelectIncrement Wallet Mint UploaderAddress Increment
    -- get
    | GetCatalog AlmostCatalog
    -- download
    | Download Wallet Datum

type To
    -- connect
    = ConnectSuccess Json
    | ConnectAndGetCatalogSuccess Json
    | ConnectAndGetDatumSuccess Json
    -- get
    | GetCatalogSuccess Json
    -- download
    | DownloadSuccess Json

type alias UploaderAddress = String

type alias Increment = Int

type alias Json = String
