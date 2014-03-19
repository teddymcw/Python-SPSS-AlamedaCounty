GET
  FILE='//covenas/decisionsupport/dbsvc.sav'.

select if svcdate ge datesum(svcdate,-3,'years').

sort cases by case.
match files /file=* /table='//covenas/spssdata/clinfo.sav' /by case /keep name agency
provname
ru
case
opdate
closdate
svcdate
svcmode
psmask2
proced
county
MCSvcCat
kidsru
calendar
duration
duration2
cost
LastService
ProcLong
svcAge
PrimaryTherapist
staff
bday
epflag
primdx
unit
ab3632RU
DayTx
RU2
service_Stamp
svc_Stmp.

rename vars primarytherapist=staffname name=clientname.

save outfile='//covenas/decisionsupport/meinzer/temp/Dashboard_svc3yearsy.sav'.


*pushbreak.
*skiprow.
*sqlTable =Dashboard_svc3years.
*spsstable='//covenas/decisionsupport/meinzer/temp/Dashboard_svc3yearsy.sav'.
*pushbreak.