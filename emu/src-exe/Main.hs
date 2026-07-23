module Main (main) where

import Brick.Widgets.Core
import Brick.Main.App
import qualified Data.ByteString as B
import Mem
import Numeric (showHex)
import Regs
import System.Environment (getArgs)
import Text.Printf (printf)
import Utils

main :: IO ()
main = do
  args <- getArgs
  let path = case args of
        (p : _) -> p
        _ -> error "Usage: emu-exe <file>"
  bs <- readFileBS path
  putStrLn $ path ++ " (" ++ show (B.length bs) ++ " bytes):"
  mapM_ (\b -> putStr $ padHex (showHex (fromIntegral b :: Int) "")) (B.unpack bs)
  putStrLn ""

  Mem.writeByteString 0 bs

  test <- Mem.readBytes 0 100
  mapM_ (\b -> putStr $ padHex (showHex (fromIntegral b :: Int) "")) test

  registers <- newRegisters
  Regs.writeReg registers 0 0x1234
  Regs.writeReg registers 1 0x5678
  Regs.writeReg registers 2 0x9abc
  Regs.writeReg registers 3 0xdef0

  putStrLn ""

  val0 <- Regs.readReg registers 0
  putStrLn $ printf "%x" val0

padHex :: String -> String
padHex s = if length s == 1 then "0" ++ s else s
