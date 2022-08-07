module Msg.Uploader exposing (From(..), To(..))

import Model.AlmostCatalog exposing (AlmostCatalog)
import Model.AlmostDatum exposing (AlmostDatum)
import Model.Wallet exposing (Wallet)

type From
    -- connect
    = Connect
    | ConnectAndGetDatum AlmostDatum
    -- select
    | TypingMint Wallet String
    | SelectMint AlmostCatalog
    -- upload
    | Upload AlmostDatum

type To
    -- connect
    = ConnectSuccess Wallet
    | ConnectAndGetDatumSuccess Json
    -- Upload
    | UploadSuccess Json

type alias Json = String
