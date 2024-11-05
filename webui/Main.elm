module Main exposing (..)

import Browser
import Html exposing (Html, div, h1, p, text)


type Msg
    = SayHello


type Todo
    = Todo { task : String, description : String }


type AppUser
    = AppUser
        { name : String
        , email : String
        , title : String
        , roles : List String
        }


type alias Model =
    { title : String
    , message : String
    }


view : Model -> Html Msg
view model =
    div []
        [ h1 [] [ text model.title ]
        , p [] [ text model.message ]
        ]


update : Msg -> Model -> Model
update msg model =
    case msg of
        SayHello ->
            model


init : Model
init =
    Model "HH" "Hello, world~"


main : Program () Model Msg
main =
    Browser.sandbox
        { init = init
        , view = view
        , update = update
        }
