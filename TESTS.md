# Introduction

This file is a test suite. Each section maps to an HSpec test, and
each line that is followed by a Haskell code fence is tested to make
sure re-formatting that code snippet produces the same result.

You can browse through this document to see what HIndent's style is
like, or contribute additional sections to it, or regression tests.

# Modules

Module header

``` haskell
module X where

x = 1
```

Exports

``` haskell
module X
  ( x
  , y
  , Z
  , P(x, z))
  where
```

## Imports

Import lists

``` haskell
import Data.Text
import Data.Text
import qualified Data.Text as T
import qualified Data.Text (a, b, c)
import Data.Text (a, b, c)
import Data.Text hiding (a, b, c)
```

# Declarations

Type declaration

``` haskell
type EventSource a = (AddHandler a, a -> IO ())
```

Instance declaration without decls

``` haskell
instance C a
```

Instance declaration with decls

``` haskell
instance C a where
    foobar = do
        x y
        k p
```

# Expressions

Lazy patterns in a lambda

``` haskell
f = \ ~a -> undefined
 -- \~a yields parse error on input ‘\~’
```

Bang patterns in a lambda

``` haskell
f = \ !a -> undefined
 -- \!a yields parse error on input ‘\!’
```

List comprehensions

``` haskell
defaultExtensions =
    [ e
    | e@EnableExtension {} <- knownExtensions ] \\
    map EnableExtension badExtensions
```

Record indentation

``` haskell
getGitProvider :: EventProvider GitRecord ()
getGitProvider =
    EventProvider
    { getModuleName = "Git"
    , getEvents = getRepoCommits
    }
```

Records again

``` haskell
commitToEvent :: FolderPath -> TimeZone -> Commit -> Event.Event
commitToEvent gitFolderPath timezone commit =
    Event.Event
    { pluginName = getModuleName getGitProvider
    , eventIcon = "glyphicon-cog"
    , eventDate = localTimeToUTC timezone (commitDate commit)
    }
```

Cases

``` haskell
strToMonth :: String -> Int
strToMonth month =
    case month of
        "Jan" -> 1
        "Feb" -> 2
        _ -> error $ "Unknown month " ++ month
```

Operators

``` haskell
x =
    Value <$> thing <*> secondThing <*> thirdThing <*> fourthThing <*> Just thisissolong <*>
    Just stilllonger
```

# Type signatures

Class constraints

``` haskell
fun
    :: (Class a, Class b)
    => a -> b -> c
```

Tuples

``` haskell
fun :: (a, b, c) -> (a, b)
```

# Function declarations

Where clause

``` haskell
sayHello = do
    name <- getLine
    putStrLn $ greeting name
  where
    greeting name = "Hello, " ++ name ++ "!"
```

Guards and pattern guards

``` haskell
f x
    | x <- Just x
    , x <- Just x =
        case x of
            Just x -> e
    | otherwise = do e
  where
    x = y
```

Multi-way if

``` haskell
x =
    if | x <- Just x,
         x <- Just x ->
           case x of
               Just x -> e
               Nothing -> p
       | otherwise -> e
```

Case inside a `where` and `do`

``` haskell
g x =
    case x of
        a -> x
  where
    foo =
        case x of
            _ -> do
                launchMissiles
      where
        y = 2
```

Let inside a `where`

``` haskell
g x =
    let x = 1
    in x
  where
    foo =
        let y = 2
            z = 3
        in y
```

Lists

``` haskell
exceptions = [InvalidStatusCode, MissingContentHeader, InternalServerError]

exceptions =
    [ InvalidStatusCode
    , MissingContentHeader
    , InternalServerError
    , InvalidStatusCode
    , MissingContentHeader
    , InternalServerError]
```

# Johan Tibell compatibility checks

Basic example from Tibbe's style

``` haskell
sayHello :: IO ()
sayHello = do
    name <- getLine
    putStrLn $ greeting name
  where
    greeting name = "Hello, " ++ name ++ "!"

filter :: (a -> Bool) -> [a] -> [a]
filter _ [] = []
filter p (x:xs)
    | p x = x : filter p xs
    | otherwise = filter p xs
```

Data declarations

``` haskell
data Tree a
    = Branch !a
             !(Tree a)
             !(Tree a)
    | Leaf

data HttpException
    = InvalidStatusCode Int
    | MissingContentHeader

data Person = Person
    { firstName :: !String -- ^ First name
    , lastName :: !String -- ^ Last name
    , age :: !Int -- ^ Age
    }
```

Spaces between deriving classes

``` haskell
-- From https://github.com/chrisdone/hindent/issues/167
data Person = Person
    { firstName :: !String -- ^ First name
    , lastName :: !String -- ^ Last name
    , age :: !Int -- ^ Age
    } deriving (Eq, Show)
```

Hanging lambdas

``` haskell
bar :: IO ()
bar =
    forM_ [1, 2, 3] $
    \n -> do
        putStrLn "Here comes a number!"
        print n

foo :: IO ()
foo =
    alloca 10 $
    \a ->
         alloca 20 $
         \b -> cFunction fooo barrr muuu (fooo barrr muuu) (fooo barrr muuu)
```

# Comments

Comments within a declaration

``` haskell
bob -- after bob
 =
    foo -- next to foo
    -- line after foo
        (bar
             foo -- next to bar foo
             bar -- next to bar
         ) -- next to the end paren of (bar)
        -- line after (bar)
        mu -- next to mu
        -- line after mu
        -- another line after mu
        zot -- next to zot
        -- line after zot
        (case casey -- after casey
               of
             Just -- after Just
              -> do
                 justice -- after justice
                  *
                     foo
                         (blah * blah + z + 2 / 4 + a - -- before a line break
                          2 * -- inside this mess
                          z /
                          2 /
                          2 /
                          aooooo /
                          aaaaa -- bob comment
                          ) +
                     (sdfsdfsd fsdfsdf) -- blah comment
                 putStrLn "")
        [1, 2, 3]
        [ 1 -- foo
        , ( 2 -- bar
          , 2.5 -- mu
           )
        , 3]

foo = 1 -- after foo
```

Haddock comments

``` haskell
-- | Module comment.
module X where

-- | Main doc.
main :: IO ()
main = return ()

data X
    = X -- ^ X is for xylophone.
    | Y -- ^ Y is for why did I eat that pizza.

data X = X
    { field1 :: Int -- ^ Field1 is the first field.
    , field11 :: Char
      -- ^ This field comment is on its own line.
    , field2 :: Int -- ^ Field2 is the second field.
    , field3 :: Char -- ^ This is a long comment which starts next to
      -- the field but continues onto the next line, it aligns exactly
      -- with the field name.
    , field4 :: Char
      -- ^ This is a long comment which starts on the following line
      -- from from the field, lines continue at the sme column.
    }
```

Comments around regular declarations

``` haskell
-- This is some random comment.
-- | Main entry point.
main = putStrLn "Hello, World!"
 -- This is another random comment.
```

## Regression tests

cocreature removed from declaration issue #186

``` haskell
-- https://github.com/chrisdone/hindent/issues/186
trans One e n =
    M.singleton
        (Query Unmarked (Mark NonExistent)) -- The goal of this is to fail always
        (emptyImage
         { notPresent = S.singleton (TransitionResult Two (Just A) n)
         })
```

sheyll explicit forall in instances #218

``` haskell
-- https://github.com/chrisdone/hindent/issues/218
instance forall x. C

instance forall x. Show x =>
         C x
```

tfausak support shebangs #208

``` haskell
#!/usr/bin/env stack
-- stack runghc
main = pure ()
-- https://github.com/chrisdone/hindent/issues/208
```

joe9 preserve newlines between import groups

``` haskell
-- https://github.com/chrisdone/hindent/issues/200
import Data.List
import Data.Maybe

import MyProject
import FooBar

import GHC.Monad

-- blah
import Hello

import CommentAfter -- Comment here shouldn't affect newlines
import HelloWorld

import CommentAfter -- Comment here shouldn't affect newlines

import HelloWorld

-- Comment here shouldn't affect newlines
import CommentAfter

import HelloWorld
```

# Behaviour checks

Unicode

``` haskell
α = γ * "ω"
 -- υ
```

Empty module

``` haskell
```

Trailing newline is preserved

``` haskell
module X where

foo = 123

```

# Complex input

A complex, slow-to-print decl

``` haskell
quasiQuotes =
    [ ( ''[]
      , \(typeVariable:_) _automaticPrinter ->
             (let presentVar = varE (presentVarName typeVariable)
              in lamE
                     [varP (presentVarName typeVariable)]
                     [|(let typeString = "[" ++ fst $(presentVar) ++ "]"
                        in ( typeString
                           , \xs ->
                                  case fst $(presentVar) of
                                      "GHC.Types.Char" ->
                                          ChoicePresentation
                                              "String"
                                              [ ( "String"
                                                , StringPresentation
                                                      "String"
                                                      (concatMap
                                                           getCh
                                                           (map
                                                                (snd
                                                                     $(presentVar))
                                                                xs)))
                                              , ( "List of characters"
                                                , ListPresentation
                                                      typeString
                                                      (map (snd $(presentVar)) xs))]
                                          where getCh (CharPresentation "GHC.Types.Char" ch) =
                                                    ch
                                                getCh (ChoicePresentation _ ((_, CharPresentation _ ch):_)) =
                                                    ch
                                                getCh _ = ""
                                      _ ->
                                          ListPresentation
                                              typeString
                                              (map (snd $(presentVar)) xs)))|]))]
```

Random snippet from hindent itself

``` haskell
exp' (App _ op a) = do
    (fits, st) <- fitsOnOneLine (spaced (map pretty (f : args)))
    if fits
        then put st
        else do
            pretty f
            newline
            spaces <- getIndentSpaces
            indented spaces (lined (map pretty args))
  where
    (f, args) = flatten op [a]
    flatten :: Exp NodeInfo -> [Exp NodeInfo] -> (Exp NodeInfo, [Exp NodeInfo])
    flatten (App _ f' a') b = flatten f' (a' : b)
    flatten f' as = (f', as)
```
