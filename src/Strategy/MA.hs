module Strategy.MA (maCrossoverStrategy, Trade (..)) where

import Data.List (tails)
import Data.Market
import Data.Time (Day)

data Trade = Buy Day Double | Sell Day Double deriving (Show)

-- Simple Moving Average
sma :: Int -> [Double] -> [Double]
sma n xs = [sum win / fromIntegral n | win <- windows n xs]
  where
    windows m = map (take m) . filter ((>= m) . length) . tails

maCrossoverStrategy :: [OHLC] -> ([Trade], Double)
maCrossoverStrategy ohlc =
  let closes = map close ohlc
      dates = map date ohlc
      fastMA = drop (slowPeriod - fastPeriod) $ sma fastPeriod closes
      slowMA = sma slowPeriod closes
      signals = zip3 (drop (slowPeriod - 1) dates) fastMA slowMA
   in simulate signals False Nothing [] 0.0
  where
    fastPeriod = 5
    slowPeriod = 20

simulate :: [(Day, Double, Double)] -> Bool -> Maybe (Day, Double) -> [Trade] -> Double -> ([Trade], Double)
simulate [] _ _ trades ret = (reverse trades, ret)
simulate ((d, f, s) : xs) holding mEntry trades ret =
  case (f > s, holding) of
    (True, False) -> simulate xs True (Just (d, f)) (Buy d f : trades) ret
    (False, True) ->
      case mEntry of
        Just (_, buyPrice) ->
          let gain = (f - buyPrice) / buyPrice
           in simulate xs False Nothing (Sell d f : trades) (ret + gain)
        _ -> simulate xs False Nothing trades ret
    _ -> simulate xs holding mEntry trades ret
