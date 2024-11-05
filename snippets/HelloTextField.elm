module HelloTextField exposing (main)

import Browser
import Html exposing (Attribute, Html, div, input, text)
import Html.Attributes exposing (..)
import Html.Events exposing (onInput)
import Utils.ReaderM as RM exposing (ReaderM)


type alias Model =
    { content : String
    }


type Msg
    = Change String


init : Model
init =
    { content = ""
    }


view : Model -> Html Msg
view model =
    div []
        [ input [ placeholder "Text to reverse", value model.content, onInput Change ] []
        , div [] [ text (String.reverse model.content) ]
        , div [] [ text ("Length: " ++ (String.length model.content |> String.fromInt)) ]
        ]


update : Msg -> Model -> Model
update msg model =
    let
        m =
            RM.ReaderM String.toUpper
    in
    case msg of
        Change newContent ->
            { model | content = RM.run newContent m }


main : Program () Model Msg
main =
    Browser.sandbox
        { init = init
        , view = view
        , update = update
        }
