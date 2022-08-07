port module Sub.Generic exposing (..)

-- senders


port downloadSender : String -> Cmd msg


port getCatalogSender : String -> Cmd msg



-- listeners


port downloadSuccessListener : (String -> msg) -> Sub msg


port getCatalogSuccessListener : (String -> msg) -> Sub msg


port genericErrorListener : (String -> msg) -> Sub msg
