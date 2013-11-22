*:******************************************************************************
*:
*: Procedure File C:\DATA\NDMS\PRG\DG\CCSIIR.PRG
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
*:   CCSIIR
*!******************************************************************************
*!
*! Procedure CCSIIR
*!
*!  Calls
*!      EOF
*!      INT
*!      INTO
*!      NOT
*!      SUBSTR
*!      VALUES
*!      to
*!
*!******************************************************************************
procedure CCSIIR
	lc_print=lc_siirto+'\kompkat.txt'
	SELECT 0
	USE ('..\..\old\'+p_kieli+'\kompkat') ALIAS old
	SELECT 0
	USE ..\cc_str
	COPY next 0 to (lc_siirto+'\muutos\kompkat') WITH cdx
	USE (lc_siirto+'\muutos\kompkat') ALIAS muutos

	SELECT dg
	SET ORDER TO varval
	SELECT kompkat
	WAIT WINDOW NOWAIT 'Complication categories'
	set ORDER to compl
	set FILTER to Valid
	set RELATION to SUBSTR(inclprop,1,2)+SUBSTR(inclprop,4,2)+SUBSTR(inclprop,3,1) INTO dgomin
	SELECT 0
	USE ..\kokat_st
	COPY next 0 to (lc_siirto+'\kompkat.dbf') TYPE foxplus
	use (lc_siirto+'\kompkat.dbf') alias apukomp
	INSERT INTO (lc_siirto+'\kompkat.dbf') (compl, text) VALUES ('#####', 'NordDRG '+p_vers+' '+p_kieli+' '+dtoc(date()))
	SELECT kompkat
	goto Top
	lc_n=0
	do WHILE NOT EOF()
		lc_n=lc_n+1
		if NOT inuse
			SKIP
			LOOP
		endif
		if 10*INT(lc_n/10)=lc_n
			WAIT WINDOW NOWAIT kompkat.compl
		ENDIF
		INSERT INTO (lc_siirto+'\kompkat.dbf') (compl, inclprop, text);
			VALUES (kompkat.compl, kompkat.inclprop, kompkat.english)
		SELECT dg
	    SEEK 'COMPL   '+SUBSTR(kompkat.compl,1,2)+SUBSTR(kompkat.compl,4,2)+'G'
	    IF FOUND()
 		  INSERT INTO (lc_siirto+'\kompkat.dbf') (compl, inclprop, text);
			VALUES (SUBSTR(kompkat.compl,1,2)+'G'+SUBSTR(kompkat.compl,4,2), kompkat.inclprop, TRIM(kompkat.english)+'- major CC')
	    ENDIF 
		SELECT kompkat
		SKIP
	ENDDO
	select apukomp
	COPY to (lc_siirto+'\kompkat.xl2') TYPE XLS 
	use
	SELECT kompkat
	set RELATION to
	goto Top
	do WHILE NOT EOF()
		SELECT old
		do WHILE SUBSTR(old.compl,1,2)+SUBSTR(old.compl,4,2)+SUBSTR(old.compl,3,1) + old.inclprop<;
				SUBSTR(kompkat.compl,1,2)+SUBSTR(kompkat.compl,4,2)+SUBSTR(kompkat.compl,3,1)+kompkat.inclprop AND NOT EOF()
			SELECT dgomin
			SEEK SUBSTR(old.inclprop,1,2)+SUBSTR(old.inclprop,4,2)+SUBSTR(old.inclprop,3,1)
			INSERT INTO (lc_siirto+'\muutos\kompkat') (new, compl, comptext, inclprop, proptext);
				VALUES ('D', old.compl, kompkat.english, old.inclprop,dgomin.english )
			SELECT old
			SKIP
		ENDDO
		if NOT (SUBSTR(old.compl,1,2)+SUBSTR(old.compl,4,2)+SUBSTR(old.compl,3,1)=;
				SUBSTR(kompkat.compl,1,2)+SUBSTR(kompkat.compl,4,2)+SUBSTR(kompkat.compl.3,1) AND old.inclprop=kompkat.inclprop
			if NOT (inclprop=' ')
				SELECT dgomin
				SEEK SUBSTR(kompkat.inclprop,1,2)+SUBSTR(kompkat.inclprop,4,2)+SUBSTR(kompkat.inclprop,3,1)
				INSERT INTO (lc_siirto+'\muutos\kompkat') (new, compl, comptext, inclprop, proptext);
					VALUES ('N', kompkat.compl, kompkat.english, kompkat.inclprop, dgomin.english)
			ENDIF 
		ELSE
			SELECT old
			SKIP
		endif
		SELECT kompkat
		SKIP
	ENDDO
	SELECT muutos
	COPY to (lc_siirto+'\muutos\kompkat.xls') TYPE XL5
	USE
	SELECT old
	USE
	return