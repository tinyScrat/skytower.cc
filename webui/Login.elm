{- Login Form
   Demo the use of HttpOnly cookie

   store the JWT in a Secure HttpOnly cookie

   When making a http request in a browser, it will collect
   all the cookies and put them in "Cookie" reuqest header
   and send them to server.

   Server can set cookie in browser by using "Set-Cookie" in
   http response.

   1. How to get a specific cookie and send it to server?
      Auto sent by borwser when making http request?
-}


port module Login exposing (main)

import Browser
import Html exposing (Html, button, div, form, h1, input, p, text)
import Html.Attributes exposing (name, placeholder, type_, value)
import Html.Events exposing (onClick, onInput, onSubmit)
import Http
import Json.Decode as D
import Json.Encode as E


port sendMessage : String -> Cmd msg


type alias LoginForm =
    { username : String
    , password : String
    }


toJson : LoginForm -> D.Value
toJson form =
    E.object
        [ ( "username", E.string form.username )
        , ( "password", E.string form.password )
        ]


type alias Model =
    { title : String
    , description : String
    , form : LoginForm
    }


type Msg
    = OnSucceeded String
    | OnLoginClicked LoginForm
    | OnFormChanged LoginForm


init : () -> ( Model, Cmd Msg )
init _ =
    ( Model "Login" "Login form" (LoginForm "" ""), Cmd.none )


view : Model -> Html Msg
view model =
    let
        viewInput t p v toMsg =
            input [ type_ t, placeholder p, value v, onInput toMsg ] []

        usernameChanged v =
            LoginForm v model.form.password |> OnFormChanged

        passwordChanged p =
            LoginForm model.form.username p |> OnFormChanged
    in
    div []
        [ h1 [] [ text model.title ]
        , p [] [ text model.description ]
        , form [ onSubmit (OnLoginClicked model.form) ]
            [ viewInput "text" "username" model.form.username usernameChanged
            , viewInput "password" "password" model.form.password passwordChanged
            , input [ type_ "submit", value "Submit" ] []
            ]
        ]


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        OnSucceeded token ->
            ( model, sendMessage token )

        OnLoginClicked form ->
            ( model, sendMessage (form |> toJson |> E.encode 4) )

        OnFormChanged form ->
            ( { model | form = form }, Cmd.none )


main : Program () Model Msg
main =
    Browser.element
        { init = init
        , view = view
        , update = update
        , subscriptions = \_ -> Sub.none
        }
