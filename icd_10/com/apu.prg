procedure apu
clear all
use icd_10
select 0
USE "h:\ndms\icd_10\com\icd-10 second edition.dbf" alias b
select icd_10
set order to code
delete all
select b
goto top
do while not eof()
  select icd_10
  seek b.c1
  if found()
    if not (trim(icd_10.text)=trim(b.c3) and trim(b.c3)=trim(icd_10.text))
      replace change with ctod('01/01/2005')
    endif
    recall
  else 
    append blank
    replace change with ctod('01/01/2005')
  endif
  replace icd_10.code with b.c1
  replace icd_10.who with .t.
  replace icd_10.code_w with b.c1
  replace text with b.c3
  replace prim with .t. 
  replace valid with .t.
  replace headline with .f.
  replace ast with b.c2
  select b
  skip
enddo
select icd_10
*set filter to at('.',code)=0 and len(trim(code))=5
*recall all
*replace all change with ctod('2005/01/01')
*set filter to 
*browse
return