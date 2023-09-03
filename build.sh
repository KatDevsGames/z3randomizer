#!/bin/bash

rm ../working.sfc
cp ../alttp.sfc ../working.sfc
./bin/macos/asar LTTP_RND_GeneralBugfixes.asm ../working.sfc
