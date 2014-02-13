DEFINE DBstartdate() date.dmy(1,7,2012) !ENDDEFINE.
define TAYkeepRU() '81931','81441','81442','88036','01101','01D81','01E81','01GF1','01GG1','018435','01FH1','01FK1','01FK2','81935','01ES1','01E31' !ENDDEFINE.

*pull indirect services code is from kim. chet did not change it.
insert file='//covenas/decisionsupport/meinzer/production/ps/IndirectSVC.sps'.

 * begin program.
 * main('IndirectS')
end program.

save outfile='//covenas/decisionsupport/temp/IndirectDBsvc.sav'.

Select if proced ne 300.
select if any(ru,TAYkeepRU).

Sort cases by ru.
Match files/table='//covenas/spssdata/RUTable.sav' /file=*/by ru /Keep Ru provname svcdate proced staff hours minute svcMode agency.


*DURATION CODE TO USE FOR PRODUCTIVITY--INDIRECT.
recode minute(sysmis=0).
recode hours(sysmis=0).
compute hours2=0.
compute hours2=(minute)/60.
compute duration=hours+hours2.

sort cases by proced.
Match Files/Table='//covenas/spssdata/procedSMA.sav'/File=*/by proced.
exe.
Select if substr(FSPSvcCatShort,1,1) = "4".

String GCSvcGroup(A35).
If svc_cat="grp therapy" GCSvcGroup="Group".
If svc_cat="crisis intervention" GCSvcGroup="Crisis".
If svc_cat="assessment" or svc_cat="evaluation" or svc_cat="planning" GCSvcGroup="Assess_Eval_PlanDevel".
If svc_cat="ind therapy" or svc_cat="collateral" or svc_cat="family therapy" GCSvcGroup="Ind_Collat_Fam".
If svc_cat="brokerage" GCSvcGroup="Brokerage".
If svc_cat="court eval" GCSvcGroup="Court-Ordered Eval".
If FSPsvcCatShort="4. MAA Services" GCSvcGroup="MAA".

Compute drop=0.
If substr(Proclong,1,3)="Day" drop=1.
If svc_cat="meds" drop=1.

*Temp.
*select if GCsvcGroup = " ".
*freq proclong.

If GCsvcGroup = " " drop=1.
Select if drop=0.

rename vars svcdate=tempdate.
insert file='//covenas/decisionsupport/meinzer/modules/tempdatefy.sps'.
rename vars tempdate=svcdate.
insert file ='//covenas/decisionsupport/modules/calsvcdate.sps'.
*This file gets matched into the mcsvccats.
save outfile='//covenas/decisionsupport/temp/maasvcTAY.sav' /keep provname mcsvccat ru fiscalyear calendar duration proced proclong svcmode.


*this section calculates admits and discharges.

get file='//covenas/spssdata/epsCG.sav'  /keep  ru case opdate closDate epflag primdx PrimaryTherapist staff lastService.
select if any(ru,TAYkeepRU).

insert file='//covenas/decisionsupport/modules/uncookedmonth.sps'.
select if opdate lt UnCookedMonth and (Closdate ge DBstartdate or sysmis(closdate)).

compute counter=1.
*use for length of stay and tis.
save outfile='//covenas/decisionsupport/meinzer/temp/TAYlos.sav'.

* use fo last svc in 90 days.
compute PriorMonth=datesum(UnCookedMonth, -1,'months').
formats PriorMonth uncookedmonth(date11).
Temp.
select if opdate lt UnCookedMonth and (closdate ge PriorMonth or sysmis(closdate)).
save outfile '//covenas/decisionsupport/meinzer/temp/lastepmonthTAY.sav'.

*this is weird... but dont want to lose admits, so if we forget about your closdate, the math works out.
if closdate ge uncookedmonth closdate=$sysmis.

insert file='//covenas/decisionsupport/meinzer/modules/admitdischarge.sps'.

rename vars admit=fiscalyear.
compute admitselect=1.
temp.
select if fiscalYear ne " ".
xsave outfile='//covenas/decisionsupport/temp/admitstaytest.sav'.
aggregate outfile='//covenas/decisionsupport/meinzer/temp/fiscaladmitsTAY.sav' 
	/break= fiscalyear ru 
	/FYAdmits=sum(counter).

rename vars fiscalyear = deletex.
rename vars discharge=fiscalyear.	
compute admitselect=0.
temp.
select if fiscalYear ne " ".
xsave outfile='//covenas/decisionsupport/temp/dcsstaytest.sav'.
aggregate outfile='//covenas/decisionsupport/meinzer/temp/fiscalDischargeTAY.sav'
	/break= fiscalyear RU
	/FYDischarges=sum(counter).

rename vars calendaropen=calendar.	
temp.
select if not missing(calendar).
aggregate outfile='//covenas/decisionsupport/meinzer/temp/MonthadmitsTAY.sav'
	/break= calendar ru 
	/MonthlyAdmits=sum(counter).

rename vars calendar=deletexx.	
rename vars calendarclose=calendar.	
temp.
select if not missing(calendar).
aggregate outfile='//covenas/decisionsupport/meinzer/temp/monthdischargeTAY.sav'
	/break= calendar RU
	/MonthlyDischarges=sum(counter).

add files
/file='//covenas/decisionsupport/temp/dcsstaytest.sav'
/file='//covenas/decisionsupport/temp/admitstaytest.sav'.

sort cases by case.
match files /table='//covenas/spssdata/clinfo.sav' /file=* /by case.
rename vars primdx=dx.
sort cases by dx.
match files /table='//covenas/decisionsupport/dxtable.sav' /file=* /by dx.

save outfile='//covenas/decisionsupport/temp/admitDCcaselistTay.sav' /keep case name bday opdate dx_descr closdate.

*pushbreak.
*get file='//covenas/decisionsupport/temp/admitDCcaselistTay.sav'. 

 * SAVE TRANSLATE /TYPE=ODBC
 /Connect ='DSN=Dashboarddatadev;UID=;APP=SPSS For'+
 ' Windows;WSID=HPMXL9360ZDD;DATABASE=Dashboarddatadev;Trusted_Connection=Yes'
 /table= 'TAY_AdmitDCCaselistByFY' /MAP/REPLACE.
*pushbreak.

select if admitselect=0.
sort case by ru.
match files /table='//covenas/decisionsupport/rutable.sav' /rename tayru=xxx /file=*  /by ru.
sort cases by case.
rename vars ru=TayRU opdate=Tayopdate closdate=TayClosdate provname=TayProvname.

save outfile='//covenas/decisionsupport/temp/dischargeList.sav' /keep TayRU TayProvname case FiscalYear TayOpdate Tayclosdate.
compute TayDCclient=1.
aggregate outfile='//covenas/decisionsupport/dischargeUnique.sav'
   /break case
   /TayDCclient=max(TayDCclient).

 * get file='//covenas/decisionsupport/temp/dischargeList.sav' .

*services after discharge from TAY RU.

get file='//covenas/decisionsupport/dbsvc.sav' /keep agency provname ru case opdate closdate proced svcdate cost calendar duration psmask2 MCsvcCat svcMode PrimaryTherapist staff proclong epflag.
select if svcdate ge DBstartdate.
save outfile='//covenas/decisionsupport/dbsvc2011only.sav'.
select if not proced=197.
select if proced lt 800.

*get file='//covenas/decisionsupport/dbsvc2011only.sav'.
sort cases by case.

*only interested in services for people that had a TAY DC.
match files /table='//covenas/decisionsupport/dischargeUnique.sav' /file=* /by case.
select if TayDCclient=1.
*save outfile='//covenas/decisionsupport/dbsvc2011TayonlyTAY.sav'.


*get file='//covenas/decisionsupport/dbsvc2011TayonlyTAY.sav'  /keep case opdate svcdate ru primarytherapist.
sort cases by case.
CASESTOVARS   
/id=case.

*use discharge list with fiscal year needs everypossible service matched by case. 
sort cases by case.
match files /table=* /file='//covenas/decisionsupport/temp/dischargeList.sav' /by case.
exe.
compute svcdatex=999999999999999.
compute opdatex=9999999999999999.
string rux(a6).
string primarytherapistx(a28).
compute rux='None'.
sort variables by name.
VARSTOCASES
/make primarytherapist from primarytherapist.1 to primarytherapistx
/make svcdate from svcdate.1 to svcdatex
/make ru from ru.1 to rux
/make opdate from opdate.1 to opdatex.

*This select is keeping services that happend within 30 days of discharge, and because ru=none is still in mix, it does not delete anyone.
select if (tayclosdate lt svcdate and svcdate le datesum(tayclosdate,30,'days')) or ru='None'.
 * compute x=datedif(tayclosdate, svcdate,'days').
 * freq x/formats=notable/stats=min max.

do if opdate gt date.moyr(1,2050).
compute opdate=$sysmis.
compute svcdate=$sysmis.
end if.

aggregate outfile=* mode=addvariables
   /break case fiscalyear
   /records=n.

select if not missing(opdate) or (missing(opdate) and records = 1).

sort cases by ru. 
match files /table='//covenas/decisionsupport/rutable.sav'/rename tayru=xxx /file=*  /by ru.
sort cases by case.
match files /table='//covenas/spssdata/clinfo.sav' /file=* /by case.
if ru='None' provname=ru.

save outfile='//covenas/decisionsupport/temp/TayFollowupSVcs.sav' /keep TayRU TayProvname Tayopdate case svcdate fiscalyear name agency provname ru primarytherapist opdate .

get file='//covenas/decisionsupport/temp/TayFollowupSVcs.sav'. 
*pushbreak.
*get file='//covenas/decisionsupport/temp/TayFollowupSVcs.sav'. 

 *SAVE TRANSLATE /TYPE=ODBC
 /Connect ='DSN=Dashboarddatadev;UID=;APP=SPSS For'+
 ' Windows;WSID=HPMXL9360ZDD;DATABASE=Dashboarddatadev;Trusted_Connection=Yes'
 /table= 'TAY_FollowUpEps' /MAP/REPLACE.
*pushbreak.

*total number of clients that had a discharge destination or not.
sort cases by tayru fiscalyear ru case .
match files /file=* /by tayru fiscalyear ru case  /first=TayruFiscalyearRUcase1.

aggregate outfile='//covenas/decisionsupport/temp/TayFollowupRUs.sav'
   /break TayRU TayProvname provname ru FiscalYear 
   /Clients=sum(TayruFiscalyearRUcase1).

*pushbreak.
*get file='//covenas/decisionsupport/temp/TayFollowupRUs.sav'. 

*SAVE TRANSLATE /TYPE=ODBC
 /Connect ='DSN=Dashboarddatadev;UID=;APP=SPSS For'+
 ' Windows;WSID=HPMXL9360ZDD;DATABASE=Dashboarddatadev;Trusted_Connection=Yes'
 /table= 'TAY_FollowUpRUs' /MAP/REPLACE.
*pushbreak.

**********************services.
*get file='//covenas/decisionsupport/dbsvc.sav' /keep agency provname ru case opdate closdate proced svcdate cost calendar duration psmask2 MCsvcCat svcMode PrimaryTherapist staff proclong epflag.

get file='//covenas/decisionsupport/dbsvc2011only.sav'.

string unit(a10).
if svcmode='15' unit = 'minutes'.
if svcmode='05' unit = 'day'.
string Units(a10).
do if unit="day".
compute units ="Days".
compute duration=1.
end if.
if unit="minutes" units ="Hours".

insert file='//covenas/decisionsupport/modules/uncookedmonth.sps'.

*this file used for face sheets later.       
TEMPORARY.
select if svcdate gt datesum(UnCookedMonth,-3,'years').  
save outfile='//covenas/decisionsupport/meinzer/temp/TAYsvcs.sav' /keep ru case opdate closdate proclong svcdate epflag PrimaryTherapist staff Agency provname UnCookedMonth.

match files /file=* /keep unit units agency provname ru case opdate closdate proced svcdate cost calendar duration psmask2 MCsvcCat svcMode UnCookedMonth.
 * get file='//covenas/decisionsupport/meinzer/temp/TAYsvcs.sav'.
select if svcdate ge DBstartdate.   

insert file='//covenas/decisionsupport/meinzer/modules/calfiscalyear.sps'.



select if any(ru,TAYkeepRU).
save outfile='//covenas/decisionsupport/meinzer/temp/TAYonly.sav'.

*get last svc in 3 or 4 cooked months.  is three enought if last ep month is one of thsoe months.
temp.
select if svcdate ge DateSum(UnCookedMonth,-3,"months").
aggregate outfile='//covenas/decisionsupport/meinzer/temp/svcs90dayswideTAY.sav'
   /break= ru case  opdate
   /lastsvc90=max(svcdate).

*previously wanted only cooked services.
 * temp.
 * select if svcdate ge DateSum(UnCookedMonth,-1,"months") and svcdate lt uncookedmonth.
 * aggregate outfile='//covenas/decisionsupport/meinzer/temp/svcs30dayswideTAY.sav'
   /break= ru case  opdate
   /lastsvc30=max(svcdate).

select if svcdate lt uncookedmonth.

sort cases by FiscalYear ru case.
match files /file=* /by FiscalYear ru case /first=FYRuCase1.

sort cases by ru calendar case.
match files /file=* /by ru calendar case /first=RuCalCase1.

sort cases by FiscalYear ru McSvcCat case .
match files /file=* /by FiscalYear ru McSvcCat case /first=FYRuMcSvcCatCase1.

sort cases by ru calendar McSvcCat case .
match files /file=* /by ru calendar McSvcCat case /first=RuCalMcSvcCatCase1.


save outfile='//covenas/decisionsupport/meinzer/temp/TAY_work.sav'.

get file='//covenas/decisionsupport/meinzer/temp/TAY_work.sav'.

Aggregate outfile=*mode addvariables
   /break = FiscalYear ru    
   /FYruClients=Sum(FYruCase1)
   /FYruHours=Sum(duration)
   /FYruCost=sum(Cost).
*save outfile='//covenas/decisionsupport/meinzer/temp/fiscalTAY.sav'.

Aggregate outfile=*mode addvariables
   /break = ru calendar 
   /CalMonthClients=Sum(RuCalCase1)
   /CalMonthTime=Sum(duration)
  /CalMonthCost=sum(Cost).

save outfile='//covenas/decisionsupport/meinzer/temp/calTAY.sav'.
get file='//covenas/decisionsupport/meinzer/temp/calTAY.sav'.
TEMPORARY.
select if index(mcsvccat,'Client S') gt 0.
Aggregate outfile= '//covenas/decisionsupport/meinzer/projects/older adult/calendarTAYDrillTrhoughsupport.sav'
   /break=ru calendar mcsvccat  fiscalyear agency provname  CalMonthClients CalMonthTime CalMonthCost 
   /units=max(units)
   /ProcClients=sum(RuCalMcSvcCatCase1)
   /Proctime=sum(Duration)
   /ProcCost=sum(cost).



if index(mcsvccat,'Client S') gt 0 Mcsvccat='Client Support'.
exe.
delete vars FYRuMcSvcCatCase1 RuCalMcSvcCatCase1 .
sort cases by FiscalYear ru McSvcCat case .
match files /file=* /by FiscalYear ru McSvcCat case /first=FYRuMcSvcCatCase1.

sort cases by ru calendar McSvcCat case .
match files /file=* /by ru calendar McSvcCat case /first=RuCalMcSvcCatCase1.

Aggregate outfile= '//covenas/decisionsupport/meinzer/projects/older adult/FYTAY.sav'
   /break = FiscalYear provname ru   
   /units=max(units)
   /FYruClients=Sum(FYruCase1)
   /FYruTime=Sum(duration)
   /FYruCost=sum(Cost).

add files
/file=*
/file='//covenas/decisionsupport/temp/maasvcTAY.sav' .

Aggregate outfile= '//covenas/decisionsupport/meinzer/projects/older adult/calendarTAY.sav'
   /break=ru calendar mcsvccat  fiscalyear agency provname   psMask2 CalMonthClients CalMonthTime CalMonthCost     
   /units=max(units)
   /ProcClients=sum(RuCalMcSvcCatCase1)
   /Proctime=sum(Duration)
   /ProcCost=sum(cost).
 
aggregate outfile=*
   /break  case ru Calendar FiscalYear CalMonthClients
   /TotalhoursPerCleintbyMonth=sum(duration).

sort cases by ru calendar.
match files /file=* /by ru calendar /first=RuCal1.

if RuCal1 ne 1 calmonthclients=$sysmis. 

aggregate outfile='//covenas/decisionsupport/temp/TAYAveHoursPerClientinFY.sav'
   /break  FiscalYear ru 
   /AveHourPerCleintPerMonthinByFY=mean(TotalhoursPerCleintbyMonth)
   /AverClientsperMonthbyFY=mean(CalMonthClients).

*get file='//covenas/decisionsupport/temp/TAYAveHoursPerClientinFY.sav'.


*pushbreak.
 * get file= '//covenas/decisionsupport/meinzer/projects/older adult/calendarTAYDrillTrhoughsupport.sav'.

 * SAVE TRANSLATE /TYPE=ODBC
 /Connect ='DSN=Dashboarddatadev;UID=;APP=SPSS For'+
 ' Windows;WSID=HPMXL9360ZDD;DATABASE=Dashboarddatadev;Trusted_Connection=Yes'
 /table= 'TAY_DrillTrhoughsupport' /MAP/REPLACE.
*pushbreak.



*********************************This section for evaluating fiscal year goals.
get file='//covenas/decisionsupport/meinzer/projects/older adult/FYTAY.sav'.

insert file='//covenas/decisionsupport/modules/uncookedmonth.sps'.

string CookedFiscalYear(a10).
do if xdate.month(uncookedmonth)-1 lt 7.
compute Cookedfiscalyear=concat("FY ",substr(string(xdate.year(uncookedmonth)-1,n4),3,2),"-",substr(string(xdate.year(uncookedmonth),n4),3,2)).
else if xdate.month(uncookedmonth)-1 ge 7.
compute Cookedfiscalyear=concat("FY ",substr(string(xdate.year(uncookedmonth),n4),3,2),"-",substr(string(xdate.year(uncookedmonth)+1,n4),3,2)).
end if.

*if month is july to dec then we are in the second half of the fy, otherwise first half.
*.
 * insert file='//covenas/decisionsupport/meinzer/modules/cookedfiscalyear.sps'.

sort cases by ru fiscalyear.
match files /table='//covenas/decisionsupport/meinzer/tables/contractTay.sav' /file=* /by ru fiscalyear.
rename vars fyrutime=duration.

if units="Days" CDDuration=CDDaysofSvcs.
if Units="Hours" CDDuration=CDHrsofSvcs.

do if xdate.month(UnCookedMonth)-1 gt 6 and FiscalYear=CookedFiscalYear.
compute FYPercent=(xdate.month(UnCookedMonth)-7)/12.
else if xdate.month(UnCookedMonth)-1 le 6 and FiscalYear=CookedFiscalYear.
compute FYPercent=(xdate.month(UnCookedMonth)+5)/12.
else.
compute FYPercent=1.
end if.

compute CDDurationAdjust = CDDuration*fypercent.
compute DurationPercentAdjGoal = Duration/CDDurationAdjust.
compute CDAmountAdjust =CDAmount*fypercent.
compute CostPercentAdjGaol = FYruCost/CDAmountAdjust.

recode  CDMAASvcs CDCaseMgtHrs CDMHHrs CDMedsSupptHrs CDCrisisHrs CDResidentialDays CDDaysofSvcs CDHrsofSvcs CDAmount
 FYruClients  FYruCost  UnCookedMonth FYPercent duration CDDuration
CDDurationAdjust  CDAmountAdjust  DurationPercentAdjGoal CostPercentAdjGaol CDOutreach
CDClientSuppt
CDMAASvcs (sysmis=0).
sort cases by ru fiscalyear.
save outfile='//covenas/decisionsupport/meinzer/temp/MonthlygoalsMatched1TAY.sav'. 
*pushbreak.
 * get file='//covenas/decisionsupport/meinzer/temp/MonthlygoalsMatched1TAY.sav'. 

 * SAVE TRANSLATE /TYPE=ODBC
 /Connect ='DSN=Dashboarddatadev;UID=;APP=SPSS For'+
 ' Windows;WSID=HPMXL9360ZDD;DATABASE=Dashboarddatadev;Trusted_Connection=Yes'
 /table= 'TAY_GoalsFY' /MAP/REPLACE.
*pushbreak.

get file='//covenas/decisionsupport/meinzer/tables/contractTay.sav' .
*get file='//covenas/decisionsupport/meinzer/tables/contractTAY.sav' .
vector mcsvccat(7 a35).
if not missing(CDCaseMgtHrs) mcsvccat1="A. Case Management Services".
if not missing(CDMHHrs) mcsvccat2="B. Mental Health Services".
if not missing(CDMedsSupptHrs) mcsvccat3="C. Medication Support".
if not missing(CDCrisisHrs) mcsvccat4="D. Crisis Intervention".
if not missing(CDResidentialDays) mcsvccat5="G. Residential".
if ru ='81441'  and not missing(CDResidentialDays) mcsvccat5='H. Crisis Residential'.
if not missing(CDClientSuppt) mcsvccat6='Client Support'.
if not missing(CDMAASvcs) mcsvccat6='M. MAA Services'.
*if not missing(N. Client Support Education Hours) or  not missing(O. Client Support Housing Hours) or  not missing(O. Client Support Housing Hours) mcsvccat6='Client Support'.


*BACS WOODROE PLACE CRISIS RES.
exe.
VARSTOCASES
/make mcsvccat from mcsvccat1 to mcsvccat7
/keep provname ru fiscalyear.

save outfile='//covenas/decisionsupport/meinzer/temp/contractshellTAY.sav'. 

get file= '//covenas/decisionsupport/meinzer/projects/older adult/calendarTAY.sav'.
select if not index(mcsvccat,'MAA') gt 0.
select if not index(mcsvccat,'Client S') gt 0. 
aggregate outfile=*
   /break = fiscalyear calendar ru provname  
   /Proctime=sum(proctime).

string McSvcCat(a35).
compute mcsvccat="Total".
add files
   /file=*
   /file= '//covenas/decisionsupport/meinzer/projects/older adult/calendarTAY.sav' .

sort cases by ru calendar mcsvccat. 
save outfile='//covenas/decisionsupport/meinzer/temp/calendarTAYshelled.sav'.

add files
/file=*
/file='//covenas/decisionsupport/meinzer/temp/contractshellTAY.sav'. 
select if mcsvccat ne ''.
aggregate outfile=*
   /break = ru mcsvccat
   /provname=max(provname).


vector calshell(50,f11).
compute CountMonths=datediff($time,dbstartdate,"months").
compute #dateindex=1.

compute calshell1=dbstartdate.
loop #count=2 to countmonths.
compute calshell(#count)=datesum(calshell( #dateindex),1,'month','closest').
compute #dateindex=1 + #dateindex.
end loop.
formats calshell1 to calshell50 (date11).

match files /file=* /drop countmonths.
VARSTOCASES
/make Calendar from Calshell1 to calshell50.

insert file='//covenas/decisionsupport/modules/uncookedmonth.sps'.

insert file='//covenas/decisionsupport/meinzer/modules/calfiscalyear.sps'.
select if calendar lt uncookedmonth.
formats calendar(date11).
sort cases by   ru calendar mcsvccat.
 * match files /table= '//covenas/decisionsupport/meinzer/projects/older adult/calendarTAY.sav' /file=* /by  ru calendar mcsvccat.
match files /table= '//covenas/decisionsupport/meinzer/temp/calendarTAYshelled.sav' /file=* /by  ru calendar mcsvccat.
exe.
sort cases by ru fiscalyear.
*match files /table='//covenas/decisionsupport/meinzer/tables/contractTAY.sav' /file=* /by ru.
match files /table='//covenas/decisionsupport/meinzer/tables/contractTay.sav' /file=* /by ru fiscalyear.

formats calendar(date11).

****.
insert file='//covenas/decisionsupport/modules/uncookedmonth.sps'.
insert file='//covenas/decisionsupport/meinzer/modules/cookedfiscalyear.sps'.



*if month is july to dec then we are in the second half of the fy, otherwise first half.



aggregate outfile=* mode=addvariables overwrite=yes
/break=ru fiscalyear
   /units=max(units).

if units="Days" CDDuration=CDDaysofSvcs.
if Units="Hours" CDDuration=CDHrsofSvcs.

compute CDDurationAdjust = CDDuration*fypercent.
****.
compute PercentCalClient =CalMonthClients/(CDClients/12).
if mcsvccat="A. Case Management Services" PercentCalCaseMGThrs =proctime/(CDCaseMgtHrs/12).
if mcsvccat="B. Mental Health Services" PercentCalMHhrs = proctime/(CDMHHrs/12).
if mcsvccat="C. Medication Support" PercentCalMedSupHRS = proctime/(CDMedsSupptHrs/12).
if mcsvccat="D. Crisis Intervention" PercentCalCrisis = proctime/(CDCrisisHrs/12).
if mcsvccat="G. Residential" or mcsvccat="H. Crisis Residential" PercentCalResidentialDays = proctime/(CDResidentialDays/12).
if mcsvccat='M. MAA Services' PercentCalMAA=proctime/(CDMAASvcs/12).
if mcsvccat="Client Support" PercentCalClientSupport = proctime/(CDClientSuppt/12).

compute PercentCalDays = CalMonthTime/(CDDaysofSvcs/12).
compute PercentCalHrs = CalMonthTime/(CDHrsofSvcs/12).
compute PercentCalAmount = CalMonthCost/(CDAmount/12).

compute CDMonthDaysofSvcs = (CDDaysofSvcs/12).
compute CDMonthHrsofSvcs = (CDHrsofSvcs/12).
compute CDMonthCost = (CDAmount/12).
compute CDMonthDuration= (CDDuration/12).
if mcsvccat="A. Case Management Services" CDMonthHrsofSvcs = (CDCaseMgtHrs/12).
if mcsvccat="B. Mental Health Services" CDMonthHrsofSvcs = (CDMHHrs/12).
if mcsvccat="C. Medication Support" CDMonthHrsofSvcs = (CDMedsSupptHrs/12).
if mcsvccat="D. Crisis Intervention" CDMonthHrsofSvcs = (CDCrisisHrs/12).
if mcsvccat='M. MAA Services' CDMonthHrsofSvcs=(CDMAASvcs/12).
if mcsvccat="G. Residential" or mcsvccat="H. Crisis Residential" CDMonthDaysofSvcs = (CDResidentialDays/12).
if mcsvccat="Client Support" CDMonthHrsofSvcs = (CDClientSuppt/12).
*this file doesn't go anywhere.
save outfile='//covenas/decisionsupport/meinzer/temp/MonthlygoalsMatchedTAY.sav'. 

sort cases by ru fiscalyear mcsvccat calendar .
match files /file=* /by ru fiscalyear mcsvccat /first=first.

do if first=1.
compute  costRun=proccost.
compute  daysRun=proctime.
compute  hoursRun=proctime.
compute  CDcostRun=CDMonthCost.
compute  CDdaysRun=CDMonthDaysofSvcs.
compute  CdhoursRun=CDMonthHrsofSvcs.
ELSE.
compute  costRun=costRun+proccost.
compute  daysRun=daysRun+proctime.
compute  hoursRun=hoursRun+proctime.
compute  CDcostRun=CdcostRun+CDMonthCost.
compute  CddaysRun=CddaysRun+CDMonthDaysofSvcs.
compute  CdhoursRun=CDhoursRun+CDMonthHrsofSvcs.
END IF.
leave  costrun daysrun hoursrun CDcostrun CDdaysrun CDhoursrun.
exe.

match files /file=* /drop first .

match files file=* /keep FiscalYear provname ru McSvcCat calendar CdhoursRun all.

recode CDClients CDMAASvcs CDCaseMgtHrs CDMHHrs CDMedsSupptHrs CDCrisisHrs CDResidentialDays
CDDaysofSvcs CDHrsofSvcs CDAmount ProcCost procclients proctime proctime CalMonthClients
CalMonthTime CalMonthCost PercentCalClient PercentCalCaseMGThrs
PercentCalMHhrs PercentCalMedSupHRS PercentCalCrisis PercentCalResidentialDays
PercentCalDays PercentCalHrs PercentCalAmount CDMonthDaysofSvcs
CDMonthHrsofSvcs CDMonthCost PercentCalClientSupport PercentCalMAA (sysmis=0).

match files /table='//covenas/decisionsupport/rutable.sav' /file=* /by ru /drop EPSDTGroup	DayTx	RU2		Level3Classic	county	kidsru	ab3632RU	CESDC	psmask2	svcType	cds_Code	
MHSA	start_dt	end_dt	school	TAYru	Level2	TAYru	svcType3	program	Residential	OutCty	CalWorks	SafePassages	RUCITY	frc.

sort cases by mcsvccat units.
match files /table='//covenas/decisionsupport/meinzer/tables/mcunits.sav' /file=* /by mcsvccat.

compute Duration=proctime.

do if mcsvccat ne"Total" .
compute mcsvccat =  concat(rtrim(mcsvccat)," ", Units).
else.
compute mcsvccat= "Total Time".
end if.

save outfile='//covenas/decisionsupport/meinzer/temp/TAY_MainLineGraphs.sav'.
*pushbreak.
 * get file='//covenas/decisionsupport/meinzer/temp/TAY_MainLineGraphs.sav'.
  *SAVE TRANSLATE /TYPE=ODBC
 /Connect ='DSN=Dashboarddatadev;UID=;APP=SPSS For'+
 ' Windows;WSID=HPMXL9360ZDD;DATABASE=Dashboarddatadev;Trusted_Connection=Yes'
 /table= 'TAY_GoalsMonthly' /MAP/REPLACE.
*pushbreak.

*get file='//covenas/decisionsupport/meinzer/temp/TAY_MainLineGraphs.sav'.
match files /file=* /keep MCSvcCat
units
ru
FiscalYear
FYPercent
Duration
CDDuration
CDDurationAdjust
provname
CDClients
CDCaseMgtHrs
CDMHHrs
CDMedsSupptHrs
CDCrisisHrs
CDResidentialDays
CDDaysofSvcs
CDHrsofSvcs
CDAmount
Proctime
PercentCalClientSupport
CDOutreach
CDClientSuppt
CDMAASvcs
PercentCalClientSupport.


*I think most of these are unneccisary.
if mcsvccat="A. Case Management Services Hours" YTDcdTime=CDCaseMgtHrs*fypercent.
if mcsvccat="B. Mental Health Services Hours" YTDcdTime=CDMHHrs*fypercent.
if mcsvccat="C. Medication Support Hours" YTDcdTime=CDMedsSupptHrs*fypercent.
if mcsvccat="D. Crisis Intervention Hours" YTDcdTime=CDCrisisHrs*fypercent.
if mcsvccat="G. Residential Days" or mcsvccat="H. Crisis Residential Days" YTDcdTime=CDResidentialDays*fypercent.
if mcsvccat='Client Support Hours' YTDcdTime=CDClientSuppt *fypercent.
if mcsvccat='M. MAA Services' YTDcdTime=CDMAASvcs *fypercent.
if mcsvccat='Total Time' YTDcdTime=CDDurationAdjust.

if mcsvccat="A. Case Management Services Hours" FYcdTime=CDCaseMgtHrs.
if mcsvccat="B. Mental Health Services Hours" FYcdTime=CDMHHrs.
if mcsvccat="C. Medication Support Hours" FYcdTime=CDMedsSupptHrs.
if mcsvccat="D. Crisis Intervention Hours" FYcdTime=CDCrisisHrs.
if mcsvccat="G. Residential Days" or mcsvccat="H. Crisis Residential Days" FYcdTime=CDResidentialDays.
if mcsvccat='Client Support Hours' FYcdTime=CDClientSuppt.
if mcsvccat='M. MAA Services' FYcdTime=CDMAASvcs.
if mcsvccat='Total Time' FYcdTime=cdduration.

aggregate outfile='//covenas/decisionsupport/temp/bargraphtay.sav'
/break provname ru fiscalyear mcsvccat
/YTDActualTime=sum(Proctime)
/FYcdTime	=max(FYcdTime)
/YTDcdTime=max(YTDcdTime).
*get file='//covenas/decisionsupport/temp/bargraphtay.sav'.

*pushbreak.
 * get file='//covenas/decisionsupport/temp/bargraphtay.sav'.
  *SAVE TRANSLATE /TYPE=ODBC
 /Connect ='DSN=Dashboarddatadev;UID=;APP=SPSS For'+
 ' Windows;WSID=HPMXL9360ZDD;DATABASE=Dashboarddatadev;Trusted_Connection=Yes'
 /table= 'TAY_BarGraphFY' /MAP/REPLACE.
*pushbreak.

*per month eps.
get file='//covenas/decisionsupport/epsCG.sav'  /keep ru case opdate closDate epflag.
select if any(ru,TAYkeepRU).

insert file='//covenas/decisionsupport/modules/uncookedmonth.sps'.
select if opdate lt UnCookedMonth and (Closdate ge DBstartdate or sysmis(closdate)).
match files /file=* /keep ru case opdate closdate.

insert file='//covenas/decisionsupport/meinzer/modules/explodemonth.sps'.

aggregate outfile=*
   /break=ru calendar
   /permontheps=sum(counter).

insert file='//covenas/decisionsupport/meinzer/modules/calfiscalyear.sps'.

sort cases by ru calendar fiscalyear.
save outfile='//covenas/decisionsupport/meinzer/temp/permonthepsTAY.sav'.

*admits DCs.
get file='//covenas/decisionsupport/rutable.sav' /keep ru provname.

select if any(ru,TAYkeepRU).
insert file='//covenas/decisionsupport/modules/uncookedmonth.sps'.
vector calshell(50,f11).
compute CountMonths=datediff(uncookedmonth,DBstartdate,"months").
compute #dateindex=1.

compute calshell1=DBstartdate.
loop #count=2 to countmonths.
compute calshell(#count)=datesum(calshell( #dateindex),1,'month','closest').
compute #dateindex=1 + #dateindex.
end loop.
formats calshell1 to calshell50 (date11).
match files /file=* /drop countmonths.
VARSTOCASES
/make Calendar from Calshell1 to calshell50.

sort cases by calendar ru.
match files /table='//covenas/decisionsupport/meinzer/temp/MonthadmitsTAY.sav' /file=* /by calendar ru.
match files /table='//covenas/decisionsupport/meinzer/temp/monthdischargeTAY.sav' /file=* /by  calendar ru.
insert file='//covenas/decisionsupport/meinzer/modules/calfiscalyear.sps'.
sort cases by fiscalyear ru.
match files /table='//covenas/decisionsupport/meinzer/temp/fiscalDischargeTAY.sav' /file=* /by fiscalyear ru.
match files /table='//covenas/decisionsupport/meinzer/temp/fiscaladmitsTAY.sav' /file=* /by fiscalyear ru.
match files /table='//covenas/decisionsupport/temp/TAYAveHoursPerClientinFY.sav' /file=* /by fiscalyear ru. 

sort cases by ru fiscalyear calendar.
match files /table='//covenas/decisionsupport/meinzer/temp/permonthepsTAY.sav' /file=* /by ru calendar fiscalyear.

recode MonthlyDischarges MonthlyAdmits(sysmis=0).
save outfile='//covenas/decisionsupport/meinzer/temp/MonthlygoalsMatchedTAYc.sav'. 
*pushbreak.
 * get file='//covenas/decisionsupport/meinzer/temp/MonthlygoalsMatchedTAYc.sav'. 
  *SAVE TRANSLATE /TYPE=ODBC
 /Connect ='DSN=Dashboarddatadev;UID=;APP=SPSS For'+
 ' Windows;WSID=HPMXL9360ZDD;DATABASE=Dashboarddatadev;Trusted_Connection=Yes'
 /table= 'TAY_AdmitsDischarges' /MAP/REPLACE.
*pushbreak.



get file='//covenas/decisionsupport/meinzer/temp/TAYonly.sav'.
select if svcdate lt UnCookedMonth.
sort cases by case.
match files /table='//covenas/spssdata/clinfo.sav' /file=* /by case /keep ru case opdate svcdate calendar fiscalyear calendar agency ethnic hispanic sex bday provname      .
insert file='//covenas/decisionsupport/modules/ethnicity.sps'.

sort cases by ru case fiscalyear calendar.
match files /file=* /by ru case fiscalyear /first=CalRuCase1 /drop RaceEthnicityCode hispanic.
select if calrucase1=1.
*sort cases by ru case fiscalyear.
*match files /file=* /by ru case fiscalyear /first=FYRuCase1.

aggregate outfile=* mode=addvariables
   /break = case ru
   /minSvcdate=min(svcdate).
COMPUTE Age= trunc((xdate.tday(minSvcDate)-xdate.tday(bday))/365.25).

insert file='//covenas/decisionsupport/meinzer/modules/tayagegroup.sps'.
compute counter=1.

aggregate outfile='//covenas/decisionsupport/meinzer/temp/TAYAgeAgg.sav'
   /break provname ru fiscalyear agegroup
   /Clients=sum(counter).

aggregate outfile='//covenas/decisionsupport/meinzer/temp/TAYEthnicityagg.sav'
   /break provname ru fiscalyear ethnicity
   /Clients=sum(counter).
rename vars sex=gender.
aggregate outfile='//covenas/decisionsupport/meinzer/temp/TAYGender.sav'
   /break provname ru fiscalyear gender
   /Clients=sum(counter).

*pushbreak.
 * get file='//covenas/decisionsupport/meinzer/temp/TAYGender.sav'.
 * SAVE TRANSLATE /TYPE=ODBC
 /Connect ='DSN=Dashboarddatadev;UID=;APP=SPSS For'+
 ' Windows;WSID=HPMXL9360ZDD;DATABASE=Dashboarddatadev;Trusted_Connection=Yes'
 /table= 'TAY_Demographics_Gender' /MAP/REPLACE.
*pushbreak.

*get file='//covenas/decisionsupport/meinzer/temp/TAYonly.sav'.
aggregate outfile=*
   /break provname ru FiscalYear
   /bogus=n.

match files /file=*  /drop bogus.

vector AgeGroup(5,a20).
compute agegroup1="15 and Under".
compute agegroup2="16-17".
compute agegroup3="18-20".
compute AgeGroup4="21-24".
compute agegroup5="25 and Over".

varstocases
/make AgeGroup from agegroup1 to agegroup5.

sort cases by provname ru fiscalyear agegroup.
match files /table='//covenas/decisionsupport/meinzer/temp/TAYAgeAgg.sav' /file=* /by provname ru fiscalyear agegroup.

save outfile='//covenas/decisionsupport/meinzer/temp/TAYAgegroupShelledAGG'.
*pushbreak.
*get file='//covenas/decisionsupport/meinzer/temp/TAYAgegroupShelledAGG'.
 *SAVE TRANSLATE /TYPE=ODBC
 /Connect ='DSN=Dashboarddatadev;UID=;APP=SPSS For'+
 ' Windows;WSID=HPMXL9360ZDD;DATABASE=Dashboarddatadev;Trusted_Connection=Yes'
 /table= 'TAY_Demographics_Agegroup' /MAP/REPLACE.
*pushbreak.
get file='//covenas/decisionsupport/meinzer/temp/TAYonly.sav'.
aggregate outfile=*
   /break FiscalYear RU provname
   /bogus=n.

match files /file=*  /drop bogus.

vector Ethnicity(6,a17).
compute ethnicity1="African American".
compute ethnicity2="Asian/PI".
compute ethnicity3="Caucasian".
compute ethnicity4="Latino".
compute ethnicity5="Native American".
compute ethnicity6="Other/Unknown".

varstocases
/make Ethnicity from ethnicity1 to ethnicity6.

sort cases by provname ru fiscalyear Ethnicity.
match files /table='//covenas/decisionsupport/meinzer/temp/TAYEthnicityAgg.sav' /file=* /by provname ru fiscalyear Ethnicity.


save outfile='//covenas/decisionsupport/meinzer/temp/TAYEthnicityShelled.sav' /keep FiscalYear provname RU Ethnicity clients.
*pushbreak.
*get file='//covenas/decisionsupport/meinzer/temp/TAYEthnicityShelled.sav'.
 * SAVE TRANSLATE /TYPE=ODBC
 /Connect ='DSN=Dashboarddatadev;UID=;APP=SPSS For'+
 ' Windows;WSID=HPMXL9360ZDD;DATABASE=Dashboarddatadev;Trusted_Connection=Yes'
 /table= 'TAY_Demographics_Ethnicity' /MAP/REPLACE.
*pushbreak.



**************last svc in 90 days.
get file '//covenas/decisionsupport/meinzer/temp/lastepmonthTAY.sav'.
select if epflag="O".
aggregate outfile=* mode=AddVars 
	/break=ru 
	/openCases = N.

sort cases by ru case opdate.
match files /table='//covenas/decisionsupport/rutable.sav' /file=* /by ru /keep closdate agency provname ru case opdate epflag opencases. 
match files /table='//covenas/decisionsupport/meinzer/temp/svcs90dayswideTAY.sav' /file=* /by ru case opdate.
 * match files /tablefile='//covenas/decisionsupport/meinzer/temp/svcs30dayswideTAY.sav' /file=* /by ru case opdate.

*am i cutting closed people?.
insert file='//covenas/decisionsupport/modules/uncookedmonth.sps'.
if missing(LastSvc90) NoSvc90=1.
if lastsvc90 lt datesum(uncookedmonth,-1,'months') or missing(lastsvc90) NoSVC30=1.

Temp.
Select if NoSvc90=1 and Epflag='O'.
save outfile='//covenas/decisionsupport/meinzer/temp/NoSvc90ClientsTAY.sav'.

aggregate outfile= *
   /break=ru
   /provname=max(provname)
   /agency=max(agency)
   /opencases=max(opencases)
   /NoSvc90=sum(NoSvc90)
   /NoSvc30=sum(NoSVC30).

recode NoSvc90  NoSvc30 opencases (sysmis=0).
compute PctNoSvc90 = NoSvc90/Opencases.
compute PctNoSvc30 = NoSvc30/Opencases.
match files /file=* /keep Agency Provname ru OpenCases NoSvc90 PctNoSvc90 NoSvc30 PctNoSvc30.
 * save outfile='//covenas/decisionsupport/meinzer/temp/NoSvc90byRU.sav' /keep Agency Provname ru OpenCases NoSvc90 PctNoSvc90.

save outfile='//covenas/decisionsupport/meinzer/temp/TAY_NoSvc90ru.sav'.

*pushbreak.
*get file='//covenas/decisionsupport/meinzer/temp/TAY_NoSvc90ru.sav'.
  *SAVE TRANSLATE /TYPE=ODBC
 /Connect ='DSN=Dashboarddatadev;UID=;APP=SPSS For'+
 ' Windows;WSID=HPMXL9360ZDD;DATABASE=Dashboarddatadev;Trusted_Connection=Yes'
 /table= 'TAY_NoLastSvc90RU' /MAP/REPLACE.
*pushbreak.

*case list for drill through.
get file='//covenas/decisionsupport/meinzer/temp/NoSvc90ClientsTAY.sav'.
sort cases by case.
match files /table='//covenas/spssdata/clinfo.sav' /file=* /by case /keep agency provname ru case opdate name bday.

compute NoSVCClient=1.
aggregate outfile='//covenas/decisionsupport/temp\KeepEpsTAY.sav' 
   /break=case
   /NoSVCClient=max(NoSVCClient)
   /RecentTAYVisit=max(Provname).

sort cases by ru case.
match files /file=* /by ru case /last=RUcase1.
select if rucase1=1.

*save outfile='//covenas/decisionsupport/temp\KeepEpsTAY.sav'  /RENAME Provname=LastTAYVisit ru=lastTAYRU opdate=lastTAYopdate.
match files /file=* /drop  rucase1.

COMPUTE Age= trunc((xdate.tday($time)-xdate.tday(bday))/365.25).

save outfile='//covenas/decisionsupport/temp/clientlistTAY.sav'.

*pushbreak.
*get file='//covenas/decisionsupport/temp/clientlistTAY.sav'.

 *SAVE TRANSLATE /TYPE=ODBC
 /Connect ='DSN=Dashboarddatadev;UID=;APP=SPSS For'+
 ' Windows;WSID=HPMXL9360ZDD;DATABASE=Dashboarddatadev;Trusted_Connection=Yes'
 /table= 'TAY_LastSvc90Clients' /MAP/REPLACE.
*pushbreak.

*** face sheet code. this file still has uncooked svcs and is only 3 years of svcs.
get file='//covenas/decisionsupport/meinzer/temp/TAYsvcs.sav' .

sort cases by case.
match files/table='//covenas/decisionsupport/temp\KeepEpsTAY.sav' /file=* /by case.
select if NoSVCClient=1.
match files/table='//covenas/decisionsupport/clinfoCG.sav'//file=* /by case/drop sex .
rename vars name = ClientName.
sort cases by staff.
match files /table='//covenas/decisionsupport/staff.sav' /file=* /by staff.
rename vars Name = StaffName.

save outfile='//covenas/decisionsupport/temp\TAYSvcs.sav' /keep ru case svcdate opdate agency provname StaffName proclong svcdate ClientName.

*pushbreak.
*get file='//covenas/decisionsupport/temp\TAYSvcs.sav'.

*SAVE TRANSLATE /TYPE=ODBC
 /Connect ='DSN=Dashboarddatadev;UID=;APP=SPSS For'+
 ' Windows;WSID=HPMXL9360ZDD;DATABASE=Dashboarddatadev;Trusted_Connection=Yes'
 /table= 'TAY_allSVCSforLastSvc90Clients' /MAP/REPLACE.
*pushbreak.

get file='//covenas/decisionsupport/epscg.sav' .
insert file='//covenas/decisionsupport/modules/uncookedmonth.sps'.
select if closdate ge datesum(uncookedmonth,-3,'years') or missing(closdate).
sort cases by case.
match files/table='//covenas/decisionsupport/temp\KeepEpsTAY.sav' /file=* /by case.
select if NoSVCClient=1.
match files/table='//covenas/decisionsupport/clinfoCG.sav'//file=* /by case/drop sex .
rename vars name = ClientName.
sort cases by ru.
match files /table='//covenas/decisionsupport/rutable.sav' /file=* /by ru /keep ClientName ru agency provname case opdate epflag primarytherapist closdate lst_svc. 

aggregate outfile='//covenas/decisionsupport/temp\EpsTAY.sav'
   /break=ClientName RU case opdate epflag PrimaryTherapist agency provname
  	/closedate  = max(closdate) 
   /LastSvc = max(lst_svc).

*pushbreak.
 * get file='//covenas/decisionsupport/temp\EpsTAY.sav'.

 * SAVE TRANSLATE /TYPE=ODBC
 /Connect ='DSN=DashboardDatadev;UID=;APP=SPSS For'+
 ' Windows;WSID=HPMXL9360ZDD;DATABASE=DashboardDatadev;Trusted_Connection=Yes'
 /table= 'TAY_EpsforLastSvc90Clients' /MAP/REPLACE.
*pushbreak.
*********************LOS.
get file='//covenas/decisionsupport/meinzer/temp/TAYlos.sav'.

insert file='//covenas/decisionsupport/modules/uncookedmonth.sps'.
compute LOSmonths=datediff(closdate,opdate,'months').
if epflag="O" TISmonths=datediff($time,opdate,'months').

do if  any(ru,TAYkeepRU).
string LOS(a40).
if LOSMonths ge 0 and LOSMonths lt 3 LOS="1. 0-2 months".
if LOSMonths ge 3 and LOSMonths lt 6 LOS="2. 3-5 months".
if LOSMonths ge 6 and LOSMonths lt 13 LOS="3. 6-12 months".
if LOSMonths ge 13 and LOSMonths lt 25 LOS="4. 13-24 months ".
if LOSMonths ge 25 and LOSMonths lt 37 LOS="5. 25-36 months".
if LOSMonths ge 37 LOS="6. 37 months or More".
string TIS(a40).
if TISMonths ge 0 and TISMonths lt 3 TIS="1. 0-2 months".
if TISMonths ge 3 and TISMonths lt 6 TIS="2. 3-5 months".
if TISMonths ge 6 and TISMonths lt 13 TIS="3. 6-12 months".
if TISMonths ge 13 and TISMonths lt 25 TIS="4. 13-24 months ".
if TISMonths ge 25 and TISMonths lt 37 TIS="5. 25-36 months".
if TISMonths ge 37 TIS="6. 37 months or More".
end if.

*what fiscal year was your clos date?.
insert file='//covenas/decisionsupport/meinzer/modules/closdatefiscalyear.sps'.

string OpdateFiscalYear (a10).
do if xdate.month(Opdate) lt 7.
compute Opdatefiscalyear=concat("FY ",substr(string(xdate.year(Opdate)-1,n4),3,2),"-",substr(string(xdate.year(Opdate),n4),3,2)).
else if xdate.month(Opdate) ge 7.
compute Opdatefiscalyear=concat("FY ",substr(string(xdate.year(Opdate),n4),3,2),"-",substr(string(xdate.year(Opdate)+1,n4),3,2)).
end if.

sort cases by ru.
match files /table='//covenas/decisionsupport/rutable.sav'  /file=* /by ru /keep case opdate opdatefiscalyear primdx provname ru los tis counter fiscalyear uncookedmonth closdate PrimaryTherapist LOSMonths TISMonths.

temp.
select if LOS ne "" and closdate lt uncookedmonth.
aggregate outfile='//covenas/decisionsupport/meinzer/temp/LOSTAY.sav'
   /break=provname ru los fiscalyear
   /LengthofStay=sum(counter).

*this will become.
temp.
select if TIS ne "".
aggregate outfile='//covenas/decisionsupport/meinzer/temp/TISTAY.sav'
   /break=provname ru TIS
   /TimeinService=sum(counter).

rename vars primdx=dx.
sort cases by dx.
match files /table='//covenas/decisionsupport/dxtable.sav' /file=* /by dx /keep case opdate opdatefiscalyear  dx dx_descr provname ru LOS TIS counter FiscalYear
UnCookedMonth closdate PrimaryTherapist LOSMonths TISMonths. 

*client name, age at discharge, current age, length of stay (in exact months not just month categories)?.
sort cases by case.
match files/table='//covenas/decisionsupport/clinfoCG.sav'//file=* /by case .
rename vars name = ClientName.

COMPUTE CurrentAge= trunc((xdate.tday($time)-xdate.tday(bday))/365.25).
COMPUTE DischargeAge= trunc((xdate.tday(closdate)-xdate.tday(bday))/365.25).


save outfile='//covenas/decisionsupport/temp/LOSListwithDX1.sav' /drop tismonths ssn client_stamp cin tis counter uncookedmonth.

*pushbreak.
*get file='//covenas/decisionsupport/temp/LOSListwithDX1.sav'.

*SAVE TRANSLATE /TYPE=ODBC
 /Connect ='DSN=DashboardDatadev;UID=;APP=SPSS For'+
 ' Windows;WSID=HPMXL9360ZDD;DATABASE=DashboardDatadev;Trusted_Connection=Yes'
 /table= 'TAY_LOSListwithDX' /MAP/REPLACE.
*pushbreak.

compute keepEpTAY=1.
aggregate outfile='//covenas/decisionsupport/temp/TAYLOSUniquelist.sav'
   /break case
   /keepEpTAY=max(keepEpTAY).

select if closdate lt uncookedmonth.

aggregate outfile=*
   /break fiscalyear
   /bogus=max(counter).

CASESTOVARS
/id=bogus.

save outfile="//covenas/decisionsupport/temp/fytableTAY.sav".

get file='//covenas/decisionsupport/meinzer/temp/TAYlos.sav'.
insert file='//covenas/decisionsupport/modules/uncookedmonth.sps'.

if epflag="O" TISmonthsNow=datediff($time,opdate,'months').

*if sysmis(closdate) closdate=datesum($time,1,'months').
if sysmis(closdate) closdate=datesum($time,1,'days').

compute Countyears=datediff($time,DBstartdate,"years")+2.

vector dateEp(50,f11).
do if xdate.quarter(opdate) le 2.
compute dateEp1=date.dmy(30,6, xdate.year(opdate)).
else if xdate.quarter(opdate) ge 3.
compute dateep1=date.dmy(30,6, xdate.year(opdate)+1).
end if.
*select if closdate gt dateep1.
do if xdate.quarter(dbstartdate) lt 3.
 do if dateep1 le date.dmy(30,6,xdate.year(dbstartdate)). 
   compute dateep1=date.dmy(30,6,xdate.year(dbstartdate)). 
 end if.
else if xdate.quarter(dbstartdate) ge 3.
 do if dateep1 le date.dmy(30,6,xdate.year(dbstartdate)+1).
   compute dateep1=date.dmy(30,6,xdate.year(dbstartdate)+1). 
  end if.
end if.

*if dateep1 gt $time dateep1=datesum($time,1,'months').

*formats dateep1(date11).
compute #dateindex=1.
loop #count=1 to countyears.
do if dateep(#dateindex) lt closdate.
compute dateep(#dateindex+1) = datesum(dateep(#dateindex),1,"years","closest").
end if.
compute #dateindex=#dateindex+1.
end loop.
formats dateep1 to dateep50(date11).
VARSTOCASES
/make Endfy from dateep1 to dateep50.

*formats calendar(date11).

compute counter=1.



select if closdate gt endfy or (endfy gt $time and epflag='O').

if closdate gt $time closdate=$sysmis.
*freq counter.
do if endfy lt $time.
compute TISmonths=datediff(endfy,opdate,'months').
ELSE if endfy ge $time and epflag='O'.
compute TISMonths=datediff($time,opdate,'months').
end if.

do if  any(ru,TAYkeepRU).
string TIS(a40).
if TISMonths ge 0 and TISMonths lt 3 TIS="1. 0-2 months".
if TISMonths ge 3 and TISMonths lt 6 TIS="2. 3-5 months".
if TISMonths ge 6 and TISMonths lt 13 TIS="3. 6-12 months".
if TISMonths ge 13 and TISMonths lt 25 TIS="4. 13-24 months ".
if TISMonths ge 25 and TISMonths lt 37 TIS="5. 25-36 months".
if TISMonths ge 37 TIS="6. 37 months or More".
end if.

string FiscalYear (a10).
do if xdate.month(endfy) lt 7.
compute FiscalYear=concat("FY ",substr(string(xdate.year(endfy)-1,n4),3,2),"-",substr(string(xdate.year(endfy),n4),3,2)).
else if xdate.month(endfy) ge 7.
compute FiscalYear=concat("FY ",substr(string(xdate.year(endfy),n4),3,2),"-",substr(string(xdate.year(endfy)+1,n4),3,2)).
end if.

*select if endfy lt datesum(uncookedmonth,-1,'days').

rename vars primdx=dx.
sort cases by dx.
match files /table='//covenas/decisionsupport/dxtable.sav' /file=* /by dx /keep ru case opdate closdate epflag dx dx_descr UnCookedMonth counter TISmonthsNow Countyears
Endfy TISmonths TIS FiscalYear PrimaryTherapist. 

*client name, age at discharge, current age, length of stay (in exact months not just month categories)?.
sort cases by case.
match files/table='//covenas/decisionsupport/clinfoCG.sav'//file=* /by case .
rename vars name = ClientName.

COMPUTE CurrentAge= trunc((xdate.tday($time)-xdate.tday(bday))/365.25).

sort cases by ru.
match files /table='//covenas/decisionsupport/rutable.sav' /file=* /by ru /keep = agency  ru provname case fiscalyear ClientName bday Endfy TISmonthsNow opdate closdate epflag dx dx_descr TISmonths TIS FiscalYear PrimaryTherapist CurrentAge counter.

save outfile='//covenas/decisionsupport/temp/TISListwithDX.sav' /keep case agency ru provname fiscalyear ClientName bday Endfy TISmonthsNow opdate closdate epflag dx dx_descr TISmonths TIS FiscalYear PrimaryTherapist CurrentAge.

*pushbreak.
 * get file='//covenas/decisionsupport/temp/TISListwithDX.sav'.

 * SAVE TRANSLATE /TYPE=ODBC
 /Connect ='DSN=DashboardDatadev;UID=;APP=SPSS For'+
 ' Windows;WSID=HPMXL9360ZDD;DATABASE=DashboardDatadev;Trusted_Connection=Yes'
 /table= 'TAY_TISListwithDX' /MAP/REPLACE.
*pushbreak.

compute keepEpTAY=1.
aggregate outfile='//covenas/decisionsupport/temp/TAYTISUniquelist.sav'
   /break case
   /TISkeepEpTAY=max(keepEpTAY).

aggregate outfile='//covenas/decisionsupport/meinzer/temp/TISTAYEndFY.sav'
   /break=ru TIS EndFY FiscalYear
   /TimeinService=sum(counter).

aggregate outfile=*
   /break fiscalyear
   /bogus=max(counter).

CASESTOVARS
/id=bogus.

save outfile="//covenas/decisionsupport/temp/fytableTIS.sav".

get file='//covenas/decisionsupport/rutable.sav' /keep provname ru.
select if any(ru,TAYkeepRU).

string TIS1 to TIS6 (a40).
do if  any(ru,TAYkeepRU).
compute TIS1="1. 0-2 months".
compute TIS2="2. 3-5 months".
compute TIS3="3. 6-12 months".
compute TIS4="4. 13-24 months ".
compute TIS5="5. 25-36 months".
compute TIS6="6. 37 months or More".
end if.

VARSTOCASES
/make TIS from TIS1 to TIS6.

compute bogus=1.
match files /table="//covenas/decisionsupport/temp/fytableTAY.sav"  /file=*  /by bogus.
string FiscalYear.x(a10).
compute FiscalYear.x="-99".

sort variables by name.
VARSTOCASES
/make FiscalYear from Fiscalyear.1 to FiscalYear.x.
select if not FiscalYear = "-99".

insert file='//covenas/decisionsupport/modules/uncookedmonth.sps'.
sort cases by ru tis fiscalyear.
match files /table='//covenas/decisionsupport/meinzer/temp/TISTAYEndFY.sav' /file=* /by ru tis fiscalyear /drop bogus.

compute cookedmonth=datesum(uncookedmonth,-1,'days').

*select if not xdate.year(cookedmonth) = 2000+number(substr(fiscalyear,7,2),n4).

string FiscalYearcutCurrent (a10).
do if xdate.month(cookedmonth) lt 7.
compute FiscalYearcutCurrent=concat("FY ",substr(string(xdate.year(cookedmonth)-1,n4),3,2),"-",substr(string(xdate.year(cookedmonth),n4),3,2)).
else if xdate.month(cookedmonth) ge 7.
compute FiscalYearcutCurrent=concat("FY ",substr(string(xdate.year(cookedmonth),n4),3,2),"-",substr(string(xdate.year(cookedmonth)+1,n4),3,2)).
end if.

*select if FiscalYear ne FiscalYearcutCurrent.



formats cookedmonth(date11).
save outfile='//covenas/decisionsupport/meinzer/temp/TISpastandpresentShellTAY.sav'. 
*pushbreak.
 *    get file='//covenas/decisionsupport/meinzer/temp/TISpastandpresentShellTAY.sav'. 
 *  SAVE TRANSLATE /TYPE=ODBC
 /Connect ='DSN=DashboardDatadev;UID=;APP=SPSS For'+
 ' Windows;WSID=HPMXL9360ZDD;DATABASE=DashboardDatadev;Trusted_Connection=Yes'
 /table= 'TAY_TIS' /MAP/REPLACE.
*pushbreak.


*get file='//covenas/decisionsupport/meinzer/temp/TISTAYEndFY.sav'.
*if endfy ge opdate and endfy le closdate check=1.

get file='//covenas/decisionsupport/rutable.sav' /keep provname ru.
select if not ru = "01087" .
select if any(ru,TAYkeepRU).
string LOS1 to LOS6 (a40).

do if any(ru,TAYkeepRU).
compute LOS1="1. 0-2 months".
compute LOS2="2. 3-5 months".
compute LOS3="3. 6-12 months".
compute LOS4="4. 13-24 months ".
compute LOS5="5. 25-36 months".
compute LOS6="6. 37 months or More".
end if.

VARSTOCASES
/make LOS from LOS1 to LOS6.
compute bogus=1.
match files  /table="//covenas/decisionsupport/temp/fytableTAY.sav"   /file=* /by bogus.
string FiscalYear.x(a10).
compute FiscalYear.x="-99".
sort variables by name.
VARSTOCASES
/make FiscalYear from Fiscalyear.1 to FiscalYear.x.
select if not FiscalYear = "-99".
sort cases by provname ru los fiscalyear.
match files /table='//covenas/decisionsupport/meinzer/temp/LOSTAY.sav' /file=* /by provname ru los fiscalyear.

save outfile='//covenas/decisionsupport/meinzer/temp/LOSShellTAY.sav' /drop bogus. 

*pushbreak.
*get file='//covenas/decisionsupport/meinzer/temp/LOSShellTAY.sav'. 

 * SAVE TRANSLATE /TYPE=ODBC
 /Connect ='DSN=DashboardDatadev;UID=;APP=SPSS For'+
 ' Windows;WSID=HPMXL9360ZDD;DATABASE=DashboardDatadev;Trusted_Connection=Yes'
 /table= 'TAY_LOS' /MAP/REPLACE.
*pushbreak.

**************************TIS.
 * get file='//covenas/decisionsupport/rutable.sav' /keep provname ru.

 * select if any(ru,TAYkeepRU).
 * string TIS1 to TIS6 (a40).

 * do if  any(ru,TAYkeepRU).
 * compute TIS1="1. 0-2 months".
 * compute TIS2="2. 3-5 months".
 * compute TIS3="3. 6-12 months".
 * compute TIS4="4. 13-24 months ".
 * compute TIS5="5. 25-36 months".
 * compute TIS6="6. 37 months or More".
 * end if.

 * VARSTOCASES
/make TIS from TIS1 to TIS6.
 * sort cases by provname ru tis .
 * match files /table='//covenas/decisionsupport/meinzer/temp/TISTAY.sav' /file=* /by provname ru tis.
*add other fy's.
 * insert file='//covenas/decisionsupport/modules/uncookedmonth.sps'.
 * compute cookedmonth=datesum(uncookedmonth,-1,'days').
 * string FiscalYear (a10).
 * do if xdate.month(cookedmonth) lt 7.
 * compute FiscalYear=concat("FY ",substr(string(xdate.year(cookedmonth)-1,n4),3,2),"-",substr(string(xdate.year(cookedmonth),n4),3,2)).
 * else if xdate.month(cookedmonth) ge 7.
 * compute FiscalYear=concat("FY ",substr(string(xdate.year(cookedmonth),n4),3,2),"-",substr(string(xdate.year(cookedmonth)+1,n4),3,2)).
 * end if.

 * add files
/file=*
/file='//covenas/decisionsupport/meinzer/temp/TISTAYEndFYshell.sav'.
 * formats cookedmonth(date11).
 * save outfile='//covenas/decisionsupport/meinzer/temp/TISpastandpresentShellTAY.sav'. 

*client list.
get file='//covenas/decisionsupport/meinzer/temp/TAYlos.sav'.
sort cases by ru.
match files /table='//covenas/decisionsupport/rutable.sav' /file=* /by ru /keep agency ru provname case opdate closdate epflag primdx PrimaryTherapist staff LastService UnCookedMonth counter.
sort cases by case.
match files /table ='//covenas/decisionsupport/temp/TAYLOSUniquelist.sav' /file=* /by case.
match files /table ='//covenas/decisionsupport/temp/TAYTISUniquelist.sav' /file=* /by case.
select if keepEpTAY=1 or TISkeepEpTAY=1.
match files/table='//covenas/decisionsupport/clinfoCG.sav'//file=* /by case/drop sex .
rename vars name = ClientName.
sort cases by staff.
match files /table='//covenas/decisionsupport/staff.sav' /file=* /by staff.
rename vars Name = StaffName.
Sort cases by primdx.
rename vars primdx=dx.
match files /table='//covenas/decisionsupport/dxtable.sav' /file=* /by dx /keep  case ClientName opdate closdate epflag dx ru agency provname PrimaryTherapist sex bday ethnic LastService dx_descr.
rename vars dx=primdx.
save outfile='//covenas/decisionsupport/meinzer/temp/TAY_ClientListEps.sav' /keep case ClientName opdate closdate epflag primdx ru agency provname PrimaryTherapist sex bday ethnic LastService dx_descr.
*pushbreak.
 *   get file='//covenas/decisionsupport/meinzer/temp/TAY_ClientListEps.sav'.
 *     SAVE TRANSLATE /TYPE=ODBC
 /Connect ='DSN=DashboardDatadev;UID=;APP=SPSS For'+
 ' Windows;WSID=HPMXL9360ZDD;DATABASE=DashboardDatadev;Trusted_Connection=Yes'
 /table= 'TAY_ClientList_Eps' /MAP/REPLACE.
*pushbreak.

get file='//covenas/decisionsupport/meinzer/temp/TAYsvcs.sav' /keep ru case opdate closdate proclong svcdate epflag PrimaryTherapist staff Agency provname UnCookedMonth.

sort cases by case.
match files /table ='//covenas/decisionsupport/temp/TAYLOSUniquelist.sav' /file=* /by case.
match files /table ='//covenas/decisionsupport/temp/TAYTISUniquelist.sav' /file=* /by case.
select if keepEpTAY=1 or TISkeepEpTAY=1.
match files/table='//covenas/spssdata/clinfo.sav'//file=* /by case/drop sex .
rename vars name = ClientName.
sort cases by staff.
match files /table='//covenas/decisionsupport/staff.sav' /file=* /by staff.
rename vars Name = StaffName.

save outfile='//covenas/decisionsupport/meinzer/temp/TAY_ClientListSVC.sav'.

*pushbreak.
 * get file='//covenas/decisionsupport/meinzer/temp/TAY_ClientListSVC.sav'.
 * SAVE TRANSLATE /TYPE=ODBC
 /Connect ='DSN=DashboardDatadev;UID=;APP=SPSS For'+
 ' Windows;WSID=HPMXL9360ZDD;DATABASE=DashboardDatadev;Trusted_Connection=Yes'
 /table= 'TAY_ClientListSVC' /MAP/REPLACE.
*pushbreak.

