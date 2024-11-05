{- Show user's profile,
   including username, email, date of signup, etc.
-}


module Pages.Profile exposing (..)

import Html exposing (Html, div, h3, text)
import Time exposing (Posix)


type alias Model =
    { username : String
    , email : String
    , date : Posix
    }


init : String -> String -> Posix -> Model
init username email date =
    { username = username
    , email = email
    , date = date
    }


view : Model -> Html msg
view model =
    div []
        [ h3 [] [ text "User Profile" ]
        , div [] [ text model.username ]
        , div [] [ text model.email ]
        , div [] [ String.fromInt >> text <| Time.toYear Time.utc model.date ]
        ]
