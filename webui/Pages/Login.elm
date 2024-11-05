module Pages.Login exposing (..)

import Dict
import Html exposing (Html, div, form, h3, input, label, text)
import Html.Attributes exposing (type_, value)
import Html.Events exposing (onClick, onInput)
import Http
import Json.Encode as E


type alias LoginForm =
    { username : String
    , password : String
    }


toJsonValue : LoginForm -> E.Value
toJsonValue model =
    Dict.fromList
        [ ( "username", model.username )
        , ( "password", model.password )
        ]
        |> E.dict identity E.string


type Msg
    = OnSubmit
    | UsernameChanged String
    | PasswordChanged String
    | GotToken (Result Http.Error String)


init : Cmd Msg
init =
    Cmd.none


view : LoginForm -> Html Msg
view model =
    div []
        [ h3 [] [ text "Login" ]
        , form []
            [ div []
                [ label [] [ text "username" ]
                , input [ type_ "text", value model.username, onInput UsernameChanged ] []
                ]
            , div []
                [ label [] [ text "password" ]
                , input [ type_ "password", value model.password, onInput PasswordChanged ] []
                ]
            , input [ type_ "submit", value "Submit", onClick OnSubmit ] []
            ]
        ]


update : Msg -> LoginForm -> ( LoginForm, Cmd Msg )
update msg model =
    case msg of
        OnSubmit ->
            ( model, login model )

        UsernameChanged username ->
            ( { model | username = username }, Cmd.none )

        PasswordChanged password ->
            ( { model | password = password }, Cmd.none )

        GotToken token ->
            -- store token and redirect to different page?
            ( model, Cmd.none )


login : LoginForm -> Cmd Msg
login model =
    Http.post
        { url = "https://example.com/login"
        , body = Http.jsonBody <| toJsonValue model
        , expect = Http.expectString GotToken
        }
