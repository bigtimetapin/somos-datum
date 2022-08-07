module Msg.Phantom exposing (FromPhantomMsg(..), ToPhantomMsg(..))


type
    ToPhantomMsg
    -- connection attempt
    = Connect Json


type
    FromPhantomMsg
    -- connection attempt
    = ErrorOnConnection Error


type alias Json =
    String


type alias Error =
    String
