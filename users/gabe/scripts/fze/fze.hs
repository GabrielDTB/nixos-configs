{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE ExtendedDefaultRules #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE NoImplicitPrelude #-}

import Relude
import Shh
import qualified Data.ByteString.Lazy as BL

$(loadEnv SearchPath)

main :: IO ()
main = grep |> find |> capture >>= edit
    where
        grep = rg "--files"
               "--hidden"
               "--glob"
               "!.git/*"
               "./"
        find = ignoreCode 130 (fzf "--height"
                "40%"
                "--reverse"
                "--border"
                "--preview"
                "bat --color=always --style=numbers --line-range :500 {}")
        edit "" = pure ()
        edit name = exe "hx" $ BL.dropEnd 1 name
