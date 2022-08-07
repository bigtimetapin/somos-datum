module Model.Uploader exposing (HasWalletUploader(..), Uploader(..), WaitingForWalletUploader(..))

import Model.AlmostDatum exposing (AlmostDatum)
import Model.Catalog exposing (Catalog)
import Model.Datum exposing (Datum)
import Model.Wallet exposing (Wallet)


type Uploader
    = Top
    | HasWallet HasWalletUploader
    | WaitingForWallet WaitingForWalletUploader


type
    HasWalletUploader
    -- logged in
    = LoggedIn Wallet
      -- uploading
    | TypingMint Wallet String
    | WaitingForCatalog Wallet
    | HasCatalog Catalog
    | WaitingForUpload Wallet
    | Uploaded Datum


type WaitingForWalletUploader
    = AlmostLoggedIn
    | AlmostHasDatum AlmostDatum
