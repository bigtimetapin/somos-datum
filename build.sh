#!/bin/sh
set -e

js="dist/elm.js"
min="web/elm.min.js"

# build the elm app (using optimized flag)
elm make --optimize --output=$js elm/src/Main.elm

# uglify the js (once to compress and again to mangle)
uglifyjs $js --compress "pure_funcs=[F2,F3,F4,F5,F6,F7,F8,F9,A2,A3,A4,A5,A6,A7,A8,A9],pure_getters,keep_fargs=false,unsafe_comps,unsafe" | uglifyjs --mangle > $min

# echo metrics to brag about how much better the optimized/minified app is
echo "Initial size:  $(cat $js | wc -c) bytes"
echo "Minified size: $(cat $min | wc -c) bytes"