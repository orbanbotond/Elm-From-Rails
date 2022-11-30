import Browser
import Browser.Navigation as Nav
import Html exposing (..)
import Html.Attributes exposing (..)
import Url
import Url.Parser exposing (Parser, (</>), (<?>), int, map, oneOf, s, string)
import Url.Parser.Query as Query
--import Page.Home exposing (content)

-- MAIN

main : Program () Model Msg
main =
  Browser.application
    { init = init
    , update = update
    , view = view
    , subscriptions = subscriptions
    , onUrlChange = UrlChanged
    , onUrlRequest = LinkClicked
    }

-- MODEL

type alias Model =
  { key : Nav.Key
  , route : Maybe Route
  }

init : () -> Url.Url -> Nav.Key -> ( Model, Cmd Msg )
init flags url navKey =
  ( { key = navKey, route = Url.Parser.parse urlParser url }, Cmd.none )

-- UPDATE

type Msg
  = LinkClicked Browser.UrlRequest
  | UrlChanged Url.Url

update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
  case msg of
    LinkClicked urlRequest ->
      case urlRequest of
        Browser.Internal url ->
          ( model, Nav.pushUrl model.key (Url.toString url) )

        Browser.External href ->
          ( model, Nav.load href )

    UrlChanged url ->
      ( { model | route = Url.Parser.parse urlParser url }
      , Cmd.none
      )

-- Routes

type Route
  = Home
  | BlogQuery (Maybe String)
  | Profile
  | Reviews String

urlParser : Parser (Route -> a) a
urlParser =
  oneOf
    [ Url.Parser.map Home  ( Url.Parser.s "home")
    , Url.Parser.map Profile  ( Url.Parser.s "profile")
    , Url.Parser.map Reviews  ( Url.Parser.s "reviews" </> string)
    ]

-- SUBSCRIPTIONS

subscriptions : Model -> Sub Msg
subscriptions _ =
  Sub.none

-- VIEW

view : Model -> Browser.Document Msg
view model =
  let
    title =
      case model.route of
        Just route ->
          case route of
            Home ->
              "Home"
            BlogQuery seourl ->
              "BlogQuery"
            Profile ->
              "Profile"
            Reviews seourl ->
              "Reviews"

        Nothing ->
          "Invalid route"
  in
  { title = "URL Interceptor"
  , body =
      [ div [ id "content" ]
        [ nav [ class "navbar navbar-light bg-faded"]
            [ ul [ class "nav nav-tabs" ]
                [ navBarLink "/home" "Home"
                  ,navBarLink "/profile" "Profile"
                  ,navBarLink "/reviews/the-first-elm-app" "First Elm App"
                ]
            ]
          , text "The current URL is: "
          , b [] [ text title ]
          , div [ class "container"]
              [ div [ class "row"]
                [ div [ class "col-sm"] [ text "One of three columns"]
                 , div [ class "col-sm"] [ text "One of three columns"]
                 , div [ class "col-sm"] [ text "One of three columns"]
                ]
              ]
        ]
      ]
  }

viewLink : String -> Html msg
viewLink path =
  li [] [ a [ href path ] [ text path ] ]

navBarLink : String -> String -> Html msg
navBarLink path display =
  li [ class "nav-item"] [a [ class "nav-link", href path]
           [ text display ] ]
