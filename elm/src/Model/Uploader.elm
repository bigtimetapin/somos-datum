module Model.Uploader exposing (HasWalletUploader(..), Uploader(..), WaitingForWalletUploader(..))

import Model.AlmostCatalog exposing (AlmostCatalog)
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
      -- selecting upload
    | TypingMint Wallet String
    | WaitingForCatalog Wallet
      -- initializing catalog
    | HasUninitializedCatalog AlmostCatalog
      -- uploading
    | HasCatalog Catalog
    | WaitingForUpload Wallet
    | Uploaded Datum


type WaitingForWalletUploader
    = AlmostLoggedIn
    | AlmostHasCatalog AlmostCatalog
