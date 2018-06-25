xquery version "3.1" encoding "utf-8";

(: run on BaseX 9.0.2; written by Giuseppe G. A. Celano :)

declare variable $p :=
"/Users/mycomputer/Desktop/UDWorkshop2018/texts/02_calculate_IC_for_01table/";


for $f at $count in sort(file:list($p, true(), "*.txt"))[. != "UD_Czech.txt"] 
  (: UD_Czech is avoided because grouping factors must have > 1 sampled level :)
order by $f
let $n := replace(replace($f, ".txt", ""), "-", "_")
return
(file:write("/Users/mycomputer/Desktop/UDWorkshop2018/01_lmer-after_default_aspect_assignment/texts/03_01_temp_R_commands/" 
           || $f,
 $n || "=read.table('" || $p || $f || "',header=T,comment.char='');attach(" || $n || ")" || 
 
 ";library(lme4);library(lmerTest);DEFAULT=as.factor(DEFAULT);summary(lmer(CHAR_NUMBER~DEFAULT+FREQUENCY+(1|LEMMA)))"
)
,
file:write("/Users/mycomputer/Desktop/UDWorkshop2018/01_lmer-after_default_aspect_assignment/texts/03_02_mixed_effects_results/" || replace($f, ".txt", ".xml"),
<r v="{$f}">
{for $u at $c in
tokenize(proc:system("/usr/local/bin/Rscript", "/Users/mycomputer/Desktop/UDWorkshop2018/01_lmer-after_default_aspect_assignment/texts/03_01_temp_R_commands/" || $f), "\n")
return
<t n="{$c}">{$u}</t>
}</r>
)
)