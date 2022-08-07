port module Sub.Uploader exposing (..)

-- senders


port connectAsUploader : () -> Cmd msg

port connectAndGetDatumAsUploader : Json -> Cmd msg

port getCatalogAsUploader : Json -> Cmd msg

port upload : Json -> Cmd msg


-- listeners


port connectAsUploaderSuccess : (Json -> msg) -> Sub msg

port connectAndGetDatumAsUploaderSuccess : (Json -> msg) -> Sub msg

port uploadSuccess : (Json -> msg) -> Sub msg

type alias Json = String
