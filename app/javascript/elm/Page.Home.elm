module Page.Home exposing (content)

import Html exposing (..)
import Html.Attributes exposing (..)

-- VIEW

content : Model -> Html msg
content model =
      [ div [ id "content" ] [ text "Home Page"] ]
