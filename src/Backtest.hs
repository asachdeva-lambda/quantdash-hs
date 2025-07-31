module Backtest (runBacktestIO) where

import Common.BacktestTypes
import Common.Types (OHLC)
import Conduit
import Strategy.MA (runMAStrategy)

-- Accept a Conduit source of OHLC data
runBacktestIO :: (MonadIO m) => ConduitT () OHLC m () -> BacktestRequest -> m BacktestResult
runBacktestIO ohlcStream req = do
  ohlcData <- runConduit $ ohlcStream .| sinkList
  let result = runMAStrategy ohlcData req
  return result
