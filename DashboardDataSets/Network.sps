
GET DATA  /TYPE=TXT
  /FILE="//covenas/decisionsupport/Meinzer\Tables\networkContractUpdate.csv"
  /ENCODING='Locale'
  /DELCASE=LINE
  /DELIMITERS=","
  /ARRANGEMENT=DELIMITED
  /FIRSTCASE=2
  /IMPORTCASE=ALL
  /VARIABLES=
  V1 F3.0
  ru A6
  ProvnameNetwork A83
  FiscalYear A10
  Clients f8
  ClientsPerMonth F4.1
  CDDays F7.1
  @#CaseMgmtHrs F6.1
  @#MentalHealthHrs F7.1
  @#MedSupportHrs F7.1
  @#CrisisInterventionHrs F5.1
  OtherHours F7.1
  CDtotalhours F7.1
  V14 F6.1.
CACHE.
EXECUTE.



sort cases by ru fiscalyear.
match files /file=* /by ru fiscalyear /last=last.
select if last=1.
exe.
delete vars last v1.
 * select if ru ne 'nan' or ru ne ''.

*save outfile='//covenas/decisionsupport/networkcontract.sav'.

 * string test(a2).
 * compute test= substr(fiscalyear, 4,2).
 * compute testnum=number(concat('20',test),f4.0).
save outfile='//covenas/decisionsupport/networkcontract.sav' /keep ru provnameNetwork FiscalYear Clients ClientsPerMonth CDDays @#CaseMgmtHrs @#MentalHealthHrs
@#MedSupportHrs @#CrisisInterventionHrs OtherHours CDtotalhours.

*get file='//covenas/decisionsupport/networkcontract.sav'.

sort cases by ru fiscalyear.
varstocases
/make CD from @#CaseMgmtHrs to @#CrisisInterventionHrs
/index=CDcat.
select if CD ne 0.
string mcsvccat(a35).
if CDcat = 1 mcsvccat ='A. Case Management Services'.
if CDcat = 2 mcsvccat ='B. Mental Health Services'.
if CDcat = 3 mcsvccat ='C. Medication Support'.
if CDcat = 4 mcsvccat ='D. Crisis Intervention'.

vector month(6,f11).
compute month1=date.dmy(1,7,number(concat('20',substr(fiscalyear, 4,2)),f4.0)).
formats month1(date11).
compute #dateindex=1.
loop #count=1 to 5.
compute month(#dateindex+1) =datesum(month1,(#dateindex),"month","closest").
compute #dateindex= #dateindex+1.
end loop.
vector month2(6,f11).
compute month21=date.dmy(1,1,number(concat('20',substr(fiscalyear, 7,2)),f4.0)).
formats month21(date11).
compute #dateindex=1.
loop #count=1 to 5.
compute month2(#dateindex+1) =datesum(month21,(#dateindex),"month","closest").
compute #dateindex= #dateindex+1.
end loop.
varstocases
/make calendar from month1 to month26.
compute cost=0.

save outfile='//covenas/decisionsupport/networkshell.sav' /keep ru fiscalyear calendar mcsvccat cost .

get file='//covenas/decisionsupport/insystservicesallxx.sav'
   /keep ru case proced svcdate cost calendar duration svcmode.

 * save outfile='//covenas/decisionsupport/temp/tempnetwork.sav'.
*get file='//covenas/decisionsupport/temp/tempnetwork.sav'.
*select if xdate.tday(svcdate) ge yrmoda(2011,07,01).

add files
/file=*
/file='//covenas/decisionsupport/networkshell.sav'.

insert file='//covenas/decisionsupport/meinzer/modules/NoShow.sps'.

sort cases by ru.

match files /file=* /Table='//covenas/decisionsupport/ruTable.sav'/by ru
/keep mcsvccat ru provname case proced svcdate cost  duration calendar school ru2 level3Classic agency psMask2 kidsru county svcmode.

recode school(sysmis=0).

if ru2 ne '' ru=ru2.
if missing(svcdate) svcdate=calendar.
exe.
insert file='//covenas/decisionsupport/meinzer/modules/calsvcdate.sps'.
insert file='//covenas/decisionsupport/modules/uncookedmonth.sps'.
select if svcdate lt UncookedMonth.

*insert file='//covenas/decisionsupport/modules\duration.sps'.


 
 * recode level3classic(sysmis=0).
 * select if level3classic=0.

if level3Classic=1 Drop=1.
select if missing(Drop).

temp.
select if Agency = " ".
freq provname.

select if agency ne " ".

Insert file= '//covenas/decisionsupport/modules\RenameCountySites.sps'.

string RUProgram(a40).
compute RUProgram = concat(RU,"    ",rtrim(provname)).


sort cases by proced.

match files /Table='//covenas/decisionsupport/procedsma.sav' /file=*/by proced
/keep agency proclong provname RUProgram ru case svcdate school duration proced MCSvcCat unit cost svcMode psMask2 kidsru calendar.

 * temp.
 * select if MCsvcCat = " ".
 * freq proclong. 
if mcSvcCat = " " MCsvcCat = "z. Other".

insert file='//covenas/decisionsupport/meinzer/modules/calfiscalyear.sps'.

sort cases by FiscalYear agency case.
match files /file=* /by FiscalYear agency case /first=FYAgenCase1.
if missing(case) FYAGENCASE1=0.

sort cases by FiscalYear agency mcsvccat case.
match files /file=* /by FiscalYear agency mcsvccat case /first=FYAgenMCCase1.
if missing(case) FYAgenMCCase1=0.

sort cases by FiscalYear ru case.
match files /file=* /by FiscalYear ru case /first=FYRuCase1.
if missing(case) FYRuCase1=0.

sort cases by FiscalYear ru McSvcCat case.
match files /file=* /by FiscalYear ru McSvcCat case /first=FYRuMcSvcCatCase1.
if missing(case) FYRuMcSvcCatCase1=0.

sort cases by ru calendar case.
match files /file=* /by ru calendar case /first=RuCalCase1.
if missing(case) RuCalCase1=0.

sort cases by agency calendar case.
match files /file=* /by agency calendar case /first=AgenCalCase1.
if missing(case) AgenCalCase1=0.

sort cases by ru calendar McSvcCat case.
match files /file=* /by ru calendar McSvcCat case /first=RuCalMcSvcCatCase1.
if missing(case) RuCalMcSvcCatCase1=0.

if any(svcMode,"05","10") AND MCSvcCat ne "F. Crisis Stabilization" Day=1.

if day=1 Duration=$sysmis.

Aggregate outfile=*mode addvariables
   /break = FiscalYear ru    
   /TotalClients=Sum(FYruCase1)
   /TotalHours=Sum(duration)
   /TotalDays=sum(Day)
   /TotalCost=sum(Cost).

Aggregate outfile=*mode addvariables
   /break = FiscalYear agency    
   /TotalAgencyClients=Sum(FYagenCase1)
   /TotalAgencyHours=Sum(duration)
  /TotalAgencyDays=sum(Day)
	/TotalAgencyCost=sum(Cost).

Aggregate outfile=*mode addvariables
   /break = FiscalYear agency mcsvccat
   /TotalAgencyMCClients=Sum(FYagenMCCase1)
   /TotalAgencyMCHours=Sum(duration)
  /TotalAgencyMCDays=sum(Day)
	/TotalAgencyMCCost=sum(Cost).

Aggregate outfile=*mode addvariables
   /break = ru calendar 
   /TotalMonthClients=Sum(RuCalCase1)
   /TotalMonthHours=Sum(duration)
  /TotalMonthDays=sum(day)
	/TotalMonthCost=sum(Cost).

save outfile ='//covenas/decisionsupport/temp/NetworkAggWOrkx.sav'.

 * get file='//covenas/decisionsupport/temp\NetworkAggWOrkx.sav'.


if missing(cost) cost=0.
select if ru ne 'nan'.
*select if MCsvcCat = " ".
*freq proclong.
*display vars.

*freq proclong.

*fytotalsx is a file that is used in admits dc file.
Aggregate outfile= '//covenas/decisionsupport/temp/FYTotalsX.sav'
   /break= FiscalYear agency provname ru RUProgram psMask2 school kidsru TotalClients TotalHours TotalDays MCSvcCat TotalCost TotalAgencyClients TotalAgencyHours TotalAgencyDays TotalAgencyCost 
 TotalAgencyMCClients TotalAgencyMCHours TotalAgencyMCDays TotalAgencyMCCost 
   /ProcClients=sum(FYruMcSvcCatCase1)
   /ProcHours=sum(Duration)
   /ProcDays=sum(day)
   /ProcCost=sum(cost).

 *Select if FiscalYear = 'Fiscal Year 12-13 YTD(July-Oct)'.

*monthlytotals is used in admits dc file.
Aggregate outfile= '//covenas/decisionsupport/temp/MonthlyTotals.sav'
   /break=ru Calendar agency provname  RUProgram psMask2 kidsru  school TotalMonthClients TotalMonthHours TotalMonthDays MCSvcCat TotalMonthCost FiscalYear  TotalClients TotalHours TotalDays TotalCost
   /ProcClients=sum(RuCalMcSvcCatCase1)
   /ProcHours=sum(Duration)
   /ProcDays=sum(day)
   /ProcCost=sum(cost).


***********************************************************************************.
***********************************************************************************.

get file=  '//covenas/decisionsupport/temp/MonthlyTotals.sav'.
*this file is also used in networkadmitsandDC.sps.
sort cases by ru.
match files /file=* /table='//covenas/decisionsupport/networkcontract.sav' /by ru fiscalyear.

insert file='//covenas/decisionsupport/modules/uncookedmonth.sps'.

if (not missing(CDtotalhours) or cdtotalhours > 0) and missing(TotalHours) TotalHours=0.
if (not missing(CDDays) or CDDays > 0) and missing(TotalDays) TotalDays=0.
if (not missing(CDtotalhours) or cdtotalhours > 0) and missing(TotalmonthHours) TotalmonthHours=0.
if (not missing(CDDays) or CDDays > 0) and missing(TotalMonthDays) TotalMonthDays=0.



string CookedFiscalYear(a10).
do if xdate.month(uncookedmonth)-1 lt 7.
compute Cookedfiscalyear=concat("FY ",substr(string(xdate.year(uncookedmonth)-1,n4),3,2),"-",substr(string(xdate.year(uncookedmonth),n4),3,2)).
else if xdate.month(uncookedmonth)-1 ge 7.
compute Cookedfiscalyear=concat("FY ",substr(string(xdate.year(uncookedmonth),n4),3,2),"-",substr(string(xdate.year(uncookedmonth)+1,n4),3,2)).
end if.


do if xdate.month(calendar) gt 6 .
compute MonthPercent=(xdate.month(calendar)-6)/12.
else.
compute MonthPercent=(xdate.month(calendar)+6)/12.
end if.


do if xdate.month(UnCookedMonth)-1 gt 6 and FiscalYear=CookedFiscalYear.
compute FYPercent=(xdate.month(UnCookedMonth)-7)/12.
else if xdate.month(UnCookedMonth)-1 le 6 and FiscalYear=CookedFiscalYear.
compute FYPercent=(xdate.month(UnCookedMonth)+5)/12.
else.
compute FYPercent=1.
end if.

compute CDCaseManageAdjust = @#CaseMgmtHrs/12.
if mcsvccat="A. Case Management Services" cdCaseManagePercentAdjGoal = prochours/CDCaseManageAdjust.

compute CDMentalHealthHrsAdjust = @#MentalHealthHrs/12.
if mcsvccat="B. Mental Health Services" cdMentalHealthHrsPercentAdjGoal = prochours/CDMentalHealthHrsAdjust.

compute CDMedSupportHrsAdjust = @#MedSupportHrs/12.
if mcsvccat="C. Medication Support" cdMedSupportHrsPercentAdjGoal = prochours/CDMedSupportHrsAdjust.

compute CDCrisisInterventionHrsAdjust = @#CrisisInterventionHrs/12.
if mcsvccat="D. Crisis Intervention" cdCrisisInterventionHrsPercentAdjGoal = prochours/CDCrisisInterventionHrsAdjust.

compute CDHoursAdjust = CDtotalhours/12.
compute cdHoursPercentAdjGoal = TotalMonthHours/CDHoursAdjust.

compute CDDaysAdjust = CDDays/12.
compute cdDaysPercentAdjGoal = TotalMonthDays/CDDaysAdjust.

if totalmonthhours = 0 and cdtotalhours > 0 cdHoursPercentAdjGoal=0.
if totalmonthdays = 0 and cddays > 0 cdDaysPercentAdjGoal=0.

 * compute CDOtherAdjust = OtherHours/12.
 * compute cdOtherPercentAdjGoal = totalhours/CDOtherAdjust.

RENAME VARIABLES
Clients =cdClients
ClientsPerMonth =cdClientsPerMonth
@#CaseMgmtHrs =cdCaseMgmtHrs
@#MentalHealthHrs =cdMentalHealthHrs
@#MedSupportHrs =cdMedSupportHrs
@#CrisisInterventionHrs =cdCrisisInterventionHrs
OtherHours =cdOtherHours.

if not missing(cdCaseManagePercentAdjGoal) PercentAdjGoalCat=cdCaseManagePercentAdjGoal.
if not missing(cdMentalHealthHrsPercentAdjGoal) PercentAdjGoalCat=cdMentalHealthHrsPercentAdjGoal.
if not missing(cdMedSupportHrsPercentAdjGoal) PercentAdjGoalCat=cdMedSupportHrsPercentAdjGoal.
if not missing(cdCrisisInterventionHrsPercentAdjGoal) PercentAdjGoalCat=cdCrisisInterventionHrsPercentAdjGoal.
 * if not missing(cdHoursPercentAdjGoal) PercentAdjGoal=cdHoursPercentAdjGoal.
 * if not missing(cdDaysPercentAdjGoal) PercentAdjGoal=cdDaysPercentAdjGoal.
 * if not missing(cdOtherPercentAdjGoal) PercentAdjGoal=cdOtherPercentAdjGoal.

if not missing(cdDaysPercentAdjGoal) PercentAdjGoalDuration=cdDaysPercentAdjGoal.
if not missing(cdHoursPercentAdjGoal) PercentAdjGoalDuration=cdHoursPercentAdjGoal.

if mcsvccat="A. Case Management Services" CDCat=cdCaseMgmtHrs.
if mcsvccat="B. Mental Health Services" CDCat=cdMentalHealthHrs.
if mcsvccat="C. Medication Support" CDCat=cdMedSupportHrs.
if mcsvccat="D. Crisis Intervention" CDCat=cdCrisisInterventionHrs.
if (not missing(CDCat) or CDcat > 0) and missing(prochours) prochours = 0.
if (not missing(CDCat) or CDcat > 0) and prochours =0 PercentAdjGoalCat=0.

compute MonthlyCDCat=CDCAT/12.
compute CDPercentClients = TotalClients/cdClients.

*if mcsvccat='z. Other' .

*add month .
*school from ru recode sysmis0 
*client percent.

do if xdate.month(calendar) gt 6 .
compute Month=(xdate.month(calendar)-6).
else.
compute Month=(xdate.month(calendar)+6).
end if.



*COLORS - ru Monthly.
 * RED = SIGNIFICANTLY UNDER TARGET - Less than 60% of expected monthly units
YELLOW = SLIGHTLY UNDER TARGET - 60%-80% of expected monthly units
YELLOW = OVER TARGET - More than 120% of expected monthly units
GREEN = NEAR TARGET - Between 80%-120% of expected monthly units.
*No highlighting for school RUs in June, July, or August.

String MonthlyUnitsColor(a10). 
Do if school=0.
If PercentAdjGoalDuration lt .6 MonthlyUnitsColor='Red'.
If PercentAdjGoalDuration ge .6 and  PercentAdjGoalDuration lt .8 MonthlyUnitsColor='Yellow'.
If PercentAdjGoalDuration gt 1.2 MonthlyUnitsColor='Yellow'.
If PercentAdjGoalDuration ge .8 and  PercentAdjGoalDuration le 1.2 MonthlyUnitsColor='Green'.
End if.

Do if school=1 and any(month, 3, 4, 5, 6, 7, 8, 9, 10, 11).
If PercentAdjGoalDuration lt .6 MonthlyUnitsColor='Red'.
If PercentAdjGoalDuration ge .6 and  PercentAdjGoalDuration lt .8 MonthlyUnitsColor='Yellow'.
If PercentAdjGoalDuration gt 1.2 MonthlyUnitsColor='Yellow'.
If PercentAdjGoalDuration ge .8 and  PercentAdjGoalDuration le 1.2 MonthlyUnitsColor='Green'.
End if.

*COLORS - ru Monthly SvcCat.
*RED = Monthly medication support units less than 60% of expected
*School RUs do not have highlighting in June July or August.

String MonthlySvcCatColor(a10). 
Do if school=0 and MCSvcCat= 'C. Medication Support'.
if PercentAdjGoalCat lt .6 MonthlySvcCatColor='Red'.
End if.

Do if school=1 and any(month, 3, 4, 5, 6, 7, 8, 9, 10, 11) and MCSvcCat= 'C. Medication Support'.
if PercentAdjGoalCat lt .6 MonthlySvcCatColor='Red'.
End if.

save outfile='//covenas/decisionsupport/meinzer/temp/xfile.sav'.

*pushbreak.

*sqlTable = 'NetworkOfficeMonthlyTotals'.
*spsstable='//covenas/decisionsupport/meinzer/temp/xfile.sav'.
*pushbreak.

get file=  '//covenas/decisionsupport/temp/FYTotalsX.sav'.

insert file='//covenas/decisionsupport/modules/uncookedmonth.sps'.

sort cases by ru.
match files /file=* /table='//covenas/decisionsupport/networkcontract.sav' /by ru fiscalyear.

if (not missing(CDtotalhours) or cdtotalhours > 0) and missing(TotalHours) TotalHours=0.
if (not missing(CDDays) or CDDays > 0) and missing(TotalDays) TotalDays=0.

string CookedFiscalYear(a10).
do if xdate.month(uncookedmonth)-1 lt 7.
compute Cookedfiscalyear=concat("FY ",substr(string(xdate.year(uncookedmonth)-1,n4),3,2),"-",substr(string(xdate.year(uncookedmonth),n4),3,2)).
else if xdate.month(uncookedmonth)-1 ge 7.
compute Cookedfiscalyear=concat("FY ",substr(string(xdate.year(uncookedmonth),n4),3,2),"-",substr(string(xdate.year(uncookedmonth)+1,n4),3,2)).
end if.


do if xdate.month(UnCookedMonth)-1 gt 6 and FiscalYear=CookedFiscalYear.
compute FYPercent=(xdate.month(UnCookedMonth)-7)/12.
else if xdate.month(UnCookedMonth)-1 le 6 and FiscalYear=CookedFiscalYear.
compute FYPercent=(xdate.month(UnCookedMonth)+5)/12.
else.
compute FYPercent=1.
end if.

compute CDCaseManageAdjust = @#CaseMgmtHrs*fypercent.
if mcsvccat="A. Case Management Services" cdCaseManagePercentAdjGoal = prochours/CDCaseManageAdjust.

compute CDMentalHealthHrsAdjust = @#MentalHealthHrs*fypercent.
if mcsvccat="B. Mental Health Services" cdMentalHealthHrsPercentAdjGoal = prochours/CDMentalHealthHrsAdjust.

compute CDMedSupportHrsAdjust = @#MedSupportHrs*fypercent.
if mcsvccat="C. Medication Support" cdMedSupportHrsPercentAdjGoal = prochours/CDMedSupportHrsAdjust.

compute CDCrisisInterventionHrsAdjust = @#CrisisInterventionHrs*fypercent.
if mcsvccat="D. Crisis Intervention" cdCrisisInterventionHrsPercentAdjGoal = prochours/CDCrisisInterventionHrsAdjust.

compute CDHoursAdjust = CDtotalhours*fypercent.
compute cdHoursPercentAdjGoal = totalhours/CDHoursAdjust.

compute CDDaysAdjust = CDDays*fypercent.
compute cdDaysPercentAdjGoal = totaldays/CDDaysAdjust.

 * compute CDOtherAdjust = OtherHours*MonthPercent.
 * compute cdOtherPercentAdjGoal = totalhours/CDOtherAdjust.

RENAME VARIABLES
Clients =cdClients
ClientsPerMonth =cdClientsPerMonth
@#CaseMgmtHrs =cdCaseMgmtHrs
@#MentalHealthHrs =cdMentalHealthHrs
@#MedSupportHrs =cdMedSupportHrs
@#CrisisInterventionHrs =cdCrisisInterventionHrs
OtherHours =cdOtherHours.

if not missing(cdCaseManagePercentAdjGoal) PercentAdjGoalCat=cdCaseManagePercentAdjGoal.
if not missing(cdMentalHealthHrsPercentAdjGoal) PercentAdjGoalCat=cdMentalHealthHrsPercentAdjGoal.
if not missing(cdMedSupportHrsPercentAdjGoal) PercentAdjGoalCat=cdMedSupportHrsPercentAdjGoal.
if not missing(cdCrisisInterventionHrsPercentAdjGoal) PercentAdjGoalCat=cdCrisisInterventionHrsPercentAdjGoal.
 * if not missing(cdHoursPercentAdjGoal) PercentAdjGoal=cdHoursPercentAdjGoal.
 * if not missing(cdDaysPercentAdjGoal) PercentAdjGoal=cdDaysPercentAdjGoal.
 * if not missing(cdOtherPercentAdjGoal) PercentAdjGoal=cdOtherPercentAdjGoal.

if not missing(cdDaysPercentAdjGoal) PercentAdjGoalDuration=cdDaysPercentAdjGoal.
if not missing(cdHoursPercentAdjGoal) PercentAdjGoalDuration=cdHoursPercentAdjGoal.
 * if totalhours = 0 and cdtotalhours > 0 cdHoursPercentAdjGoal=0.
 * if totaldays = 0 and cddays > 0 cdDaysPercentAdjGoal=0.

if mcsvccat="A. Case Management Services" CDCat=cdCaseMgmtHrs.
if mcsvccat="B. Mental Health Services" CDCat=cdMentalHealthHrs.
if mcsvccat="C. Medication Support" CDCat=cdMedSupportHrs.
if mcsvccat="D. Crisis Intervention" CDCat=cdCrisisInterventionHrs.
*if mcsvccat='z. Other' .
if (not missing(CDCat) or CDcat > 0) and missing(prochours) prochours = 0.
if (not missing(CDCat) or CDcat > 0) and prochours =0 PercentAdjGoalCat=0.

compute CDPercentClients = TotalClients/cdClients.

do if xdate.year(datesum(uncookedmonth,-1,'months')) = number(concat('20',substr(fiscalyear,4,2)),f4.0).
  do if xdate.month(datesum(uncookedmonth,-1,'months')) gt 6 .
  compute Month=(xdate.month(datesum(uncookedmonth,-1,'months'))-6).
  ELSE.
  compute Month=(xdate.month(datesum(uncookedmonth,-1,'months'))+6).
  end if.
ELSE.
compute month=12.
end if.

*COLORS - ru FY.
*UNITS*.
*RED = SIGNIFICANTLY UNDER TARGET - Less than 60% of expected FY Units
YELLOW = SLIGHTLY UNDER TARGET - 60%-80% of expected FY Units
YELLOW = OVER TARGET - More than 120% of expected FY Units
GREEN = NEAR TARGET - Between 80%-120% of expected FY Units.

 * CLIENTS**.
 * RED = SIGNIFICANTLY UNDER TARGET - Less than 60% of FY contract number
YELLOW = SLIGHTLY UNDER TARGET - 60%-80% of FY contract number
YELLOW = OVER TARGET - More than 120% of FY contract number
GREEN = NEAR TARGET - Between 80%-120% of FY contract number.

*No highlighting for school RUs until after quarter 1.
**No highlighting for any RUs until after quarter 1.

String FYUnitsColor(a10). 
Do if school=0.
If PercentAdjGoalDuration lt .6 FYUnitsColor='Red'.
If PercentAdjGoalDuration ge .6 and  PercentAdjGoalDuration lt .8 FYUnitsColor='Yellow'.
If PercentAdjGoalDuration gt 1.2 FYUnitsColor='Yellow'.
If PercentAdjGoalDuration ge .8 and  PercentAdjGoalDuration le 1.2 FYUnitsColor='Green'.
End if.

Do if school=1 and MONTH ge 3.
If PercentAdjGoalDuration lt .6 FYUnitsColor='Red'.
If PercentAdjGoalDuration ge .6 and  PercentAdjGoalDuration lt .8 FYUnitsColor='Yellow'.
If PercentAdjGoalDuration gt 1.2 FYUnitsColor='Yellow'.
If PercentAdjGoalDuration ge .8 and  PercentAdjGoalDuration le 1.2 FYUnitsColor='Green'.
End if.

String FYClientColor(a10). 
Do if MONTH ge 3.
If CDPercentClients lt .6 FYClientColor='Red'.
If CDPercentClients ge .6 and  CDPercentClients lt .8 FYClientColor='Yellow'.
If CDPercentClients gt 1.2 FYClientColor='Yellow'.
If CDPercentClients ge .8 and  CDPercentClients le 1.2 FYClientColor='Green'.
End if.

*COLORS - ru Monthly SvcCat.
*RED = Monthly medication support units less than 60% of expected
*School RUs do not have highlighting in June July or August.

String FYSvcCatColor(a10). 
Do if school=0 and MCSvcCat= 'C. Medication Support'.
if PercentAdjGoalCat lt .6 FYSvcCatColor='Red'.
End if.

Do if school=1 and month ge 3 and MCSvcCat= 'C. Medication Support'.
if PercentAdjGoalCat lt .6 FYSvcCatColor='Red'.
End if.

Compute PctClientsSvcCat = ProcClients/TotalClients.
recode PctClientsSvcCat(sysmis=0). 

save outfile='//covenas/decisionsupport/meinzer/temp/yxfile.sav'.


*pushbreak.

*sqlTable='NetworkOfficeFYTotals'.
*spssTable=//covenas/decisionsupport/meinzer/temp/yxfile.sav'.
*pushbreak.

*network admit dc .

get file='//covenas/decisionsupport/dbsvc.sav'   
/keep agency provname ru case opdate closdate svcdate county kidsru.
 * get file='//covenas/decisionsupport/insystservicesallxx.sav'
   /keep ru case opdate closdate svcdate.

 * sort cases by ru.
 * match files /table='//covenas/decisionsupport/rutable.sav' /file=* /by ru /keep agency provname ru case opdate closdate svcdate county kidsru.


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

*sqlTable='NetworkFYRUsA&D'.
*spssTable='//covenas/decisionsupport/meinzer/temp/NetworkFYRUsAx.sav'.
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

*sqlTable='NetworkCalRUsA&D'.
*spssTable='//covenas/decisionsupport/meinzer/temp/NetworkCalRUsA.sav'.
*pushbreak.

get file ='//covenas/decisionsupport/temp/NetworkAggWOrkx.sav'.

Sort cases by ru fiscalyear proced case. 
match files /file=* /by ru fiscalyear proced case /first= RuFyProcedCase1.

Aggregate outfile = * mode=addvariables
   /Break=ru fiscalyear
   /FyRuClients = sum(fyrucase1)
   /FyRuHours = sum(duration)
   /FyRuDays=sum(day).

Aggregate outfile =*
   /Break = Agency Provname ru fiscalyear MCSvcCat proced proclong FyRuHours FyRuClients FyRuDays
   /ProcedClients = sum(RuFyProcedCase1)
   /ProcedHours=Sum(duration)
   /ProcedCharges=sum(cost)
   /ProcedDays=sum(day).

Compute PctOfHours = ProcedHours/FyRuHours.
Compute PctOfClients = ProcedClients/FyRuClients.

Rename variables proced = ProcedCode.
Rename variables Proclong = Procedure.

recode procedcode(sysmis=0).
select if procedcode gt 0. 
   
save outfile = '//covenas/decisionsupport/meinzer/temp/NetworkFyProclong.sav'.


*pushbreak.

*sqlTable='NetworkFyProclong'.
*spssTable='//covenas/decisionsupport/meinzer/temp/NetworkFyProclong.sav'.
*pushbreak.
