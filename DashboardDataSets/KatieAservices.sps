get file='//covenas/spssdata/EpsCG.sav' /keep ru case opdate epFlag lastservice.
if RU = "01FB1" PP=1.
 * temp. 
 * select if pp=1.
 * freq epflag.
select if EpFlag="O".
match files /table='//covenas/spssdata/RuTable.sav' /file=* /by ru
/keep ru case opdate epFlag provname agency psmask2 lastservice.
 * select if (xdate.tday(lst_Svc) ge yrmoda(2013,07,01)) OR xdate.tday(opdate) ge yrmoda(2013,11,01).
Select if lastservice ge datesum($time,-120, "days") OR opdate ge datesum($time,-45, "days").

if provname  = "CHILDREN'S HOSP BERT MHS" Drop=1.
if psmask2=5 Drop=1.
*take out Crisis Stabilization AND JG highland consults.
if any(RU,"81203","01GH1","01EJ3","01016","01013") drop=1.
select if missing(Drop).
sort cases by case.
match files /table='//covenas/spssdata/KatieAkids.sav' /file=* /by case /first=case1.
select if KatieA=1.
if RU = "01FB1" PP=1.
if psmask2 = 262145 OR any(RU,"81422","81423","81424","81425","81232","81231","81787") Level1=1.
if index(Provname,"TBS") ge 1 TBS=1.
exe.

if missing(PP) AND missing(TBS) AND missing(Level1) OtherSvc=1.

agg outfile='//covenas/spssdata/temp\KatieAinService.sav'
   /break=case
   /TBS = max(TBS)
   /PPkid=max(PP)
   /Level1= max(Level1) 
   /OtherSvc = max(OtherSvc).

get file='//covenas/spssdata/KatieAkids.sav' .
match files /table='//covenas/spssdata/temp\KatieAinService.sav' /file=* /by Case.
exe.

compute IntensiveSvcCount = sum(TBS,PPkid,Level1).
if IntensiveSvcCount ge 1 intensiveService=1.
freq IntensiveSvcCount intensiveService.

 * sort cases by intensiveService.
 * split file by intensiveService.
 * freq otherSvc.

if missing(intensiveservice) and missing(otherSvc) unserved=1.

Compute age = trunc((xdate.tday($time) - xdate.tday(bday))/365.2).

if age lt 12 YoungKid=1. 

aggregate outfile='//covenas/spssdata/temp/katieASvcKids.sav'
   /break=YoungKid Dependent
   /TotalClients=sum(katieA)
   /UnservedKids=sum(unserved)
   /Level1kids=sum(Level1)
   /PPkids=sum(ppkid)
   /TBSkids=sum(TBS)
   /OtherSvcKids=sum(OtherSvc).

***********CFS list of dependents under 12 - start.

Select if YoungKid=1 and Dependent=1.
*sort cases by case.
*Match files /table='//covenas/spssdata/clinfo.sav' /file=* /by case. 

Compute age = trunc((xdate.tday($time) - xdate.tday(bday))/365).
If age ge 12 drop=1.
freq drop.
recode drop(sysmis=0).
select if drop=0. 

sort cases by CWSclientID.
rename variables PPkid=ActiveProjectPermanence. 
rename variables Level1=ActiveLevel1.
rename variables TBS=ActiveTBS.
rename variables OtherSvc=ActiveOtherSvc.
rename variables youngkid=Under12. 

save outfile= '//covenas/decisionsupport/Orozco/CSOC/Katie A/KatieA_MHSvcStatus.sav' 
/keep CWSclientID lname fname  bday KatieAStartDate KatieAEndDate Dependent Under12 ActiveProjectPermanence ActiveLevel1 ActiveTBS ActiveOtherSvc Unserved. 

 * get file = '//covenas/decisionsupport/Orozco/CSOC/Katie A/KatieA_MHSvcStatus.sav'.

 * SAVE TRANSLATE OUTFILE='//covenas/decisionsupport/orozco\CSOC/Katie A/KatieA_MHSvcStatus.xlsx'
  /TYPE=XLS
  /VERSION=12
  /MAP
  /REPLACE
  /FIELDNAMES
  /CELLS=VALUES.

***********CFS list of dependents under 12 - end.

***********Katie A kid status summary for KTA meetings. 

 * get file='//covenas/spssdata/temp/katieASvcKids.sav'.

 * SAVE TRANSLATE OUTFILE='//covenas/decisionsupport/orozco\CSOC/Katie A/katieASvcKids.xlsx'
  /TYPE=XLS
  /VERSION=12
  /MAP
  /REPLACE
  /FIELDNAMES
  /CELLS=VALUES.

***********Katie A intervention list of CSOC - PART 2 - Start. 
*ERMHS Status. 
get file='//covenas/spssdata/AB3632/tblClients_insystList.sav' /keep case ab3632 qualifyingDate.
if xdate.tday(qualifyingDate) ge yrmoda(1900,11,01) ERMHSQualified=1.
save outfile= '//covenas/decisionsupport/Orozco/Temp/KTA_AB3632.sav' /keep case ab3632 ERMHSQualified. 

*MostRecentProvider. 
get file='//covenas/spssdata/EpsCG.sav'.
sort cases by lastservice(d).
sort cases by case. 
match files /file=* /by case /first=case1.
select if case1=1.
sort cases by ru.
match files /table= '//covenas/decisionsupport/rutable.sav' /file=* /by ru.
sort cases by case.
save outfile= '//covenas/decisionsupport/Orozco/Temp/KTA_MostRecentEp.sav' /keep case Agency RU provname psmask2 Daytx Opdate closdate epflag PrimaryTherapist LastService. 

*High level eps in past year.
 * get file = '//covenas/decisionsupport/Orozco/CSOC/Key Indicator Dashboard/ConsecHighLevelClients-.sav'.
 * sort cases by case.
 * save outfile= '//covenas/decisionsupport/Orozco/Temp/KTA_ConsecHighLevelEps.sav' /keep case ConsecHighLevelEps.
Get file '//covenas/decisionsupport/epscg.sav' /keep ru case opdate closdate lastservice epflag.
select if not missing(lastservice).
Select if lastservice gt datesum($time,-1, "years").

sort cases by ru.
match files /table='//covenas/decisionsupport/rutable.sav' /file=* /by ru /keep agency provname ru case opdate closdate lastservice psmask2 program SvcType epflag.
recode program(sysmis=0).
select if program=0.

Compute HospEp=0.
if psmask2=5  HospEp=1.

Compute CrisisEp=0.
if any(RU, "81783","01EJ3", "01016")  CrisisEp=1.
if psmask2=34 CrisisEp=1.
if RU = "811825" CrisisEp=1.

Save outfile = '//covenas/decisionsupport/Orozco/Temp/EpsLast365.sav'.

select if HospEp=1 or CrisisEp=1.
Compute HighLevelEp=1.

sort cases by case lastservice(d).
do if lag(case) = case and lag(HospEp) =1 and CrisisEp=1.
compute CrisisClosToHospOp= xdate.tday(lag(opdate)) - xdate.tday(closdate).
Compute CrisisOpToHospOp = xdate.tday(lag(opdate)) - xdate.tday(opdate).
end if.
exe.

Compute Drop=0.
if range(CrisisClosToHospOp,-1,1) = 1 Drop=1.
if range(CrisisOpToHospOp,0,1) =1 Drop=1.
if CrisisClosToHospOp lt 0 and CrisisOpToHospOp gt 1 Drop=1.
if  CrisisOpToHospOp gt 1 and missing(CrisisClosToHospOp)  Drop=1.

Select if Drop=0.

Aggregate outfile = *
   /Break = Case
   /HighLevelEpsLastYear= sum(HighLevelEp).

If HighLevelEpsLastYear ge 2 MultipleHighLevelEpsClient=1. 
   
sort cases by case.
Save outfile = '//covenas/decisionsupport/Orozco/Temp/KTA_MultipleHighLevelEps.sav'.

*Number of Outpatient Providers.
Get file = '//covenas/decisionsupport/Orozco/Temp/EpsLast365.sav'.
Select if lastservice ge datesum($time,-120, "days") OR opdate ge datesum($time,-45, "days").
select if epflag= "O".

Select if  HospEp=0 and CrisisEp=0.

Compute OutpatientEp=1.

*if (agency = "Crisis Response" and any(proced,371,690)) .
if agency = "CJ Mental Health" OutpatientEp=0.

*this means that the willow rock Seneca short term cm program doesn't get counted as outpatient.
if any(PsMask2,34,17,19,33) OutpatientEp=0.

*if psmask2 =700 drop=1.
*01193 is adolescent sex offender - not custodial gudiance program.
if ru ne "01193" AND psmask2=4097 OutpatientEp=0.

*Assessment Center.
if any(ru,"01DW1", "81933") OutpatientEp=0.

*SENECA MOBILE RESP TEAM MHS CH  .
if RU = "811825" OutpatientEp=0.

*Semi-Crisis providers.
 * ACCESS MHS ADULT LA CLINICA
ACCESS MHS ADULT LA FAMILIA
BACS WOODROE PLACE CRISIS RES
BACS WOODROE PLACE MHS
BAY PSYCHIATRIC ASSOC GRP
BERKELEY PLACE 24HR RES
CONSERVATORSHIP CONT CARE SUP
CRIMINAL JUSTICE MHS SNTA RITA
CRISIS RESPONSE LIVERMORE ADLT
FFYC IN-HOME CRISIS MHS CHILD
JOHN GEORGE PSY SVS MHS ADULT
MH COURT ADVOCATES ADULT MHS
MOBILE CRISIS RESP PGM MHS AD
SENECA CTR WILLOW ROCK MHS CHD
TELECARE SAUSAL CRK MHS CRISIS
TELECARE VILLA IMD/SNF.
if any  (ru, '00681', '0105A7', '01101', '0163A8', '018423', '0191A9', '01EJ1', '01G51', '01GH1', '81142',
'81143','81163','81441','81442','8162A6', "765001", "01871" ,"01013") OutpatientEp=0.

Select if OutpatientEp=1.
sort cases by case. 

Aggregate outfile = '//covenas/decisionsupport/Orozco/Temp/KTA_MultipleOutpatientEps.sav'
   /Break = Case
   /ActiveOutpatientEps= sum(OutpatientEp).

*Katie A services count - ICC IHBS.

get file ='//covenas/decisionsupport/Orozco/Temp/KatieA_ICC_IHBSReport.sav'.
 * Compute ServiceCounter=1.
sort cases by case.

Aggregate outfile = '//covenas/decisionsupport/Orozco/Temp/KTA_ICCIHBSServiceCount.sav'
   /Break = Case
   /ICCIHBSServiceCount= sum(duration).

*Bring it all together.
get file='//covenas/spssdata/KatieAkids.sav' .
match files /table='//covenas/spssdata/temp\KatieAinService.sav' /file=* /by Case.
exe.

compute IntensiveSvcCount = sum(TBS,PPkid,Level1).
if IntensiveSvcCount ge 1 intensiveService=1.
 * freq IntensiveSvcCount intensiveService.
 * if missing(intensiveservice) and missing(otherSvc) unserved=1.

 * if xdate.tday(KatieAEndDate) ge yrmoda(1900,11,01) Drop=1.
 * recode drop(sysmis=0).
 * select if drop=0. 

Compute age = trunc((xdate.tday($time) - xdate.tday(bday))/365.25).
 * if age lt 12 Under12=1. 
 * recode Under12(sysmis=0).

sort cases by case.
match files /table='//covenas/decisionsupport/Orozco/Temp/KTA_AB3632.sav' /file=* /by case.

Match files /table='//covenas/decisionsupport/Orozco/Temp/KTA_MostRecentEp.sav' /file=* /by case.

Match files /table='//covenas/decisionsupport/Orozco/Temp/KTA_MultipleHighLevelEps.sav' /file=* /by case.

Match files /table='//covenas/decisionsupport/Orozco/Temp/KTA_MultipleOutpatientEps.sav' /file=* /by case.

Match files /table= '//covenas/decisionsupport/Orozco/Temp/KTA_ICCIHBSServiceCount.sav' /file=* /by case.

 * If any(psmask2, 5, 33, 34) LastSvcCrisisOrHosp=1.
 * If (Daytx=1 or any(psmask2, 700, 65537)) and epflag = 'C' LastSvcClosedDaytx=1. 

Recode ActiveOutpatientEps HighLevelEpsLastYear ActiveOutPatientEps(sysmis=0). 
If ActiveOutpatientEps=0 Unserved=1.

Compute RiskFactors = sum(KatieA, MultipleHighLevelEpsClient, ERMHSQualified, TBS, PPKid, Level1).

sort cases by ActiveOutPatientEps. 
sort cases by RiskFactors HighLevelEpsLastYear (d).

String ActiveTBS ActiveProjPerm ActiveLevel1 ActiveOtherService ERMHSQualifiedText UnservedText DependentText(a8).
if TBS=1 ActiveTBS='Yes'.
if ppkid=1 ActiveProjPerm='Yes'.
if Level1=1 ActiveLevel1='Yes'.
if OtherSvc=1 ActiveOtherService='Yes'.
if Unserved=1 UnservedText='Yes'.
if ERMHSQualified=1 ERMHSQualifiedText='Yes'.

if Dependent=1 DependentText='Yes'.
If Dependent=0 DependentText='No'.

Save Outfile = '//covenas/decisionsupport/Orozco/Temp/ActiveKatieA_InterventionList.sav' /Keep CWSclientID case KatieAStartDate KatieAEndDate
Lname
Fname
bday
Age
DependentText
ActiveTBS 
ActiveProjPerm 
ActiveLevel1 
ActiveOtherService 
ERMHSQualifiedText 
UnservedText 
ICCIHBSServiceCount
ActiveOutpatientEps
HighLevelEpsLastYear
RiskFactors
LastService
Agency 
RU 
Provname
epflag
PrimaryTherapist.


*pushbreak.
*sqlTable = 'ActiveKatieA_InterventionList'.
*spsstable= //covenas/decisionsupport/Orozco/Temp/ActiveKatieA_InterventionList.sav.
*pushbreak.



***********Katie A intervention list of CSOC - End. 

***********KTA Proced Check.

get file='//covenas/spssdata/KatieAkids.sav' /keep case KatieAStartDate KatieAEndDate.
Save outfile = '//covenas/decisionsupport/Orozco/Temp/KatieATempCohort.sav'.
sort cases by case.
DATA LIST /case 1-8.
BEGIN DATA
99
99
END DATA.

Add files
/file=*
/file='//covenas/decisionsupport/Orozco/Temp/KatieATempCohort.sav'.

sort cases by case.
match files /file=* /by case /first=case1.
recode case1(sysmis=0).

if case=99 and case1=1 KatieAStartDate = date.dmy(01,01,2000).
if case=99 and case1=1 KatieAEndDate = date.dmy(01,01,2001).
if case=99 and case1=0 KatieAStartDate = date.dmy(01,01,2005).
if case=99 and case1=0 KatieAEndDate = date.dmy(01,01,2006).
match files /file=* /by case /drop case1.

casestovars
/id=case.  
Save outfile ='//covenas/decisionsupport/Orozco/Temp/KatieA_Eps.sav'.

get file = '//covenas/decisionsupport/DBSVC.sav'.
select if any(proced, 557, 577). 
exe.
insert file = '//covenas/decisionsupport/modules/calsvcdate.sps'.
 * sort cases by calendar.
 * split file by calendar.
 * freq proced. 

Sort cases by case calendar.
match files /table='//covenas/decisionsupport/medicaltable.sav' /file=* /by case calendar. 

Match files /table= '//covenas/spssdata/clinfo.sav' /file=* /by case 
/keep 
case
name
ru
provname
agency
proced
svcdate
duration
InMedsTable
eCounty
calendar
Full
staff
bday
svc_Stmp
service_Stamp.

Compute age = trunc((xdate.tday($time) - xdate.tday(bday))/365.25).

 * sort cases by proced.
 * match files /table='//covenas/decisionsupport/procedsma.sav' /file=* /by proced. 

Sort cases by case.
match files /table='//covenas/decisionsupport/Orozco/Temp/KatieA_Eps.sav' /file=* /by case.
exe.
if missing(KatieAStartDate.1) KatieAStartDate.1=-99.
compute KatieAStartDatex=999999999999999.
compute KatieAEndDatex=9999999999999999.
 * string rux(a6).
 * string primarytherapistx(a28).
 * compute rux='None'.
sort variables by name.
VARSTOCASES
/make KatieAStartDate from KatieAStartDate.1 to KatieAStartDatex
/make KatieAEndDate from KatieAEndDate.1 to KatieAEndDatex.

if KatieAStartDate=-99 KatieAStartDate=$sysmis.

Select if KatieAStartDate lt date.dmy(01,01,3030) or missing(KatieAStartDate).

Compute fakeKTAenddate = date.dmy(01,01,3030).
formats fakeKTAenddate(adate10).

if KatieAEndDate ge yrmoda(1900,11,01)  fakeKTAenddate = KatieAEndDate.

If (xdate.tday(svcdate) ge xdate.tday(KatieAstartdate)) and (xdate.tday(svcdate) le xdate.tday(fakeKTAenddate))  ValidSvc=1.
recode ValidSvc(sysmis=0).

Sort cases by ValidSvc(d).
Sort cases by svc_stmp.
match files /file=* /by svc_stmp /first= svc_stmp1.
select if svc_stmp1=1. 

If ValidSvc = 1 ValidSvcTime= duration.
If ValidSvc = 0 InvalidSvcTime= duration.

Save Outfile = '//covenas/decisionsupport/Orozco/Temp/KatieA_ICC_IHBSReport.sav' /keep
agency
bday
age
calendar
case
duration
eCounty
Full
InMedsTable
name
proced
provname
ru
staff
svc_Stmp
svcdate
KatieAStartDate
KatieAEndDate
ValidSvc
ValidSvcTime
InvalidSvcTime.


 * recode katieA (sysmis=0).
 * select if KatieA=0.
 * freq case.

*pushbreak.
*sqlTable = 'KatieA_ICC_IHBSReport'.
*spsstable='//covenas/decisionsupport/Orozco/Temp/KatieA_ICC_IHBSReport.sav'.
*pushbreak.



*Which RUs are currently serving Katie A kids. 
Get file = '//covenas/decisionsupport/Orozco/Temp/EpsLast365.sav'.
Select if lastservice ge datesum($time,-120, "days") OR opdate ge datesum($time,-45, "days").
select if epflag= "O".

Sort cases by case. 
match files /table='//covenas/spssdata/KatieAkids.sav' /file=* /by case. 
select if KatieA=1.

if provname = 'LINCOLN FREMONT HIGH MHS CHILD' Agency= 'Lincoln'. 

Compute age = trunc((xdate.tday($time) - xdate.tday(bday))/365.2).

Compute drop=0.
if KatieAEndDate gt date.dmy(01,01,1900) Drop=1.
select if drop=0.

Save outfile ='//covenas/decisionsupport/Orozco/Temp/KatieA_ActiveProviders.sav' /drop drop. 

*pushbreak.
*sqlTable = 'KatieA_ActiveProviders'.
*spsstable='//covenas/decisionsupport/Orozco/Temp/KatieA_ActiveProviders.sav'. 
*pushbreak.
 
Get file = '//covenas/decisionsupport/Orozco/Temp/ActiveKatieA_InterventionList.sav' .
SELECT IF MISSING(KatieAEndDate).
Compute ActiveKTAClient=1. 
If ICCIHBSServiceCount gt 0 ICCIHBSClient=1.
if ActiveOutpatientEps gt 0 OutpatientClient=1.
Compute Date = date.dmy((xdate.mday($time)),(xdate.month($Time)),(xdate.year($time))). 
FORMATS Date(date11). 
 * Compute CreateDate = trunc($time). 

Aggregate outfile = *
   /Break=Date
   /KTASubClass=sum(ActiveKTAClient)
   /ICCIHBSClients=sum(ICCIHBSClient)
   /OutpatientClients=sum(OutpatientClient).

Compute PctICCIHBS= ICCIHBSClients/KTASubClass.
Compute PctOutpatientClients = OutpatientClients/KTASubClass.

 * Save outfile = '//covenas/decisionsupport/Orozco/CSOC/Katie A/KTASubPopSvcTrends.sav'.

Add files
 /file= *
 /file='//covenas/decisionsupport/Orozco/CSOC/Katie A/KTASubPopSvcTrends.sav'.

Sort cases by Date.
match files /file=* /by date /first=Date1.
Select if Date1=1. 

Save outfile = '//covenas/decisionsupport/Orozco/CSOC/Katie A/KTASubPopSvcTrends.sav' /drop date1.


*pushbreak.
*sqlTable = 'KTASubPopSvcTrends'.
*spsstable= '//covenas/decisionsupport/Orozco/CSOC/Katie A/KTASubPopSvcTrends.sav'.
*pushbreak.

 
