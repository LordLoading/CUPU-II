module Utils (readFileBS) where 

import qualified Data.ByteString as B

readFileBS :: FilePath -> IO B.ByteString
readFileBS path = B.readFile path
