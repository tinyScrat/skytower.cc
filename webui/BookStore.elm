{- Book Store
   For managing books.

   1. Display a list of books in a table.
-}


module BookStore exposing (main)

import Browser
import Browser.Dom as Dom
import Html exposing (Html, caption, table, tbody, td, text, th, thead, tr)
import Html.Events exposing (onClick)
import Http
import Json.Decode as D
import Task
import Time exposing (utc)


type alias Book =
    { isbn : String
    , name : String
    , edition : Int
    , publish : Time.Posix
    , authors : List String
    }


posixTimeDecoder : D.Decoder Time.Posix
posixTimeDecoder =
    D.map Time.millisToPosix D.int


bookDecoder : D.Decoder Book
bookDecoder =
    D.map5 Book
        (D.field "isbn" D.string)
        (D.field "name" D.string)
        (D.field "edition" D.int)
        (D.field "publish" posixTimeDecoder)
        (D.field "authors" <| D.list D.string)


type alias Store =
    { name : String
    , books : List Book
    , origin : String
    }


type Msg
    = Loaded (Result Http.Error (List Book))
    | NewTime Time.Posix
    | Focus (Result Dom.Error ())


getBooks : String -> Cmd Msg
getBooks origin =
    Http.get
        { url = String.concat [ origin, "/data/books.json" ]
        , expect = Http.expectJson Loaded (D.list bookDecoder)
        }


getNewTime : Cmd Msg
getNewTime =
    Task.perform NewTime Time.now


focus : Cmd Msg
focus =
    Task.attempt Focus (Dom.focus "my-app-search-box")


init : String -> ( Store, Cmd Msg )
init origin =
    ( Store "My Books" [] origin, getBooks origin )


view : Store -> Html Msg
view model =
    let
        row book =
            tr []
                [ th [] [ text book.isbn ]
                , td [] [ text book.name ]
                , td [] [ book.edition |> String.fromInt |> text ]
                , td [] [ book.publish |> Time.toYear utc |> Debug.log "year" |> String.fromInt |> text ]
                , td [] [ book.authors |> String.join "," |> text ]
                ]
    in
    table []
        [ caption [] [ text model.name ]
        , thead []
            [ tr []
                [ th [] [ text "ISBN" ]
                , th [] [ text "Name" ]
                , th [] [ text "Edition" ]
                , th [] [ text "Publish" ]
                , th [] [ text "Authors" ]
                ]
            ]
        , tbody [] (model.books |> List.map (Debug.log "book" >> row))
        ]


update : Msg -> Store -> ( Store, Cmd Msg )
update msg model =
    case msg of
        Loaded result ->
            case result of
                Ok books ->
                    ( { model | books = books }, Cmd.none )

                Err _ ->
                    ( model, Cmd.none )

        NewTime _ ->
            ( model, Cmd.none )

        _ ->
            Debug.todo "Handle the rest of message"


main : Program String Store Msg
main =
    Browser.element
        { init = init
        , view = view
        , update = update
        , subscriptions = \_ -> Sub.none
        }
