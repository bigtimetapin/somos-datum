module Model.Uploader exposing (HasWalletUploader(..), Uploader(..), Uploading(..), WaitingForWalletUploader(..))

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
    | WaitingForUpload Uploading
    | Uploaded Datum


type Uploading
    = WaitingForEncryption Wallet
    | WaitingForCreateAccount Wallet
    | WaitingForMakeImmutable Wallet
    | WaitingForFileUpload Wallet
    | WaitingForMetaDataUpload Wallet
    | WaitingForUrlPublish Wallet


type WaitingForWalletUploader
    = AlmostLoggedIn
    | AlmostHasCatalog AlmostCatalog
