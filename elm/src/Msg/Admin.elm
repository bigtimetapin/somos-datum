module Msg.Admin exposing (From(..), To(..))

import Model.Wallet exposing (Wallet)


type From
    = Connect
    | InitializeTariff Wallet


type To
    = ConnectSuccess Wallet
    | InitializeTariffSuccess Wallet
