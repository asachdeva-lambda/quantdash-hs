{-# LANGUAGE DeriveGeneric #-}

module Common.Types where

import Data.Aeson
import GHC.Generics

data BacktestRequest = BacktestRequest
  { ticker :: String,
    strategy :: String
  }
  deriving (Show, Generic)

instance FromJSON BacktestRequest

data BacktestResult = BacktestResult
  { totalReturn :: Double,
    trades :: Int
  }
  deriving (Show, Generic)

instance ToJSON BacktestResult
