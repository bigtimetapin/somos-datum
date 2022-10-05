port module Sub.Downloader exposing (..)

-- sender


port connectAsDownloader : () -> Cmd msg


port connectAndGetManyCatalogsAsDownloader : Json -> Cmd msg


port connectAndGetDatumAsDownloader : Json -> Cmd msg


port getCatalogAsDownloader : Json -> Cmd msg


port getDatumAsDownloader : Json -> Cmd msg


port download : Json -> Cmd msg



-- listeners


port connectAsDownloaderSuccess : (String -> msg) -> Sub msg


port connectAndGetCatalogAsDownloaderSuccess : (Json -> msg) -> Sub msg


port connectAndGetManyCatalogsAsDownloaderSuccess : (Json -> msg) -> Sub msg


port connectAndGetDatumAsDownloaderSuccess : (Json -> msg) -> Sub msg


port unauthorized : (String -> msg) -> Sub msg


port downloadSuccess : (String -> msg) -> Sub msg


type alias Json =
    String
