declare variable $u := "/Users/mycomputer/Desktop/UDWorkshop2018/01_lmer-after_default_aspect_assignment/texts/00_01_merge_files/";

for $t in file:list($u)[2]
return
  for $h at $c in doc($u || $t)//t[@d != "punct"]
  group by $g := fn:lower-case($h/@f), $i :=$h/@l
  order by count($c) descending
  return
  
  <g n="{count($c)}">
  <f>{$h[1]/@f/data(.)}</f>
  <n>{count(string-to-codepoints($h[1]/@f))}</n>
  <freq>{count($c)}</freq>
  <l>{$h[1]/@l/data(.)}</l>
  </g>/*
  
  => string-join("	")
