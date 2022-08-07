port module Sub.Phantom exposing (..)

-- senders


port connectSender : String -> Cmd msg



-- listeners


port connectFailureListener : (String -> msg) -> Sub msg
