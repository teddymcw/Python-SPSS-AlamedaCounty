

GET DATA
  /TYPE=ODBC
  /CONNECT='DSN=AOD;UID=;Trusted_Connection=Yes;APP=IBM SPSS Products: Statistics '+
    'Common;WSID=HPMXL2221NXK;DATABASE=CG_AOD'
  /SQL='SELECT CLIENT_NUMBER AS "case", COUNTY_NUMBER AS casemhs, CLIENT_NAME AS name, SEX, '+
    'BIRTH_DATE AS bday, ETHNICITY AS ethnic, PREFERRED_LANGUAGE AS "LANGUAGE", DISABILITY AS '+
    'DISAB, EDUCATION AS EDUC, HISPANIC_ORIGIN AS HISPANIC, CLIENT_STAMP AS reg_date, '+
    'MARITAL_STATUS AS MARITAL, CLIENT_INDEX_NUMBER AS cin, SOCIAL_SECURITY_NUMBER AS ssn FROM '+
    'CG_AOD.dbo.[CLIENTS]'
  /ASSUMEDSTRWIDTH=255.
VARIABLE LABELS case 'CLIENT_NUMBER'.
VARIABLE LABELS casemhs 'COUNTY_NUMBER'.
VARIABLE LABELS name 'CLIENT_NAME'.
VARIABLE LABELS bday 'BIRTH_DATE'.
VARIABLE LABELS ethnic 'ETHNICITY'.
VARIABLE LABELS LANGUAGE 'PREFERRED_LANGUAGE'.
VARIABLE LABELS DISAB 'DISABILITY'.
VARIABLE LABELS EDUC 'EDUCATION'.
VARIABLE LABELS HISPANIC 'HISPANIC_ORIGIN'.
VARIABLE LABELS reg_date 'CLIENT_STAMP'.
VARIABLE LABELS MARITAL 'MARITAL_STATUS'.
VARIABLE LABELS cin 'CLIENT_INDEX_NUMBER'.
VARIABLE LABELS ssn 'SOCIAL_SECURITY_NUMBER'.
CACHE.
EXECUTE.
save outfile='//covenas/decisionsupport/Meinzer/Production/Backup/stage/aodClinfo.sav'.
