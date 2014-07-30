{-# OPTIONS_GHC -fno-warn-unused-do-bind #-}
module CommandParser where

import Data.Char
import ParserMonad

------------------------------------------------------------------------
data DebugCommand 
    = SetBreakpoint String Int    -- module, line
    | RemoveBreakpoint String Int -- module, index
    | Resume
    | History
    | StepInto
    | StepOver
    | Trace String                -- command
    | BreakList String            -- module
    | Exit
    | Unknown
        deriving Show

debugCommand :: Parser DebugCommand
setBreakpoint :: Parser DebugCommand
removeBreakpoint :: Parser DebugCommand
resume :: Parser DebugCommand
history :: Parser DebugCommand
stepInto :: Parser DebugCommand
stepOver :: Parser DebugCommand
trace :: Parser DebugCommand
breaklist :: Parser DebugCommand
exit :: Parser DebugCommand
unknown :: Parser DebugCommand

debugCommand = unlist [
                        setBreakpoint,
                        removeBreakpoint,
                        resume,
                        history,
                        stepInto,
                        stepOver,
                        trace,
                        breaklist,
                        exit,
                        unknown
                      ]

setBreakpoint = do
    string ":break"
    waitAndSkipSpaces
    mod' <- restSatisfiedChars (not . isSpace)
    waitAndSkipSpaces
    line <- int
    skipSpaces
    end
    return $ SetBreakpoint mod' line

removeBreakpoint = do
    string ":delete"
    waitAndSkipSpaces
    moduleName <- restSatisfiedChars (not . isSpace)
    waitAndSkipSpaces
    ind <- int
    skipSpaces
    end
    return $ RemoveBreakpoint moduleName ind

resume = do
    string ":continue"
    skipSpaces
    end
    return Resume

history = do
    string ":history"
    skipSpaces
    end
    return History

stepInto = do
    string ":step"
    skipSpaces
    end
    return StepInto

stepOver = do
    string ":steplocal"
    skipSpaces
    end
    return StepOver

trace = do
    string ":trace"
    waitAndSkipSpaces
    cmd <- restOfInput
    return $ Trace cmd

breaklist = do
    string ":breaklist"
    waitAndSkipSpaces
    mod' <- restSatisfiedChars (not . isSpace)
    skipSpaces
    end
    return $ BreakList mod'

exit = do
    string ":q"
    skipSpaces
    end
    return Exit

unknown = do
    restOfInput
    return $ Unknown
