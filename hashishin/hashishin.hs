--
--  (C)opyright 2007 Ricardo Martins <ricardo at scarybox dot net>
--  Licensed under the MIT/X11 License.
--  See LICENSE file for license details.
--

module Main where

import System (getArgs)
import Text.Regex.Posix
import Text.Regex.Base
import System.IO

myFilter :: String -> Bool
myFilter x = not (x =~ ">" :: Bool)

-- strip the email message from those stupid signatures
mangle :: [String] -> [String]
mangle []     = []
mangle (x:xs) =
    -- when/if a signature is found
    if (x =~ "> (--|__)" :: Bool)
        -- filter quoted lines (that is, lines starting with ">")
        then filter (myFilter) xs
    else
        x : mangle xs

hGetContentsStrict h = do
    b <- hIsEOF h
    if b then return [] else do
        c <- hGetChar h
        r <- hGetContentsStrict h
        return (c:r)

readFileStrict fn = do
    hdl <- openFile fn ReadMode
    xs <- hGetContentsStrict hdl
    hClose hdl
    return xs

main = do
    [file] <- getArgs
    email  <- readFileStrict file
    writeFile file $ unlines $ mangle $ lines email
