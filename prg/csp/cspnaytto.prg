PROCEDURE cspnaytto
if alias()='LANGUAGE'
  select csp
endif
lc_alias=alias()
select csp
set filter to not released
lc_vartype=drgtpt.vartype
lc_varval=drgtpt.varval
set relation to
select drgtpt
set relation to
set filter to valid
if lc_alias='CSP' or (lc_alias='DRGTPT' and (drgtpt.vartype='OR' or drgtpt.vartype='CC'))
  do ..\csp\yhtnaytto
endif
if lc_alias<>'TPOMIN' and lc_alias<>'DGOMIN'
  *
  select dgomin
  set filter to valid
  seek SUBSTR(drgtpt.varval,1,2)+SUBSTR(drgtpt.varval,4,2)+SUBSTR(drgtpt.varval,3,1)
  if not found ()
    goto top
  endif
  browse window dgomin noedit nodelete fields dgprop, english, finish, inuse save nowait
  *
  select tpomin
  set filter to valid
  seek drgtpt.varval
  if not found ()
    goto top
  endif
  browse window tpomin noedit nodelete fields procprop:R, extens:3, or_1:3, english:R, finish:R, inuse:R save nowait
  *
  select (lc_alias)
  if lc_alias='CSP' or lc_alias='DRGTPT'
    if lc_alias='DRGTPT'
       select csp
       set order to code
       seek drgtpt.code
    endif
    lc_koodi=csp.ncsp
    pub_koodi=substr(csp.ncsp,1,3)
  else
    lc_koodi=ncsp
    pub_koodi=substr(ncsp,1,4)
    SELECT csp
    lc_order=order()
    set order to ncsp
    seek substr(lc_koodi,1,4)
    if not found()
      seek substr(lc_koodi,1,3)
    endif
    if not bof()
      skip -1
      skip
    endif
    set order to code
    do case
    case p_kieli='Fin'
      BROWSE WINDOW koodit nodelete FIELDS csp.usedate:6:R, csp.code:10:R, csp.text:R:40, csp.ncsp:7,;
      csp_en.text:40:R, drgtpt.chdate:6:R ; 
      SAVE nowait
    case p_kieli='Com'
      BROWSE WINDOW koodit noedit nodelete FIELDS csp.usedate:6:R, drgtpt.chdate:6:R, csp.code:10:R, csp.text:R:40;
      SAVE nowait
    otherwise
      BROWSE WINDOW koodit nodelete FIELDS csp.usedate:6:R, csp.code:10:R, csp.text:R:40, csp.ncsp:7,;
      csp_en.text:40:R, drgtpt.chdate:6:R, drgtpt.vartype:8:R, drgtpt.varval:7:R; 
      SAVE nowait
    endcase
    select drgtpt
    set filter to valid and code=csp.code
    BROWSE WINDOW drgtpt nodelete noedit fields drgtpt.vartype:8, drgtpt.varval:7, drgtpt.chdate:6, drgtpt.code:10 SAVE NOWAIT
  ENDIF
  IF lc_alias<>'NCSP_SUB'
    SELECT NCSP_SUB
    if p_kieli='Dan'
      set filter to substr(ncsp,1,3)=trim(substr(pub_koodi,2,3)) and not deleted()
    else
      set filter to substr(ncsp,1,3)=trim(pub_koodi) and not deleted()
    endif
    BROWSE WINDOW alaryh noedit nodelete FIELDS ncsp:7:R, text:70:R NOWAIT SAVE
  ENDIF
  IF lc_alias<>'NCSP_GRO'
    SELECT ncsp_gro
    if p_kieli='Dan'
      set filter to substr(ncsp,1,2)=trim(substr(pub_koodi,2,2)) and not deleted()
    else
      set filter to substr(ncsp,1,2)=trim(substr(pub_koodi,1,2)) and not deleted()
    endif
    BROWSE WINDOW ryhmat noedit nodelete FIELDS ncsp:7:R, text:70:R NOWAIT SAVE
  ENDIF
  IF lc_alias<>'NCSP_CHA'
    SELECT ncsp_cha
    if p_kieli='Dan'
      set filter to substr(ncsp,1,1)=trim(substr(pub_koodi,2,1)) 
    else
      set filter to substr(ncsp,1,1)=trim(substr(pub_koodi,1,1))
    endif
    BROWSE WINDOW luvut noedit nodelete FIELDS ncsp:7:R, text:70:R NOWAIT SAVE
  ENDIF
else
  select csp
  if p_kieli<>'Com'
    set relation to ncsp into csp_en additive
  endif
  select drgtpt
  set relation to code into csp
endif
DO CASE
CASE lc_alias='NCSP_CHA'
   SELECT ncsp_cha
   BROWSE WINDOW luvut noedit nodelete FIELDS ncsp:7:R, text:70:R SAVE nowait
   set filter to 
CASE lc_alias='NCSP_GRO'
   SELECT ncsp_gro
   set filter to 
   BROWSE WINDOW ryhmat noedit nodelete FIELDS ncsp:7:R, text:70:R SAVE nowait
CASE lc_alias='NCSP_SUB'
   SELECT ncsp_sub
   set filter to 
   BROWSE WINDOW alaryh noedit nodelete FIELDS ncsp:7:R, text: 70:R SAVE nowait
CASE lc_alias='CSP' or lc_alias='DRGTPT'
   SELECT csp
   lc_koo=code
   do case
   case p_kieli='Fin'
     set relation to ncsp into csp_en additive
     BROWSE WINDOW koodit noedit nodelete FIELDS csp.usedate:6, csp.released:2, csp.code:10:R, csp.text:R:40,csp.ncsp:7:R,;
     csp_en.text:40:R SAVE nowait
   case p_kieli='Com'
     BROWSE WINDOW koodit noedit nodelete FIELDS csp.usedate:6, csp.released:2, csp.code:10:R, csp.text:R:40;
     SAVE nowait
   otherwise
      set relation to ncsp into csp_en additive
      BROWSE WINDOW koodit nodelete FIELDS csp.usedate:6:R, csp.code:10:R, csp.text:R:40, csp.ncsp:7,;
      csp_en.text:40:R SAVE nowait
   endcase
   select drgtpt
   if lc_alias='DRGTPT'
     set filter to valid
     BROWSE WINDOW drgtpt fields drgtpt.code:10:R, drgtpt.vartype:8, drgtpt.varval:7, drgtpt.chdate:6, valid:2 SAVE NOWAIT
   else
     set filter to valid and code=csp.code
     skip -2
     BROWSE WINDOW drgtpt nodelete noedit fields drgtpt.vartype:8, drgtpt.varval:7, drgtpt.chdate:6, drgtpt.code:10 SAVE NOWAIT
   endif
CASE lc_alias='TPOMIN'
   select drgtpt
   do case
   case p_kieli='Fin'
     BROWSE WINDOW koodit noedit nodelete FIELDS csp.usedate:6, csp.released:2, drgtpt.vartype:8, drgtpt.varval:7, csp.code:10:R, csp.text:R:40, csp.ncsp:7:R, csp_en.text:40:R; 
     SAVE nowait
   case p_kieli='Com'
     BROWSE WINDOW koodit noedit nodelete FIELDS csp.usedate:6, csp.released:2, drgtpt.vartype:8, drgtpt.varval:7, csp.code:10:R, csp.text:R:40;
     SAVE nowait
   otherwise
     BROWSE WINDOW koodit noedit nodelete FIELDS csp.usedate:6, csp.released:2, drgtpt.vartype:8, drgtpt.varval:7, csp.code:10:R, csp.text:R:40, csp.ncsp:7:R, csp_en.text:40:R; 
     SAVE nowait
   endcase
CASE lc_alias='DGOMIN'
   select drgtpt
   do case
   case p_kieli='Fin'
     BROWSE WINDOW koodit noedit nodelete FIELDS csp.usedate:6, csp.released:2, drgtpt.vartype:8, drgtpt.varval:7, csp.code:10:R, csp.text:R:40, csp.ncsp:7:R, csp_en.text:40:R; 
     SAVE nowait
   case p_kieli='Com'
     BROWSE WINDOW koodit noedit nodelete FIELDS csp.usedate:6, csp.released:2, drgtpt.vartype:8, drgtpt.varval:7, csp.code:10:R, csp.text:R:40;
     SAVE nowait
   otherwise
     BROWSE WINDOW koodit noedit nodelete FIELDS csp.usedate:6, csp.released:2, drgtpt.vartype:8, drgtpt.varval:7, csp.code:10:R, csp.text:R:40, csp.ncsp:7:R, csp_en.text:40:R; 
     SAVE nowait
   endcase
ENDCASE
public p_omin, p_dgpr
p_omin=drgtpt.varval
p_dgpr=dgomin.dgprop
if p_kieli='Com'
  p_lproc=csp.code
else
  p_lproc=csp.ncsp
endif
RETURN

*: EOF: NAYTTO.PRG
