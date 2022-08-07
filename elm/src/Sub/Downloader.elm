port module Sub.Downloader exposing (..)

-- sender


port connectAsDownloader : () -> Cmd msg

port connectAndGetCatalogAsDownloader : Json -> Cmd msg

port connectAndGetDatumAsDownloader : Json -> Cmd msg

port getCatalogAsDownloader : Json -> Cmd msg

port download : Json -> Cmd msg



-- listeners


port connectAsDownloaderSuccess : (String -> msg) -> Sub msg

port connectAndGetCatalogAsDownloaderSuccess : (String -> msg) -> Sub msg

port connectAndGetDatumAsDownloaderSuccess : (String -> msg) -> Sub msg

port getCatalogAsDownloaderSuccess : (String -> msg) -> Sub msg

port downloadSuccess : (String -> msg) -> Sub msg

type alias Json = String
