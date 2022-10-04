module Model.AlmostCatalogQuery exposing (AlmostCatalogQuery, Query, decode, parser, toString)

import Dict
import Model.Mint exposing (Mint)
import Url.Parser as UrlParser exposing ((</>), (<?>))
import Url.Parser.Query as Query


type alias AlmostCatalogQuery =
    { mint : Mint
    , encodedUploaderList : String -- list[string] delimited by - to be url parsed
    , query : Query
    }


type alias Query =
    { many : Maybe Bool
    }


decode : String -> List String
decode string =
    String.split "-" string


toString : Query -> String
toString query =
    let
        many =
            case query.many of
                Just True ->
                    "many=1"

                _ ->
                    "many=0"
    in
    String.join
        "&"
        [ many
        ]


parser : UrlParser.Parser (AlmostCatalogQuery -> c) c
parser =
    UrlParser.map AlmostCatalogQuery <| parser_


parser_ : UrlParser.Parser (Mint -> String -> Query -> a) a
parser_ =
    UrlParser.s "download" </> UrlParser.string </> UrlParser.string <?> Query.map Query manyParser


manyParser : Query.Parser (Maybe Bool)
manyParser =
    Query.enum "many" (Dict.fromList [ ( "true", True ), ( "false", False ), ( "1", True ), ( "0", False ) ])
