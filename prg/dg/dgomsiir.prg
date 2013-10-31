*:******************************************************************************
*:
*: Procedure File C:\DATA\NDMS\PRG\DG\DGOMSIIR.PRG
*:
*:	
*:	
*:	
*:	
*:	
*:	
*:	
*:	
*:	Nordic Centre for Classification of Diseases
*:	
*:	Nordic Centre for Classification of Diseaes
*:	NordDRG Maintenance system
*:	
*:
*: Documented using Visual FoxPro Formatting wizard version  .05
*:******************************************************************************
*:   DGOMSIIR
*!******************************************************************************
*!
*! Procedure DGOMSIIR
*!
*!  Calls
*!      EOF
*!      INTO
*!      VALUES
*!      found
*!      to
*!
*!******************************************************************************
procedure DGOMSIIR
	WAIT WINDOW NOWAIT 'Diagnosis properties'
	SELECT 0
	USE ..\dgom_st
	COPY to (lc_siirto+'\dgomin.dbf')TYPE foxplus
	USE (lc_siirto+'\dgomin.dbf') ALIAS apusiir
	append blank
	replace dgprop with '#####', text with 'NordDRG '+p_vers+' '+p_kieli+' '+dtoc(date())
	SELECT dgomin
	set ORDER to dgprop
	set FILTER to Valid
	goto Top
	do WHILE NOT EOF()
		SELECT catomin
		SEEK dgomin.dgprop
		if NOT found() OR NOT inuse
			if NOT found()
				APPEND BLANK
				REPLACE catomin WITH dgomin.dgprop, inuse WITH .F.
			endif
			SELECT dgomin
			SKIP
			LOOP
		endif
		SELECT dgomin
		INSERT INTO (lc_siirto+'\dgomin.dbf')(dgprop, text) VALUES (dgomin.dgprop, dgomin.english)
		SELECT dgomin
		SKIP
	ENDDO
	SELECT apusiir
	COPY to (lc_siirto+'\dgomin.xl2') TYPE XLS
	COPY to (lc_siirto+'\dgomin.txt') DELIMITED WITH CHAR ';'
	SELECT apusiir
	USE
	return