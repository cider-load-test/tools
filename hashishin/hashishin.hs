--
--  (C)opyright 2007 Ricardo Martins <ricardo at scarybox dot net>
--  Licensed under the MIT/X11 License.
--  See LICENSE file for license details.
--

module Main where

import System (getArgs)
import Text.Regex.Posix
import StrictIO

myFilter :: String -> Bool
myFilter x = not (x =~ "^>" :: Bool)

-- strip the email message from those stupid signatures
mangle :: [String] -> [String]
mangle []     = []
mangle (x:xs) =
    -- when/if a signature is found
    if (x =~ "^> (--|__)" :: Bool)
        -- filter quoted lines (that is, lines starting with ">")
        then filter (myFilter) xs
    else
        x : mangle xs

-- removes duplicate adjacent elements
uniq :: (Eq a) => [a] -> [a]
uniq [] = []
uniq (x:y:z) =
    if (x == y) then uniq (y:z)
    else x : uniq (y : z)
uniq x = x

main :: IO ()
main = do
    [file] <- getArgs
    email  <- readFileStrict file
    writeFile file $ unlines $ uniq $ mangle $ lines email
