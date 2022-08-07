module Msg.Msg exposing (Msg(..), resetViewport)

import Browser
import Browser.Dom as Dom
import Msg.Anchor exposing (FromAnchorMsg, ToAnchorMsg)
import Msg.Generic exposing (FromJsMsg, ToJsMsg)
import Msg.Phantom exposing (FromPhantomMsg, ToPhantomMsg)
import Task
import Url


type
    Msg
    -- system
    = NoOp
    | UrlChanged Url.Url
    | LinkClicked Browser.UrlRequest
      -- phantom sub
    | ToPhantom ToPhantomMsg
    | FromPhantom FromPhantomMsg
      -- anchor sub
    | ToAnchor ToAnchorMsg
    | FromAnchor FromAnchorMsg
      -- generic js sub
    | ToJs ToJsMsg
    | FromJs FromJsMsg


resetViewport : Cmd Msg
resetViewport =
    Task.perform (\_ -> NoOp) (Dom.setViewport 0 0)
