{-# LANGUAGE RankNTypes #-}
{-# LANGUAGE GADTs #-}
{-# LANGUAGE DeriveDataTypeable #-}
{-# LANGUAGE NamedFieldPuns #-}
{-# LANGUAGE GeneralizedNewtypeDeriving #-}
{-# LANGUAGE FlexibleContexts #-}

-- | All types.

module HIndent.Types
  (Printer(..)
  ,PrintState(..)
  ,Config(..)
  ,defaultConfig
  ,NodeInfo(..)
  ,NodeComment(..)
  ) where

import Control.Applicative
import Control.Monad
import Control.Monad.State.Strict (MonadState(..),StateT)
import Control.Monad.Trans.Maybe
import Data.ByteString.Builder
import Data.Functor.Identity
import Data.Int (Int64)
import Language.Haskell.Exts.SrcLoc

-- | A pretty printing monad.
newtype Printer a =
  Printer {runPrinter :: StateT PrintState (MaybeT Identity) a}
  deriving (Applicative,Monad,Functor,MonadState PrintState,MonadPlus,Alternative)

-- | The state of the pretty printer.
data PrintState = PrintState
  { psIndentLevel :: !Int64
    -- ^ Current indentation level, i.e. every time there's a
    -- new-line, output this many spaces.
  , psOutput :: !Builder
    -- ^ The current output bytestring builder.
  , psNewline :: !Bool
    -- ^ Just outputted a newline?
  , psColumn :: !Int64
    -- ^ Current column.
  , psLine :: !Int64
    -- ^ Current line number.
  , psConfig :: !Config
    -- ^ Configuration of max colums and indentation style.
  , psInsideCase :: !Bool
    -- ^ Whether we're in a case statement, used for Rhs printing.
  , psHardLimit :: !Bool
    -- ^ Bail out if we exceed current column.
  , psEolComment :: !Bool
  }

-- | Configurations shared among the different styles. Styles may pay
-- attention to or completely disregard this configuration.
data Config = Config
    { configMaxColumns :: !Int64 -- ^ Maximum columns to fit code into ideally.
    , configIndentSpaces :: !Int64 -- ^ How many spaces to indent?
    , configTrailingNewline :: !Bool -- ^ End with a newline.
    }

-- | Default style configuration.
defaultConfig :: Config
defaultConfig =
    Config
    { configMaxColumns = 80
    , configIndentSpaces = 4
    , configTrailingNewline = True
    }

data NodeComment
  = CommentSameLine String
  | CommentAfterLine String
  | CommentBeforeLine String
  deriving (Show,Ord,Eq)

-- | Information for each node in the AST.
data NodeInfo = NodeInfo
  { nodeInfoSpan :: !SrcSpanInfo -- ^ Location info from the parser.
  , nodeInfoComments :: ![NodeComment] -- ^ Comment attached to this node.
  }
instance Show NodeInfo where
  show (NodeInfo _ []) = ""
  show (NodeInfo _ s) =
    "{- " ++ show s ++ " -}"
