{-# LANGUAGE OverloadedStrings #-}

module Data.Market (OHLC (..), loadCSV) where

import Control.Applicative ((<|>))
import Data.ByteString qualified as BS
import Data.Csv
import Data.Text (unpack)
import Data.Text.Encoding (decodeUtf8)
import Data.Time (Day, defaultTimeLocale, parseTimeM)
import GHC.Generics
import qualified Data.ByteString.Lazy as BL
import qualified Data.Vector as V

instance FromField Day where
  parseField s =
    let str = unpack (decodeUtf8 s)
     in parseTimeM True defaultTimeLocale "%Y-%m-%d" str
          <|> parseTimeM True defaultTimeLocale "%-m/%-d/%Y" str

data OHLC = OHLC
  { date :: Day,
    open :: Double,
    high :: Double,
    low :: Double,
    close :: Double,
    volume :: Int
  }
  deriving (Show, Generic)

instance FromNamedRecord OHLC where
  parseNamedRecord m =
    OHLC
      <$> m .: "Date"
      <*> m .: "Open"
      <*> m .: "High"
      <*> m .: "Low"
      <*> m .: "Close"
      <*> m .: "Volume"

loadCSV :: FilePath -> IO [OHLC]
loadCSV path = do
  csvData <- BL.readFile path
  case decodeByName csvData of
    Left err -> fail err
    Right (_, vec) -> return (V.toList vec)
