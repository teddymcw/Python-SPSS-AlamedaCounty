*removed lst_Svc and PrimDX and EpFlag b/c the adjusted episodes need finesse to fix those.
DEFINE 
StartDateGC() date.dmy(1,1,2011) 
!ENDDEFINE.

get file='//covenas/decisionsupport/epsCG.sav' / keep ru case opdate closDate primdx.

match files /table='//covenas/decisionsupport/ruTable.sav '/file=* /by ru/keep agency ru case opdate closDate psmask2 Provname primdx.
select if  agency = "Guidance Clinic"  and ru ne "01193".


if Missing(closdate) closdate=date.dmy(01,01,2020).
compute counter=1.

aggregate outfile=* mode=addVars /break=Case /admits=sum(counter).

sort cases by case opdate.
execute.
do if lag(case) = case.
compute CloseDatePrevious=lag(closdate).
end if.

sort cases by case opdate.
exe.
do if  case=lag(case).
do if closdate lt closedateprevious.
compute closdate=closedateprevious.
end if.
end if.

sort cases by case opdate.
execute.
do if lag(case) = case.
compute CloseDatePrevious=lag(closdate).
end if.
formats closedateprevious opdate  (date11).

sort cases by admits(d) case opdate.
compute overlap = xdate.tday(opdate) - xdate.tday(closedateprevious).
exe.

do if case=lag(case).
do if overlap lt 4.
compute opdate=lag(opdate).
end if.
end if.


aggregate outfile=* mode=addvariables overwrite=yes
   /break=case opdate
   /closdate=max(closdate).

sort cases by case opdate.
match files/file=* /by case opdate/first=ep1.

select if ep1=1.

match files/file=* /drop ep1 admits closeDatePrevious.

insert file='//covenas/decisionsupport/modules\UncookedMonth.sps'.

if closdate=date.dmy(1,1,2020) closdate=$sysmis.

select if opdate lt UnCookedMonth and (Closdate ge StartDateGC or sysmis(closdate)).

match files /table='//covenas/decisionsupport/temp/Globteamep.sav' /file=* /by case.
formats teamclosedatex teamclosedate.1 teamopdate.1(f30).
*get  file='//covenas/decisionsupport/meinzer/temp/Globteamep.sav'.

*555 needed as placeholder for hosp eps without team.
recode teamopdate.1(sysmis=555).
exe.
VARSTOCASES
/make TeamOpdate from teamopdate.1 to teamopdatex
/make teamclosedate from teamclosedate.1 to teamclosedatex.

*gets rid of nth record which was signified by the 99 value.
select if teamopdate ne 99.

if teamOpdate ne 555 AND missing(teamclosedate) teamclosedate=date.moyr(1,2080).
if missing(closdate) closdate=date.moyr(1,2080).

recode teamopdate(555=sysmis).

if teamopdate le opdate and teamclosedate ge opdate SvcTeamClient=1.
*teamop and teamclos do not appear after this line.

if closdate=date.moyr(1,2080) closdate=$sysmis.

compute calendar = date.moyr(xdate.month(closdate), xdate.year(closdate)).
formats calendar (moyr6).

sort cases by case calendar.
match files/table='//covenas/decisionsupport/MEdicalTable.sav' /file=* /by Case calendar.

if full=1 AND inMedsTable=1 HasMediCal=1.
aggregate outfile=* 
   /break= ru case opdate closdate hasmedical  calendar  provname primdx
   /SvcTeamClient=max(SvcTeamClient).

sort cases by case opdate(d).
execute.
do if lag(case) = case.
compute OpDateNext=lag(opdate).
end if.
FORMATS OpDateNext(date11).
*if opDateNext=0 OpDateNext = date.dmy(01,01,2020).
 
sort cases by case opdate.
execute.
do if lag(case) = case.
compute OpDatePrevious=lag(opdate).
end if.
FORMATS OpDatePrevious(date11).
recode opDateNext OpDatePrevious(sysmis=0).
formats case(f8.0).

rename variables primDx=Dx.
sort cases by dx.
match files/table='//covenas/decisionsupport/dx_Table2.sav'/file=* /by dx /drop SPMI potSpMI dx_grpadult.
*childhood other dxtablechild?.

sort cases by case.
match files/table='//covenas/decisionsupport/clinfoCG.sav' /file=* /by case /drop name ssn CLIENT_STAMP birthName cin.
save outfile='//covenas/decisionsupport/temp\GuidanceClinicALLkids.sav' .

get file='//covenas/decisionsupport/temp\GuidanceClinicALLkids.sav'.

if opdateNext = 0 OpDateNext = date.dmy(01,01,2020).

compute AdmitAge = Trunc((xdate.tday(Opdate) - xdate.tday(bday))/365.25).
*select if admitAge lt 18.

string AgeGroup(a15).
compute ageGroup = "a. 0-5".
if AdmitAge ge 6 ageGroup = "b. 6-11".
if AdmitAge ge 12 ageGroup = "c. 12-17".

rename variables opdate=HospOpDate.
rename variables provname=HospProvname.
rename variables ClosDate= HospCloseDate.
rename vars ru=hospru.

save outfile='//covenas/decisionsupport/temp/GuidHospepx.sav'.
 * get file='//covenas/decisionsupport/temp/GuidHospepx.sav'.

*GO Start 12-30-13.
get file='//covenas/decisionsupport/epsCG.sav' /keep ru case opdate closDate.
match files /table='//covenas/decisionsupport/ruTable.sav '/file=* /by ru/keep agency ru case opdate closDate.
select if  agency = "Guidance Clinic"  and any(ru, "01194", "01195").
Compute NotFlwUpEligLastRU=1.
rename variables ClosDate= HospCloseDate.
sort cases by case HospCloseDate. 
aggregate outfile = '//covenas/decisionsupport/Orozco/Temp/GuidanceNotFlwUpEligRUs.sav'
   /Break case HospCloseDate
   /NotFlwUpEligLastRU = max(NotFlwUpEligLastRU).

get file = '//covenas/decisionsupport/temp/GuidHospepx.sav'.
sort cases by case HospCloseDate. 
match files /table=  '//covenas/decisionsupport/Orozco/Temp/GuidanceNotFlwUpEligRUs.sav' /file=* /by case HospCloseDate.
recode NotFlwUpEligLastRU(sysmis=0).
select if NotFlwUpEligLastRU=0.

save outfile = '//covenas/decisionsupport/temp/GuidHospepxx_Updated.sav' /drop NotFlwUpEligLastRU.
 

*GO End 12-30-13.

match files /table='//covenas/decisionsupport/temp\ServicesByTypeWide.sav' /file=* /by case.
recode svcdate.1(sysmis=-99).
exe.
VARSTOCASES
/make svcdate from svcdate.1 to svcdatex
/make ru from ru.1 to rux
/make Provname from provname.1 to provnamex
/make Agency from agency.1 to agencyx.

select if svcdate ne 99.
recode svcdate(-99=Sysmis).


save outfile='//covenas/decisionsupport/meinzer/temp/tempguidwork.sav'.
get file='//covenas/decisionsupport/meinzer/temp/tempguidwork.sav'.

select if svcdate ge (HospClosedate-1).
compute lapse = xdate.tday(svcdate) - (xdate.tday(HospClosedate)-1).
select if lapse le 90.

*if JOHN GEORGE PSY SVS EMERGENCY within one day of svc, drop.
*if range(xdate.tday(Svcdate) - xdate.tday(OpDateNext),-1,1) AND ru = "01016" Drop=1.
*select if missing(Drop).
if xdate.tday(svcdate) lt xdate.tday(OpDateNext) AND lapse lt 8 AND FUsvc=1 Latent7=1.
if xdate.tday(svcdate) lt xdate.tday(OpDateNext) AND lapse lt 31 AND FUsvc=1 Latent30=1.
*GO Start - Latent60 12-30-13*.
if xdate.tday(svcdate) lt xdate.tday(OpDateNext) AND lapse lt 61 AND FUsvc=1 Latent60=1.


aggregate outfile='//covenas/decisionsupport/temp/GuidHospPostSvc.sav'
	/break= case hospRU HospOpdate
	/latent7 = max(latent7)
	/Latent30 = max(Latent30)
 /Latent60 = max(Latent60).
insert file='//covenas/decisionsupport/modules/uncookedmonth.sps'.
temp.
select if hospCloseDate lt datesum(UnCookedMonth,-1,'months').
save outfile='//covenas/decisionsupport/temp/GuidHospPostSvc_Latency.sav' /keep case FUsvc bday sex dx dx_descr  dx_grpDSM  hospru HospOpDate HospCloseDate  calendar HospProvname 
SvcTeamClient HasMediCal OpDateNext OpDatePrevious AdmitAge  agegroup svcdate ru Provname Agency lapse Latent7 Latent30 Latent60.

get file='//covenas/decisionsupport/temp/GuidHospepxx_Updated.sav'.
sort cases by case hospRU hospOpdate.
match files/table='//covenas/decisionsupport/temp/GuidHospPostSvc.sav' /file=* /by case hospRU hospOpdate.

if xdate.tday(OpdateNext) ne yrmoda(2020,01,01) AND xdate.tday(OpdateNext) - xdate.tday(HospCloseDate) lt 11 HospRecid10=1.
if xdate.tday(OpdateNext) ne yrmoda(2020,01,01) AND xdate.tday(OpdateNext) - xdate.tday(HospCloseDate) lt 31 HospRecid30=1.

compute calendar = date.moyr(xdate.month(HospCloseDate),xdate.year(HospCloseDate)).
formats calendar(moyr6).

compute LOS = xdate.tday(HospCloseDate) - xdate.tday(HospOpDate)+1.

save outfile='//covenas/decisionsupport/temp/GuidHospResults_WORK.sav'.
aggregate outfile=*
	/break=case HOSPRU HospOpdate HospCloseDate HospProvname dx dx_descr dx_grpDSM bday sex HasMediCal LOS  agegroup  SvcTeamClient
	/Latent7 = max(Latent7)
	/Latent30= max(latent30)
 /Latent60=max(Latent60)
	/HospRecid10= max(HospRecid10)	
	/HospRecid30= max(HospRecid30)	.		

compute DischargeAge = Trunc((xdate.tday(HospClosedate) - xdate.tday(bday))/365.25).
recode Latent7 Latent30 Latent60 HospRecid10 HospRecid30 	(sysmis=0).
recode HasMediCal SvcTeamClient (sysmis=0).

compute counter=1.
compute DischargeMonth = date.moyr(xdate.month(HospCloseDate), xdate.year(hospCloseDate)).
formats DischargeMonth (moyr6).

save outfile='//covenas/decisionsupport/dashboarddatasets\GuidHospitalEpisodesWork.sav'.
get file='//covenas/decisionsupport/dashboarddatasets\GuidHospitalEpisodesWork.sav'.
insert file='//covenas/decisionsupport/modules\UncookedMonth.sps'.

select if hospclosedate lt datesum(UnCookedMonth,-1,'months'). 

if hospclosedate gt datesum(UnCookedMonth,-2,'months') possiblefu30=0.
if hospclosedate le datesum(UnCookedMonth,-2,'months') possiblefu30=1.



compute HospRU = "BOGUS".
compute HospProvname =  "Guidance BOGUS".

rename variables
hospru = GuidanceRU 
hospopdate=GuidanceOpDate 
HospCloseDate = GuidanceCloseDate 
Hospprovname=GuidanceProviderName 
hosprecid10=GuidanceRecidivism10 
hosprecid30=GuidanceRecidivism30.

recode  latent7 Latent30 Latent60 SvcTeamClient HasMedical(sysmis=0).
string Latent7Client Latent30Client Latent60Client SEDKid HasMedicalText Gender (a22).
if latent7=1 Latent7Client='Yes'.
if latent7=0  latent7client='No'.
if Latent30=0 latent30client='No'.
if Latent30=1 Latent30Client='Yes'.
if Latent60=0 latent60client='No'.
if Latent60=1 Latent60Client='Yes'.
if SvcTeamClient=0 SEDKid='Not Case Managed'.
if SvcTeamClient=1 SEDKid='Case Managed'.
if HasMedical=0 HasMedicalText='None'.
if HasMedical=1 HasMedicalText='Medi-Cal'.
if sex='M' Gender='Male'.
if sex='F' Gender='Female'.
if sex='U' Gender='Unknown'.
compute SEDsvcKid=SvcTeamClient.
*save outfile='//covenas/decisionsupport/meinzer/temp/Guidance30.sav'.
compute possibleLOS30=1.
if missing(GuidanceCloseDate) PossibleLOS30 =0.

match files /file=* /drop sex.
sort cases by case.
match files /table='//covenas/spssdata/clinfo.sav'  /file=*  /by case /keep ethnic hispanic name case GuidanceRU GuidanceOpDate GuidanceCloseDate GuidanceProviderName dx dx_descr dx_grpDSM bday
sex HasMediCal LOS AgeGroup SvcTeamClient Latent7 Latent30 Latent60 GuidanceRecidivism10 GuidanceRecidivism30 DischargeAge counter DischargeMonth UnCookedMonth possiblefu30
Latent7Client Latent30Client Latent60Client SEDKid HasMedicalText Gender SEDsvcKid possibleLOS30.

insert file='//covenas/decisionsupport/modules/ethnicity.sps'.
compute createDate = $time.
formats createDate(datetime17).
 * insert file='//covenas/decisionsupport/modules/uncookedmonth.sps'.
if guidanceCloseDate ge datesum(uncookedmonth,-1,'months') possiblefu30=0.
if guidancecloseDate lt datesum(uncookedmonth,-1,'months') possiblefu30=1.

if xdate.mday($time) le 15 dateFU30 = DateSum($time,-2,"months").
if xdate.mday($time) gt 15 dateFU30 = DateSum($time,-1,"months").
compute dateFU30 =date.moyr(xdate.month(dateFU30), xdate.year(dateFU30)).
formats dateFU30(date12).


save outfile='//covenas/decisionsupport/dashboardDataSets\GuidanceEpisodes_kids.sav'.
 * get file='//covenas/decisionsupport/dashboardDataSets\GuidanceEpisodes_kids.sav'.
select if Latent30=0.


compute NoLatencyCare=1.


save outfile='//covenas/decisionsupport/temp/GuidanceNoLatencyCareDetailx.sav'.

*pushbreak.
*sqlTable = 'GuidanceNoLatencyCareDetail'.
*spsstable='//covenas/decisionsupport/temp/GuidanceNoLatencyCareDetailx.sav'.
*pushbreak.


 * get file='//covenas/decisionsupport/dashboardDataSets\GuidanceEpisodes_kids.sav'.

 * SAVE TRANSLATE /TYPE=ODBC
 /Connect ='DSN=Dashboarddatadev;UID=;APP=SPSS For'+
 ' Windows;WSID=HPMXL9360ZDD;DATABASE=Dashboarddatadev;Trusted_Connection=Yes'
 /table= 'GuidanceEpisodes_kids' /MAP/REPLACE.
*pushbreak.
*****************************.
get file='//covenas/decisionsupport/temp/GuidHospPostSvc_Latency.sav' .

compute counter=1.
compute DischargeMonth = date.moyr(xdate.month(HospCloseDate), xdate.year(hospCloseDate)).
formats DischargeMonth (moyr6).

sort cases by ru DischargeMonth case HospOpdate.
*check.
match files/file=* /by ru DischargeMonth case /first=FUruCase1.
match files/file=* /by ru DischargeMonth case HospOpDate /first=FUruEp1.

recode  latent7 Latent30 Latent60 SvcTeamClient HasMedical(sysmis=0).
string Latent7Client Latent30Client Latent60Client SEDKid HasMedicalText Gender (a22).
if latent7=1 Latent7Client='Yes'.
if latent7=0  latent7client='No'.
if Latent30=0 latent30client='No'.
if Latent30=1 Latent30Client='Yes'.
if Latent60=0 latent60client='No'.
if Latent60=1 Latent60Client='Yes'.
if SvcTeamClient=0 SEDKid='Not Case Managed'.
if SvcTeamClient=1 SEDKid='Case Managed'.
if HasMedical=0 HasMedicalText='None'.
if HasMedical=1 HasMedicalText='Medi-Cal'.
if sex='M' Gender='Male'.
if sex='F' Gender='Female'.
if sex='U' Gender='Unknown'.

aggregate outfile='//covenas/decisionsupport/DashboardDataSets\GuidFollowUpCareDetail.sav'
	/break=DischargeMonth  Ru Provname  HospProvname  case hospOpdate HospCloseDate agegroup gender hasmedical dx_grpdsm 
	/Latent7 = max(Latent7)
	/Latent30= max(Latent30)
	/Latent60= max(Latent60)
	/Visits =sum(counter)
	/HasMedicalText=max(HasMedicalText)
	/SvcTeamClient=max(SvcTeamClient)
/sedkid=max(sedkid).

aggregate outfile=*
	/break=DischargeMonth  Ru Provname  HospProvname  case hospOpdate HospCloseDate 
	/Clients = sum(FURUcase1)
	/DischargeEps = sum(FURUep1).

compute createDate = $time.
formats createDate(date11).

rename vars Hospprovname=GuidanceProviderName .
 * compute HospProvname =  "Guidance BOGUS".

 * rename vars 
hospopdate=GuidanceOpDate 
HospCloseDate = GuidanceCloseDate 
Hospprovname=GuidanceProvName.

save outfile='//covenas/decisionsupport/meinzer/temp/Guidthosfollowupru.sav'.
*pushbreak.
*get file='//covenas/decisionsupport/meinzer/temp/Guidthosfollowupru.sav'.
*do not push.
 * SAVE TRANSLATE /TYPE=ODBC
 /Connect ='DSN=Dashboarddatadev;UID=;APP=SPSS For'+
 ' Windows;WSID=HPMXL9360ZDD;DATABASE=Dashboarddatadev;Trusted_Connection=Yes'
 /table= 'GuidanceHosp_FollowUpRus' /MAP/REPLACE.
*pushbreak.



get file='//covenas/decisionsupport/DashboardDataSets\GuidFollowUpCareDetail.sav'.
compute createDate = $time.
formats createDate(datetime17).

sort cases by case.
match files /table='//covenas/spssdata/clinfo.sav' /file=* /by case /drop  bornname language disab educ created cin marital minors ssn. 
insert file= '//covenas/decisionsupport/modules/ethnicity.sps'.
match files/file=*/drop raceethnicitycode hispanic.

*compute HospRU = "BOGUS".
compute HospProvname =  "Guidance BOGUS".

recode svcteamclient(sysmis=0).
rename vars 
hospopdate=GuidanceOpDate 
HospCloseDate = GuidanceCloseDate 
Hospprovname=GuidanceProvName.

formats createDate(date11).
recode svcteamclient(sysmis=0).

string Latent7Client Latent30Client  Latent60Client DaysLatent60 DaysLatent30 DaysLatent7 (a3).

if latent7=1 Latent7Client='Yes'.
if latent7=0  latent7client='No'.
if Latent30=0 latent30client='No'.
if Latent30=1 Latent30Client='Yes'.
compute DaysLatent30=Latent30Client.
if Latent60=0 latent60client='No'.
if Latent60=1 Latent60Client='Yes'.
compute DaysLatent60=Latent60Client.
compute DaysLatent7=Latent7Client.
exe.
compute SEDSVCkid=svcTeamClient.
sort cases by ru.
match files /table="//covenas/decisionsupport/rutable.sav" /file=* /by ru /keep psmask2  Ethnicity case name Gender bday DischargeMonth RU provname GuidanceProvName 
GuidanceOpDate
GuidanceCloseDate AgeGroup  Visits  createDate Latent7Client Latent30Client DaysLatent30 Latent60Client DaysLatent60 DaysLatent7 sedkid SEDSVCkid.

select if not psmask2=700.
exe.
save outfile='//covenas/decisionsupport/temp/GuidanceFollowUpCareDetailxx.sav'  .
display vars.
*New Code 6/28/13.

match files /file=* /keep Case GuidanceOpDate.

sort cases by case GuidanceOpDate.
match files /file=* /by case GuidanceOpDate /first =GCep1.
select if GCep1=1.

match files /file=* /drop GCep1. 

CASESTOVARS 
/id=case.
compute gx=99.
save outfile = '//covenas/decisionsupport/temp/GCEps_UndupCases.sav'.

get file ='//covenas/decisionsupport/epscg.sav'
   /keep ru case opdate closdate epflag lastservice.
select if closdate ge StartDateGC.

sort cases by case.
match files /table= '//covenas/decisionsupport/temp/GCEps_UndupCases.sav' /file=* /by case.
exe.
VARSTOCASES 
   /make GuidanceOpDate from GuidanceOpDate.1 to gx.
exe.
select if guidanceopdate ne 99.
Compute OpenAtRuAtGCIntake=0.

If opdate lt GuidanceOpDate and lastservice ge datesum(GuidanceOpDate,-60,'days') OpenAtRuAtGCIntake=1.
*If opdate lt GuidanceOpDate and missing(closdate) OpenAtRuAtGCIntake=1.

select if OpenAtRuAtGCIntake=1.

Aggregate outfile = *
   /break case GuidanceOpDate ru
   /OpenAtRuAtGCIntake=max(OpenAtRuAtGCIntake). 

 * sort cases by case GuidanceOpDate ru. 
 * match files file=* by case GuidanceOpDate ru /first=GCepFlwUpRU1.

save outfile = '//covenas/decisionsupport/temp/RUsGCClientsWereActiveAtGCIntake3.sav' /keep case GuidanceOpDate ru OpenAtRuAtGCIntake.
get file = '//covenas/decisionsupport/temp/RUsGCClientsWereActiveAtGCIntake3.sav'.
sort cases by ru case guidanceOpdate. 

*Match Active At GC Intake data to Guidance Clinic Follow-Up Care Details to identify which 
exe.
get file='//covenas/decisionsupport/temp/GuidanceFollowUpCareDetailxx.sav'  /keep psmask2 Ethnicity case name Gender bday DischargeMonth ru 
provname GuidanceProvName GuidanceOpDate GuidanceCloseDate AgeGroup Visits createDate Latent7Client Latent30Client  Latent60Client DaysLatent60 DaysLatent30
DaysLatent7 sedkid SEDSVCkid.
exe.
display vars.
sort cases by case GuidanceOpDate ru. 
match files /table= '//covenas/decisionsupport/temp/RUsGCClientsWereActiveAtGCIntake3.sav' /file=* /by case GuidanceOpDate ru /keep case GuidanceOpDate ru
OpenAtRuAtGCIntake psmask2 Ethnicity name  Gender bday DischargeMonth provname GuidanceProvName GuidanceCloseDate AgeGroup
Visits createDate Latent7Client Latent30Client DaysLatent30 Latent60Client DaysLatent60 DaysLatent7 sedkid SEDSVCkid .

display vars.
String OpenAtGCIntakeText(a10). 

If OpenAtRuAtGCIntake = 1 OpenAtGCIntakeText= "Yes".

Compute Counter=1.

Save outfile ='//covenas/decisionsupport/temp/GuidanceFollowUpCareDetailS.sav'. 
display vars.

*pushbreak.
*sqlTable = 'GuidanceFollowUpCareDetail'.
*spsstable='//covenas/decisionsupport/temp/GuidanceFollowUpCareDetailS.sav'.
*pushbreak.

