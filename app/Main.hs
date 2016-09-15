{-# LANGUAGE TemplateHaskell #-}
module Main where

import Lib
import Data.FileStore

main :: IO ()
main = do
  -- initialise a filestore
  let f = gitFileStore "mystore"   
  initialize f     -- if the direcory "mystore" already exists you ger an exception
  -- create a file
  let a = Author "Max" "max@example.com"
  create f "some_file.txt" a "describe the revision" "content of the file"
  -- get list of resources in filestore
  i <- index f
  print i
  -- search for revisions
  rs <- searchRevisions f False "some_file.txt" ""
  print rs
  -- get revId of newest revision
  let i = head $ map (\(Revision i t a d cs) -> i) rs
  -- let i = latest f "some_file.txt"       -- same as above
  -- modify it
  m <- modify f "some_file.txt" i a "description of change" "new content!"
  -- print revisions again
  rs <- searchRevisions f False "some_file.txt" ""
  print rs
  -- read content of file
  content <- (smartRetrieve f False "some_file.txt" Nothing) :: IO String
  print content
  -- achieve the same with 'retrieve'
  content <- (retrieve f "some_file.txt" Nothing) :: IO String
  print content
  return ()
