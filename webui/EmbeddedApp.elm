port module EmbeddedApp exposing (main)

import Browser exposing (Document)
import Html exposing (button, div, h1, p, text)
import Html.Events exposing (onClick)


port sendMessage : Int -> Cmd msg


port messageReceiver : (String -> msg) -> Sub msg


type alias Model =
    { title : String
    , description : String
    , count : Int
    }


type Msg
    = OnClicked Int
    | GotMessage String


init : () -> ( Model, Cmd Msg )
init _ =
    ( Model "EmbedApp" "This is an embedded app run inside an iframe" 0, Cmd.none )


view : Model -> Document Msg
view model =
    let
        title =
            model.title

        body =
            [ h1 [] [ text title ]
            , div []
                [ p [] [ text model.description ]
                , button [ onClick (OnClicked <| model.count + 1) ] [ text "Click Me" ]
                ]
            ]
    in
    { title = title
    , body = body
    }


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        OnClicked count ->
            ( { model | count = count }, sendMessage count )

        GotMessage message ->
            ( { model | description = message }, Cmd.none )


subscriptions : Model -> Sub Msg
subscriptions _ =
    messageReceiver GotMessage


main : Program () Model Msg
main =
    Browser.document
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }
