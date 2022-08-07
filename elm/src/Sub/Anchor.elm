port module Sub.Anchor exposing (..)

-- senders


port uploadAssetsSender : String -> Cmd msg


port getCurrentStateSender : String -> Cmd msg



-- listeners


port getCurrentStateListener : (String -> msg) -> Sub msg


port getCurrentStateSuccessListener : (String -> msg) -> Sub msg
