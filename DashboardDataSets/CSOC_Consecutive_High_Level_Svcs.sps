*level3 and doc names as outpatient?.
*STEP 1 - GET EPISODE AND CLIENT VARIABLES *********.

Get file '//covenas/decisionsupport/epscg.sav' /keep ru case opdate closdate lastservice .
select if not missing(lastservice).

sort cases by ru.
match files /table='//covenas/decisionsupport/rutable.sav' /file=* /by ru /keep agency provname ru case opdate closdate lastservice psmask2 program SvcType.
recode program(sysmis=0).
select if program=0.

sort cases by case.
match files /table='//covenas/spssdata/clinfo.sav' /file=* /by case /keep agency provname ru case opdate closdate lastservice psmask2 name ethnic hispanic bday sex SvcType.


compute CurrentAge = Trunc((xdate.tday($Time) - xdate.tday(bday))/365.25).

STRING ChildAgeGroup(a20).
if CurrentAge lt 6 ChildAgeGroup = "a. 0-5".
if CurrentAge ge 6 and CurrentAge lt 12 ChildAgeGroup = "b. 6-11".
if CurrentAge ge 12 and CurrentAge lt 18 ChildAgeGroup = "c. 12-17".
if CurrentAge ge 17 ChildAgeGroup = "d. 18".
select if CurrentAge lt 19 and CurrentAge gt 0.

String Gender (a22).
if sex='M' Gender='Male'.
if sex='F' Gender='Female'.
if sex='U' Gender='Unknown'.

insert file='//covenas/decisionsupport/modules/ethnicity.sps'.

String HospName(a30).
If Provname = "ALTA BATES/HERRICK MEDICAL CTR" HospName = "Alta Bates".
If Provname = "BEHAVIORAL HEALTH CARE FREMONT" HospName = "Fremont".
If Provname = "EDEN HOSPITAL" HospName = "Eden".
If Provname = "JOHN GEORGE PSY SVS INPATIENT" HospName = "John George".
If Provname = "JOHN MUIR BEHAVIORAL HLTH CTR" HospName = "John Muir".
If Provname = "OUT-OF-COUNTY HOSPITAL" HospName = "Out of County".
If Provname = "TELECARE WILLOW ROCK PHF CHILD" HospName = "Willow Rock".
If Provname = "ST HELENA HOSP CTR BEHAV HLTH" HospName = "St Helena".
if provname = "ST MARY'S HOSPITAL MEDICAL CTR" HospName = "Saint Mary’s".

*STEP 2 - CREATE PROGRAM TYPE MARKERS*********.

*Hospital, Crisis, HighLevel, and Outpatient Episode Markers.
Compute HospEp=0.
if psmask2=5  HospEp=1.


*is this enough to qualify crisis.
Compute CrisisEp=0.
if any(RU, "81783","01EJ3", "01016")  CrisisEp=1.
if psmask2=34 CrisisEp=1.
*Alta Bates (non Hosp)? Childrens Hosp (BERT)  WillowRock Crisis. 81783, 01EJ3, 01EJ2, 01016, = CrisisEp. 

*All other crisis all pulled out. 

Compute HighLevelEp=0.
If HospEp+CrisisEp gt 0 HighLevelEp=1.

 * if any(RU, "01GH1","81203","81163")  
OR agency = "CJ Mental Health" CrisisEp=1.
 * if ru = "01016" CrisisEp=1.
 * if any(Psmask2, 33, 34) CrisisEp=1.
*Line above not in Global Code.

 * sort cases by ru.
 * split file by ru psmask2.
 * temp.
 * select if CrisisEp=1.
 * freq provname.

Compute OutpatientEp=1.

*if (agency = "Crisis Response" and any(proced,371,690)) .
if agency = "CJ Mental Health" OutpatientEp=0.

if HighLevelEp=1 OutpatientEp=0.

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

if agency = "Vocational" OutpatientEp=0.

Compute drop=0.
if OutpatientEp + HighLevelEp lt 1 drop=1. 


 * sort cases by ru.
 * split file by ru.

 * temporary.
 * select if drop=1.
 * freq provname.

 * temporary.
 * select if OutpatientEp=1.
 * freq provname.

*select if agency =' ' drop=1.
select if drop=0.

sort cases by lastservice (d).

SORT CASES BY case.
MATCH FILES
  /FILE=*
  /BY case
  /FIRST=MostRecentEp
  /LAST=FirstEp.

DO IF (MostRecentEp).
COMPUTE  EpCounter=1-FirstEp.
ELSE.
COMPUTE  EpCounter=EpCounter+1.
END IF.
LEAVE  EpCounter.
exe.

recode EpCounter(0=1).

if EpCounter=1 and HighLevelEp=1 LastSvcHighLevel=1.

Aggregate outfile = * mode=ADDVARIABLES
   /break=case
   /HighLevelClient=max(LastSvcHighLevel).

Select if HighLevelClient=1.
match files /file=*  /keep case name opdate closdate LastService HighLevelEp
EpCounter agency ru provname HospName psmask2 svcType HospEp CrisisEp
OutpatientEp MostRecentEp FirstEp CurrentAge ChildAgeGroup Gender Ethnicity.

*STEP 3 - Create Rules.
Save outfile = '//covenas/decisionsupport/Orozco/Temp/ConsecHighLvlWork.sav' .
get file = '//covenas/decisionsupport/Orozco/Temp/ConsecHighLvlWork.sav'.

sort cases by Case EpCounter.

Compute Drop=0.
if MostRecentEp=1 and FirstEp=1 Drop=1. 
if epcounter=2 and HighLevelEp=0 Drop=1.

Aggregate outfile =*  mode= ADDVARIABLES
   /Break=case
   /DropCase = max(drop).

select if DropCase=0.

sort cases by case LastService(d).
execute.
do if lag(case) = case.
compute OpDateNext=lag(opdate).
FORMATS OpDateNext(date11).
end if.

compute DaysBtwHighLevelEps = datedif(OpDateNext,closdate,'days').

if OutpatientEp=1 DaysBtwHighLevelEps= 999.
recode DaysBtwHighLevelEps(sysmis=0).

Compute ConsecHighLvlEpsCounter=0.
if HighLevelEp=1 and DaysBtwHighLevelEps lt 270 ConsecHighLvlEpsCounter=EpCounter.

recode ConsecHighLvlEpsCounter(sysmis=0).

If ConsecHighLvlEpsCounter=0 Drop=1.

sort cases by case EpCounter.
execute.
do if lag(case) = case and lag(Drop) =1.
compute Drop=lag(Drop).
end if.
exe.

Select if drop=0.

*Eliminate crisis eps that are connected to/lead to hospital eps. Only counted as one high level ep rather than two. 

sort cases by case lastservice(d).
do if lag(case) = case and lag(HospEp) =1 and CrisisEp=1.
compute CrisisClosToHospOp= xdate.tday(lag(opdate)) - xdate.tday(closdate).
Compute CrisisOpToHospOp = xdate.tday(lag(opdate)) - xdate.tday(opdate).
end if.
exe.

if range(CrisisClosToHospOp,-1,1) = 1 Drop=1.
if range(CrisisOpToHospOp,0,1) =1 Drop=1.
if CrisisClosToHospOp lt 0 and CrisisOpToHospOp gt 1 Drop=1.
if  CrisisOpToHospOp gt 1 and missing(CrisisClosToHospOp)  Drop=1.

Select if Drop=0.

Aggregate outfile =* mode= addvariables
   /Break= case 
   /ConsecHighLevelEps= sum(HighLevelEp).
exe.

Select if ConsecHighLevelEps gt 1.  
Compute DaysSinceDischarge =xdate.tday($Time) - xdate.tday(closdate).
recode DaysSinceDischarge(sysmis=0).

*If you only had two consecutive high level eps and the most recent closed less than 30 days ago or has not closed. Eliminate case from list.
If ConsecHighLevelEps=2 and DaysSinceDischarge lt 30 and ConsecHighLvlEpsCounter=1 Drop=1.
Aggregate outfile =* mode= addvariables
   /Break= case 
   /DropCases= max(drop).
   exe.

select if DropCases = 0.

*STEP 4 - Assign a most recent crisis and/or hosp name to cases.

sort cases by case HospEp Epcounter.
Match files /FILE=* /by case HospEp /first=MostRecentHospMarker.
If HospEp=0 MostRecentHospMarker=0.
EXECUTE.


String Hospital HospProvname(a30).
If MostRecentHospMarker=1 Hospital=HospName.
if Hospital ne " " HospProvname=Provname.
if Hospital ne " "  HospSvc = lastservice.
if Hospital ne " "  HospAdmitDate = opdate.
if Hospital ne " "  HospDischargeDate = closdate.
FORMATS HospSvc HospAdmitDate HospDischargeDate (date11).


sort cases by case CrisisEp Epcounter.
Match files /FILE=* /by case CrisisEp /first=MostRecentCrisisMarker.
If CrisisEp=0 MostRecentCrisisMarker=0.

String CrisisProvname CrisisAgency(a30).
If MostRecentCrisisMarker=1 CrisisProvname=Provname.
If MostRecentCrisisMarker=1 CrisisAgency=Agency.
if CrisisProvname ne " "  CrisisSvc = lastservice.
if CrisisProvname ne " "   CrisisAdmitDate = opdate.
if CrisisProvname ne " "   CrisisDischargeDate= closdate.
FORMATS CrisisSvc CrisisAdmitDate CrisisDischargeDate (date11).

String MostRecentHighLevelProvider(a30).
 * If MostRecentEp=1 and HospEp=1 MostRecentHighLevelProvider=HospName.
 * If MostRecentEp=1 and CrisisEp=1 MostRecentHighLevelProvider=Provname.
If MostRecentEp=1 MostRecentHighLevelProvider=Provname.
if MostRecentHighLevelProvider ne " "  HighLevelSvc = lastservice.
if MostRecentHighLevelProvider ne " "   HighLevelAdmitDate = opdate.
if MostRecentHighLevelProvider  ne " "    HighLevelDischargeDate= closdate.
FORMATS HighLevelSvc HighLevelAdmitDate HighLevelDischargeDate (date11).


Save outfile = '//covenas/decisionsupport/Orozco/Temp/ConsecHighLvlWork2.sav'.
get file = '//covenas/decisionsupport/Orozco/Temp/ConsecHighLvlWork2.sav'. 


Aggregate outfile = '//covenas/decisionsupport/Orozco/Temp/ConsecHighLevelClients.sav'
   /Break= Case Name CurrentAge ChildAgeGroup Gender Ethnicity ConsecHighLevelEps
   /Hospital=max(Hospital)
   /HospProvname=max(HospProvname)
   /HospAdmitDate=max(HospAdmitDate)
   /HospDischargeDate=max(HospDischargeDate)
   /LastHospitalService=max(HospSvc)
   /CrisisAgency=max(CrisisAgency)
   /CrisisProvname=max(CrisisProvname)
   /CrisisAdmitDate=max(CrisisAdmitDate)
   /CrisisDischargeDate=max(CrisisDischargeDate)
   /LastCrisisService=max(CrisisSvc)
   /MostRecentHighLevelProvider=max(MostRecentHighLevelProvider)
   /LastHighLevelSvc=max(HighLevelSvc)
   /HighLevelAdmitDate=max(HighLevelAdmitDate)
   /HighLevelDischargeDate=max(HighLevelDischargeDate).


get file =  '//covenas/decisionsupport/MedicalData/MedsCurrentUncut.sav'.
save outfile= '//covenas/decisionsupport/Temp/MedsCurrentUncutCity.sav' /keep CIN City.

get file =  '//covenas/decisionsupport/Orozco/Temp/ConsecHighLevelClients.sav'.
Select if LastCrisisService gt datesum($time,-1, "years") or LastHospitalService gt datesum($time,-1, "years") .

sort cases by case.
match files /table='//covenas/decisionsupport/addressmhs.sav' /file=* /by case.
rename vars city=CityInsyst.
match files /table= '//covenas/spssdata/clinfo.sav' /file=* /by case.
sort cases by CIN.
match files /table= '//covenas/decisionsupport/Temp/MedsCurrentUncutCity.sav' /file=* /by CIN.

If City=" " City= CityInsyst.

sort cases by ConsecHighLevelEps(d).
Save outfile = '//covenas/decisionsupport/Orozco/CSOC/Key Indicator Dashboard/ConsecHighLevelClients-.sav' 
/keep 
case
name
CurrentAge
ChildAgeGroup
Gender
Ethnicity
ConsecHighLevelEps
Hospital
HospProvname
HospAdmitDate
HospDischargeDate
LastHospitalService
CrisisAgency
CrisisProvname
CrisisAdmitDate
CrisisDischargeDate
LastCrisisService
MostRecentHighLevelProvider
LastHighLevelSvc
HighLevelAdmitDate
HighLevelDischargeDate
City.

get file = '//covenas/decisionsupport/Orozco/CSOC/Key Indicator Dashboard/ConsecHighLevelClients-.sav' .

*pushbreak.
*sqlTable = 'CSOC_ConsecutiveHighLevelSvcsClientList'.
*spsstable='//covenas/decisionsupport/Orozco/CSOC/Key Indicator Dashboard/ConsecHighLevelClients-.sav'.
*pushbreak.

