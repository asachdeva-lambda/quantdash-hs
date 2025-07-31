{-# LANGUAGE OverloadedStrings #-}

module Api (app) where

import Backtest (runBacktestIO)
import Common.BacktestTypes
import Network.Wai (Application)
import Servant
import Servant.Server
import Streaming.JetStream (jetStreamOHLCSource)

-- API Type
type API = "backtest" :> ReqBody '[JSON] BacktestRequest :> Post '[JSON] BacktestResult

server :: Server API
server = backtestHandler

-- Handler that streams OHLC data from JetStream
backtestHandler :: BacktestRequest -> Handler BacktestResult
backtestHandler req = liftIO $ runBacktestIO jetStreamOHLCSource req

app :: Application
app = serve (Proxy :: Proxy API) server

-- WAI application
app :: Application
app = serve api server
