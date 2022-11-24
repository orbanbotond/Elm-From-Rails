import Browser
import Browser.Navigation as Nav
import Html exposing (..)
import Html.Attributes exposing (..)
import Url
import Url.Parser exposing (Parser, (</>), (<?>), int, map, oneOf, s, string)
import Url.Parser.Query as Query

-- MAIN


main : Program () Model Msg
main =
  Browser.application
    { init = init
    , view = view
    , update = update
    , subscriptions = subscriptions
    , onUrlChange = UrlChanged
    , onUrlRequest = LinkClicked
    }



-- MODEL


type alias Model =
  { key : Nav.Key
  , url : Url.Url
  }


init : () -> Url.Url -> Nav.Key -> ( Model, Cmd Msg )
init flags url key =
  ( Model key url, Cmd.none )



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
      ( { model | url = url }
      , Cmd.none
      )

-- Routes


type Route
  = Home
  | BlogQuery (Maybe String)
  | Profile
  | Reviews String

routeParser : Parser (Route -> a) a
routeParser =
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

--urlInterpretation : Model -> String
--urlInterpretation model =
--  case routeParser of
--    Maybe Home ->
--      "Home"
--    Maybe Profile ->
--      "Profile"
--    Just a ->
--      "Homepage"

view : Model -> Browser.Document Msg
view model =
  { title = "URL Interceptor"
  , body =
      [ div [ id "content" ]
        [ nav [ class "navbar navbar-light bg-faded"]
            [ ul [ class "nav nav-tabs" ]
                [ li [ class "nav-item"]
                    [a [ class "nav-link", href "/activities"]
                       [ text "Erdemnaplo" ] ]
                  ,li [ class "nav-item"]
                    [a [ class "nav-link", href "/kids"]
                       [ text "Gyerekek" ] ]
                ]
            ]
          , text "The current URL is: "
          , b [] [ text (Url.toString model.url) ]
          , div [ class "container"]
              [ div [ class "row"]
                [ div [ class "col-sm"] [ text "One of three columns"]
                 , div [ class "col-sm"] [ text "One of three columns"]
                 , div [ class "col-sm"] [ text "One of three columns"]
                ]
              ]
          , ul []
              [ viewLink "/home"
              , viewLink "/profile"
              , viewLink "/reviews/the-century-of-the-self"
              , viewLink "/reviews/public-opinion"
              , viewLink "/reviews/shah-of-shahs"
              ]
        ]
      ]
  }

viewLink : String -> Html msg
viewLink path =
  li [] [ a [ href path ] [ text path ] ]
