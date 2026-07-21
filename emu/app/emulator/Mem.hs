module Emu.Mem where

import Data.Word (Word8) 
import Data.Primitive.ByteArray (MutableByteArray)

mem :: MutableByteArray 
mem = newByteArray (2 ^ 16) 

