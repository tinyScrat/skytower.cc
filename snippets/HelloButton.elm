module HelloButton exposing (main)

import Browser
import Html exposing (Html, br, button, div, text)
import Html.Events exposing (onClick)


type alias Model =
    Int


type Msg
    = Increment Int
    | Decrement
    | Reset


init : Int
init =
    0


view : Model -> Html Msg
view model =
    div []
        [ button [ onClick (Increment 1) ] [ text "+" ]
        , div [] [ text (String.fromInt model) ]
        , button [ onClick Decrement ] [ text "-" ]
        , br [] []
        , button [ onClick Reset ] [ text "Reset" ]
        , br [] []
        , button [ onClick (Increment 10) ] [ text "+ 10" ]
        ]


update : Msg -> Model -> Model
update msg model =
    case msg of
        Increment amount ->
            model + amount

        Decrement ->
            model - 1

        Reset ->
            0


main : Program () Model Msg
main =
    Browser.sandbox
        { init = init
        , view = view
        , update = update
        }
