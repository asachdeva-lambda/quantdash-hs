-- app/Main.hs
module Main where

import Api (app)
import Network.Wai.Handler.Warp (run)

main :: IO ()
main = do
  putStrLn "🚀 QuantDash Haskell backend running on http://localhost:8080"
  run 8080 app
