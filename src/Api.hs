{-# LANGUAGE DataKinds #-}
{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE TypeOperators #-}

module Api (api, server, API, app) where

import Backtest (runBacktestIO)
import Common.BacktestTypes (BacktestRequest, BacktestResult)
import Control.Monad.IO.Class (liftIO)
import Network.Wai (Application)
import Servant
import Servant (serve)
import Servant.Server

-- Define the API type
type API = "backtest" :> ReqBody '[JSON] BacktestRequest :> Post '[JSON] BacktestResult

-- API proxy
api :: Proxy API
api = Proxy

-- Server handler
server :: Server API
server = handleBacktest

handleBacktest :: BacktestRequest -> Handler BacktestResult
handleBacktest req = liftIO $ runBacktestIO req

-- WAI application
app :: Application
app = serve api server
