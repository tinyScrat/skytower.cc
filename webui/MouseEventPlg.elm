{- MouseEvent Playground
   Get some MouseEvent properties and show them.
-}


module MouseEventPlg exposing (main)

import Browser
import Browser.Events exposing (onMouseDown, onMouseMove, onMouseUp)
import Html exposing (Html, div, h2, li, text, ul)
import Html.Events exposing (onClick, onMouseEnter, onMouseLeave, onMouseOver)
import Json.Decode as D


type alias MousePosition =
    { offsetX : Float
    , offsetY : Float
    , pageX : Float
    , pageY : Float
    }


mousePositionDecoder : D.Decoder MousePosition
mousePositionDecoder =
    D.map4 MousePosition
        (D.field "offsetX" D.float)
        (D.field "offsetY" D.float)
        (D.field "pageX" D.float)
        (D.field "pageY" D.float)


toMousePosition : D.Value -> Msg
toMousePosition value =
    case D.decodeValue mousePositionDecoder value of
        Ok v ->
            OnMouseEvent v

        Err _ ->
            Ignore


type alias Model =
    { title : String
    , description : String
    , mouseState : MouseState
    , mousePos : MousePosition
    }


type MouseState
    = MouseDown
    | MouseUp


type Msg
    = OnMouseEnter String
    | OnMouseLeave String
    | OnMouseOver String
    | OnMouseClick String
    | OnMouseEvent MousePosition
    | Ignore
    | OnMouseDown
    | OnMouseUp
    | OnMouseMoving MousePosition


init : () -> ( Model, Cmd Msg )
init _ =
    let
        mousePos =
            MousePosition 0 0 0 0
    in
    ( Model "MouseEvent Playground" "Playground" MouseUp mousePos, Cmd.none )


view : Model -> Html Msg
view model =
    let
        offset =
            String.concat [ "offset", "(", String.fromFloat model.mousePos.offsetX, ", ", String.fromFloat model.mousePos.offsetY, ")" ]

        page =
            String.concat [ "page", "(", String.fromFloat model.mousePos.pageX, ", ", String.fromFloat model.mousePos.pageY, ")" ]
    in
    div []
        [ h2 [] [ text model.title ]
        , div []
            [ text model.description
            ]
        , ul []
            [ li [] [ text offset ]
            , li [] [ text page ]
            ]
        ]


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        OnMouseEnter str ->
            ( { model | description = str }, Cmd.none )

        OnMouseLeave str ->
            ( { model | description = str }, Cmd.none )

        OnMouseOver str ->
            ( { model | description = str }, Cmd.none )

        OnMouseClick str ->
            ( { model | description = str }, Cmd.none )

        OnMouseEvent pos ->
            ( { model | mousePos = pos }, Cmd.none )

        Ignore ->
            ( { model | description = "ignore" }, Cmd.none )

        OnMouseDown ->
            ( { model | mouseState = MouseDown }, Cmd.none )

        OnMouseUp ->
            ( { model
                | mouseState = MouseUp
                , mousePos =
                    { pageX = 0
                    , pageY = 0
                    , offsetX = 0
                    , offsetY = 0
                    }
              }
            , Cmd.none
            )

        OnMouseMoving pos ->
            ( { model | mousePos = pos }, Cmd.none )


subscriptions : Model -> Sub Msg
subscriptions model =
    case model.mouseState of
        MouseUp ->
            onMouseDown <| D.succeed OnMouseDown

        MouseDown ->
            Sub.batch
                [ onMouseUp <| D.succeed OnMouseUp
                , onMouseMove (D.map OnMouseMoving mousePositionDecoder)
                ]


main : Program () Model Msg
main =
    Browser.element
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }
