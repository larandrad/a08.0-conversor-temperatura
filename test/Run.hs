module Run (runWithInput) where

import Control.Applicative (liftA2)
import Control.Exception (bracket, finally)
import GHC.IO.Handle (hDuplicate, hDuplicateTo)
import System.IO (IOMode (ReadMode, WriteMode), hClose, stdin, stdout, withFile)
import System.IO.Temp (emptySystemTempFile, writeSystemTempFile)

redirect :: IO a -> FilePath -> FilePath -> IO a
redirect action inputFileName outputFileName =
  withFile inputFileName ReadMode $ \hIn ->
    withFile outputFileName WriteMode $ \hOut ->
      bracket
        (liftA2 (,) (hDuplicate stdin) (hDuplicate stdout))
        (\(oldStdin, oldStdout) ->
           (hDuplicateTo oldStdin stdin >> hDuplicateTo oldStdout stdout)
           `finally`
           (hClose oldStdin >> hClose oldStdout))
        (\_ -> do
           hDuplicateTo hIn stdin
           hDuplicateTo hOut stdout
           action)

runWithInput :: IO a -> String -> IO String
runWithInput action input = do
  inputFileName <- writeSystemTempFile "input.txt" input
  outputFileName <- emptySystemTempFile "output.txt"
  _ <- redirect action inputFileName outputFileName
  readFile outputFileName
