module IncrementExample (..) where

import Html exposing (..)
import Html.Events exposing (..)
import Signal exposing (Signal, Mailbox, mailbox)


{-| The complete Model
-}
type alias Model =
    Int


initalState : Model
initalState =
    0


actionBox : Mailbox Action
actionBox =
    mailbox NoOp


{-| Action Type
-}
type Action
    = Increment
    | Decrement
    | NoOp


{-|
View layer
-}
view : Model -> Html
view count =
    div
        []
        [ div [] [ text ("current state is " ++ toString count) ]
        , button
            [ onClick actionBox.address Increment ]
            [ text "Increment" ]
        , button
            [ onClick actionBox.address Decrement ]
            [ text "Decrement" ]
        ]


{-|
update layers
-}
update : Action -> Model -> Model
update action count =
    case action of
        Increment ->
            count + 1

        Decrement ->
            count - 1

        NoOp ->
            count


state : Signal Model
state =
    Signal.foldp update initalState actionBox.signal



-- main : Signal Html
-- main =
--     Signal.map view state
