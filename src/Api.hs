-- src/Api.hs
{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE DataKinds #-}
{-# LANGUAGE TypeOperators #-}

module Api (app) where

import Servant
import GHC.Generics
import Network.Wai
import Data.Aeson
import Backtest (runBacktest)

data BacktestRequest = BacktestRequest
  { ticker :: String
  , strategy :: String
  } deriving (Show, Generic)

instance FromJSON BacktestRequest

data BacktestResult = BacktestResult
  { totalReturn :: Double
  , trades      :: Int
  } deriving (Show, Generic)

instance ToJSON BacktestResult

type API = "backtest" :> ReqBody '[JSON] BacktestRequest :> Post '[JSON] BacktestResult

server :: Server API
server = handler
  where
    handler req = pure $ runBacktest req

app :: Application
app = serve (Proxy :: Proxy API) server

