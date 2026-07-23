module Regs (newRegisters, readReg, writeReg, widget) where

import Brick
import qualified Brick.Widgets.Border as B
import Brick.Widgets.Border.Style
import Brick.Widgets.Core
import qualified Data.Vector.Unboxed.Mutable as MUV
import Data.Word (Word32)
import Text.Printf (printf)

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

widget :: MUV.IOVector Word32 -> IO (Widget ())
widget r =
  do
    vals <- mapM (Regs.readReg r) [0 .. 31]
    return $
      B.borderWithLabel (str "Registers") $
        vBox [str $ (printf "$%02d 0x%08x" i v :: String) | (i, v) <- zip ([0 ..] :: [Int]) vals]
