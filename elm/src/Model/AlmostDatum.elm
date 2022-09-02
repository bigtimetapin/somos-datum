module Model.AlmostDatum exposing (AlmostDatum, encode, fromCatalog, fromDatum, parser)

import Json.Encode as Encode
import Model.Catalog exposing (Catalog)
import Model.Datum exposing (Datum)
import Model.Mint exposing (Mint)
import Model.Wallet exposing (Wallet)
import Url.Parser as UrlParser exposing ((</>))


type alias AlmostDatum =
    { mint : Mint
    , uploader : Wallet
    , increment : Increment
    }


type alias Increment =
    Int



{- increments -}


fromCatalog : Catalog -> AlmostDatum
fromCatalog catalog =
    { mint = catalog.mint
    , uploader = catalog.uploader
    , increment = catalog.increment + 1
    }



{- drops meta-data -}


fromDatum : Datum -> AlmostDatum
fromDatum datum =
    { mint = datum.mint
    , uploader = datum.uploader
    , increment = datum.increment
    }


encode : AlmostDatum -> String
encode datum =
    let
        encoder =
            Encode.object
                [ ( "mint", Encode.string datum.mint )
                , ( "uploader", Encode.string datum.uploader )
                , ( "increment", Encode.int datum.increment )
                ]
    in
    Encode.encode 0 encoder


parser : UrlParser.Parser (AlmostDatum -> c) c
parser =
    UrlParser.map AlmostDatum parser_


parser_ : UrlParser.Parser (Mint -> Wallet -> Increment -> a) a
parser_ =
    UrlParser.s "download" </> UrlParser.string </> UrlParser.string </> UrlParser.int
