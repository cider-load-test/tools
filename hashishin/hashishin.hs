--
--  (C)opyright 2007 Ricardo Martins <ricardo at scarybox dot net>
--  Licensed under the MIT/X11 License.
--  See LICENSE file for license details.
--

module Main where

import System (getArgs)
import Text.Regex.Posix
import StrictIO
import Test.QuickCheck

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
uniq_adj :: (Eq a) => [a] -> [a]
uniq_adj [] = []
uniq_adj [x] = [x]
uniq_adj (x:y:z) =
    if (x == y) then uniq_adj (y:z)
    else x : uniq_adj (y : z)

prop_uniq_adj xs = length (uniq_adj xs) <= length xs

-- removes trailing quotes after removing signatures
rmt :: [String] -> [String]
rmt [] = []
rmt [x] = [x]
rmt (x:y:z) =
    if (x =~ "^>( )?$" :: Bool) && (y == "") then y:z
    else x : rmt (y:z)

prop_rmt xs = length (rmt xs) <= length xs

main :: IO ()
main = do
    [file] <- getArgs
    email  <- readFileStrict file
    writeFile file $ unlines $ rmt $ uniq_adj $ mangle $ lines email
