PROCEDURE muutlogi

DEFINE WINDOW drgnames FROM max_y/5,3 TO 3*(max_y/5+5), max_x TITLE 'DRGnimet' FONT max_foty,  max_fosi 
DEFINE WINDOW drglogic FROM max_y/3,3 TO max_y,max_x TITLE 'DRG:n loogiset s��nn�t' FONT max_foty,  max_fosi 

ACTIVATE WINDOW valikko
CLEAR
@ 0,0 SAY 'NordDRG - logic of the DRG assignment'
@ 2,0 SAY '[F11] update the screen'
@ 3,0 SAY '[Alt][B] lis�� rivi logiikkatauluun'
@ 4,0 SAY '[F9] vaihda j�rjestys jarj/drg/mdc'

@ 6,0 SAY 'Merkitse poistettavat hiirell�'

@ 8,0 SAY '[F7] palaa perusn�ytt��n'


ON KEY LABEL f12
ON KEY LABEL alt+f12
ON KEY LABEL alt+x
ON KEY LABEL f10
ON KEY LABEL ctrl+f9
ON KEY LABEL alt+f9
ON KEY LABEL f8
ON KEY LABEL alt+f8
ON KEY LABEL ctrl+s
ON KEY LABEL ctrl+f1
ON KEY LABEL alt+f1
ON KEY LABEL ctrl+t
ON KEY LABEL ctrl+i
ON KEY LABEL alt+i
ON KEY LABEL ctrl+K
ON KEY LABEL alt+K
ON KEY LABEL alt+A
ON KEY LABEL alt+l

ON KEY LABEL f7 DO logipal
ON KEY LABEL f11 DO muutlogi
ON KEY LABEL f9 DO logijarj
ON KEY LABEL alt+B DO logiappe
ON KEY LABEL ctrl+B DO apuikk WITH .T.

select drglogic
set order to mdc
seek substr(dg.dgkat,1,2)
set order to jarj

SELECT drgnames
BROWSE WINDOW drgnames NOWAIT SAVE FIELDS mdc, drg,nimike:75,name:75
SELECT drglogic
SET FILTER TO NOT DELETED()
BROWSE WINDOW drglogic NOWAIT SAVE FIELDS jarj, drg, drgnames.nimike:40,icd,mdc,pdgomin, or,tp1,tp2,tp3,dgkat1,dgkat2,ikaraja,kompl,;
   sex,dgomin1,dgomin2, dgomin3, dgomin4, stp1, exitus
RETURN
*: EOF: MUUTLOGI.PRG
