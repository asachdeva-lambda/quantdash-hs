{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE OverloadedStrings #-}

module Streaming.JetStream
  ( jetStreamOHLCSource,
  )
where

import Common.Types (OHLC)
import Conduit
import Control.Monad.IO.Class (liftIO)
import Data.Aeson
import Data.Aeson (eitherDecode)
import Data.ByteString.Char8 qualified as BS8
import Data.ByteString.Lazy (ByteString, fromStrict)
import Data.ByteString.Lazy.Char8 qualified as BL
import Data.Conduit
import Data.Conduit.List qualified as CL
import GHC.Generics (Generic)
import Network.HTTP.Client
import Network.HTTP.Client.TLS
import Network.HTTP.Types.Header (hContentType)
import Network.HTTP.Types.Method (methodPost)

-- Already implemented: fetch messages from JetStream
jetStreamOHLCSource :: (MonadIO m) => ConduitT () OHLC m ()
jetStreamOHLCSource = getJetStreamMessages .| decodeMessages

decodeMessages :: (Monad m) => ConduitT ByteString OHLC m ()
decodeMessages = awaitForever $ \bs ->
  case eitherDecode bs of
    Left err -> return () -- or log the error
    Right ohlc -> yield ohlc

data JetStreamMessage = JetStreamMessage
  { subject :: String,
    data_ :: ByteString,
    seq_ :: Int
  }
  deriving (Show, Generic)

instance FromJSON JetStreamMessage where
  parseJSON = withObject "JetStreamMessage" $ \v ->
    JetStreamMessage
      <$> v .: "subject"
      <*> (v .: "data" >>= \s -> pure (fromStrict (BS8.pack s)))
      <*> v .: "seq"

-- Replace with actual NATS JetStream endpoint
jetStreamSource :: String -> String -> ConduitT () ByteString IO ()
jetStreamSource baseUrl consumer = do
  manager <- liftIO $ newManager tlsManagerSettings
  let url = baseUrl ++ "/js/consumers/" ++ consumer ++ "/messages"
  let req =
        (parseRequest_ url)
          { method = methodPost,
            requestHeaders = [(hContentType, "application/json")]
          }
  loop manager req
  where
    loop manager req = do
      resp <- liftIO $ httpLbs req manager
      case eitherDecode (responseBody resp) of
        Left _ -> return ()
        Right msg -> do
          yield (data_ msg)
          loop manager req
