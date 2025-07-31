module Common.Types
  ( OHLC (..), -- <-- this needs to be added
  )
where

import Data.Aeson
import Data.Time (Day)
import GHC.Generics

data OHLC = OHLC
  { date :: Day,
    open :: Double,
    high :: Double,
    low :: Double,
    close :: Double
  }
  deriving (Show, Eq)

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
