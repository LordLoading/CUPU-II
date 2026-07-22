module Regs (newRegisters, readReg, writeReg) where

import qualified Data.Vector.Unboxed.Mutable as MUV
import Data.Word (Word32)

-- Initialize 32 registers to 0
newRegisters :: IO (MUV.IOVector Word32)
newRegisters = MUV.replicate 32 0


-- Read register r
readReg :: MUV.IOVector Word32 -> Int -> IO Word32
readReg _ 0 = return 0
readReg regs r = MUV.read regs r

-- Write register r
writeReg :: MUV.IOVector Word32 -> Int -> Word32 -> IO ()
writeReg _ 0 _ = return ()
writeReg regs r val = MUV.write regs r val
