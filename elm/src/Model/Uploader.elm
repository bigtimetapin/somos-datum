module Model.Uploader exposing (HasWalletUploader(..), Uploader(..), WaitingForWalletUploader(..))

import Model.AlmostCatalog exposing (AlmostCatalog)
import Model.Catalog exposing (Catalog)
import Model.Datum exposing (Datum)
import Model.Mint exposing (Mint)
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
    | HasMint Wallet Mint
    | WaitingForUpload Wallet
    | Uploaded Wallet Datum
      -- viewing uploads
    | WaitingForCatalog Wallet
    | HasCatalog Catalog


type WaitingForWalletUploader
    = AlmostHasDatum Datum
    | AlmostHasCatalog AlmostCatalog
