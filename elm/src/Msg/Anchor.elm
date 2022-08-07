module Msg.Anchor exposing (FromAnchorMsg(..), ToAnchorMsg(..))

import Model.Mint exposing (Mint)
import Model.Wallet exposing (Wallet)


type ToAnchorMsg
    = UploadAssets Wallet Mint


type alias Price =
    String


type
    FromAnchorMsg
    -- some event success asking for current state
    = GetCurrentState Json
      -- state lookup attempt
    | SuccessOnStateLookup Json


type alias Json =
    String
