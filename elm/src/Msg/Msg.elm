module Msg.Msg exposing (Msg(..), resetViewport)

import Browser
import Browser.Dom as Dom
import Msg.Admin as Admin
import Msg.Downloader as Downloader
import Msg.Generic exposing (FromJsMsg)
import Msg.Uploader as Uploader
import Task
import Url


type
    Msg
    -- system
    = NoOp
    | UrlChanged Url.Url
    | LinkClicked Browser.UrlRequest
      -- uploader sub
    | FromUploader Uploader.From
    | ToUploader Uploader.To
      -- downloader sub
    | FromDownloader Downloader.From
    | ToDownloader Downloader.To
      -- admin sub
    | FromAdmin Admin.From
    | ToAdmin Admin.To
      -- generic js sub
    | FromJs FromJsMsg


resetViewport : Cmd Msg
resetViewport =
    Task.perform (\_ -> NoOp) (Dom.setViewport 0 0)
