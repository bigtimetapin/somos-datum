port module Sub.Generic exposing (..)

-- listeners
port genericError : (String -> msg) -> Sub msg
