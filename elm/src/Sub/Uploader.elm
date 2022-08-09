port module Sub.Uploader exposing (..)

-- senders


port connectAsUploader : () -> Cmd msg


port connectAndGetCatalogAsUploader : Json -> Cmd msg


port getCatalogAsUploader : Json -> Cmd msg


port upload : Json -> Cmd msg



-- listeners


port connectAsUploaderSuccess : (Json -> msg) -> Sub msg


port connectAndGetCatalogAsUploaderSuccess : (Json -> msg) -> Sub msg


port getCatalogAsUploaderSuccess : (Json -> msg) -> Sub msg


port uploadSuccess : (Json -> msg) -> Sub msg


type alias Json =
    String
