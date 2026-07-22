module Mem (mem, readByte, writeByte, readHalf, writeHalf, readWord, writeWord, readBytes, writeBytes, writeByteString) where

import Control.Monad.Primitive (RealWorld)
import Data.Bits (shiftL, shiftR, (.|.))
import qualified Data.ByteString as B
import Data.Primitive.ByteArray (MutableByteArray, newByteArray, readByteArray, writeByteArray)
import Data.Word (Word16, Word32, Word8)
import System.IO.Unsafe (unsafePerformIO)

mem :: MutableByteArray RealWorld
mem = unsafePerformIO (newByteArray (65536 :: Int))
{-# NOINLINE mem #-}

readByte :: Word16 -> IO Word8
readByte addr = readByteArray mem (fromIntegral addr)

writeByte :: Word16 -> Word8 -> IO ()
writeByte addr b = writeByteArray mem (fromIntegral addr) b

readHalf :: Word16 -> IO Word16
readHalf addr = do
  b1 <- readByte addr
  b2 <- readByte (addr + 1)
  return $ fromIntegral b1 .|. (fromIntegral b2 `shiftL` 8)

writeHalf :: Word16 -> Word16 -> IO ()
writeHalf addr w = do
  let b1 = w `shiftR` 8
      b2 = w
  writeByte addr (fromIntegral b2)
  writeByte (addr + 1) (fromIntegral b1)

readWord :: Word16 -> IO Word32
readWord addr = do
  b1 <- readByte addr
  b2 <- readByte (addr + 1)
  b3 <- readByte (addr + 2)
  b4 <- readByte (addr + 3)
  return $ (fromIntegral b4 `shiftL` 24) .|. (fromIntegral b3 `shiftL` 16) .|. (fromIntegral b2 `shiftL` 8) .|. fromIntegral b1

writeWord :: Word16 -> Word32 -> IO ()
writeWord addr w = do
  let b1 = w `shiftR` 24
      b2 = w `shiftR` 16
      b3 = w `shiftR` 8
      b4 = w
  writeByte addr (fromIntegral b4)
  writeByte (addr + 1) (fromIntegral b3)
  writeByte (addr + 2) (fromIntegral b2)
  writeByte (addr + 3) (fromIntegral b1)

readBytes :: Word16 -> Word16 -> IO [Word8]
readBytes addr len = mapM (\i -> readByte (addr + i)) [0 .. len - 1]

writeBytes :: Word16 -> [Word8] -> IO ()
writeBytes addr bs = mapM_ (\(i, b) -> writeByte (addr + fromIntegral (i :: Int)) b) (zip [0 ..] bs)

writeByteString :: Word16 -> B.ByteString -> IO ()
writeByteString addr bs = mapM_ (\(i, b) -> writeByte (addr + fromIntegral (i :: Int)) b) (zip [0 ..] (B.unpack bs))
