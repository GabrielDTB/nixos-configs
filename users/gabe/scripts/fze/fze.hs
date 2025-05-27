{-# LANGUAGE NoImplicitPrelude #-}
{-# LANGUAGE OverloadedStrings #-}

import Relude
import Turtle (shellStrict, proc, argPath, options, (<>), empty, stdin, format, fp)
import qualified Turtle as T
import qualified Data.Text as Text

main :: IO ()
main = do
    dir <- options "fze" (T.argPath "path" "Path to search")
    editor <- maybe "vi" toText <$> lookupEnv "EDITOR"
    let rgCmd = "rg --files --hidden --glob '!.git/*' " <> T.format T.fp dir
        fzfCmd = "fzf --height 40% --reverse --border " <>
                 "--preview 'bat --color=always --style=numbers --line-range :500 {}'"
        fullCmd = rgCmd <> " | " <> fzfCmd
    (_, output) <- T.shellStrict fullCmd T.stdin
    let mfile = Text.strip output
    unless (Text.null mfile) $
        void $ T.proc editor [mfile] T.empty
