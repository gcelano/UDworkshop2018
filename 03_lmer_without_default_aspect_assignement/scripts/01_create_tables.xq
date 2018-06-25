declare variable $u := "/Users/mycomputer/Documents/UDWorkshop2018BigFiles/00_01_merge_files/";


for $t in file:list($u, true(), "*.xml")
return
  
  file:write("/Users/mycomputer/Documents/UDworkshop2018/03_lmer_without_default_aspect_assignement/texts/01_create_tables/" || replace($t, "xml", "txt"),
  
  (
  "FORM	CHAR_NUMBER	FREQ	ASPECT	LEMMA" ,
  
  for $s at $c in doc($u || $t)//t
  let $as := $s//v[@n="Aspect"]
  where $as and $s/@f != "_" and $s/@l != "_"
  group by  $f := $s/@f, $l := $s/@l
  return
  
  string-join(
  <g c="{count($c)}">
  <f>{$s[1]/@f/data(.)}</f>
  <n>{count(string-to-codepoints($s[1]/@f))}</n>
  <freq>{count($c)}</freq>
  <aspect>{$s[1]//v[@n="Aspect"]/data(.)}</aspect>
  <l>{$s[1]/@l/data(.)}</l>
  </g>/*
  ,
  "	")
  )
  
  
  ,map {"item-separator": "&#xa;"})
 