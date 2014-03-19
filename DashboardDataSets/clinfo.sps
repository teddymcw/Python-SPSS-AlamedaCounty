GET DATA  /TYPE=ODBC
  /CONNECT='DSN=MHS;Description=Insyst E1 - CG Copy;UID=;APP=IBM SPSS Products: Statistics '+
    'Common;WSID=WINSPSSV4;Database=CG_Snappers;Trusted_Connection=Yes'
  /SQL='SELECT  CLIENT_NUMBER as "case"  , CLIENT_NAME as xname, SOCIAL_SECURITY_NUMBER as ssn, '+ 
    'BIRTH_DATE as bday, ETHNICITY as xethnic, SEX as gender, '+
    'HISPANIC_ORIGIN as xhispanic, BIRTH_NAME as xbornname, MARITAL_STATUS as xmarital, DISABILITY as disab, EDUCATION as educ, '+
    'PREFERRED_LANGUAGE as xlanguage, CAREGIVER1 as minors, CLIENT_STAMP as created, '+
    'CLIENT_INDEX_NUMBER as xcin FROM CG_Snappers.dbo.[CLIENTS] order by client_number'
  /ASSUMEDSTRWIDTH=255.

CACHE.
EXECUTE.

string marital hispanic language ethnic(a1).
string cin (a9).
string bornname name(a28).
string sex(a5).
formats minors educ disab(f12).

*jb exception.
compute cin=ltrim(xcin).

compute language=xlanguage.
compute marital=xmarital.
compute bornname=xbornname.
compute hispanic=xhispanic.
compute sex=gender.
compute ethnic=xethnic.
compute name=xname.
compute bornname=xbornname.

formats ssn case(f8).
formats bday created (date11).

variable labels
case 'CLIENTS.CLIENT_NUMBER'
name 'CLIENTS.CLIENT_NAME'
bornname 'CLIENTS.BIRTH_NAME'
sex 'CLIENTS.SEX'
bday 'CLIENTS.BIRTH_DATE'
ethnic 'CLIENTS.ETHNICITY'
language 'CLIENTS.PREFERRED_LANGUAGE'
disab 'CLIENTS.DISABILITY'
educ 'CLIENTS.EDUCATION'
hispanic 'CLIENTS.HISPANIC_ORIGIN'
created 'CLIENTS.CLIENT_STAMP'
cin 'CLIENTS.CLIENT_INDEX_NUMBER'
marital 'CLIENTS.MARITAL_STATUS'
minors 'CLIENTS.CAREGIVER1'.

match files /file=* /keep bday created case ssn disab educ minors ethnic language hispanic marital sex cin name bornname.
save outfile='//covenas/decisionsupport/Meinzer/Production/Backup/stage/clinfo.sav'.
 * save outfile='//covenas/spssdata/clinfo.sav'.

insert file='//covenas/decisionsupport/meinzer/production/ps/modules/varinfo.sps'.
