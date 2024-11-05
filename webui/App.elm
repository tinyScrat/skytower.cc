module App exposing (main)

import Browser exposing (Document, UrlRequest(..))
import Browser.Navigation as Nav exposing (Key)
import Html exposing (div, h1, text)
import Pages.Login as Login
import Pages.Profile as Profile
import Url exposing (Url)


{-| Wrapper for the model of each page
-}
type Page
    = LoginPage Login.LoginForm
    | ProfilePage Profile.Model
    | NotFoundPage


type Route
    = HomeRoute
    | ProfileRoute


{-| This is the model of the app. Add necessary fields
as you see fit.

    sorter =
        decreaseBy 9

-}
type alias Model =
    { title : String
    , description : String
    , origin : String
    , key : Key
    , page : Page
    }


type Msg
    = OnUrlRequested UrlRequest
    | OnUrlChanged Url
    | OnLoaded
    | OnLoginPage Login.Msg


{-| This is the init function.
The second line of the comment.
What about this line?

    list : Int
    list =
        1

-}
init : String -> Url -> Key -> ( Model, Cmd Msg )
init origin url key =
    -- parse the url and go to the corresponding page
    ( Model "App" "Elm App" origin key NotFoundPage, Cmd.none )


view : Model -> Document Msg
view model =
    let
        title =
            model.title

        body =
            [ h1 [] [ text title ]
            , div [] [ text model.description ]
            ]
    in
    { title = title
    , body = body
    }


{-| That is great
Now I want to learn more
-}
update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        OnUrlRequested urlRequest ->
            case urlRequest of
                Internal url ->
                    ( model, Nav.pushUrl model.key (Url.toString url) )

                External href ->
                    ( model, Nav.load href )

        OnUrlChanged url ->
            -- route to different page based on url
            ( model, Cmd.none )

        OnLoaded ->
            ( model, Cmd.none )

        OnLoginPage loginMsg ->
            case model.page of
                LoginPage loginModel ->
                    let
                        ( loginForm, cmd ) =
                            Login.update loginMsg loginModel
                    in
                    ( { model | page = LoginPage loginForm }, Cmd.map OnLoginPage cmd )

                _ ->
                    ( model, Cmd.none )


subscriptions : Model -> Sub Msg
subscriptions _ =
    Sub.none


main : Program String Model Msg
main =
    Browser.application
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        , onUrlRequest = OnUrlRequested
        , onUrlChange = OnUrlChanged
        }
