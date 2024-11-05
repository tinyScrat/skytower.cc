module OnDemo exposing (..)

import Browser
import Html exposing (Html, div, text)
import Html.Events exposing (on)
import Json.Decode as D


type alias MousePosition =
    { pageX : Float
    , pageY : Float
    }


type alias Model =
    { title : String
    , pos : MousePosition
    }


type Msg
    = OnMove MousePosition


mousePositionDecoder : D.Decoder Msg
mousePositionDecoder =
    D.map2 (MousePosition << OnMove)
        (D.field "pageX" D.float)
        (D.field "pageY" D.float)


init : () -> ( Model, Cmd Msg )
init _ =
    ( Model "onDemo" (MousePosition 0 0), Cmd.none )


view : Model -> Html Msg
view model =
    div [ on "mousemove" mousePositionDecoder ] [ text "GG" ]


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        OnMove pos ->
            ( model, Cmd.none )


main : Program () Model Msg
main =
    Browser.element
        { init = init
        , view = view
        , update = update
        , subscriptions = \_ -> Sub.none
        }
