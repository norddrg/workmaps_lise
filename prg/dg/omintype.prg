Procedure omintype
parameter om_type, om_kieli
SELECT dg
om_wn=0
om_ln=0
om_found=.f.
select dg
SEEK upper(lc_icdo+lc_icde)+om_type
do while upper(dg.code+dg.d_code)+dg.vartype= upper(lc_icdo+lc_icde)+om_type
  om_found=.t.
  if valid
    do ominval with 'l', varval
  endif
  select dg
  skip
enddo
if not ((om_type='DGCAT' and om_found))
  SEEK lc_icdo+SPACE(6)+om_type
  do while upper(dg.code+dg.d_code)+dg.vartype= upper(lc_icdo)+SPACE(6)+om_type
    om_found=.t.
    if valid
      do ominval with 'l', varval
    endif
    select dg
    skip
  enddo
endif
if not ((om_type='DGCAT') or (om_type='COMPL' and om_found))
  SEEK upper(lc_icde)+SPACE(6)+om_type
  do while upper(dg.code+dg.d_code)+dg.vartype= upper(lc_icde)+SPACE(6)+om_type
    if valid
      do ominval with 'l', varval
    endif
    select dg
    skip
  enddo
endif

select dg_oth
om_found=.f.
SEEK upper(lc_wicdo+lc_wicde)+om_type
do while upper(code+d_code)+vartype= upper(lc_wicdo+lc_wicde)+om_type
  om_found=.t.
  if valid
    do ominval with 'w', varval
  endif
  select dg_oth
  skip
enddo
if not ((om_type='DGCAT' and om_found))
  SEEK upper(lc_wicdo)+SPACE(6)+om_type
  do while upper(code+d_code)+vartype= upper(lc_wicdo)+SPACE(6)+om_type
  	om_found=.t.
    if valid
      do ominval with 'w', varval
    endif
    select dg_oth
    skip
  enddo
endif
if not (om_type='DGCAT' or (om_type='COMPL' and om_found))
  SEEK lc_wicde+SPACE(6)+om_type
  do while upper(code+d_code)+vartype= upper(lc_wicde)+SPACE(6)+om_type
    if valid
      do ominval with 'w', varval
    endif
    select dg_oth
    skip
  enddo
endif
return
