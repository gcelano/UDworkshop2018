xquery version "3.1" encoding "utf-8";

(: run on BaseX 8.6.7; written by Giuseppe G. A. Celano;
   This query calculates the Information Content  
 :)

declare variable $p :=
"/Users/mycomputer/Desktop/UDWorkshop2018/01_lmer-after_default_aspect_assignment/texts/01_table_syntax_with_adjuncts/";

for $f in file:list($p, true(), "*.tsv")
where file:size($p || $f) > 61 (: to avoid files with only the header :)
let $t := csv:parse(
          unparsed-text($p || $f), map {"separator": "	", "header": "yes"}
                   )

return

file:write(
"/Users/mycomputer/Desktop/UDWorkshop2018/01_lmer-after_default_aspect_assignment/texts/02_calculate_IC_for_01table/"
|| replace($f, "tsv", "txt")
,

(
"LEMMA	DEFAULT	FREQUENCY	IC	ASPECT	CHAR_NUMBER",

let $i :=
        for $k in $t//record
        group by $g := $k/LEMMA
        order by $g
        return
        <lemma word="{count($k)}">{  
        for $i in $k 
        group by $h := $i/DEFAULT
        order by $h
        return 
        <wf c2="{count($i)}">{    
        for $j in $i
        group by $h2 := $j/SYNT-WITH-ADJUNCTS
        order by $h2
        return
        <ds c3="{count($j)}">{$j}</ds> 
        }</wf>
        }</lemma>
let $all_v_sum := sum($i//@c3)
let $dis := distinct-values($i//SYNT-WITH-ADJUNCTS)
let $v := 
          for $v in $dis
          let $ff := $i//record[./SYNT-WITH-ADJUNCTS = $v] 
                                          (: number of unique-values for syntax, 
                                                        regarless of the verb :)
          return
          <v c="{count($ff)}">{$v}</v>
          
let $fin :=
  for $kl in $i//ds
  let $pp := $kl/record[1]
  return
  <verb>{
     $pp/LEMMA, 
     $pp/DEFAULT, 
     $pp/SYNT-WITH-ADJUNCTS, 
     <OCCUR>{$pp/parent::ds/@c3/data(.)}</OCCUR>,
     <IC_P>{- math:log( ($pp/parent::ds/@c3 div $all_v_sum) div 
                        ($v[. = $pp/SYNT-WITH-ADJUNCTS]/@c div sum($v/@c)) 
                      )
           }</IC_P>, 
     $pp/ASPECT, 
     $pp/WORD_FORM, 
     $pp/CHAR_NUMBER
  }</verb>
  
  
let $xm :=
  
  for $m in $fin
  group by $h1 := $m/LEMMA,   $h2 := $m/DEFAULT
  return
  <line>
  {$m}
  </line>
  
  
return

for $n in $xm (: e line :)

return
string-join(
($n/verb[1]/LEMMA, $n/verb[1]/DEFAULT, -math:log( sum($n/verb/OCCUR) div 
                                                  ($all_v_sum) ),
 
 (:sum($n/verb/IC_P) div sum($n/verb/OCCUR) , :)

 sum(for $k in $n/verb return $k/IC_P * $k/OCCUR) div sum($n/verb/OCCUR), 


$n/verb[1]/ASPECT , 

sum(for $k in $n/verb return $k/OCCUR * $k/CHAR_NUMBER) div sum($n/verb/OCCUR)

)
, "	")
), map {"item-separator": "&#xa;"}
)