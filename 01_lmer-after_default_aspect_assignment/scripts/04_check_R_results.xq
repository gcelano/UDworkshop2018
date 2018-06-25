xquery version "3.1" encoding "utf-8";

(: run on BaseX 9.0.2; written by Giuseppe G. A. Celano :)

for $u in collection("/Users/mycomputer/Desktop/UDWorkshop2018/01_lmer-after_default_aspect_assignment/texts/03_02_mixed_effects_results/")
let $f := analyze-string($u/r/t[20], "\*") (: DEFAULT1 :)
let $f1 := $f/fn:match
let $f2 := count($f/fn:match)

let $g := analyze-string($u/r/t[21], "\*") (: FREQUENCY :)
let $g1 := $f/fn:match
let $g2 := count($f/fn:match)

where  $f2 > 0
return
$u//@v