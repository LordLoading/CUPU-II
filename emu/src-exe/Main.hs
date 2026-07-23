module Main (main) where

import Brick
import qualified Data.ByteString as B
import Mem
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
  mapM_ (\b -> putStr $ printf "%02x" b) (B.unpack bs)
  putStrLn ""

  Mem.writeByteString 0 bs

  test <- Mem.readBytes 0 100
  mapM_ (\b -> putStr $ printf "%02x" b) test

  registers <- newRegisters
  Regs.writeReg registers 0 0x1234
  Regs.writeReg registers 1 0x5678
  Regs.writeReg registers 2 0x9abc
  Regs.writeReg registers 3 0xdef0
  Regs.writeReg registers 4 0x01234567

  regWidget <- Regs.widget registers
  simpleMain $ hBox [str "Hello!", regWidget]
