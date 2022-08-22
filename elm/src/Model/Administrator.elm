module Model.Administrator exposing (Administrator(..))

import Model.Wallet exposing (Wallet)


type Administrator
    = Top
    | WaitingForWallet
    | HasWallet Wallet
    | WaitingForInitializeTariff Wallet
    | InitializedTariff Wallet
