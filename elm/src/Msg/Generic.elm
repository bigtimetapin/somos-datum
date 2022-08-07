module Msg.Generic exposing (FromJsMsg(..))

type FromJsMsg
    -- error
    = Error String
