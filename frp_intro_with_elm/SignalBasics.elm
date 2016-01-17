module Main (..) where

import Signal exposing (..)
import Graphics.Element exposing (show, Element)
import Mouse


position : Signal ( Int, Int )
position =
    Mouse.position


view : ( Int, Int ) -> Element
view ( x, y ) =
    if y < 50 then
        show "Its High!"
    else if y > 200 then
        show "Its Low!"
    else
        show ( x, y )


main : Signal Element
main =
    Signal.map view position
