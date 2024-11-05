port module Worker exposing (..)

import Json.Decode as D
import Json.Encode as E
import Platform


port sendResult : E.Value -> Cmd msg


port cmdReceiver : (Int -> msg) -> Sub msg


type alias Command =
    { cmd : String
    , data : Int
    }



-- Decoder


commandDecoder : D.Decoder Command
commandDecoder =
    D.map2 Command
        (D.field "cmd" D.string)
        (D.field "data" D.int)


type alias Result =
    { data : Int
    }



-- Encoder


resultEncoder : Result -> E.Value
resultEncoder result =
    E.object
        [ ( "result", E.int result.data ) ]


type alias Model =
    Int


type Msg
    = Add Int
    | Subt Int


init : Int -> ( Model, Cmd Msg )
init n =
    ( n, Cmd.none )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Add n ->
            let
                result =
                    model + n
            in
            ( result, resultEncoder { data = result } |> sendResult )

        Subt n ->
            let
                result =
                    model - n
            in
            ( result, resultEncoder { data = result } |> sendResult )


subscriptions : Model -> Sub Msg
subscriptions model =
    if model > 10 then
        cmdReceiver Subt

    else
        cmdReceiver Add


main : Program Int Model Msg
main =
    Platform.worker
        { init = init
        , update = update
        , subscriptions = subscriptions
        }
