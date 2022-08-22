port module Sub.Admin exposing (..)

import Model.Wallet exposing (Wallet)



-- senders


port connectAsAdmin : () -> Cmd msg


port initializeTariff : () -> Cmd msg



-- listeners


port connectAsAdminSuccess : (Wallet -> msg) -> Sub msg


port initializeTariffSuccess : (Wallet -> msg) -> Sub msg
