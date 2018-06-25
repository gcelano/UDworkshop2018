xquery version "3.1" encoding "utf-8";

(: run on BaseX 9.0.2; written by Giuseppe G. A. Celano; 
   This query puts together the train, dev, test files belonging to a certain
   treebank  
 :)

declare variable $path := "/Users/mycomputer/Desktop/UDWorkshop2018/" || 
                          "texts/00_00_CoNLLXML/";                  (: UD 2.1 :)

let $merge-files := distinct-values(for $t in file:list($path) return
                    replace($t, "-train.xml", "") => replace("-test.xml", "")
                    => replace("-dev.xml", ""))
for $i in $merge-files
let $files := for $u in  file:list($path, true(), $i || "*.xml")
              for $s in doc($path || $u)
              return
              $s
let $file-name := distinct-values($files//@ud_tbk)
return
file:write

("/Users/mycomputer/Desktop/UDWorkshop2018/01_lmer-after_default_aspect_assignment/texts/00_01_merge_files/" 
 || $file-name || ".xml",

<alltexts v="{$file-name}">{$files}</alltexts>)