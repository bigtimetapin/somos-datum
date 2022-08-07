module Sub.Sub exposing (subs)

import Msg.Anchor exposing (FromAnchorMsg(..))
import Msg.Generic as GenericMsg
import Msg.Msg exposing (Msg(..))
import Msg.Phantom exposing (FromPhantomMsg(..))
import Sub.Anchor exposing (..)
import Sub.Generic exposing (..)
import Sub.Phantom exposing (..)


subs : Sub Msg
subs =
    Sub.batch
        [ -- phantom connect
          connectFailureListener
            (\error ->
                FromPhantom (ErrorOnConnection error)
            )

        -- anchor get current state
        , getCurrentStateListener
            (\jsonString ->
                FromAnchor (GetCurrentState jsonString)
            )

        -- anchor get current state attempt
        , getCurrentStateSuccessListener
            (\jsonString ->
                FromAnchor (SuccessOnStateLookup jsonString)
            )

        -- generic download success
        , downloadSuccessListener
            (\jsonString ->
                FromJs <| GenericMsg.DownloadSuccess jsonString
            )

        -- generic get catalog success
        , getCatalogSuccessListener
            (\jsonString ->
                FromJs <| GenericMsg.GetCatalogSuccess jsonString
            )

        -- generic error
        , genericErrorListener
            (\error ->
                FromJs <| GenericMsg.Error error
            )
        ]
