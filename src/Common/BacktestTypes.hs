-- src/Common/BacktestTypes.hs
module Common.BacktestTypes where

import Data.Aeson
import GHC.Generics

data BacktestRequest = BacktestRequest
  { ticker :: String,
    strategy :: String
  }
  deriving (Generic, Show)

instance FromJSON BacktestRequest

data BacktestResult = BacktestResult
  { totalReturn :: Double,
    tradeCount :: Int
  }
  deriving (Generic, Show)

instance ToJSON BacktestResult
