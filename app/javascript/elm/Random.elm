-- Press a button to generate a random number between 1 and 6.
--
-- Read how it works:
--   https://guide.elm-lang.org/effects/random.html
--

import Browser
import Html exposing (..)
import Html.Events exposing (..)
import Random

-- Custom Spin Generator
type Symbol = Cherry | Seven | Bar | Grapes

symbol_generator : Random.Generator Symbol
symbol_generator =
  Random.uniform Cherry [ Seven, Bar, Grapes ]

spin : Random.Generator Model
spin =
  Random.map3 Model symbol_generator symbol_generator symbol_generator
--

-- MAIN
main =
  Browser.element
    { init = init
    , update = update
    , subscriptions = subscriptions
    , view = view
    }

-- MODEL
type alias Model =
  { one : Symbol
  , two : Symbol
  , three : Symbol
  }

init : () -> (Model, Cmd Msg)
init _ =
  ( Model Cherry Cherry Cherry
  , Cmd.none
  )

-- UPDATE
type Msg
  = Roll
  | NewSpin Model

update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    Roll ->
      ( model
      , Random.generate NewSpin spin
      )

    NewSpin newSpin ->
      ( newSpin
      , Cmd.none
      )

-- Random.generate NewSpin spin

-- SUBSCRIPTIONS
subscriptions : Model -> Sub Msg
subscriptions model =
  Sub.none

-- VIEW
symbolToString : Symbol -> String
symbolToString symbol =
  case symbol of
    Cherry -> 
      "Cherry"
    Seven ->
      "Seven"
    Bar ->
      "Bar"
    Grapes ->
      "Grapes"

win : Model -> Bool
win model = 
  (model.one == model.two) && (model.two == model.three)

display : Model -> String
display model =
  [model.one, model.two, model.three] |> List.map symbolToString |> String.join "|"

displayWin : Model -> String
displayWin model =
  if win(model) then "Ding Ding" else "Nope"

view : Model -> Html Msg
view model =
  div []
    [ h1 [] [ text ( display model) ]
    , h1 [] [ text ( "Winner:" ++ displayWin(model)) ]
    , button [ onClick Roll ] [ text "Roll" ]
    ]
