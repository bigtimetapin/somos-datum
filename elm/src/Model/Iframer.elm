module Model.Iframer exposing (Iframer)

import Model.Downloader exposing (Downloader)
import Model.Uploader exposing (Uploader)


type Iframer
    = Upload Uploader
    | Download Downloader
