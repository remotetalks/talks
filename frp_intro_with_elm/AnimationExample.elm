module AnimationExample (..) where

import Html.Attributes exposing (style)
import Html.Events exposing (onClick)
import Html exposing (..)
import Signal exposing (Signal, Mailbox)
import Animation exposing (Animation)
import Time exposing (Time)
import Mouse
import Debug


type Action
    = Target
    | Position ( Int, Int )
    | Tick Time
    | NoOp


type alias Model =
    { mousePos : ( Int, Int )
    , animation : ( Animation, Animation )
    , position : ( Float, Float )
    , clock : Time
    }


initialState : Model
initialState =
    { mousePos = ( 0, 0 )
    , animation = ( Animation.static 0, Animation.static 0 )
    , position = ( 0, 0 )
    , clock = 0
    }


actionBox : Mailbox Action
actionBox =
    Signal.mailbox NoOp


blueBox : ( Float, Float ) -> Html
blueBox ( x, y ) =
    div
        [ style
            [ ( "position", "absolute" )
            , ( "top", toString y ++ "px" )
            , ( "left", toString x ++ "px" )
            , ( "height", "100px" )
            , ( "width", "100px" )
            , ( "background", "blue" )
            ]
        , onClick actionBox.address Target
        ]
        [ text "Wowzers!" ]


view : Model -> Html
view { position } =
    div
        [ style
            [ ( "position", "absolute" )
            , ( "top", "0" )
            , ( "left", "0" )
            , ( "height", "100%" )
            , ( "width", "100%" )
            ]
        , onClick actionBox.address Target
        ]
        [ blueBox position ]


update : Action -> Model -> Model
update action model =
    case action of
        Position xy ->
            { model | mousePos = xy }

        Target ->
            let
                ( animX, animY ) = model.animation

                ( posX, posY ) = model.mousePos

                retarget = Animation.retarget model.clock
            in
                { model
                    | animation =
                        ( retarget (toFloat posX) animX
                        , retarget (toFloat posY) animY
                        )
                }

        Tick now ->
            let
                ( animX, animY ) = model.animation

                clock = now + model.clock
            in
                { model
                    | clock = clock
                    , position =
                        ( Animation.animate clock animX
                        , Animation.animate clock animY
                        )
                }

        NoOp ->
            model


clock : Signal Action
clock =
    Time.fps 30
        |> Signal.map Tick


mousePos : Signal Action
mousePos =
    Mouse.position
        |> Signal.map Position


main : Signal Html
main =
    Signal.mergeMany [ clock, mousePos, actionBox.signal ]
        |> Signal.map (Debug.watch "Action")
        |> Signal.foldp update initialState
        |> Signal.map view
