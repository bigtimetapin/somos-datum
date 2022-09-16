module Model.Downloader exposing (Downloader(..), HasWalletDownloader(..), WaitingForWalletDownloader(..))

import Model.AlmostCatalog exposing (AlmostCatalog)
import Model.AlmostDatum exposing (AlmostDatum)
import Model.Catalog exposing (Catalog)
import Model.Datum exposing (Datum)
import Model.Mint exposing (Mint)
import Model.Wallet exposing (Wallet)


type Downloader
    = Top
    | HasWallet HasWalletDownloader
    | WaitingForWallet WaitingForWalletDownloader


type
    HasWalletDownloader
    -- logged in
    = LoggedIn Wallet
      -- selecting download
    | TypingMint Wallet String
    | HasMint Wallet Mint
    | TypingUploaderAddress Wallet Mint String
    | WaitingForCatalog Wallet
    | HasCatalog Wallet Catalog
    | WaitingForDatum Wallet
      -- downloading
    | HasDatum Wallet Datum
    | WaitingForDownload Wallet
    | Unauthorized Wallet Datum
    | Downloaded Wallet Datum


type WaitingForWalletDownloader
    = AlmostLoggedIn
    | AlmostHasCatalog AlmostCatalog
    | AlmostHasDatum AlmostDatum


type alias UploaderAddress =
    String
