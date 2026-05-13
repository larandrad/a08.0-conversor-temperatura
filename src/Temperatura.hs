module Temperatura (main, converteTemperatura) where

import Data.Maybe (fromJust, isNothing)
import System.IO (BufferMode (NoBuffering), hSetBuffering, stdout)
import Text.Printf (printf)
import Text.Read (readMaybe)

converteTemperatura :: Double -> Maybe (Double, Double)
converteTemperatura celsius =
  undefined

main :: IO ()
main =
  undefined
