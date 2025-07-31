{-# LANGUAGE OverloadedStrings #-}

module Backtest.Conduit (processMessages) where

import Control.Monad.IO.Class (liftIO)
import Data.ByteString.Lazy (ByteString)
import qualified Data.ByteString.Lazy.Char8 as BL
import Data.Conduit

processMessages :: ConduitT ByteString Void IO ()
processMessages = awaitForever $ \bs -> do
  liftIO $ putStrLn "Backtest received message:"
  liftIO $ BL.putStrLn bs
