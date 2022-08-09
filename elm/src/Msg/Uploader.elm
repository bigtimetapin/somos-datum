module Msg.Uploader exposing (From(..), To(..))

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
      -- upload
    | Upload Datum


type
    To
    -- connect
    = ConnectSuccess Wallet
    | ConnectAndGetCatalogSuccess Json
      -- Upload
    | UploadSuccess Json


type alias Json =
    String
