port module Todos exposing (main)

import Browser exposing (Document)
import Html exposing (Html, button, div, h1, input, li, text, ul)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Json.Decode as D


{-| Ports
Communite with js
And other stuff
-}
port sendMessage : String -> Cmd msg


{-| this is another port
which is to receive message from js
-}
port messageReceiver : (String -> msg) -> Sub msg


type Msg
    = SayHi
    | DraftChanged String
    | Send
    | Recv String


type alias Model =
    { title : String
    , draft : String
    , messages : List String
    }


init : () -> ( Model, Cmd Msg )
init _ =
    ( Model "Todo" "" [], Cmd.none )


view : Model -> Document Msg
view model =
    let
        title =
            model.title

        body =
            div []
                [ h1 [] [ text "Todo" ]
                , input
                    [ type_ "text"
                    , placeholder "Draft"
                    , onInput DraftChanged
                    , value model.draft
                    ]
                    []
                , button [ onClick Send ] [ text "Send" ]
                , ul [] (model.messages |> List.map (\msg -> li [] [ text msg ]))
                ]
    in
    { title = title
    , body = [ body ]
    }


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        SayHi ->
            ( model, Cmd.none )

        DraftChanged draft ->
            ( { model | draft = draft }, Cmd.none )

        Send ->
            ( model, sendMessage model.draft )

        Recv message ->
            ( { model | messages = model.messages ++ [ message ] }, Cmd.none )


subscriptions : Model -> Sub Msg
subscriptions _ =
    messageReceiver Recv


main : Program () Model Msg
main =
    Browser.document
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }
