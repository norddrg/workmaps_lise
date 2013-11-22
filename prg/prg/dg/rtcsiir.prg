*:******************************************************************************
*:
*: Procedure File C:\DATA\NDMS\PRG\DG\RTCSIIR.PRG
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
*:   rtcsiir
*!******************************************************************************
*!
*! Procedure RTCSIIR
*!
*!  Calls
*!      EOF
*!      INTO
*!      VALUES
*!      to
*!
*!******************************************************************************
procedure rtcsiir
	SELECT 0
	USE ..\rtc_str
	set SAFETY OFF
	COPY to (lc_siirto+'\rtc.dbf')TYPE foxplus next 0
	USE (lc_siirto+'\rtc.dbf') ALIAS apusiir
	append blank
	replace code with '#', text with 'NordDRG '+p_vers+' '+p_kieli+' '+dtoc(date())
	WAIT WINDOW NOWAIT 'RTC'
	SELECT rtc
	set ORDER to code
	lc_apu=lc_siirto+'\dgkat'
	goto Top
	do WHILE NOT EOF()
		INSERT INTO (lc_siirto+'\rtc.dbf') (code, text) VALUES (rtc.code, rtc.eng)
		DO case
		CASE p_kieli='Fin'
		  replace apusiir.text WITH rtc.fin
		CASE p_kieli='Ice' 
		  replace apusiir.text WITH rtc.ice
		CASE p_kieli='Swe'
		  replace apusiir.text WITH rtc.swe
		ENDCASE
		SELECT rtc
		SKIP
	ENDDO
	SELECT apusiir
	COPY to  (lc_siirto+'\rtc.xl2') TYPE XLS FIELDS code, text
	COPY to  (lc_siirto+'\rtc.txt') DELIMITED WITH CHAR ';' FIELDS code, text
	SELECT rtc
	USE
	SELECT apusiir
	USE
	return