DEFINE DBstartdate() date.dmy(1,7,2011) !ENDDEFINE.
define OAkeepRU() "01EM1","01EI1","00621","81601","01087","01H11" !enddefine.

*this section calculates admits and discharges.
get file='//covenas/decisionsupport/epsCG.sav'  /keep  ru case opdate closDate epflag primdx PrimaryTherapist staff lastservice.

select if any(ru,OAkeepRU).

if ru = "01087"  ru = "01H11".

insert file='//covenas/decisionsupport/modules/uncookedmonth.sps'.

select if opdate lt UnCookedMonth and (Closdate ge DBstartdate or sysmis(closdate)).

compute counter=1.
*use for length of stay and tis.
save outfile='//covenas/decisionsupport/meinzer/temp/oalos.sav'.
 * get file='//covenas/decisionsupport/meinzer/temp/oalos.sav'.
* use fo last svc in 90 days.
compute PriorMonth=datesum(UnCookedMonth, -1,'months').
Temp.
select if opdate lt UnCookedMonth and (closdate ge PriorMonth or sysmis(closdate)).
formats PriorMonth(moyr6).
save outfile '//covenas/decisionsupport/meinzer/temp/lastepmonth.sav'.

*this is weird... but dont want to lose admits, so if we forget about your closdate, the math works out.
if closdate ge uncookedmonth closdate=$sysmis.
*select if closdate lt UnCookedMonth or sysmis(closdate).

insert file='//covenas/decisionsupport/meinzer/modules/admitdischarge.sps'.

compute calendarOpen = date.MOYR(xdate.month(opdate),xdate.year(opdate)).
compute calendarClose = date.MOYR(xdate.month(closdate),xdate.year(closdate)).
formats calendarOpen calendarClose(MOYR6).

rename vars admit=fiscalyear.
temp.
select if fiscalYear ne " ".
xsave outfile='//covenas/decisionsupport/temp/admitsOlder_Adulttest.sav'.
aggregate outfile='//covenas/decisionsupport/meinzer/temp/fiscaladmits.sav' 
	/break= fiscalyear ru 
	/FYAdmits=sum(counter).

rename vars fiscalyear = deletex.
rename vars discharge=fiscalyear.	
compute admitselect=0.
temp.
select if fiscalYear ne " ".
xsave outfile='//covenas/decisionsupport/temp/dcssOlder_Adulttest.sav'.
aggregate outfile='//covenas/decisionsupport/meinzer/temp/fiscalDischarge.sav'
	/break= fiscalyear RU
	/FYDischarges=sum(counter).

rename vars calendaropen=calendar.	
temp.
select if not missing(calendar).
aggregate outfile='//covenas/decisionsupport/meinzer/temp/Monthadmits.sav'
	/break= calendar ru 
	/MonthlyAdmits=sum(counter).

rename vars calendar=deletexx.	
rename vars calendarclose=calendar.	
temp.
select if not missing(calendar).
aggregate outfile='//covenas/decisionsupport/meinzer/temp/monthdischarge.sav'
	/break= calendar RU
	/MonthlyDischarges=sum(counter).

add files
/file='//covenas/decisionsupport/temp/dcssOlder_Adulttest.sav'
/file='//covenas/decisionsupport/temp/admitsOlder_Adulttest.sav'.
recode admitselect (sysmis=1).
sort cases by case.
match files /table='//covenas/spssdata/clinfo.sav' /file=* /by case.
rename vars primdx=dx.
sort cases by dx.
match files /table='//covenas/decisionsupport/dxtable.sav' /file=* /by dx.
sort cases by ru.
match files /table='//covenas/decisionsupport/rutable.sav' file=* /by ru.
save outfile='//covenas/decisionsupport/temp/admitDCcaselistOlder_Adult.sav' /keep ru provname case name bday admitselect opdate dx_descr closdate fiscalyear.

 * get file = '//covenas/decisionsupport/temp/admitDCcaselistOlder_Adult.sav'.

*pushbreak.
*sqlTable = 'Older_Adult_AdmitDCCaselistByFY'.
*spsstable= '//covenas/decisionsupport/temp/admitDCcaselistOlder_Adult.sav'.
*pushbreak.

select if admitselect=0.
sort case by ru.
match files  /file=* /table='//covenas/decisionsupport/rutable.sav'  /by ru.
sort cases by case.
rename vars ru=Older_AdultRU opdate=Older_Adultopdate closdate=Older_AdultClosdate provname=Older_AdultProvname.

save outfile='//covenas/decisionsupport/temp/dischargeList.sav' /keep Older_AdultRU Older_AdultProvname case FiscalYear Older_AdultOpdate Older_Adultclosdate.
compute Older_AdultDCclient=1.
aggregate outfile='//covenas/decisionsupport/dischargeUniqueOlderAdult.sav'
   /break case
   /Older_AdultDCclient=max(Older_AdultDCclient).

 * get file='//covenas/decisionsupport/temp/dischargeList.sav' .

*services after discharge from Older_Adult RU.

get file='//covenas/decisionsupport/dbsvc.sav' /keep agency provname ru case opdate closdate proced svcdate cost calendar duration psmask2 MCsvcCat svcMode PrimaryTherapist staff proclong epflag.
select if svcdate ge DBstartdate.
save outfile='//covenas/decisionsupport/dbsvc2011only.sav'.
get file='//covenas/decisionsupport/dbsvc2011only.sav'.
select if not proced=197.
select if proced lt 800.

*get file='//covenas/decisionsupport/dbsvc2011only.sav'.
sort cases by case.

*only interested in services for people that had a Older_Adult DC.
match files /table='//covenas/decisionsupport/dischargeUniqueOlderAdult.sav' /file=* /by case.
select if Older_AdultDCclient=1.
save outfile='//covenas/decisionsupport/dbsvc2011Older_Adultonly.sav'.


get file='//covenas/decisionsupport/dbsvc2011Older_Adultonly.sav'  /keep case opdate svcdate ru primarytherapist.
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
select if (Older_Adultclosdate lt svcdate and svcdate le datesum(Older_Adultclosdate,30,'days')) or ru='None'.
 * compute x=datedif(Older_Adultclosdate, svcdate,'days').
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
match files /table='//covenas/decisionsupport/rutable.sav' /file=*  /by ru.
sort cases by case.
match files /table='//covenas/spssdata/clinfo.sav' /file=* /by case.
if ru='None' provname=ru.

save outfile='//covenas/decisionsupport/temp/Older_AdultFollowupSVcs.sav' /keep Older_AdultRU Older_AdultProvname Older_Adultopdate case svcdate fiscalyear name agency provname ru primarytherapist opdate .

*get file='//covenas/decisionsupport/temp/Older_AdultFollowupSVcs.sav'. 

*pushbreak.
*sqlTable = 'Older_Adult_FollowUpEps' .
*spsstable= '//covenas/decisionsupport/temp/Older_AdultFollowupSVcs.sav'.
*pushbreak.

*total number of clients that had a discharge destination or not.
sort cases by Older_Adultru fiscalyear ru case .
match files /file=* /by Older_Adultru fiscalyear ru case  /first=Older_AdultruFiscalyearRUcase1.

aggregate outfile='//covenas/decisionsupport/temp/Older_AdultFollowupRUs.sav'
   /break Older_AdultRU Older_AdultProvname provname ru FiscalYear 
   /Clients=sum(Older_AdultruFiscalyearRUcase1).

*pushbreak.
*sqlTable ='Older_Adult_FollowUpRUs'.
*spsstable= '//covenas/decisionsupport/temp/Older_AdultFollowupRUs.sav'.
*pushbreak.

**********************services.
get file='//covenas/decisionsupport/dbsvc.sav' /keep agency provname ru case opdate closdate proced svcdate cost calendar duration psmask2 MCsvcCat svcMode PrimaryTherapist staff proclong epflag.

string unit(a10).
if svcmode='15' unit = 'minutes'.
if svcmode='05' unit = 'day'.
string Units(a10).
do if unit="day".
compute units ="Days".
compute duration=1.
end if.
if unit="minutes" units ="Hours".

if ru = "01087" ru = "01H11".
if ru = "01087" provname='GART MHS OLDER ADULT'.
*select if any(ru,"01EM1","01EI1","00621","00622","81601","01087","01H11") OR psMask2=5.
*TELECARE MORTON BAKAR SNF	00621 TELECARE STAGES MH ADULT	81601.
insert file='//covenas/decisionsupport/modules/uncookedmonth.sps'.

*this file used for face sheets later.       
TEMPORARY.
select if svcdate gt datesum(UnCookedMonth,-3,'years').  
save outfile='//covenas/decisionsupport/meinzer/temp/oasvcs.sav' /keep ru case opdate closdate proclong svcdate epflag PrimaryTherapist staff Agency provname UnCookedMonth.

match files /file=* /keep unit units agency provname ru case opdate closdate proced svcdate cost calendar duration psmask2 MCsvcCat svcMode UnCookedMonth.
 * get file='//covenas/decisionsupport/meinzer/temp/oasvcs.sav'.
select if svcdate ge DBstartdate.   

insert file='//covenas/decisionsupport/meinzer/modules/calfiscalyear.sps'.

if psmask2=5  HospClient=1.
if HospClient =1 hospdate=opdate.

temp. 
select if svcdate lt uncookedmonth.
aggregate outfile=* mode= ADDVARIABLES
   /break = FiscalYear case  
   /FYhospClient=max(HospClient)
   /FYlastHosp=max(hospdate).
exe.
temp. 
select if svcdate lt uncookedmonth.
 aggregate outfile=* mode= ADDVARIABLEs
   /break =case Calendar 
   /CalHospClient=max(HospClient)
   /CalLastHosp=max(hospdate).
exe.

select if any(ru,OAkeepRU).
save outfile='//covenas/decisionsupport/meinzer/temp/oaonly.sav'.

*get last svc in 3 or 4 cooked months.  is three enought if last ep month is one of thsoe months.
temp.
select if svcdate ge DateSum(UnCookedMonth,-3,"months").
aggregate outfile='//covenas/decisionsupport/meinzer/temp/svcs90dayswide.sav'
   /break= ru case opdate 
   /lastsvc=max(svcdate).

select if svcdate lt uncookedmonth.

sort cases by FiscalYear ru case.
match files /file=* /by FiscalYear ru case /first=FYRuCase1.

sort cases by ru calendar case.
match files /file=* /by ru calendar case /first=RuCalCase1.

sort cases by FiscalYear ru McSvcCat case .
match files /file=* /by FiscalYear ru McSvcCat case /first=FYRuMcSvcCatCase1.

sort cases by ru calendar McSvcCat case .
match files /file=* /by ru calendar McSvcCat case /first=RuCalMcSvcCatCase1.

if RuCalCase1=1 AND CalHospClient=1 RuCalHospCase1=1.
if FYRuCase1=1 AND FYhospClient=1 RuFYHospCase1=1.
match files /file=* /drop HospClient hospdate FYhospClient FYlastHosp.

save outfile='//covenas/decisionsupport/meinzer/temp/olderAdult_work.sav'.

get file='//covenas/decisionsupport/meinzer/temp/olderAdult_work.sav'.

Aggregate outfile=*mode addvariables
   /break = FiscalYear ru    
   /FYruClients=Sum(FYruCase1)
   /FYruHours=Sum(duration)
   /FYruCost=sum(Cost)
   /FYHospClients=sum(RuFyHospCase1).
*save outfile='//covenas/decisionsupport/meinzer/temp/fiscaloa.sav'.

Aggregate outfile=*mode addvariables
   /break = ru calendar 
   /CalMonthClients=Sum(RuCalCase1)
   /CalMonthTime=Sum(duration)
  /CalMonthCost=sum(Cost)
  /CalHospClients=sum(RuCalHospCase1).

save outfile='//covenas/decisionsupport/meinzer/temp/caloa.sav'.
*get file='//covenas/decisionsupport/meinzer/temp/caloa.sav'.

Aggregate outfile= '//covenas/decisionsupport/meinzer/projects/older adult/FYOlderadult.sav'
   /break = FiscalYear provname ru   
   /units=max(units)
   /FYruClients=Sum(FYruCase1)
   /FYruTime=Sum(duration)
   /FYruCost=sum(Cost)
   /FYHospClients=sum(RuFyHospCase1).

Aggregate outfile= '//covenas/decisionsupport/meinzer/projects/older adult/calendarOlderAdult.sav'
   /break=ru calendar mcsvccat  fiscalyear agency provname   psMask2 CalMonthClients CalMonthTime CalMonthCost     FYHospClients CalHospClients 
   /units=max(units)
   /ProcClients=sum(RuCalMcSvcCatCase1)
   /Proctime=sum(Duration)
   /ProcCost=sum(cost).

*********************************This section for evaluating fiscal year goals.
get file='//covenas/decisionsupport/meinzer/projects/older adult/FYOlderadult.sav'.

insert file='//covenas/decisionsupport/modules/uncookedmonth.sps'.
****This seems to be the challenge as the CookedFiscalYear is not correct!!!. THIS IS THE OLD CODE.
 * string CookedFiscalYear(a10).
 * do if xdate.month(uncookedmonth-1) lt 7.
 * compute Cookedfiscalyear=concat("FY ",substr(string(xdate.year(uncookedmonth)-1,n4),3,2),"-",substr(string(xdate.year(uncookedmonth),n4),3,2)).
 * else if xdate.month(uncookedmonth-1) ge 7.
 * compute Cookedfiscalyear=concat("FY ",substr(string(xdate.year(uncookedmonth),n4),3,2),"-",substr(string(xdate.year(uncookedmonth)+1,n4),3,2)).
 * end if.
****Cooked FiscalYear is FY 14-15?????..

string CookedFiscalYear(a10).
do if xdate.month(uncookedmonth)-1 lt 7.
compute Cookedfiscalyear=concat("FY ",substr(string(xdate.year(uncookedmonth)-1,n4),3,2),"-",substr(string(xdate.year(uncookedmonth),n4),3,2)).
else if xdate.month(uncookedmonth)-1 ge 7.
compute Cookedfiscalyear=concat("FY ",substr(string(xdate.year(uncookedmonth),n4),3,2),"-",substr(string(xdate.year(uncookedmonth)+1,n4),3,2)).
end if.

 * string CookedFiscalYear(a10).
 * do if xdate.month(uncookedmonth-1) lt 7.
 * compute Cookedfiscalyear=concat("FY ",substr(string(xdate.year(uncookedmonth)-1,n4),3,2),"-",substr(string(xdate.year(uncookedmonth),n4),3,2)).
 * else if xdate.month(uncookedmonth-1) ge 7.
 * compute Cookedfiscalyear=concat("FY ",substr(string(xdate.year(uncookedmonth),n4),3,2),"-",substr(string(xdate.year(uncookedmonth)+1,n4),3,2)).
 * end if.

*if month is july to dec then we are in the second half of the fy, otherwise first half.
****EDIT: If current month is July - December we are in the 1st half of the Fiscal Year????.
****EDIT: If cooked months is July - December then we are in the 2nd half of the Fiscal Year?????.
***Which of these statements is true???.
 * do if xdate.month(UnCookedMonth-1) gt 6.
 * compute FYPercent=(xdate.month(UnCookedMonth-1)+5)/12.
 * else.
 * compute FYPercent=(xdate.month(UnCookedMonth-1)-6)/12.
 * end if.
 * freq FYpercent uncookedmonth.

do if xdate.month(UnCookedMonth)-1 gt 6 and FiscalYear=CookedFiscalYear.
compute FYPercent=(xdate.month(UnCookedMonth)-7)/12.
else if xdate.month(UnCookedMonth)-1 le 6 and FiscalYear=CookedFiscalYear.
compute FYPercent=(xdate.month(UnCookedMonth)+5)/12.
else.
compute FYPercent=1.
end if.

sort cases by ru fiscalyear.
match files /table='//covenas/decisionsupport/meinzer/tables/contractoa.sav' /file=* /by ru fiscalyear.

rename vars fyrutime=duration.

if units="Days" CDDuration=CDDaysofSvcs.
if Units="Hours" CDDuration=CDHrsofSvcs.

compute CDDurationAdjust = CDDuration*fypercent.
compute DurationPercentAdjGoal = Duration/CDDurationAdjust.
compute CDAmountAdjust =CDAmount*fypercent.
compute CostPercentAdjGaol = FYruCost/CDAmountAdjust.

recode  CDCaseMgtHrs CDMHHrs CDMedsSupptHrs CDCrisisHrs CDResidentialDays CDDaysofSvcs CDHrsofSvcs CDAmount
 FYruClients  FYruCost FYHospClients UnCookedMonth FYPercent duration CDDuration
CDDurationAdjust  CDAmountAdjust  DurationPercentAdjGoal CostPercentAdjGaol (sysmis=0).

save outfile='//covenas/decisionsupport/meinzer/temp/MonthlygoalsMatched1.sav'. 

*pushbreak.
*sqlTable ='OlderAdult_GoalsFY'.
*spsstable= '//covenas/decisionsupport/meinzer/temp/MonthlygoalsMatched1.sav'. 
*pushbreak.

get file='//covenas/decisionsupport/meinzer/tables/contractoa.sav' .
vector mcsvccat(5 a35).
if not missing(CDCaseMgtHrs) mcsvccat1="A. Case Management Services".
if not missing(CDMHHrs) mcsvccat2="B. Mental Health Services".
if not missing(CDMedsSupptHrs) mcsvccat3="C. Medication Support".
if not missing(CDCrisisHrs) mcsvccat4="D. Crisis Intervention".
if not missing(CDResidentialDays) mcsvccat5="J. SNF".
exe.
VARSTOCASES
/make mcsvccat from mcsvccat1 to mcsvccat5
/keep provname ru fiscalyear.

save outfile='//covenas/decisionsupport/meinzer/temp/contractshell.sav'. 

get file= '//covenas/decisionsupport/meinzer/projects/older adult/calendarOlderAdult.sav'.

aggregate outfile=*
   /break = fiscalyear calendar ru provname  
   /Proctime=sum(proctime).

string McSvcCat(a35).
compute mcsvccat="Total".
add files
   /file=*
   /file= '//covenas/decisionsupport/meinzer/projects/older adult/calendarOlderAdult.sav' .

sort cases by ru calendar mcsvccat.
save outfile='//covenas/decisionsupport/meinzer/temp/calendarOlderAdultshelled.sav'.

add files
/file=*
/file='//covenas/decisionsupport/meinzer/temp/contractshell.sav'. 
select if mcsvccat ne ''.
aggregate outfile=*
   /break = ru mcsvccat 
   /provname=max(provname).

**janet stopped here.

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
 * match files /table= '//covenas/decisionsupport/meinzer/projects/older adult/calendarOlderAdult.sav' /file=* /by  ru calendar mcsvccat.
match files /table= '//covenas/decisionsupport/meinzer/temp/calendarOlderAdultshelled.sav' /file=* /by  ru calendar mcsvccat.
exe.
sort cases by ru fiscalyear.
match files /table='//covenas/decisionsupport/meinzer/tables/contractoa.sav' /file=* /by ru fiscalyear.

formats calendar(date11).

compute PercentCalClient =CalMonthClients/(CDClients/12).
if mcsvccat="A. Case Management Services" PercentCalCaseMGThrs =proctime/(CDCaseMgtHrs/12).
if mcsvccat="B. Mental Health Services" PercentCalMHhrs = proctime/(CDMHHrs/12).
if mcsvccat="C. Medication Support" PercentCalMedSupHRS = proctime/(CDMedsSupptHrs/12).
if mcsvccat="D. Crisis Intervention" PercentCalCrisis = proctime/(CDCrisisHrs/12).
if mcsvccat="G. Residential" or mcsvccat="J. SNF" PercentCalResidentialDays = proctime/(CDResidentialDays/12).
compute PercentCalDays = CalMonthTime/(CDDaysofSvcs/12).
compute PercentCalHrs = CalMonthTime/(CDHrsofSvcs/12).
compute PercentCalAmount = CalMonthCost/(CDAmount/12).

compute CDMonthDaysofSvcs = (CDDaysofSvcs/12).
compute CDMonthHrsofSvcs = (CDHrsofSvcs/12).
compute CDMonthCost = (CDAmount/12).
if mcsvccat="A. Case Management Services" CDMonthHrsofSvcs = (CDCaseMgtHrs/12).
if mcsvccat="B. Mental Health Services" CDMonthHrsofSvcs = (CDMHHrs/12).
if mcsvccat="C. Medication Support" CDMonthHrsofSvcs = (CDMedsSupptHrs/12).
if mcsvccat="D. Crisis Intervention" CDMonthHrsofSvcs = (CDCrisisHrs/12).
if mcsvccat="G. Residential" or mcsvccat="J. SNF" CDMonthDaysofSvcs = (CDResidentialDays/12).
save outfile='//covenas/decisionsupport/meinzer/temp/MonthlygoalsMatched.sav'. 

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

recode CDClients CDCaseMgtHrs CDMHHrs CDMedsSupptHrs CDCrisisHrs CDResidentialDays
CDDaysofSvcs CDHrsofSvcs CDAmount ProcCost procclients proctime proctime CalMonthClients
CalMonthTime CalMonthCost PercentCalClient PercentCalCaseMGThrs
PercentCalMHhrs PercentCalMedSupHRS PercentCalCrisis PercentCalResidentialDays
PercentCalDays PercentCalHrs PercentCalAmount CDMonthDaysofSvcs
CDMonthHrsofSvcs CDMonthCost (sysmis=0).

match files /table='//covenas/decisionsupport/rutable.sav' /file=* /by ru /drop EPSDTGroup	DayTx	RU2		Level3Classic	county	kidsru	ab3632RU	CESDC	psmask2	svcType	cds_Code	
MHSA	start_dt	end_dt	school	OAru	Level2	TAYru	svcType3	program	Residential	OutCty	CalWorks	SafePassages	RUCITY	frc.

sort cases by mcsvccat units.
match files /table='//covenas/decisionsupport/meinzer/tables/mcunits.sav' /file=* /by mcsvccat.

compute Duration=proctime.

do if mcsvccat ne"Total" .
compute mcsvccat =  concat(rtrim(mcsvccat)," ", Units).
else.
compute mcsvccat= "Total Time".
end if.

save outfile='//covenas/decisionsupport/meinzer/temp/olderadult_MainLineGraphs.sav'.

*pushbreak.
*sqlTable = 'OlderAdult_GoalsMonthly'. 
*spsstable='//covenas/decisionsupport/meinzer/temp/olderadult_MainLineGraphs.sav'.
*pushbreak.

*per month eps.
get file='//covenas/decisionsupport/epsCG.sav'  /keep ru case opdate closDate epflag.

select if any(ru,OAkeepRU).

if ru = "01087"  ru = "01H11".

insert file='//covenas/decisionsupport/modules/uncookedmonth.sps'.

select if opdate lt UnCookedMonth and (Closdate ge DBstartdate or sysmis(closdate)).
match files /file=* /keep ru case opdate closdate.

insert file='//covenas/decisionsupport/meinzer/modules/explodemonth.sps'.
*this would be needed, if we were keeping this file.
*if closdate gt $time closdate=$sysmis.
aggregate outfile=*
   /break=ru calendar
   /permontheps=sum(counter).

insert file='//covenas/decisionsupport/meinzer/modules/calfiscalyear.sps'.

sort cases by ru calendar fiscalyear.
save outfile='//covenas/decisionsupport/meinzer/temp/permontheps.sav'.

*admits DCs.
get file='//covenas/decisionsupport/rutable.sav' /keep ru provname.
select if not ru = "01087" .


select if any(ru,OAkeepRU).
insert file='//covenas/decisionsupport/modules/uncookedmonth.sps'.
vector calshell(50,f11).
compute CountMonths=datediff(uncookedmonth,dbstartdate,"months").
compute #dateindex=1.

compute calshell1=date.dmy(1,7,2011).
loop #count=2 to countmonths.
compute calshell(#count)=datesum(calshell( #dateindex),1,'month','closest').
compute #dateindex=1 + #dateindex.
end loop.
formats calshell1 to calshell50 (date11).
match files /file=* /drop countmonths.
VARSTOCASES
/make Calendar from Calshell1 to calshell50.

sort cases by calendar ru.
match files /table='//covenas/decisionsupport/meinzer/temp/Monthadmits.sav' /file=* /by calendar ru.
match files /table='//covenas/decisionsupport/meinzer/temp/monthdischarge.sav' /file=* /by  calendar ru.
insert file='//covenas/decisionsupport/meinzer/modules/calfiscalyear.sps'.
sort cases by fiscalyear ru.
match files /table='//covenas/decisionsupport/meinzer/temp/fiscalDischarge.sav' /file=* /by fiscalyear ru.
match files /table='//covenas/decisionsupport/meinzer/temp/fiscaladmits.sav' /file=* /by fiscalyear ru.

sort cases by ru fiscalyear calendar.
match files /table='//covenas/decisionsupport/meinzer/temp/permontheps.sav' /file=* /by ru calendar fiscalyear.

recode MonthlyDischarges MonthlyAdmits(sysmis=0).
save outfile='//covenas/decisionsupport/meinzer/temp/MonthlygoalsMatchedxx.sav'. 

*pushbreak.
*sqlTable ='OlderAdult_AdmitsDischarges' . 
*spsstable='//covenas/decisionsupport/meinzer/temp/MonthlygoalsMatchedxx.sav'. 
*pushbreak.

****************demographs.
get file='//covenas/decisionsupport/meinzer/temp/oaonly.sav'.
select if svcdate lt UnCookedMonth.
sort cases by case.
match files /table='//covenas/spssdata/clinfo.sav' /file=* /by case /keep ru case opdate svcdate calendar fiscalyear calendar agency ethnic hispanic sex bday provname HospClient hospdate FYhospClient FYlastHosp CalHospClient CalLastHosp.
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

STRING AgeGroup(a20).
IF Age lt 55 AgeGroup="54 and Younger".
IF Age ge 55 and Age lt 60 AgeGroup="55-59".
IF Age ge 60 and Age lt 65 AgeGroup="60-64".
IF Age ge 65 and Age lt 70 AgeGroup="65-69".
IF Age ge 70 and Age lt 75 AgeGroup="70-74".
IF Age ge 75 and Age lt 80 AgeGroup="75-79".
IF Age ge 80 AgeGroup="80 or Older".

aggregate outfile='//covenas/decisionsupport/temp/oaDemographicgender.sav'
/break RU CASE FISCALYEAR AGENCY
ETHNICITY SEX BDAY PROVNAME
/AGEGROUP=Max(AGEGROUP).

compute counter=1.

aggregate outfile='//covenas/decisionsupport/meinzer/temp/OAAgeAgg.sav'
   /break provname ru fiscalyear agegroup
   /Clients=sum(counter).

aggregate outfile='//covenas/decisionsupport/meinzer/temp/OAEthnicityagg.sav'
   /break provname ru fiscalyear ethnicity
   /Clients=sum(counter).

match files /file=* /keep  RU case Opdate svcdate calendar FiscalYear agency provname Ethnicity sex bday FYhospClient FYlastHosp 
CalHospClient CalLastHosp CalRuCase1 Age AgeGroup.
formats fylasthosp callasthosp (date11).

get file='//covenas/decisionsupport/meinzer/temp/oaonly.sav'.
aggregate outfile=*
   /break provname ru FiscalYear
   /bogus=n.

match files /file=*  /drop bogus.

vector AgeGroup(7,a20).
compute agegroup1="54 and Younger".
compute AgeGroup2="55-59".
compute AgeGroup3="60-64".
compute AgeGroup4="65-69".
compute AgeGroup5="70-74".
compute AgeGroup6="75-79".
compute AgeGroup7="80 or Older".

varstocases
/make AgeGroup from agegroup1 to agegroup7.

sort cases by provname ru fiscalyear agegroup.
match files /table='//covenas/decisionsupport/meinzer/temp/OAAgeAgg.sav' /file=* /by provname ru fiscalyear agegroup.

save outfile='//covenas/decisionsupport/meinzer/temp/OAAgegroupShelledAGG.sav'.

*pushbreak.
*sqlTable ='OlderAdult_Demographics_Agegroup'. 
*spsstable='//covenas/decisionsupport/meinzer/temp/OAAgegroupShelledAGG.sav'.
*pushbreak.

get file='//covenas/decisionsupport/meinzer/temp/oaonly.sav'.
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
match files /table='//covenas/decisionsupport/meinzer/temp/OAEthnicityAgg.sav' /file=* /by provname ru fiscalyear Ethnicity.

save outfile='//covenas/decisionsupport/meinzer/temp/OAEthnicityShelled.sav' /keep FiscalYear provname RU Ethnicity clients.

*pushbreak.
*sqlTable ='OlderAdult_Demographics_Ethnicity'. 
*spsstable='//covenas/decisionsupport/meinzer/temp/OAEthnicityShelled.sav'.
*pushbreak.

get file='//covenas/decisionsupport/temp/oaDemographicgender.sav'.

save outfile='//covenas/decisionsupport/meinzer/temp/OAgender.sav' /keep RU CASE FISCALYEAR  AGENCY
ETHNICITY AGEGROUP SEX BDAY PROVNAME.

*pushbreak.
*sqlTable ='OlderAdult_Demographics'.  
*spsstable='//covenas/decisionsupport/meinzer/temp/OAgender.sav'. 
*pushbreak.

**************************running totals for cost duration.
*I added the contract goals to the following two sections.


 * get file='//covenas/decisionsupport/meinzer/temp/caloa.sav' /keep fiscalyear calendar provname ru duration day cost mcsvccat.

 * if ru = "01087" ru = "01H11".
 * aggregate outfile=* 
   /break =calendar ru fiscalyear 
   /MonthruHours=Sum(duration)
   /MonthruDays=sum(Day)
   /MonthruCost=sum(Cost).

 * sort cases by ru fiscalyear calendar.
 * match files /file=* /by ru fiscalyear /first=first.

 * do if first=1.
 * compute  cost=MonthruCost.
 * compute  days=MonthruDays.
 * compute  hours=MonthruHours.
 * ELSE.
 * compute  cost=cost+MonthruCost.
 * compute  days=days+MonthruDays.
 * compute  hours=hours+MonthruHours.
 * END IF.
 * leave  cost days hours.
 * exe.
 * match files /file=* /drop first .

 * sort cases by ru.
 * match files /table='//covenas/decisionsupport/meinzer/tables/contractoa.sav' /file=* /by ru.

 * compute DaysGoalMonth = CDDaysofSVCs/12.
 * compute HrsGoalMonth=CDHRSofSVCs/12.
 * compute CostGoalMonth=CDamount/12.

 * match files /file=* /drop  CDCaseMgtHrs CDMHHrs CDMedsSupptHrs CDCrisisHrs CDResidentialDays.
 * save outfile='//covenas/decisionsupport/meinzer/temp/bobx.sav'.

 * get file ='//covenas/decisionsupport/meinzer/temp/bobx.sav'.
 *.

********************with mcsvccat.

 * insert file='//covenas/decisionsupport/meinzer/modules/MonthRuShell.sps'.

 * get FILE='//covenas/decisionsupport/meinzer/tables/MonthRuShell.sav'.
 * insert file='//covenas/decisionsupport/meinzer/modules/mc1cal.sps'.
 * get file='//covenas/decisionsupport/meinzer/temp/caloa.sav' /keep fiscalyear calendar provname ru duration day cost mcsvccat.

 * if ru = "01087" ru = "01H11".
 * aggregate outfile=* 
   /break =calendar ru fiscalyear mcsvccat
   /MonthruHours=Sum(duration)
   /MonthruDays=sum(Day)
   /MonthruCost=sum(Cost).

 * sort cases by ru fiscalyear mcsvccat calendar .
 * match files /file=* /by ru fiscalyear mcsvccat /first=first.

 * do if first=1.
 * compute  cost=MonthruCost.
 * compute  days=MonthruDays.
 * compute  hours=MonthruHours.
 * ELSE.
 * compute  cost=cost+MonthruCost.
 * compute  days=days+MonthruDays.
 * compute  hours=hours+MonthruHours.
 * END IF.
 * leave  cost days hours.
 * exe.

 * sort cases by ru.
 * match files /table='//covenas/decisionsupport/meinzer/tables/contractoa.sav' /file=* /by ru.

 * compute  GaolMonthClient =CDClients/12.
 * if mcsvccat="A. Case Management Services" GoalsMonthCaseMGTHrs =CDCaseMgtHrs/12.
 * if mcsvccat="B. Mental Health Services" GaolMonthMHhrs = CDMHHrs/12.
 * if mcsvccat="C. Medication Support" GaolMonthMedSupHRS = CDMedsSupptHrs/12.
 * if mcsvccat="D. Crisis Intervention" GaolMonthCrisishrs = CDCrisisHrs/12.
 * if mcsvccat="G. Residential" or mcsvccat="J. SNF" GaolMonthResidentialDays = CDResidentialDays/12.
 * compute GaolMonthFYDays = CDDaysofSvcs/12.
 * compute GaolMonthFYHrs = CDHrsofSvcs/12.
 * compute GaolMonthFYAmount = CDAmount/12.

 * compute  GaolMonthClient =CDClients/12.
 * if mcsvccat="A. Case Management Services" GoalProcHours =CDCaseMgtHrs/12.
 * if mcsvccat="B. Mental Health Services" GoalProcHours = CDMHHrs/12.
 * if mcsvccat="C. Medication Support" GoalProcHours = CDMedsSupptHrs/12.
 * if mcsvccat="D. Crisis Intervention" GoalProcHours = CDCrisisHrs/12.
 * if mcsvccat="G. Residential" or mcsvccat="J. SNF" GoalProcDays = CDResidentialDays/12.
 * compute GaolMonthFYDays = CDDaysofSvcs/12.
 * compute GaolMonthFYHrs = CDHrsofSvcs/12.
 * compute GaolMonthFYAmount = CDAmount/12.


 * sort cases by ru fiscalyear mcsvccat calendar .
 * match files /file=* /by ru fiscalyear mcsvccat /first=first.

 * do if first=1.
 * compute  GoalProcDaysRT=GoalProcDays.
 * compute  GoalProchoursRT=GoalProcHours.
 * ELSE.
 * compute  GoalProcdaysRT=GoalProcDays+GoalProcdaysRT.
 * compute  GoalProchoursRT=GoalProchours+GoalProchoursRT.
 * END IF.
 * leave  GoalProcdaysRT GoalProchoursRT .
 * exe.

 * match files /file=* /drop first .

 * save outfile='//covenas/decisionsupport/meinzer/temp/MonthlygoalsMatchedxxxx.sav'. 

*pushbreak.
*sqlTable ='OlderAdult_RunTot_McSvcCat'.  
*spsstable='//covenas/decisionsupport/meinzer/temp/MonthlygoalsMatchedxxxx.sav'.
*pushbreak.

**************last svc in 90 days.
get file '//covenas/decisionsupport/meinzer/temp/lastepmonth.sav'.

aggregate outfile=* mode=AddVars 
	/break=ru 
	/openCases = N.

sort cases by ru case opdate.
match files /table='//covenas/decisionsupport/rutable.sav' /file=* /by ru /keep closdate agency provname ru case opdate epflag opencases. 
match files /table='//covenas/decisionsupport/meinzer/temp/svcs90dayswide.sav' /file=* /by ru case opdate.
freq LastSvc.
*i'm cutting closed people?.
select if epflag="O".
if missing(LastSvc) NoSvc90=1.

Temp.
Select if NoSvc90=1 and Epflag='O'.
save outfile='//covenas/decisionsupport/meinzer/temp/NoSvc90Clients.sav'.

aggregate outfile= *
   /break=ru
   /provname=max(provname)
   /agency=max(agency)
   /opencases=max(opencases)
   /NoSvc90=sum(NoSvc90).

recode NoSvc90 opencases (sysmis=0).
compute PctNoSvc90 = NoSvc90/Opencases.
match files /file=* /keep Agency Provname ru OpenCases NoSvc90 PctNoSvc90.
 * save outfile='//covenas/decisionsupport/meinzer/temp/NoSvc90byRU.sav' /keep Agency Provname ru OpenCases NoSvc90 PctNoSvc90.

save outfile='//covenas/decisionsupport/meinzer/temp/olderadult_NoSvc90ru.sav'.

*pushbreak.
*sqlTable ='OlderAdult_NoLastSvc90RU'.  
*spsstable='//covenas/decisionsupport/meinzer/temp/olderadult_NoSvc90ru.sav'.
*pushbreak.

*case list for drill through.
get file='//covenas/decisionsupport/meinzer/temp/NoSvc90Clients.sav'.
sort cases by case.
match files /table='//covenas/spssdata/clinfo.sav' /file=* /by case /keep agency provname ru case opdate name bday.

compute NoSVCClient=1.
aggregate outfile='//covenas/decisionsupport/temp\KeepEpsOlderAdult.sav' 
   /break=case
   /NoSVCClient=max(NoSVCClient)
   /RecentOlderAdultVisit=max(Provname).

sort cases by ru case.
match files /file=* /by ru case /last=RUcase1.
select if rucase1=1.

*save outfile='//covenas/decisionsupport/temp\KeepEpsOlderAdult.sav'  /RENAME Provname=LastOAVisit ru=lastOARU opdate=lastOAopdate.
match files /file=* /drop  rucase1.

save outfile='//covenas/decisionsupport/temp/clientlistolderadult.sav'.

*pushbreak.
*sqlTable ='OlderAdult_LastSvc90Clients'.  
*spsstable='//covenas/decisionsupport/temp/clientlistolderadult.sav'.
*pushbreak.

*** face sheet code. this file still has uncooked svcs and is only 3 years of svcs.
get file='//covenas/decisionsupport/meinzer/temp/oasvcs.sav' .

sort cases by case.
match files/table='//covenas/decisionsupport/temp\KeepEpsOlderAdult.sav' /file=* /by case.
select if NoSVCClient=1.
match files/table='//covenas/decisionsupport/clinfoCG.sav'//file=* /by case/drop sex .
rename vars name = ClientName.
sort cases by staff.
match files /table='//covenas/decisionsupport/staff.sav' /file=* /by staff.
rename vars Name = StaffName.

save outfile='//covenas/decisionsupport/temp\OlderAdultSvcs.sav' /keep ru case opdate agency provname StaffName proclong svcdate ClientName.

*pushbreak.
*sqlTable = 'OlderAdult_allSVCSforLastSvc90Clients'.   
*spsstable='//covenas/decisionsupport/temp\OlderAdultSvcs.sav'.
*pushbreak.

get file='//covenas/decisionsupport/epscg.sav' .
insert file='//covenas/decisionsupport/modules/uncookedmonth.sps'.
select if closdate ge datesum(uncookedmonth,-3,'years') or missing(closdate).
sort cases by case.
match files/table='//covenas/decisionsupport/temp\KeepEpsOlderAdult.sav' /file=* /by case.
select if NoSVCClient=1.
match files/table='//covenas/decisionsupport/clinfoCG.sav'//file=* /by case/drop sex .
rename vars name = ClientName.
sort cases by ru.
match files /table='//covenas/decisionsupport/rutable.sav' /file=* /by ru /keep ClientName ru agency provname case opdate epflag primarytherapist closdate lst_svc. 

 * sort cases by staff.
 * match files /table='//covenas/decisionsupport/staff.sav' /file=* /by staff.
 * rename vars Name = StaffName.

aggregate outfile='//covenas/decisionsupport/temp\EpsOlderAdult.sav'
   /break=ClientName RU case opdate epflag PrimaryTherapist agency provname
  	/closedate  = max(closdate) 
   /LastSvc = max(lst_svc).

*pushbreak.
*sqlTable ='OlderAdult_EpsforLastSvc90Clients'.   
*spsstable= '//covenas/decisionsupport/temp\EpsOlderAdult.sav'.
*pushbreak.

*********************LOS.
get file='//covenas/decisionsupport/meinzer/temp/oalos.sav'.
insert file='//covenas/decisionsupport/modules/uncookedmonth.sps'.
compute LOSmonths=datediff(closdate,opdate,'months').
if epflag="O" TISmonths=datediff($time,opdate,'months').

do if  any(ru,OAkeepRU).
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

compute counter=1.

*what fiscal year was your close date?.

string FiscalYear (a10).
do if xdate.month(closdate) lt 7.
compute fiscalyear=concat("FY ",substr(string(xdate.year(closdate)-1,n4),3,2),"-",substr(string(xdate.year(closdate),n4),3,2)).
else if xdate.month(closdate) ge 7.
compute fiscalyear=concat("FY ",substr(string(xdate.year(closdate),n4),3,2),"-",substr(string(xdate.year(closdate)+1,n4),3,2)).
end if.

sort cases by ru.
match files /table='//covenas/decisionsupport/rutable.sav'  /file=* /by ru /keep case opdate primdx provname LOSMonths ru los tis counter fiscalyear uncookedmonth closdate PrimaryTherapist LastService.


temp.
select if LOS ne "" and closdate lt uncookedmonth.
aggregate outfile='//covenas/decisionsupport/meinzer/temp/LOSoa.sav'
   /break=provname ru los fiscalyear
   /LengthofStay=sum(counter).

*this is matched into shell and will become the current fy tis.
temp.
select if TIS ne "".
aggregate outfile='//covenas/decisionsupport/meinzer/temp/TISoa.sav'
   /break=provname ru TIS
   /TimeinService=sum(counter).
string CookedFiscalYear(a10).
do if xdate.month(uncookedmonth)-1 lt 7.
compute Cookedfiscalyear=concat("FY ",substr(string(xdate.year(uncookedmonth)-1,n4),3,2),"-",substr(string(xdate.year(uncookedmonth),n4),3,2)).
else if xdate.month(uncookedmonth)-1 ge 7.
compute Cookedfiscalyear=concat("FY ",substr(string(xdate.year(uncookedmonth),n4),3,2),"-",substr(string(xdate.year(uncookedmonth)+1,n4),3,2)).
end if.

 * string uncookedFiscalYear (a10).
 * do if xdate.month(uncookedmonth) lt 7.
 * compute uncookedFiscalYear=concat("FY ",substr(string(xdate.year(uncookedmonth)-1,n4),3,2),"-",substr(string(xdate.year(uncookedmonth),n4),3,2)).
 * else if xdate.month(uncookedmonth) ge 7.
 * compute uncookedFiscalYear=concat("FY ",substr(string(xdate.year(uncookedmonth),n4),3,2),"-",substr(string(xdate.year(uncookedmonth)+1,n4),3,2)).
 * end if.

temp.
select if TIS ne "".
aggregate outfile='//covenas/decisionsupport/meinzer/temp/TISoaWithCase.sav'
   /break=case ru opdate TIS  PrimaryTherapist primdx
   /TimeinService=sum(counter)
   /FiscalYear=max(Cookedfiscalyear).

delete vars Cookedfiscalyear.

rename vars primdx=dx.
sort cases by dx.
match files /table='//covenas/decisionsupport/dxtable.sav' /file=* /by dx.
sort cases by case.
match files /file=* /table='//covenas/spssdata/clinfo.sav' /by case  /keep case opdate dx dx_descr LOSMonths provname ru LOS
TIS counter FiscalYear UnCookedMonth closdate PrimaryTherapist Bday name LastService.
rename vars name=ClientName.
compute CurrentAge=datedif($time,bday,'years').
compute DischargeAge=datedif(closdate,bday,'years').


if closdate gt $time closdate=$sysmis.
rename vars fiscalyear =fiscalyeartemp opdate=date.
insert file='//covenas/decisionsupport/meinzer/modules/datefy.sps'.
rename vars date=Opdate.
rename vars fiscalyear =OpdateFY closdate=date.
insert file='//covenas/decisionsupport/meinzer/modules/datefy.sps'.
rename vars fiscalyear =ClosdateFY date=closdate.
rename vars fiscalyeartemp=fiscalyear.

save outfile='//covenas/decisionsupport/temp/OA_loslistwithdx.sav'.

*pushbreak.
*sqlTable = 'OlderAdult_LOSListwithDX'.   
*spsstable='//covenas/decisionsupport/temp/OA_loslistwithdx.sav'.
*pushbreak.

compute keepEpOlderAdult=1.
aggregate outfile='//covenas/decisionsupport/temp/OlderAdultLOSUniquelist.sav'
   /break case
   /keepEpOlderAdult=max(keepEpOlderAdult).

select if closdate lt uncookedmonth.

aggregate outfile=*
   /break fiscalyear
   /bogus=max(counter).

CASESTOVARS
/id=bogus.

save outfile="//covenas/decisionsupport/temp/oafytable.sav".

get file='//covenas/decisionsupport/meinzer/temp/oalos.sav'.
insert file='//covenas/decisionsupport/modules/uncookedmonth.sps'.

if epflag="O" TISmonthsNow=datediff($time,opdate,'months').

if sysmis(closdate) closdate=datesum($time,1,'months').
compute Countyears=datediff($time,DBstartdate,"years").

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
*formats dateep1(date11).
compute #dateindex=1.
loop #count=1 to countyears.
do if datesum(dateep(#dateindex),1,'years','closest') lt closdate.
compute dateep(#dateindex+1) = datesum(dateep(#dateindex),1,"years","closest").
end if.
compute #dateindex=#dateindex+1.
end loop.
formats dateep1 to dateep50(date11).
VARSTOCASES
/make Endfy from dateep1 to dateep50.

*formats calendar(date11).

compute counter=1.
*freq counter.
select if closdate gt endfy.
*freq counter.
compute TISmonths=datediff(endfy,opdate,'months').

do if  any(ru,OAkeepRU).
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


select if endfy lt datesum(uncookedmonth,-1,'days').

add files 
/file=* 
/file ='//covenas/decisionsupport/meinzer/temp/TISoaWithCase.sav'.

insert file='//covenas/decisionsupport/modules/uncookedmonth.sps'.
if sysmis(endfy) endfy=uncookedmonth.
compute TISmonths=datediff(endfy,opdate,'months').
rename vars primdx=dx.
sort cases by dx.
match files /table='//covenas/decisionsupport/dxtable.sav' /file=* /by dx.
sort cases by ru.
match files /file=* /table='//covenas/decisionsupport/rutable.sav' /by ru.
sort cases by case.
match files /file=* /table='//covenas/spssdata/clinfo.sav' /by case  /keep agency ru provname case opdate closdate epflag dx dx_descr UnCookedMonth
counter TISmonthsNow Countyears Endfy TISmonths TIS FiscalYear PrimaryTherapist Bday name LastService.
rename vars name=ClientName.
compute CurrentAge=datedif($time,bday,'years').

if closdate gt $time closdate=$sysmis.
rename vars fiscalyear =fiscalyeartemp opdate=date.
insert file='//covenas/decisionsupport/meinzer/modules/datefy.sps'.
rename vars date=Opdate.
rename vars fiscalyear =OpdateFY closdate=date.
insert file='//covenas/decisionsupport/meinzer/modules/datefy.sps'.
rename vars fiscalyear =ClosdateFY date=closdate.
rename vars fiscalyeartemp=fiscalyear.

save outfile='//covenas/decisionsupport/temp/OATISListwithDX.sav'.

*pushbreak.
*sqlTable = 'OlderAdult_TISListwithDX' .   
*spsstable='//covenas/decisionsupport/temp/OATISListwithDX.sav'.
*pushbreak.

compute keepEpOlderAdult=1.
aggregate outfile='//covenas/decisionsupport/temp/OlderAdultTISUniquelist.sav'
   /break case
   /TISkeepEpOlderAdult=max(keepEpOlderAdult).

aggregate outfile='//covenas/decisionsupport/meinzer/temp/TISoaEndFY.sav'
   /break=ru TIS EndFY FiscalYear
   /TimeinService=sum(counter).

aggregate outfile=*
   /break fiscalyear
   /bogus=max(counter).

CASESTOVARS
/id=bogus.
*the next file is never used?  why.
save outfile="//covenas/decisionsupport/temp/oafytableTIS.sav".

get file='//covenas/decisionsupport/rutable.sav' /keep provname ru.
select if any(ru,OAkeepRU).
select if not ru = "01087" .

string TIS1 to TIS6 (a40).
do if  any(ru,OAkeepRU).
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
match files /table="//covenas/decisionsupport/temp/oafytable.sav"  /file=*  /by bogus.
string FiscalYear.x(a10).
compute FiscalYear.x="-99".

sort variables by name.
VARSTOCASES
/make FiscalYear from Fiscalyear.1 to FiscalYear.x.
select if not FiscalYear = "-99".

insert file='//covenas/decisionsupport/modules/uncookedmonth.sps'.
sort cases by ru tis fiscalyear.
match files /table='//covenas/decisionsupport/meinzer/temp/TISoaEndFY.sav' /file=* /by ru tis fiscalyear.

compute cookedmonth=datesum(uncookedmonth,-1,'days').

string FiscalYearcutCurrent (a10).
do if xdate.month(cookedmonth) lt 7.
compute FiscalYearcutCurrent=concat("FY ",substr(string(xdate.year(cookedmonth)-1,n4),3,2),"-",substr(string(xdate.year(cookedmonth),n4),3,2)).
else if xdate.month(cookedmonth) ge 7.
compute FiscalYearcutCurrent=concat("FY ",substr(string(xdate.year(cookedmonth),n4),3,2),"-",substr(string(xdate.year(cookedmonth)+1,n4),3,2)).
end if.

select if FiscalYear ne FiscalYearcutCurrent.
*select if not xdate.year(cookedmonth) = 2000+number(substr(fiscalyear,7,2),n4).

save outfile='//covenas/decisionsupport/meinzer/temp/OATISoaEndFYshell.sav'.

*get file='//covenas/decisionsupport/meinzer/temp/TISoaEndFY.sav'.
*if endfy ge opdate and endfy le closdate check=1.

get file='//covenas/decisionsupport/rutable.sav' /keep provname ru.
select if not ru = "01087" .
select if any(ru,OAkeepRU).
string LOS1 to LOS6 (a40).

do if any(ru,OAkeepRU).
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
match files  /table="//covenas/decisionsupport/temp/oafytable.sav"   /file=* /by bogus.
string FiscalYear.x(a10).
compute FiscalYear.x="-99".
sort variables by name.
VARSTOCASES
/make FiscalYear from Fiscalyear.1 to FiscalYear.x.
select if not FiscalYear = "-99".
sort cases by provname ru los fiscalyear.
match files /table='//covenas/decisionsupport/meinzer/temp/LOSoa.sav' /file=* /by provname ru los fiscalyear.

save outfile='//covenas/decisionsupport/meinzer/temp/OALOSShell.sav' /drop bogus. 

*pushbreak.
*sqlTable = 'OlderAdult_LOS'.   
*spsstable='//covenas/decisionsupport/meinzer/temp/OALOSShell.sav'.
*pushbreak.

**************************TIS this section calculates the current fy and adds it to old fys at the end.
get file='//covenas/decisionsupport/rutable.sav' /keep provname ru.
select if not ru = "01087" .

select if any(ru,OAkeepRU).
string TIS1 to TIS6 (a40).

do if  any(ru,OAkeepRU).
compute TIS1="1. 0-2 months".
compute TIS2="2. 3-5 months".
compute TIS3="3. 6-12 months".
compute TIS4="4. 13-24 months ".
compute TIS5="5. 25-36 months".
compute TIS6="6. 37 months or More".
end if.

VARSTOCASES
/make TIS from TIS1 to TIS6.
sort cases by provname ru tis .
match files /table='//covenas/decisionsupport/meinzer/temp/TISoa.sav' /file=* /by provname ru tis.
*add other fy's.
insert file='//covenas/decisionsupport/modules/uncookedmonth.sps'.
compute cookedmonth=datesum(uncookedmonth,-1,'days').
string FiscalYear (a10).
do if xdate.month(cookedmonth) lt 7.
compute FiscalYear=concat("FY ",substr(string(xdate.year(cookedmonth)-1,n4),3,2),"-",substr(string(xdate.year(cookedmonth),n4),3,2)).
else if xdate.month(cookedmonth) ge 7.
compute FiscalYear=concat("FY ",substr(string(xdate.year(cookedmonth),n4),3,2),"-",substr(string(xdate.year(cookedmonth)+1,n4),3,2)).
end if.
*OATISoaEndFYshell.sav has everthing except the current fy.
add files
/file=*
/file='//covenas/decisionsupport/meinzer/temp/OATISoaEndFYshell.sav'.

save outfile='//covenas/decisionsupport/meinzer/temp/OATISpastandpresentShell.sav'. 

*pushbreak.
*sqlTable = 'OlderAdult_TIS'.   
*spsstable='//covenas/decisionsupport/meinzer/temp/OATISpastandpresentShell.sav'. 
*pushbreak.

*client list.
get file='//covenas/decisionsupport/meinzer/temp/oalos.sav'.

sort cases by case.
match files /table ='//covenas/decisionsupport/temp/OlderAdultLOSUniquelist.sav' /file=* /by case.
match files /table ='//covenas/decisionsupport/temp/OlderAdultTISUniquelist.sav' /file=* /by case.
select if keepEpOlderAdult=1 or TISkeepEpOlderAdult=1.
match files/table='//covenas/decisionsupport/clinfoCG.sav'//file=* /by case/drop sex .
rename vars name = ClientName.
sort cases by staff.
match files /table='//covenas/decisionsupport/staff.sav' /file=* /by staff.
rename vars Name = StaffName.
sort cases by ru.
match files /file=* /table='//covenas/decisionsupport/rutable.sav' /by ru.
Sort cases by primdx.
rename vars primdx=dx.
match files /table='//covenas/decisionsupport/dxtable.sav' /file=* /by dx /keep agency provname lastservice staff  position StaffName sex bday ethnic langcod
ssn st_date end_date st_stat classif case ClientName CLIENT_STAMP birthName cin TISkeepEpOlderAdult
keepEpOlderAdult ru opdate closdate epflag PrimaryTherapist UnCookedMonth counter dx dx_descr LastService.
rename vars dx=primdx.
save outfile='//covenas/decisionsupport/meinzer/temp/OlderAdult_ClientListEps.sav'.

*pushbreak.
*sqlTable = 'OlderAdult_ClientList_Eps'.   
*spsstable='//covenas/decisionsupport/meinzer/temp/OlderAdult_ClientListEps.sav'.
*pushbreak.

get file='//covenas/decisionsupport/meinzer/temp/oasvcs.sav' /keep ru case opdate closdate proclong svcdate epflag PrimaryTherapist staff Agency provname UnCookedMonth.


sort cases by case.
match files /table ='//covenas/decisionsupport/temp/OlderAdultLOSUniquelist.sav' /file=* /by case.
match files /table ='//covenas/decisionsupport/temp/OlderAdultTISUniquelist.sav' /file=* /by case.
select if keepEpOlderAdult=1 or TISkeepEpOlderAdult=1.
match files/table='//covenas/spssdata/clinfo.sav'//file=* /by case/drop sex .
rename vars name = ClientName.
sort cases by staff.
match files /table='//covenas/decisionsupport/staff.sav' /file=* /by staff.
rename vars Name = StaffName.

save outfile='//covenas/decisionsupport/meinzer/temp/OlderAdult_ClientListSVC.sav'.

*pushbreak.
*sqlTable =  'OlderAdult_ClientListSVC'.   
*spsstable='//covenas/decisionsupport/meinzer/temp/OlderAdult_ClientListSVC.sav'.
*pushbreak.
