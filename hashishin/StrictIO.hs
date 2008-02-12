--
--  (C)opyright 2007 Ricardo Martins <ricardo at scarybox dot net>
--  Licensed under the MIT/X11 License.
--  See LICENSE file for license details.
--

module StrictIO where

import System.IO

hGetContentsStrict :: Handle -> IO String
hGetContentsStrict h = do
    b <- hIsEOF h
    if b then return [] else do
        c <- hGetChar h
        r <- hGetContentsStrict h
        return (c:r)

readFileStrict :: FilePath -> IO String
readFileStrict fn = do
    hdl <- openFile fn ReadMode
    xs  <- hGetContentsStrict hdl
    hClose hdl
    return xs
