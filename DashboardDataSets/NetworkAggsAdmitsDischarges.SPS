
get file='//covenas/decisionsupport/dbsvc.sav'   
/keep agency provname ru case opdate closdate svcdate county kidsru.

if xdate.mday($time) le 15 UnCookedMonth = DateSum($time,-1,"months").
if xdate.mday($time) gt 15 UnCookedMonth = DateSum($time,0,"months").
compute UnCookedMonth =date.moyr(xdate.month(UnCookedMonth), xdate.year(UnCookedMonth)).
formats UnCookedMonth(moyr6).
select if svcdate ge date.dmy(01,07,2010) and svcdate  lt UnCookedMonth.

Insert file= '//covenas/decisionsupport/modules\RenameCountySites.sps'.

IF xdate.tday(SVCDATE) ge yrmoda(2010,07,01) and xdate.tday(SVCDATE) lt yrmoda(2011,07,01) FYServed1011=1.
IF xdate.tday(SVCDATE) ge yrmoda(2011,07,01) and xdate.tday(SVCDATE) lt yrmoda(2012,07,01) FYServed1112=1.
IF xdate.tday(SVCDATE) ge yrmoda(2012,07,01) and xdate.tday(SVCDATE) lt yrmoda(2013,07,01) FYServed1213=1.
IF xdate.tday(SVCDATE) ge yrmoda(2013,07,01) and xdate.tday(SVCDATE) lt yrmoda(2014,07,01) FYServed1314=1.

IF xdate.tday(SVCDATE) ge yrmoda(2014,07,01) and xdate.tday(SVCDATE) lt yrmoda(2015,07,01) FYServed1415=1.
IF xdate.tday(SVCDATE) ge yrmoda(2015,07,01) and xdate.tday(SVCDATE) lt yrmoda(2016,07,01) FYServed1516=1.
IF xdate.tday(SVCDATE) ge yrmoda(2016,07,01) and xdate.tday(SVCDATE) lt yrmoda(2017,07,01) FYServed1617=1.

IF xdate.tday(SVCDATE) ge yrmoda(2017,07,01) and xdate.tday(SVCDATE) lt yrmoda(2018,07,01) FYServed1718=1.
IF xdate.tday(SVCDATE) ge yrmoda(2018,07,01) and xdate.tday(SVCDATE) lt yrmoda(2019,07,01) FYServed1819=1.
IF xdate.tday(SVCDATE) ge yrmoda(2019,07,01) and xdate.tday(SVCDATE) lt yrmoda(2020,07,01) FYServed1920=1.

compute calendarServed = date.MOYR(xdate.month(SVCDATE),xdate.year(SVCDATE)).
formats calendarServed (date11).

recode FYServed1011 FYServed1112 FYServed1213 FYServed1314 FYServed1415 FYServed1516 FYServed1617 FYServed1718 FYServed1920 (sysmis=0).

aggregate outfile='//covenas/decisionsupport/temp/fyservedcmx.sav'
   /break ru case 
   /FYServed1011=max(FYServed1011)
   /FYServed1112=max(FYServed1112)
   /FYServed1213=max(FYServed1213)
   /FYServed1314=max(FYServed1314)
   /FYServed1415=max(FYServed1415)
   /FYServed1516=max(FYServed1516)
   /FYServed1617=max(FYServed1617)
   /FYServed1718=max(FYServed1718)
   /FYServed1819=max(FYServed1819)
   /FYServed1920=max(FYServed1920).

get file='//covenas/decisionsupport/epsCG.sav'  /keep  ru case opdate closDate epflag.
sort cases by ru.
match files /table='//covenas/decisionsupport/rutable.sav' /file=* /by ru /keep ru case opdate closdate epflag county agency kidsru.
Insert file= '//covenas/decisionsupport/modules\RenameCountySites.sps'.


if xdate.mday($time) le 15 UnCookedMonth = DateSum($time,-1,"months").
if xdate.mday($time) gt 15 UnCookedMonth = DateSum($time,0,"months").
compute UnCookedMonth =date.moyr(xdate.month(UnCookedMonth), xdate.year(UnCookedMonth)).
formats UnCookedMonth(moyr6).

select if closdate lt UnCookedMonth or sysmis(closdate).
select if opdate lt UnCookedMonth.

insert file='//covenas/decisionsupport/meinzer/modules/admitdischarge.sps'.

compute calendarOpen = date.MOYR(xdate.month(opdate),xdate.year(opdate)).
compute calendarClose = date.MOYR(xdate.month(closdate),xdate.year(closdate)).
formats calendarOpen calendarClose(MOYR6).
compute counter=1.

sort cases by ru case.
match files /table='//covenas/decisionsupport/temp/fyservedcmx.sav' /file=* /by ru case.

string NewFYAdmit(a10).
 * if admit ="FY 11-12" and missing(FYServed1011)  NewFYAdmit="FY 11-12".
 * if admit ="FY 12-13" and missing(FYServed1112) NewFYAdmit="FY 12-13".
 * if admit ="FY 13-14" and missing(FYServed1213) NewFYAdmit="FY 13-14".
 * if admit ="FY 14-15" and missing(FYServed1314) NewFYAdmit="FY 14-15".
 * if admit ="FY 15-16" and missing(FYServed1415) NewFYAdmit="FY 15-16".
 * if admit ="FY 16-17" and missing(FYServed1516) NewFYAdmit="FY 16-17".
 * if admit ="FY 17-18" and missing(FYServed1617) NewFYAdmit="FY 17-18".
 * if admit ="FY 18-19" and missing(FYServed1718) NewFYAdmit="FY 18-19".
 * if admit ="FY 19-20" and missing(FYServed1819) NewFYAdmit="FY 19-20".

if admit ="FY 11-12" and (FYServed1011 = 0 or missing(fyserved1011)) NewFYAdmit="FY 11-12".
if admit ="FY 12-13" and (FYServed1112 = 0 or missing(fyserved1112)) NewFYAdmit="FY 12-13".
if admit ="FY 13-14" and (FYServed1213 = 0 or missing(fyserved1213)) NewFYAdmit="FY 13-14".
if admit ="FY 14-15" and (FYServed1314 = 0 or missing(fyserved1314)) NewFYAdmit="FY 14-15".
if admit ="FY 15-16" and (FYServed1415 = 0 or missing(fyserved1415)) NewFYAdmit="FY 15-16".
if admit ="FY 16-17" and (FYServed1516 = 0 or missing(fyserved1516)) NewFYAdmit="FY 16-17".
if admit ="FY 17-18" and (FYServed1617 = 0 or missing(fyserved1617)) NewFYAdmit="FY 17-18".
if admit ="FY 18-19" and (FYServed1718 = 0 or missing(fyserved1718)) NewFYAdmit="FY 18-19".
if admit ="FY 19-20" and (FYServed1819 = 0 or missing(fyserved1819)) NewFYAdmit="FY 19-20".

if NewFYAdmit ne " " NewCalAdmits = calendarOpen.

rename vars NewFYAdmit=fiscalyear.
temp.
select if fiscalYear ne " ".
aggregate outfile='//covenas/decisionsupport/temp/fiscalNewFYAdmits.sav' 
	/break= fiscalyear ru 
	/NewFYAdmit=sum(counter).

rename vars fiscalyear = deletexy.

rename vars admit=fiscalyear.
temp.
select if fiscalYear ne " ".
aggregate outfile='//covenas/decisionsupport/temp/fiscaladmits.sav' 
	/break= fiscalyear ru 
	/FYAdmits=sum(counter).

rename vars fiscalyear = deletex.
rename vars discharge=fiscalyear.	
temp.
select if fiscalYear ne " ".
aggregate outfile='//covenas/decisionsupport/temp/fiscalDischarge.sav'
	/break= fiscalyear RU
	/FYDischarges=sum(counter).

rename vars calendaropen=calendar.	
temp.
select if not missing(calendar).
aggregate outfile='//covenas/decisionsupport/temp/Monthadmits.sav'
	/break= calendar ru 
	/MonthlyAdmits=sum(counter).

rename variables calendar=psticks.

rename variables NewCalAdmits = calendar.
temp.
Select if not missing(calendar).
aggregate outfile='//covenas/decisionsupport/temp/NewMonthAdmits.sav'
   /break=calendar ru
   /NewCalAdmits = sum(counter).


rename vars calendar=deletexx.	
rename vars calendarclose=calendar.	
temp.
select if not missing(calendar).
aggregate outfile='//covenas/decisionsupport/temp/monthdischarge.sav'
	/break= calendar RU
	/MonthlyDischarges=sum(counter).

get file='//covenas/decisionsupport/rutable.sav' /keep ru provname agency.

vector calshell(50,f11).
compute CountMonths=datediff($time,date.dmy(1,7,2011),"months").
compute dateindex=1.

compute calshell1=date.dmy(1,7,2011).
loop count=2 to countmonths.
compute calshell(count)=datesum(calshell( dateindex),1,'month','closest').
compute dateindex=1 + dateindex.
end loop.
formats calshell1 to calshell50 (date11). 

match files /file=* /drop countmonths.
VARSTOCASES
/make Calendar from Calshell1 to calshell50.
exe.

insert file='//covenas/decisionsupport/modules/uncookedmonth.sps'.
select if calendar lt UnCookedMonth.


sort cases by calendar ru.
match files /table='//covenas/decisionsupport/temp/Monthadmits.sav' /file=* /by calendar ru.
match files /table='//covenas/decisionsupport/temp/NewMonthAdmits.sav' /file=* /by calendar ru. 
match files /table='//covenas/decisionsupport/temp/monthdischarge.sav' /file=* /by  calendar ru.

insert file='//covenas/decisionsupport/meinzer/modules/calfiscalyear.sps'.

sort cases by fiscalyear ru.
match files /table='//covenas/decisionsupport/temp/fiscalDischarge.sav' /file=* /by fiscalyear ru.
match files /table='//covenas/decisionsupport/temp/fiscaladmits.sav' /file=* /by fiscalyear ru.
match files /table='//covenas/decisionsupport/temp/fiscalNewFYAdmits.sav' /file=* /by fiscalyear ru.

select if calendar ge date.dmy(1,7,2011).
sort cases by ru calendar.

save outfile='//covenas/decisionsupport/temp\NetworkadmitsDC.sav' .
 

get file='//covenas/decisionsupport/temp\NetworkadmitsDC.sav' .
aggregate outfile=*
   /break=agency provname FiscalYear 
   /NewFYAdmit=max(NewFYAdmit)
   /FYAdmits=max(FYAdmits)
   /FYDischarges=max(FYDischarges).
sort cases by  agency provname FiscalYear.
save outfile='//covenas/decisionsupport/temp\NetworkFYadmitsDCx.sav' .
get file = '//covenas/decisionsupport/Network Office\FYTotalsX.sav'.
sort cases by  agency provname FiscalYear.
match files /table='//covenas/decisionsupport/temp\NetworkFYadmitsDCx.sav'   /file=* /by  agency provname FiscalYear.
exe.
recode NewFYAdmit FYAdmits FYDischarges (sysmis=0). 
rename variables totalclients=TotalFYRuClients totalagencyclients = TotalFYAgencyClients.
exe.
compute createDate = $time.
formats createDate(date11).

Aggregate outfile ='//covenas/decisionsupport/meinzer/temp/NetworkFYRUsAx.sav'
   /break fiscalyear agency ru RUProgram provname createDate
   /Discharges= max(FYDischarges) 
   /Admits = max(FYAdmits) 
   /NewAdmits = max(NewFYAdmit)
   /TotalFYRuClients = max(TotalFYRuClients)
   /TotalFYAgencyClients = max(TotalFYAgencyClients). 

*pushbreak.
 * get file='//covenas/decisionsupport/meinzer/temp/NetworkFYRUsAx.sav'.

 * SAVE TRANSLATE /TYPE=ODBC
 /Connect ='DSN=dashboarddatadev;UID=;APP=SPSS For'+
 ' Windows;WSID=HPMXL9360ZDD;DATABASE=dashboarddatadev;Trusted_Connection=Yes'
 /table= 'NetworkFYRUsA&D' /MAP/REPLACE  .
*pushbreak.





get file =  '//covenas/decisionsupport/temp/MonthlyTotals.sav'.
match files /table='//covenas/decisionsupport/temp\NetworkadmitsDC.sav' /file=* /by ru calendar.
recode NewFYAdmit FYAdmits FYDischarges MonthlyDischarges MonthlyAdmits NewCalAdmits (sysmis=0). 
rename variables totalmonthclients=TotalMonthRuClients totalclients=TotalFYRuClients.

compute createDate = $time.
formats createDate(date11).

Aggregate outfile ='//covenas/decisionsupport/meinzer/temp/NetworkCalRUsA.sav'
   /break fiscalyear calendar agency ru RUProgram provname  createDate
   /Discharges= max(monthlydischarges) 
   /Admits = max(MonthlyAdmits) 
   /NewAdmits = max(NewCalAdmits)
   /TotalMonthRuClients = max(TotalMonthRuClients)
   /TotalFYRuClients= max(TotalFYRuClients).

*pushbreak.
 * get file ='//covenas/decisionsupport/meinzer/temp/NetworkCalRUsA.sav'.

 * SAVE TRANSLATE /TYPE=ODBC
 /Connect ='DSN=dashboarddatadev;UID=;APP=SPSS For'+
 ' Windows;WSID=HPMXL9360ZDD;DATABASE=dashboarddatadev;Trusted_Connection=Yes'
 /table= 'NetworkCalRUsA&D' /MAP/REPLACE  .
*pushbreak.




