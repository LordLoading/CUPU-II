module Mem (mem, readByte, writeByte, readHalf, writeHalf, readWord, writeWord, readBytes, writeBytes) where

import Data.Primitive.ByteArray (MutableByteArray, newByteArray, readByteArray, writeByteArray)
import Control.Monad.Primitive (RealWorld)
import Data.Word (Word8, Word16, Word32)
import Data.Bits (shiftL, shiftR, (.|.))
import System.IO.Unsafe (unsafePerformIO)

mem :: MutableByteArray RealWorld
mem = unsafePerformIO (newByteArray (2 ^ 16 :: Int))
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
  writeByte addr (fromIntegral b1)
  writeByte (addr + 1) (fromIntegral b2)

readWord :: Word16 -> IO Word32
readWord addr = do
  b1 <- readByte addr
  b2 <- readByte (addr + 1)
  b3 <- readByte (addr + 2)
  b4 <- readByte (addr + 3)
  return $ (fromIntegral b1 `shiftL` 24) .|. (fromIntegral b2 `shiftL` 16) .|. (fromIntegral b3 `shiftL` 8) .|. fromIntegral b4

writeWord :: Word16 -> Word32 -> IO ()
writeWord addr w = do
  let b1 = w `shiftR` 24
      b2 = w `shiftR` 16
      b3 = w `shiftR` 8
      b4 = w
  writeByte addr (fromIntegral b1)
  writeByte (addr + 1) (fromIntegral b2)
  writeByte (addr + 2) (fromIntegral b3)
  writeByte (addr + 3) (fromIntegral b4)

readBytes :: Word16 -> Word16 -> IO [Word8]
readBytes addr len = mapM (\i -> readByte (addr + i)) [0 .. len - 1]

writeBytes :: Word16 -> [Word8] -> IO ()
writeBytes addr bs = mapM_ (\b -> writeByte (addr + fromIntegral b) b) bs
