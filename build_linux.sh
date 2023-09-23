#!/bin/bash

rm ../working.sfc
cp ../alttp.sfc ../working.sfc
./bin/linux/asar -DFEATURE_PATREON_SUPPORTERS=1 LTTP_RND_GeneralBugfixes.asm ../working.sfc
