xquery version "3.1" encoding "utf-8";

(: run on BaseX 9.0.2; written by Giuseppe G. A. Celano; 
   This query creates a table where the syntax of each verb form Imp/Perf is 
   calculated
 :)

declare variable $path := 
            "/Users/mycomputer/Desktop/UDWorkshop2018/texts/00_01_merge_files/";

declare variable $r := "/Users/mycomputer/Desktop/UDWorkshop2018/01_lmer-after_default_aspect_assignment/texts/" || 
                       "00_02_p-valuesAfterReductionToPerfImp/";


for $u in file:list($path, true(), "*.xml")             (: to avoid .DS_Store :)
for $u2 in file:list($r,  true(), "*.xml")
where $u = $u2                         (: only the files where p-values exist :)

let $d1 := doc($path || $u)
where $d1//t[@f != "_"]         (: at least one t has a form different from _ :)

return

file:write( 

 "/Users/mycomputer/Desktop/UDWorkshop2018/01_lmer-after_default_aspect_assignment/texts/01_table_syntax_with_adjuncts/" 
 || replace($u, "xml", "tsv")
 
 ,

(
"LEMMA	WORD_FORM	CHAR_NUMBER	ASPECT	DEFAULT	SYNT-WITH-ADJUNCTS",

  for $s in $d1//s//t
  let $as := $s//v[@n="Aspect"]
  where $as and $s/@f != "_" and $s/@l != "_"
  order by $s/@l, $as
  return
                    
      let $syn := $s/parent::s/t[@h = $s/@i][@d != "punct"]
                                      [@d != "conj"]
                                      [@d != "cc"]
                                      [@d != "mark"]
                                      [@d != "parataxis"]
                                      [@d != "discourse"]
                                      [@d != "aux:pass"]
                                      [@d != "aux"]
                                      [@d != "orphan"]
                                      [@d != "goeswith"]
                                      [@d != "reparandum"]
                                      [@d != "dep"]
                                      [@d != "vocative"]
                                      [@d != "dislocated"]
                                      [@d != "acl"]
                                      [@d != "acl:relcl"]
                                      [@d != "amod"]
                                      [@d != "clf"]
                                      
                                      (: [@d != "advmod"] :)
                                      (: [@d != "advcl"] :)
                                      
                                      [@d != "flat:foreign"]
                                      [@d != "nummod"]
                                      [@d != "nummod:gov"]
                                      [@d != "appos"]
                                      [@d != "fixed"]
                                      [@d != "flat"]
                                      [@d != "compound"]
                                      [@d != "list"]
                                      [@d != "det"]
                                      [@d != "expl"]
                                      [@d != "case"]
                                      [@d != "nmod"]
                                      [@d != "cop"]
                                      
                                      (: [@d != "obl"] :)
                                      
                                      (: [@d != "nsubj"] :)
                                      (: [@d != "nsubj:pass"] :)
                                      (: [@d != "csubj"] :)
                                      (: [@d != "csubj"] :)                                      
                                      /@d


    where $syn
    
    for $d in doc($r || $u)//case[data(aspect-values/@sign) = "yes"]
    where $d/verb_lemma = $s/@l and $d//verb_form[@value = $s/@f]

    
    return

    string-join(

    <r>
    <l>{$s/@l/data(.)}</l>
    <f>{$s/@f/data(.)}</f>
    <n>{count(string-to-codepoints($s/@f))}</n>
    <a>{$as/data(.)}</a>
    <as>{if ($as = $d/aspect-values/@more-frequent) then 0 else 1}</as>
    <syn-all>
    {
    string-join(for $i in $syn/data(.) order by $i return $i, "_")
    }</syn-all>
    </r>/*
    , "	"
               )
)
, map{"item-separator": "&#xa;"})