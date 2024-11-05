module HelloForms exposing (..)

import Browser
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onInput)


type alias Model =
    { name : String
    , password : String
    , passwordAgain : String
    }


type Msg
    = Name String
    | Password String
    | PasswordAgain String


init : Model
init =
    Model "" "" ""


viewInput : String -> String -> String -> (String -> msg) -> Html msg
viewInput t p v toMsg =
    div []
        [ label []
            [ text p
            , input [ type_ t, placeholder p, value v, onInput toMsg ] []
            ]
        ]


viewValidation : Model -> Html Msg
viewValidation model =
    let
        error msg =
            div [ style "color" "red" ] [ text msg ]

        valid pwd =
            let
                chars =
                    String.toList pwd
            in
            [ List.any Char.isUpper, List.any Char.isLower, List.any Char.isDigit ]
                |> List.map (\f -> f chars)
                |> List.all identity
    in
    if model.password == model.passwordAgain then
        if String.isEmpty model.password then
            div [] []

        else if String.length model.password <= 8 then
            error "Password must be longer than 8 characters"

        else if valid model.password then
            div [ style "color" "green" ] [ text "OK" ]

        else
            error "Password must contain upper case, lower case letters and digits"

    else
        error "Passwords do not match"


view : Model -> Html Msg
view model =
    div []
        [ viewInput "text" "Name" model.name Name
        , viewInput "password" "Password" model.password Password
        , viewInput "password" "Re-enter Password" model.passwordAgain PasswordAgain
        , viewValidation model
        ]


update : Msg -> Model -> Model
update msg model =
    case msg of
        Name name ->
            { model | name = name }

        Password password ->
            { model | password = password }

        PasswordAgain password ->
            { model | passwordAgain = password }


main : Program () Model Msg
main =
    Browser.sandbox
        { init = init
        , view = view
        , update = update
        }
