module Backtest (runBacktest, runBacktestIO) where

import Common.BacktestTypes
import Data.Market (loadCSV)
import Strategy.MA (maCrossoverStrategy)

runBacktest :: BacktestRequest -> BacktestResult
runBacktest req = BacktestResult total (length trades)
  where
    -- assumes a file like "data/AAPL.csv"
    filePath = "data/" ++ ticker req ++ ".csv"
    result = error "Backtest should be run in IO. Use runBacktestIO instead."
    trades = []
    total = 0.0

-- Add this for full functionality:
runBacktestIO :: BacktestRequest -> IO BacktestResult
runBacktestIO req = do
  ohlc <- loadCSV ("data/" ++ ticker req ++ ".csv")
  let (trades, totalReturn) = maCrossoverStrategy ohlc
  return $ BacktestResult totalReturn (length trades)
