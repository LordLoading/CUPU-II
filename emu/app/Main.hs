module Main (main) where

import qualified Data.ByteString as B
-- import Emu.Mem (newMemory, readByte, writeByte)
import Lib
import Numeric (showHex)
import Utils (readFileBS)
import Mem

main :: IO ()
main = do
  someFunc
  putStrLn "Hello, world!"
  print (square 5)
  print (Main.exp 2 5)
  print (factorial 5)
  bs <- readFileBS "test.bin"
  putStrLn $ "test.bin (" ++ show (B.length bs) ++ " bytes):"
  mapM_ (\b -> putStr $ padHex (showHex (fromIntegral b :: Int) "")) (B.unpack bs)
  putStrLn ""

  writeByte 100 255
  writeHalf 200 0xabcd
  test <- readBytes 100 103
  mapM_ (\b -> putStr $ padHex (showHex (fromIntegral b :: Int) "")) test

square :: Int -> Int
square x = x * x

exp :: Int -> Int -> Int
exp a b = a ^ b

factorial :: Int -> Int
factorial 0 = 1
factorial n = n * factorial (n - 1)

padHex :: String -> String
padHex s = if length s == 1 then "0" ++ s else s
