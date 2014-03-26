 * DEFINE DBstartdate() date.dmy(1,7,2012) !ENDDEFINE.

 * insert file='//covenas/decisionsupport/meinzer/modules/aodsvcepcreate.sps'.



DEFINE DBstartdate() date.dmy(1,7,2012) !ENDDEFINE.

get file="//covenas/decisionsupport/aoddbsvc.sav".

select if xdate.tday(svcdate) ge yrmoda(2011,07,01).

* The NoShow module is for MH.
* insert file='//covenas/decisionsupport/modules/noshow.sps'.

sort cases by proced.
match files /file=* /table='//covenas/spssdata/aodprocedsma.sav' /by proced.
freq service
svc_long.


sort cases by ru case opdate.

match files /table='//covenas/spssdata/aodruTable.sav'/file=* /by ru .
freq modality.
match files /table='//covenas/spssdata/aodruTable.sav'/file=* /by ru.
freq modality.

select if Agency ne ''.

*this file is aod eps 2011 to current.  
*feel free to use it in other places if you want to get file it.

insert file='//covenas/decisionsupport/meinzer/modules/calsvcdate.sps'.
insert file='//covenas/decisionsupport/modules/uncookedmonth.sps'.
select if svcdate lt UncookedMonth.

insert file='//covenas/decisionsupport/modules\duration.sps'.

string RUProgram(a40).
***** Use Provname2 instead *****.
***** compute RUProgram = concat(RU,"    ",rtrim(provname)).
compute RUProgram = concat(RU,"    ",rtrim(provname)).
freq modality.
***** Kim to fix missing modality *****.
if modality = " " modality = "z. Other".

insert file='//covenas/decisionsupport/meinzer/modules/calfiscalyear.sps'.

select if proced ne 300. 
select if proced ne 301.
select if proced ne 701.
select if proced ne 709.
select if proced ne 303.
select if proced ne 787.

*NOT SURE if we should include this code from the Budget Rpt to exclude perinatal/SACPA.
 * string division(a8).
 * compute division="general".
 * do if substr(ru,6,1)="S".
 * compute division="prop36".
 * end if.
 * select if division ne "prop36".
*this (above) excludes SACPA.

*Modality code from AOD Budget Reprot .
 * IF MODALITY="DayTx" MODALITY="B DAY TX".
 * IF MODALITY="Opiod" MODALITY="E METHADONE MAINT".
 * IF MODALITY="Opiod Detox" MODALITY="F METHADONE DETOX".
 * IF MODALITY="Outpatient" MODALITY="C OUT PT".
 * IF MODALITY="Residential" MODALITY="A RESIDENTIAL".
 * IF MODALITY="Residential Detox" MODALITY="H RESIDENTIAL DETOX".
IF MODALITY="SLE/TL" MODALITY="Transitional Living".
*IF MODALITY="Sobering" MODALITY="G SOBERING".
freq modality provname ru.
***** Missing Modality provname ru -- temp sav for Kim to help *****.
save outfile='//covenas/spssdata/temp\AODNetworkReport_MissingModality.sav'.

get file='//covenas/spssdata/temp\AODNetworkReport_MissingModality.sav'.

sort cases by FiscalYear agency case.
match files /file=* /by FiscalYear agency case /first=FYAgenCase1.

sort cases by FiscalYear agency modality case.
match files /file=* /by FiscalYear agency modality case /first=FYAgenMCCase1.

sort cases by FiscalYear ru case.
match files /file=* /by FiscalYear ru case /first=FYruCase1.

sort cases by FiscalYear ru modality case.
match files /file=* /by FiscalYear ru modality case /first=FYrumodalityCase1.

sort cases by ru calendar case.
match files /file=* /by ru calendar case /first=ruCalCase1.

sort cases by agency calendar case.
match files /file=* /by agency calendar case /first=AgenCalCase1.

sort cases by ru calendar modality case.
match files /file=* /by ru calendar modality case /first=ruCalmodalityCase1.

*this line doesn't do anything, but do we want somethign like it?.
if any(svcMode,"05","10") AND modality ne "F. Crisis Stabilization" Day=1.

if day=1 Duration=$sysmis.

Aggregate outfile=*mode addvariables
   /break = FiscalYear ru    
   /FYruClients=Sum(FYruCase1)
   /FYruhours=Sum(duration)
   /FYrudays=sum(Day)
   /FYrucost=sum(Cost).

Aggregate outfile=*mode addvariables
   /break = FiscalYear agency    
   /FYAgencyClients=Sum(FYagenCase1)
   /FYAgencyHours=Sum(duration)
  /FYAgencyDays=sum(Day)
	/FYAgencyCost=sum(Cost).

Aggregate outfile=*mode addvariables
   /break = FiscalYear agency modality
   /FYAgencyModalityClients=Sum(FYagenMCCase1)
   /FYAgencyModalityHours=Sum(duration)
  /FYAgencyModalityDays=sum(Day)
	/FYAgencyModalityCost=sum(Cost).

Aggregate outfile=*mode addvariables
   /break = ru calendar 
   /CalRUClients=Sum(ruCalCase1)
   /CalRUHours=Sum(duration)
  /CalRUDays=sum(day)
	/CalRUCost=sum(Cost).

save outfile ='//covenas/decisionsupport/temp\AODNetworkAggWOrk.sav'.
get file ='//covenas/decisionsupport/temp\AODNetworkAggWOrk.sav'.

Aggregate outfile= '//covenas/decisionsupport/temp/AODFYTotalsbyRU.sav'
   /break= FiscalYear agency provname ru RUProgram  FYruClients FYruhours FYrudays modality FYrucost FYAgencyClients FYAgencyHours FYAgencyDays FYAgencyCost 
 FYAgencyModalityClients FYAgencyModalityHours FYAgencyModalityDays FYAgencyModalityCost
   /FYModalityClients=sum(FYrumodalityCase1)
   /FYModalityHours=sum(Duration)
   /FYModalityDays=sum(day)
   /FYModalityCost=sum(cost).

Aggregate outfile= '//covenas/decisionsupport/temp/AODMonthlyTotalsByRU.sav'
   /break=ru Calendar agency provname  RUProgram   CalRUClients CalRUHours CalRUDays modality CalRUCost FiscalYear  FYruClients FYruhours FYrudays FYrucost
   /CALModalityClients=sum(ruCalmodalityCase1)
   /CALModalityHours=sum(Duration)
   /CALModalityDays=sum(day)
   /CALModalityCost=sum(cost).

*the following section will be for contract goals.


get file= '//covenas/decisionsupport/temp/AODMonthlyTotalsByRU.sav'.
*this file is also used in networkadmitsandDC.sps.
*sort cases FiscalYear agency provname.

*This is where we put in the contract goals.
*match files table='//covenas/decisionsupport/meinzer/tables\contractProbCSOC.sav'/file=*/by  FiscalYear agency provname.
 * compute PercentMonthHoursGoal =  TotalMonthHours/(CalHoursContract).
 * compute PercentMonthDaysGoal = TotalMonthDays/(CalDaysContract).
 * compute PercentMonthCostGoal = TotalMonthCost/(CalCapContract).

save outfile='//covenas/decisionsupport/meinzer/temp/AODMonthlyTotalsByRUWithContract.sav'.

*pushbreak.
*sqlTable = 'AODNetworkOfficeMonthlyTotals'.
*spsstable='//covenas/decisionsupport/meinzer/temp/AODMonthlyTotalsByRUWithContract.sav'.
*pushbreak.


get file= '//covenas/decisionsupport/temp/AODFYTotalsbyRU.sav'.
*sort cases by FiscalYear agency provname.
*This is where we put in the contract goals.
*match files table='//covenas/decisionsupport/meinzer/tables\contractProbCSOC.sav'/file=*/by  FiscalYear agency provname.

if xdate.mday($time) le 15 UncookedMonth = DateSum($time,-1,"months").
if xdate.mday($time) gt 15 UncookedMonth = DateSum($time,0,"months").
compute UncookedMonth =date.moyr(xdate.month(UncookedMonth), xdate.year(UncookedMonth)).
formats UncookedMonth(moyr6).
do if xdate.month(UncookedMonth) gt 6.
compute FYPercent=(xdate.month(UncookedMonth-1)-6)/12.
else.
compute FYPercent=(xdate.month(UncookedMonth-1)+6)/12.
end if.

string FYCurrent(a10).
if xdate.tday($time) lt yrmoda(2012,07,01) FYCurrent='FY 11-12'.
if xdate.tday($time) ge yrmoda(2012,07,01) FYCurrent='FY 12-13'.
if xdate.tday($time) ge yrmoda(2013,07,01) FYCurrent='FY 13-14'.

 * do if FyCurrent = Fiscalyear.
 * compute PercentYTDClientGoal =  TotalClients/(FYClientsContract*fypercent).
 * compute PercentYTDTotalHoursGoal = TotalHours/(fyhourscontract*fypercent).
 * compute PercentYTDTotalDaysGoal = TotalDays/(fydayscontract*fypercent).
 * compute PercentYTDTotalChargesGoal = TotalCost/(FYProgramCapContract*fypercent).
 * else.
 * compute PercentYTDClientGoal =  TotalClients/(FYClientsContract).
 * compute PercentYTDTotalHoursGoal = TotalHours/(fyhourscontract).
 * compute PercentYTDTotalDaysGoal = TotalDays/(fydayscontract).
 * compute PercentYTDTotalChargesGoal = TotalCost/(FYProgramCapContract).
 * end if.

compute createDate = $time.
formats createDate(datetime17).


save outfile='//covenas/decisionsupport/meinzer/temp/AODFYTotalsbyRUWithContract.sav'.

*pushbreak.
*sqlTable  = 'AODNetworkOfficeFYTotals'.
*spsstable='//covenas/decisionsupport/meinzer/temp/AODFYTotalsbyRUWithContract.sav'.
*pushbreak.





