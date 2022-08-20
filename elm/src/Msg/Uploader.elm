module Msg.Uploader exposing (From(..), To(..), UploadingCheckpoint(..))

import Model.AlmostCatalog exposing (AlmostCatalog)
import Model.Datum exposing (Datum)
import Model.Wallet exposing (Wallet)


type
    From
    -- connect
    = Connect
    | ConnectAndGetCatalog AlmostCatalog
      -- select
    | TypingMint Wallet String
    | SelectMint AlmostCatalog -- href
      -- init
    | InitializeCatalog AlmostCatalog
      -- upload
    | Upload Datum


type
    To
    -- connect
    = ConnectSuccess Wallet
    | ConnectAndGetCatalogSuccess Json
      -- init
    | FoundCatalogAsUninitialized Json
    | InitializeCatalogSuccess Json
      -- upload
    | Uploading UploadingCheckpoint
    | UploadSuccess Json


type UploadingCheckpoint
    = EncryptingFiles Wallet
    | CreatingAccount Wallet
    | MarkingAccountAsImmutable Wallet
    | UploadingFile Wallet
    | UploadingMetaData Wallet
    | PublishingUrl Wallet


type alias Json =
    String
