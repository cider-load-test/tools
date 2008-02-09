--
--  (C)opyright 2007 Ricardo Martins <ricardo at scarybox dot net>
--  Licensed under the MIT/X11 License.
--  See LICENSE file for license details.
--

module Main where

import System (getArgs)
import Text.Regex.Posix
import StrictIO

-- strip the email message from those stupid signatures
mangle :: [String] -> [String]
mangle []     = []
mangle (x:xs) =
    -- when/if a signature is found
    if (x =~ "^> (--|__)" :: Bool)
        -- filter quoted lines (that is, lines starting with ">")
        then filter (\a -> not (a =~ "^>" :: Bool)) xs
    else
        x : mangle xs

-- removes duplicate adjacent elements
uniq :: (Eq a) => [a] -> [a]
uniq [] = []
uniq [x] = [x]
uniq (x:y:z) =
    if (x == y) then uniq (y:z)
    else x : uniq (y : z)

main :: IO ()
main = do
    [file] <- getArgs
    email  <- readFileStrict file
    writeFile file $ unlines $ uniq $ mangle $ lines email
