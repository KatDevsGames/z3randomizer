#!/bin/bash

rm ../working.sfc
cp ../alttp.sfc ../working.sfc
./bin/macos/asar -DFEATURE_NEW_TEXT=1 LTTP_RND_GeneralBugfixes.asm ../working.sfc
