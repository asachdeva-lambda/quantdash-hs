{-# LANGUAGE OverloadedStrings #-}

module Main where

import qualified Streaming.JetStream as JS
import qualified Backtest.Conduit as BC
import Data.Conduit ((.|), runConduit)

main :: IO ()
main = do
    let baseUrl = "http://localhost:8222/api/v1" -- Replace with JetStream mgmt API
        consumer = "backtest-consumer"
    runConduit $ JS.jetStreamSource baseUrl consumer .| BC.processMessages

