# hindent [![Hackage](https://img.shields.io/hackage/v/hindent.svg?style=flat)](https://hackage.haskell.org/package/hindent) [![Build Status](https://travis-ci.org/chrisdone/hindent.png)](https://travis-ci.org/chrisdone/hindent)

Haskell pretty printer

[Demonstration site](http://chrisdone.com/hindent/)

[Examples](https://github.com/chrisdone/hindent/blob/master/TESTS.md)

## Install

    $ stack install hindent

## Usage

    bash-3.2$ hindent --help
    hindent --version --help --style STYLE --line-length <...> --tab-size <...> [-X<...>]* [<FILENAME>]
    Version 5.0.1
    The --style option is now ignored, but preserved for backwards-compatibility.
    Johan Tibell is the default and only style.

hindent is used in a pipeline style

    $ cat path/to/sourcefile.hs | hindent

Configure tab size with `--tab-size`:

    $ echo 'example = case x of Just p -> foo bar' | hindent --tab-size 2; echo
    example =
      case x of
        Just p -> foo bar
    $ echo 'example = case x of Just p -> foo bar' | hindent --tab-size 4; echo
    example =
        case x of
            Just p -> foo bar

## Emacs

In
[elisp/hindent.el](https://github.com/chrisdone/hindent/blob/master/elisp/hindent.el)
there is `hindent-mode`, which provides keybindings to reindent parts of the
buffer:

- `M-q` reformats the current declaration.  When inside a comment, it fills the
  current paragraph instead, like the standard `M-q`.
- `C-M-\` reformats the current region.

To enable it, add the following to your init file:

```lisp
(add-to-list 'load-path "/path/to/hindent/elisp")
(require 'hindent)
(add-hook 'haskell-mode-hook #'hindent-mode)
```

## Vim

The `'formatprg'` option lets you use an external program (like
hindent) to format your text. Put the following line into
~/.vim/ftplugin/haskell.vim to set this option for Haskell files:

    setlocal formatprg=hindent

Then you can format with hindent using `gq`. Read `:help gq` and `help
'formatprg'` for more details.

Note that unlike in emacs you have to take care of selecting a
sensible buffer region as input to hindent yourself. If that is too
much trouble you can try
[vim-textobj-haskell](https://github.com/gilligan/vim-textobj-haskell)
which provides a text object for top level bindings.

## Atom

Basic support is provided through
[atom/hindent.coffee](https://github.com/chrisdone/hindent/blob/master/atom/hindent.coffee). Mode
should be installed as package into `.atom\packages\${PACKAGE_NAME}`,
here is simple example of atom
[package](https://github.com/Heather/atom-hindent).
