module Msg.Uploader exposing (From(..), To(..), UploadParameter(..), UploadingCheckpoint(..))

import Model.AlmostCatalog exposing (AlmostCatalog)
import Model.Catalog exposing (Catalog)
import Model.Datum exposing (Datum)
import Model.Lit as Lit
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
    | SelectParameter Catalog Lit.Parameters UploadParameter
    | Upload Datum Lit.DecidedParameters


type UploadParameter
    = SelectMethod Lit.Method
    | SelectComparator Lit.Comparator
    | SelectValue Lit.Value


type
    To
    -- connect
    = ConnectSuccess Wallet
    | ConnectAndGetCatalogSuccess Json
      -- init
    | FoundCatalogAsUninitialized Json
    | InitializeCatalogSuccess Json
      -- upload
    | FoundEmptyWallet Wallet
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
