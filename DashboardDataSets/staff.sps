
GET DATA
  /TYPE=ODBC
  /CONNECT='DSN=mhs;Description=mhs;UID=;Trusted_Connection=Yes;APP=IBM SPSS Products: '+
    'Statistics Common;WSID=HPMXL2221NXK;DATABASE=CG_Snappers'
  /SQL='SELECT STAFF_NUMBER AS staff, STAFF_MASK as position,STAFF_NAME as name,SEX as sex,BIRTH_DATE as bday,STAFF_ETHNICITY as ethnic,STAFF_LANGUAGE_MASK langcod,STAFF_SSN as ssn,'+
   'STAFF_START_DATE as st_date,STAFF_END_DATE as end_date,STAFF_STATUS as st_stat,STAFF_COUNTY_CLASS as classif FROM '+
    'CG_Snappers.dbo.[STAFF_MASTER]'
  /ASSUMEDSTRWIDTH=255.

CACHE.
EXECUTE.

formats staff position ssn langcod st_stat(f12).
formats bday st_date end_date(date20).
alter type sex(a5).
alter type name(a28).
alter type ethnic(a1).
alter type classif(a3).

VARIABLE LABELS
staff	"STAFF_NUMBER"
position	"STAFF_MASK"
name	"STAFF_NAME"
sex	"SEX"
bday	"BIRTH_DATE"
ethnic	"STAFF_ETHNICITY"
langcod	"STAFF_LANGUAGE_MASK"
ssn	"STAFF_SSN"
st_date	"STAFF_START_DATE"
end_date	"STAFF_END_DATE"
st_stat	"STAFF_STATUS"
classif	"STAFF_COUNTY_CLASS".

if missing(bday) bday=date.dmy(17,11,1858).
if missing(st_date) st_date=date.dmy(17,11,1858).
if missing(end_date) end_date=date.dmy(17,11,1858).
*if closdate lt date.dmy(1,1,1900) closdate=$sysmis.


sort cases by staff.
 * xsave outfile='//covenas/decisionsupport/staff.sav'.
save outfile='//covenas/decisionsupport/Meinzer/Production/Backup/stage/staff.sav'.
