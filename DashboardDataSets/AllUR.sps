*get file='//covenas/decisionsupport/AllUR.sav'.

GET DATA
  /TYPE=ODBC
  /CONNECT='DSN=MHS;UID=;DATABASE=CG_Snappers;Trusted_Connection=Yes;APP=IBM SPSS Products: Statistics '+
    'Common;WSID=HPMXL2221NXK'
  /SQL='SELECT convert(varchar(23), episode_Stamp,121) AS EPSTAMP, UR_EFFECTIVE_DATE, UR_EXPIRATION_DATE, PERIOD_START_DATE, '+
    'PERIOD_END_DATE, UR_ACTION_TYPE, CLIENT_NUMBER as [case], UR_AUTHORIZATION_STAMP, REPORTING_UNIT as RU FROM '+
    'CG_Snappers.dbo.[UTILIZATION_REVIEW]'
  /ASSUMEDSTRWIDTH=255.

CACHE.
EXECUTE.

select if UR_EXPIRATION_DATE gt UR_EFFECTIVE_DATE.

if substr(epstamp,20,1) = " " epstamp=concat(rtrim(epstamp),".000").
rename variables epstamp=epStamp2.
string epStamp(a23).
compute epstamp = substr(epstamp2,1,23).	 

sort cases by epstamp.
match files /table='//covenas/decisionsupport/EpStampMatch.sav' /file=* /by epstamp.

select if not missing(opdate).
select if opdate ge date.dmy(1,1,2008).

sort cases by ru.
match files/table='//covenas/decisionsupport/rutable.sav'/file=*/by ru /keep epStamp
opdate
UR_EFFECTIVE_DATE
UR_EXPIRATION_DATE
PERIOD_START_DATE
PERIOD_END_DATE
UR_ACTION_TYPE
case psmask2
UR_AUTHORIZATION_STAMP ru ru2.

select if psMask2=5.

 * if ru2 ne "  " RU=ru2.

rename vars
epstamp=EpStampText
PERIOD_START_DATE=pstart
PERIOD_END_DATE=pend
UR_ACTION_TYPE=action
UR_EFFECTIVE_DATE=effdate
UR_EXPIRATION_DATE=expdate
UR_AUTHORIZATION_STAMP=urstamp.

variable labels 
opdate	'opdate'
pstart	'pstart'
pend	'pend'
action	'action'
case	'case'
effdate	'effdate'
expdate	'expdate'
urstamp	'urstamp'.

 * compute justdate=number(substring(EpStampText,1,10),sdate10).
 * compute justtime=number(substring(EpStampText,index(EpStampText," ")+1,13),time11).
 * compute epStamp=justtime+justdate.

match files /file=* /drop ru2 psmask2.

formats case action (f12.0).
formats urstamp expdate effdate pend pstart opdate (date11).
save outfile='//covenas/decisionsupport/Meinzer/Production/Backup/stage/AllUR.sav' /keep opdate pstart pend 
action  case effdate expdate urstamp ru.

****EPSTAMP????.

