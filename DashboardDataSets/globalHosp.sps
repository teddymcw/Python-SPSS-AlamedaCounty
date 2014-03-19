DEFINE 	DBStartDate() date.dmy(1,1,2011) !ENDDEFINE.

get file='//covenas/decisionsupport/AllUR.sav' /keep opdate pstart pend 
action case effdate expdate urstamp ru.

freq urStamp /format=NoTable/statistics=Min Max.

string DayType(a30).
if action=2 dayType="3. Not Medically Necessary".
if action=2 NonMed=1.
if action=4 dayType="1. Acute Day".
if action=4 Acute=1.
if action=32 dayType="2. Admin Day".
if action =32 Admin=1.
sort cases by case urStamp.
compute days=xdate.tday(pEnd)- xdate.tday(pstart)+1.

* "1" initial Action.
* "8".
* "64".
* "128".

save outfile='//covenas/decisionsupport/Temp/GlobalHospDays.sav'.

*get file='//covenas/decisionsupport/Temp/GlobalHospDays.sav'.
if acute=1 acute=days.
if admin=1 admin=days.
if nonMed=1 nonMed=days.
recode acute(sysmis=0).
recode admin(sysmis=0).
recode nonMed(sysmis=0).

sort cases by ru case opdate.
aggregate outfile='//covenas/decisionsupport/URagg.sav'
	/break=RU case opdate
	/Acute=sum(acute)
	/Admin=sum(admin)
	/NonMed= sum(nonMed).


get file='//covenas/decisionsupport/epsCG.sav' /keep ru case opdate epFlag closDate .
formats closdate opdate(datetime23).
select if opdate ge DBStartDate OR (Closdate ge DBStartDate or missing(closdate)).

match files /table='//covenas/decisionsupport/ruTable.sav '/file=* /by ru/keep ru case opdate closDate psmask2 program svctype.
recode program(sysmis=0).
select if program=0.
if any(psMask2,513,550) keep=1.

*keep = Connected to Intensive Service.

if SvcType="TBS" keep=1.

*project permance.
if ru = "01FB1" keep=1.

*1959. 
if any(ru,"01DW2", "81934") keep=1.

*Catch 21.
if ru = "81935" keep=1.

*Children's level 1 and DayTx.
if any(psmask2, 65537,262145)  keep=1.

**CollabCourt, MST?.
if any(ru,"01DY1","01DY2") keep=1.

*prep.
 * select if index(provname,"PREP") gt 0.
 * FFYC EXPLORE PREP SCH MHS CH	600	.
if ru = "018442" keep=1.
 * ALT FAM SRV EMANCIP PREP CHILD	524289	.
if ru = "01DA1" keep=1.
*E BAY COMM PREP SUTRO MH TAY		.
if ru = "01E82" keep=1.
*E BAY COMM PREP SAN PAB MH TAY		.
if ru = "01FF2" keep=1.
*FAMILY SVC OF SF PREP MH TAY		.
if ru = "01FV1" keep=1.
*E BAY COMM PREP FRANKLN MH TAY		.
if ru = "01GF1" keep=1.
*FAMILY SVC OF SF PREP FRKLNTAY		.
if ru = "01GG1" keep=1.


select if keep=1.

rename vars Opdate = TeamOpDate ClosDate = TeamCloseDate.

sort cases by case.
CASESTOVARS
/id case .
compute teamopdatex=99.
compute teamclosedatex=99.

*the order is import because i need clx and ox to end their variables.
sort variables by   name.
save outfile='//covenas/decisionsupport/temp/Globteamep.sav' /drop keep program.
*get file='//covenas/decisionsupport/meinzer/temp/Globteamep.sav'.

get file='//covenas/decisionsupport/epsCG.sav' / keep ru case opdate epFlag lst_svc closDate primDx staff primarytherapist.

insert file='//covenas/decisionsupport/modules/UncookedMonth.sps'.
select if opdate lt UnCookedMonth and (opdate ge DBStartDate OR Closdate ge DBStartDate or missing(closdate)).

match files /table='//covenas/decisionsupport/ruTable.sav '/file=* /by ru/keep agency ru case opdate lst_svc closDate psmask2 PrimDx Provname uncookedmonth staff primarytherapist epFlag.

*this file is for facesheets.
save outfile='//covenas/decisionsupport/temp/GlobalFaceSheet.sav'.
select if psMask2=5.

save outfile='//covenas/decisionsupport/temp/GlobalHospers.sav'.

include file='//covenas/decisionsupport/modules/CalOpdate.sps'.
sort cases by case calendar.
match files /table='//covenas/decisionsupport/MEdicalTable.sav' /file=* /by Case calendar.

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

aggregate outfile=* 
   /break= ru case opdate closdate InsystPrimAidCode InMedsTable  calendar Full lst_svc  PrimDx provname
   /SvcTeamClient=max(SvcTeamClient).

if full=1 AND inMedsTable=1 HasMediCal=1.

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
exe.
rename variables primDx=Dx.
exe.
sort cases by dx.
match files/table='//covenas/decisionsupport/dx_Table2.sav'/file=* /by dx /drop SPMI potSpMI dx_grpadult.
*childhood other dxtablechild?.

sort cases by case.
match files/table='//covenas/decisionsupport/clinfoCG.sav' /file=* /by case /drop name ssn CLIENT_STAMP birthName cin.
save outfile='//covenas/decisionsupport/temp/GlobalEpsAdmitsDC.sav' /drop Full InMedsTable calendar .

if opdateNext = 0 OpDateNext = date.dmy(01,01,2020).
compute AdmitAge = Trunc((xdate.tday(Opdate) - xdate.tday(bday))/365.25).

string AgeGroup(a20).
if AdmitAge le 17 AND ru ne "01011"  AgeGroup = "a. 0-17".
if AdmitAge ge 18 AgeGroup = "b. 18-24".
if AdmitAge ge 25 AgeGroup = "c. 25-59".
if AdmitAge ge 60 AgeGroup = "d. 60 and over".
if  ageGroup = " " AgeGroup = "c. 25-59".

STRING TayAgeGroup(a20).
if AdmitAge ge 18 and admitage lt 21 TayAgeGroup = "b. 18-20".
if AdmitAge ge 21 and admitage lt 25 TayAgeGroup = "c. 21-24".
if tayagegroup ne "" TaySelect=1.

STRING ChildAgeGroup(a20).
if admitage lt 6 AND ru ne "01011" ChildAgeGroup = "a. 0-5".
if AdmitAge ge 6 and admitage lt 12 ChildAgeGroup = "b. 6-11".
if AdmitAge ge 12 and admitage lt 18 ChildAgeGroup = "c. 12-17".
if ChildAgeGroup ne ' ' ChildSelect=1.

STRING OAAgeGroup(a20).
IF AdmitAge ge 55 and AdmitAge lt 60 OAAgeGroup="a. 55-59".
IF AdmitAge ge 60 and AdmitAge lt 65 OAAgeGroup="b. 60-64".
IF AdmitAge ge 65 and AdmitAge lt 70 OAAgeGroup="c. 65-69".
IF AdmitAge ge 70 and AdmitAge lt 75 OAAgeGroup="d. 70-74".
IF AdmitAge ge 75 and AdmitAge lt 80 OAAgeGroup="e. 75-79".
IF AdmitAge ge 80 OAAgeGroup="f. 80 or Older".
if OAAgeGroup ne ' ' OAselect=1.

string AdultAgeGroup(a20).
if AdmitAge ge 18 AdultAgeGroup = "a. 18-24".
if AdmitAge ge 25 AdultAgeGroup = "b. 25-39".
if AdmitAge ge 40 AdultAgeGroup = "c. 40-54".
if AdmitAge ge 55 AdultAgeGroup = "d. 55-59".
if AdmitAge ge 60 AdultAgeGroup = "e. 60 and over".
if AdmitAge le 17 AND ru = "01011"  AdultAgeGroup = "b. 25-39".
if AdultAgeGroup ne '' AdultSelect=1.

*STOPPED HERE.

If Provname = "JOHN GEORGE PSY SVS INPATIENT" childselect = $sysmis.
If Provname = "TELECARE WILLOW ROCK PHF CHILD" adultselect=$sysmis.

*If Provname = "ST HELENA HOSP CTR BEHAV HLTH" adultselect=$sysmis.
*if provname =  "EDEN HOSPITAL" childselect=$sysmis.
*If Provname = "JOHN MUIR BEHAVIORAL HLTH CTR" adultselect=$sysmis.

rename variables opdate=HospOpDate.
rename variables provname=HospProvname.
rename variables ClosDate= HospCloseDate.
rename vars ru=hospru.

save outfile='//covenas/decisionsupport/temp/GlobHospepx.sav'.

get file='//covenas/decisionsupport/dbsvc.sav' /keep case svcdate proced ru  opdate agency provname psMask2 svcage closdate proclong primarytherapist staff bday calendar epflag.
insert file='//covenas/decisionsupport/modules/noshow.sps'.

insert file='//covenas/decisionsupport/modules/UncookedMonth.sps'.
*sort cases by ru case opdate svcdate provname agency psMask2 bday calendar.

TEMPORARY.
select if svcdate gt datesum(UnCookedMonth,-2,'years').  
save outfile='//covenas/decisionsupport/temp/Glob_svcs.sav' /keep ru case opdate closdate proclong svcdate epflag PrimaryTherapist staff Agency provname UnCookedMonth.

temp.
select if psMask2=5 and Svcdate ge DBStartDate.
save outfile='//covenas/decisionsupport/temp/adult_HospDays_topgraph.sav' /keep ru case opdate svcdate provname agency psMask2 bday calendar.

select if svcdate lt UnCookedMonth and svcdate gt DBStartDate.
select if PsMask2 ne 5.

save outfile='//covenas/decisionsupport/temp/adultssvcwork.sav'.
get file='//covenas/decisionsupport/temp/adultssvcwork.sav'.

if any(RU, "01GH1","81203","81163")  
OR (agency = "Crisis Response" and any(proced,371,690)) 
OR agency = "CJ Mental Health" UrgentSvc=1.

compute svcdate = xdate.date(svcdate).
sort cases by ru case svcdate UrgentSvc.
match files/file=* /by ru case svcdate/last=visit1 /drop closdate proclong epflag primarytherapist staff.
select if visit1=1.

if ru = "01016" CrisisSvc=1.

*taking out urgent and some.
if any(PsMask2,34,17,19,33) drop=1.

*if psmask2 =700 drop=1.
if ru ne "01193" AND psmask2=4097 Drop=1.

*Assessment Center.
if any(ru,"01DW1", "81933") drop=1.

*SENECA MOBILE RESP TEAM MHS CH  .
if RU = "811825" drop=1.

if ru = "765001" drop=1.
if ru = "01871" drop=1.
if ru = "01013" drop=1.
if agency = "Vocational" drop =1.
select if missing(Drop).
 * save outfile='//covenas/decisionsupport/temp/fusvccheck.sav'.
 * get file='//covenas/decisionsupport/temp/fusvccheck.sav'.

if any(Psmask2,17,19,9) OR provname = "BACS WOODROE PLACE MHS" SubAcuteSvc=1.
recode UrgentSvc CrisisSvc SubAcuteSvc(sysmis=0).
if urgentSvc+CrisisSvc+SubAcuteSvc =0 FUsvc=1.

 * sort cases by drop.
 * split file by drop.
 * freq fusvc.
*is this correct, that we drop first then keep only fusvc to get rid of urgent/crisis/.
select if fusvc=1.

match files /file=* /drop psmask2  proced visit1 uncookedmonth opdate svcage urgentSvc CrisisSvc SubAcuteSvc.

sort cases by case.
CASESTOVARS
/id case
/drop bday calendar.
string rux(a6).
string AgencyX(a40).
string Provnamex(a30).

compute opdatex=99.
compute rux='99'.
compute svcdatex=99.
compute Agencyx='99'.
compute provnamex='99'.
sort variables by name.

save outfile='//covenas/decisionsupport/temp/ServicesByTypeWide.sav'.
*get file='//covenas/decisionsupport/temp/ServicesByTypeWide.sav'.

get file='//covenas/decisionsupport/temp/GlobHospepx.sav'.
match files /table='//covenas/decisionsupport/temp/ServicesByTypeWide.sav'/file=* /by case.
*match files /table=* /file='//covenas/decisionsupport/temp/GlobHospepx.sav' /by case.
recode svcdate.1(sysmis=-99).
VARSTOCASES
/make svcdate from svcdate.1 to svcdatex
/make ru from ru.1 to rux
/make Provname from provname.1 to provnamex
/make Agency from agency.1 to agencyx.

select if svcdate ne 99.
recode svcdate(-99=Sysmis).
*compute FUsvc=1.

save outfile='//covenas/decisionsupport/meinzer/temp/tempglobal.sav'.
*get file='//covenas/decisionsupport/meinzer/temp/tempglobal.sav'.

*if JOHN GEORGE PSY SVS EMERGENCY within one day of svc, drop.
*consider -1,0 as last 2 arguements.

*if range(xdate.tday(Svcdate) - xdate.tday(OpDateNext),-1,1) AND hospru = "01016" Drop=1.

select if svcdate ge (HospClosedate-1).
compute lapse = xdate.tday(svcdate) - (xdate.tday(HospClosedate)-1).
select if lapse le 90.

if xdate.tday(svcdate) lt xdate.tday(OpDateNext) AND lapse lt 8 AND FUsvc=1 Latent7=1.
if xdate.tday(svcdate) lt xdate.tday(OpDateNext) AND lapse lt 31 AND FUsvc=1 Latent30=1.

aggregate outfile='//covenas/decisionsupport/temp/HospPostSvc.sav'
	/break= case hospRU HospOpdate
	/latent7 = max(latent7)
	/Latent30 = max(Latent30).

save outfile='//covenas/decisionsupport/temp/GlobHospPostSvc_Latency.sav' /keep case FUsvc bday sex dx dx_descr  dx_grpDSM  hospru HospOpDate HospCloseDate InMedsTable  calendar Full  HospProvname 
SvcTeamClient HasMediCal OpDateNext OpDatePrevious AdmitAge TayAgeGroup ChildAgeGroup OAAgeGroup AdultAgeGroup agegroup TaySelect ChildSelect OAselect  AdultSelect   svcdate ru Provname Agency lapse Latent7 Latent30  .

get file='//covenas/decisionsupport/temp/GlobHospepx.sav'.
sort cases by case hospRU hospOpdate.
match files/table='//covenas/decisionsupport/temp/HospPostSvc.sav' /file=* /by case hospRU hospOpdate.

if xdate.tday(OpdateNext) ne yrmoda(2020,01,01) AND xdate.tday(OpdateNext) - xdate.tday(HospCloseDate) lt 11 HospRecid10=1.
if xdate.tday(OpdateNext) ne yrmoda(2020,01,01) AND xdate.tday(OpdateNext) - xdate.tday(HospCloseDate) lt 31 HospRecid30=1.

compute calendar = date.moyr(xdate.month(HospCloseDate),xdate.year(HospCloseDate)).
formats calendar(moyr6).

compute LOS = xdate.tday(HospCloseDate) - xdate.tday(HospOpDate)+1.

save outfile='//covenas/decisionsupport/temp/GlobHospResults_WORK.sav'.
aggregate outfile=*
	/break=case HOSPRU HospOpdate HospCloseDate HospProvname dx dx_descr dx_grpDSM bday sex HasMediCal LOS TayAgeGroup 
ChildAgeGroup OAAgeGroup AdultAgeGroup agegroup TaySelect ChildSelect OAselect  AdultSelect  SvcTeamClient
	/Latent7 = max(Latent7)
	/Latent30= max(latent30)
	/HospRecid10= max(HospRecid10)	
	/HospRecid30= max(HospRecid30)	.		

compute DischargeAge = Trunc((xdate.tday(HospClosedate) - xdate.tday(bday))/365.25).
recode Latent7 Latent30  HospRecid10 HospRecid30 	(sysmis=0).
recode HasMediCal SvcTeamClient (sysmis=0).

compute counter=1.
compute DischargeMonth = date.moyr(xdate.month(HospCloseDate), xdate.year(hospCloseDate)).
formats DischargeMonth (moyr6).

save outfile='//covenas/decisionsupport/dashboarddatasets/GlobalHospitalEpisodesWork.sav'.
*get file='//covenas/decisionsupport/dashboarddatasets/GlobalHospitalEpisodesWork.sav'.

insert file='//covenas/decisionsupport/modules/UncookedMonth.sps'.

if hospclosedate gt datesum(UnCookedMonth,-2,'months') possiblefu30=0.
if hospclosedate le datesum(UnCookedMonth,-2,'months') possiblefu30=1.

If hospProvname = "ALTA BATES/HERRICK MEDICAL CTR" HospProvname = "Alta Bates".
If hospProvname = "BEHAVIORAL HEALTH CARE FREMONT" HospProvname = "Fremont".
If hospProvname = "EDEN HOSPITAL" HospProvname = "Eden".
If hospProvname = "JOHN GEORGE PSY SVS INPATIENT" HospProvname = "John George".
If hospProvname = "JOHN MUIR BEHAVIORAL HLTH CTR" HospProvname = "John Muir".
If hospProvname = "OUT-OF-COUNTY HOSPITAL" HospProvname = "Out of County".
If hospProvname = "TELECARE WILLOW ROCK PHF CHILD" HospProvname = "Willow Rock".
If hospProvname = "ST HELENA HOSP CTR BEHAV HLTH" HospProvname = "St Helena".
if hospprovname = "ST MARY'S HOSPITAL MEDICAL CTR" HospProvname = "Saint Mary’s".
*If hospProvname = "ST HELENA HOSP CTR BEHAV HLTH" HospProvname = "Out of County".

rename vars HospOpDate = Opdate HospRU=RU.
sort cases by ru case opdate.
match files/table='//covenas/decisionsupport/URagg.sav' /file=* /by ru case opdate.
*get file='//covenas/decisionsupport/URagg.sav'.

Temp.
select if LOS Gt 29.
aggregate outfile=* Mode=AddVars /break=ru case opdate /LongLOS = sum(Counter).

*isn't the sort order the same as LOS?.
string LOStext(a10).
compute LOStext =string(los,f3).
if longlos =1 LOStext="30+".

rename vars opdate = HospOpdate.

recode  latent7 Latent30 SvcTeamClient HasMedical(sysmis=0).
string Latent7Client Latent30Client SvcClient HasMedicalText Gender HospRecidText10 HospRecidText30 (a22).
if latent7=1 Latent7Client='Yes'.
if latent7=0  latent7client='No'.
if Latent30=0 latent30client='No'.
if Latent30=1 Latent30Client='Yes'.
if SvcTeamClient=0 SvcClient='Not Case Managed'.
if SvcTeamClient=1 SvcClient='Case Managed'.
if HasMedical=0 HasMedicalText='None'.
if HasMedical=1 HasMedicalText='Medi-Cal'.
if sex='M' Gender='Male'.
if sex='F' Gender='Female'.
if sex='U' Gender='Unknown'.
if HospRecid10 =0 HospRecidText10='No'.
if HospRecid10 =1 HospRecidText10='Yes'.
if HospRecid30  =0 HospRecidText30='No'.
if HospRecid30  =1 HospRecidText30='Yes'.

*save outfile='//covenas/decisionsupport/meinzer/temp/adult30.sav'.
compute possibleLOS30=1.
if missing(hospclosedate) PossibleLOS30 =0.
match files /file=* /drop sex.
sort cases by case.
match files/table='//covenas/spssdata/clinfo.sav' /file=* /by case /drop created ssn disab educ minors language marital cin bornname.
insert file='//covenas/decisionsupport/modules/ethnicity.sps'.

save outfile='//covenas/decisionsupport/temp/GlobHosp_episodes.sav'.
*get file='//covenas/decisionsupport/temp/GlobHosp_episodes.sav'.

save outfile='//covenas/decisionsupport/meinzer/temp/AdultHospital_EpisodesCooked_LOS.sav' /keep ru case HospOpdate HospCloseDate HospProvname dx dx_descr dx_grpDSM bday sex HasMediCal LOS LongLOS  LOStext HasMedicalText
TayAgeGroup ChildAgeGroup OAAgeGroup AdultAgeGroup agegroup TaySelect ChildSelect OAselect  AdultSelect  SvcTeamClient Latent7 Latent30  HospRecid10 HospRecid30 HospRecidText10 HospRecidText30
DischargeAge Latent7Client Latent30Client SvcClient DischargeMonth Gender ethnicity name.

*pushbreak.
*sqlTable = 'AdultHospital_EpisodesCooked_LOS'.
*spsstable='//covenas/decisionsupport/meinzer/temp/AdultHospital_EpisodesCooked_LOS.sav'.
*pushbreak.

select if hospCloseDate lt datesum(UnCookedMonth,-1,'months').

*save outfile='//covenas/decisionsupport/meinzer/temp/AdultHospital_LatentReced.sav' /keep  ru case HospOpdate HospCloseDate HospProvname dx dx_descr dx_grpDSM bday sex 
HasMediCal LOS TayAgeGroup ChildAgeGroup OAAgeGroup AdultAgeGroup agegroup TaySelect ChildSelect OAselect  AdultSelect  SvcTeamClient Latent7 Latent30 
HospRecid10 HospRecid30 HospRecidText10 HospRecidText30 DischargeAge LongLOS Latent7Client Latent30Client SvcClient DischargeMonth HasMedicalText Gender ethnicity name.
 * get file='//covenas/decisionsupport/meinzer/temp/AdultHospital_LatentReced.sav'.

save outfile='//covenas/decisionsupport/meinzer/temp/adulthospwork_2.sav' /keep name ru case HospOpdate HospCloseDate HospProvname dx dx_descr dx_grpDSM bday sex HasMediCal LOS 
TayAgeGroup ChildAgeGroup OAAgeGroup AdultAgeGroup agegroup TaySelect ChildSelect OAselect  AdultSelect  SvcTeamClient Latent7 Latent30 HospRecidText10 HospRecidText30
HospRecid10 HospRecid30 DischargeAge LongLOS Latent7Client Latent30Client SvcClient DischargeMonth HasMedicalText Gender ethnicity.

*pushbreak.
*sqlTable = 'AdultHospital_LatentRecid'.
*spsstable='//covenas/decisionsupport/meinzer/temp/adulthospwork_2.sav'.
*pushbreak.


recode acute admin nonMed(sysmis=0).

do if hospCloseDate ge DateSum(UnCookedMonth,-3,"months").
compute acute=$sysmis.
compute admin=$sysmis.
compute NonMed=$sysmis.
end if.
exe.

compute KnownDays = acute+admin+nonMed.
compute MissingDays = (xdate.tday(HospCloseDate) - xdate.tday(HospOpdate))-KnownDays.

*freq MissingDays.  

* this section says if I cannot speak to how the day is tipified, I will not speak to the day at all.
*This is the ruleset for acute hospitalization drill through. 
*select if KnownDays ge 1.

select if hospCloseDate lt DateSum(UnCookedMonth,-3,"months").

*the acute authorization does not work.
*we should probably make datasets for it.

save outfile='//covenas/decisionsupport/meinzer/temp/AdultHospital_AcuteAuthorization.sav' /keep ru case HospOpdate Acute Admin NonMed  HospCloseDate HospProvname sex Gender HospRecidText10 HospRecidText30
HasMediCal LOS TayAgeGroup ChildAgeGroup OAAgeGroup AdultAgeGroup agegroup TaySelect ChildSelect OAselect  AdultSelect  SvcTeamClient SvcClient KnownDays MissingDays HasMedicalText dx_grpDSM.

*pushbreak.
*sqlTable = 'AdultHospital_AcuteAuthorization'.
*spsstable='//covenas/decisionsupport/meinzer/temp/AdultHospital_AcuteAuthorization.sav'.
*pushbreak.

get file='//covenas/decisionsupport/temp/adult_HospDays_topgraph.sav'.

select if Svcdate ge DBStartDate.

insert file='//covenas/decisionsupport/modules/UncookedMonth.sps'.

select if svcdate lt UnCookedMonth.

compute svcdate = xdate.date(svcdate).
sort cases by ru case svcdate.
match files/file=* /by ru case svcdate/last=visit1.
select if visit1=1.

compute HospDay=1.

aggregate outfile='//covenas/decisionsupport/temp/TopGraphGlobalHospdays.sav'
   /break = ru case opdate calendar 
   /HospitalDays=sum(HospDay).

***********************************.
get file='//covenas/decisionsupport/temp/GlobHosp_episodes.sav'.

select if latent30=0 and not missing(hospclosedate).

sort cases by case.
match files /file=* /drop sex.
match files /table='//covenas/spssdata/clinfo.sav' /file=* /by case
 /drop bornname language disab educ created cin marital minors ssn possiblefu30. 

insert file= '//covenas/decisionsupport/modules/ethnicity.sps'.

match files /file=*/drop raceethnicitycode hispanic.

compute createDate = $time.
formats createDate(datetime17).

compute NoLatencyCare=1.

*For adult hospital dashboard.


save outfile='//covenas/decisionsupport/temp/NoLatencyCareDetailAdultHospWork.sav' /keep=case name hospopdate hospclosedate hospprovname dischargeage createdate 
SvcTeamClient SvcClient Ethnicity sex DischargeMonth TayAgeGroup ChildAgeGroup OAAgeGroup AdultAgeGroup agegroup TaySelect ChildSelect OAselect  AdultSelect  
hasmedicaltext Gender dx_grpdsm.

get file =  '//covenas/decisionsupport/MedicalData/MedsCurrentUncut.sav'.
save outfile= '//covenas/decisionsupport/Temp/MedsCurrentUncutCity.sav' /keep CIN City.

get file ='//covenas/decisionsupport/temp/NoLatencyCareDetailAdultHospWork.sav'.
sort cases by case.
match files /table='//covenas/decisionsupport/addressmhs.sav' /file=* /by case.
rename vars city=CityInsyst.
match files /table= '//covenas/spssdata/clinfo.sav' /file=* /by case.
sort cases by CIN.
match files /table= '//covenas/decisionsupport/Temp/MedsCurrentUncutCity.sav' /file=* /by CIN.

If City=" " City= CityInsyst.

save outfile='//covenas/decisionsupport/temp/NoLatencyCareDetailAdultHosp.sav' /keep=case name hospopdate hospclosedate hospprovname dischargeage createdate 
SvcTeamClient SvcClient Ethnicity sex DischargeMonth TayAgeGroup ChildAgeGroup OAAgeGroup AdultAgeGroup agegroup TaySelect ChildSelect OAselect  AdultSelect  
hasmedicaltext Gender dx_grpdsm City.

*pushbreak.
*sqlTable = 'AdultHospital_NoLatencyCareDetail'.
*spsstable='//covenas/decisionsupport/temp/NoLatencyCareDetailAdultHosp.sav'.
*pushbreak.

get file='//covenas/decisionsupport/temp/GlobalEpsAdmitsDC.sav'.

insert file='//covenas/decisionsupport/meinzer/modules/explodemonth.sps'.

if closdate ge datesum($time,1,'days') closdate=$sysmis.
if calendar = date.moyr(xdate.month(opdate),xdate.year(opdate)) Admit=1.
if calendar =date.moyr(xdate.month(closdate), xdate.year(closdate)) Discharge=1.

sort cases by ru case opdate calendar.
match files /table='//covenas/decisionsupport/temp/TopGraphGlobalHospdays.sav' /file=* /by ru case opdate calendar.

insert file='//covenas/decisionsupport/modules/uncookedmonth.sps'.
select if calendar lt UnCookedMonth.

rename Vars Opdate = HospOpDate Provname = HospProvName RU = HospRU.

recode  SvcTeamClient HasMedical(sysmis=0).
string  SvcClient HasMedicalText Gender(a22).
if SvcTeamClient=0 SvcClient='Not Case Managed'.
if SvcTeamClient=1 SvcClient='Case Managed'.
if HasMedical=0 HasMedicalText='None'.
if HasMedical=1 HasMedicalText='Medi-Cal'.
if sex='M' Gender='Male'.
if sex='F' Gender='Female'.
if sex='U' Gender='Unknown'.

compute AdmitAge = Trunc((xdate.tday(hospOpdate) - xdate.tday(bday))/365.25).

string AgeGroup(a20).
if AdmitAge le 17 AND hospru ne "01011"  AgeGroup = "a. 0-17".
if AdmitAge ge 18 AgeGroup = "b. 18-24".
if AdmitAge ge 25 AgeGroup = "c. 25-59".
if AdmitAge ge 60 AgeGroup = "d. 60 and over".
if  ageGroup = " " AgeGroup = "c. 25-59".

STRING TayAgeGroup(a20).
if AdmitAge ge 18 and admitage lt 21 TayAgeGroup = "b. 18-20".
if AdmitAge ge 21 and admitage lt 25 TayAgeGroup = "c. 21-24".
if tayagegroup ne "" TaySelect=1.

STRING ChildAgeGroup(a20).
if admitage lt 6 AND hospru ne "01011" ChildAgeGroup = "a. 0-5".
if AdmitAge ge 6 and admitage lt 12 ChildAgeGroup = "b. 6-11".
if AdmitAge ge 12 and admitage lt 18 ChildAgeGroup = "c. 12-17".
if ChildAgeGroup ne ' ' ChildSelect=1.

STRING OAAgeGroup(a20).
IF AdmitAge ge 55 and AdmitAge lt 60 OAAgeGroup="a. 55-59".
IF AdmitAge ge 60 and AdmitAge lt 65 OAAgeGroup="b. 60-64".
IF AdmitAge ge 65 and AdmitAge lt 70 OAAgeGroup="c. 65-69".
IF AdmitAge ge 70 and AdmitAge lt 75 OAAgeGroup="d. 70-74".
IF AdmitAge ge 75 and AdmitAge lt 80 OAAgeGroup="e. 75-79".
IF AdmitAge ge 80 OAAgeGroup="f. 80 or Older".
if OAAgeGroup ne '' OAselect=1.

string AdultAgeGroup(a20).
if AdmitAge ge 18 AdultAgeGroup = "a. 18-24".
if AdmitAge ge 25 AdultAgeGroup = "b. 25-39".
if AdmitAge ge 40 AdultAgeGroup = "c. 40-54".
if AdmitAge ge 55 AdultAgeGroup = "d. 55-59".
if AdmitAge ge 60 AdultAgeGroup = "e. 60 and over".
if AdmitAge le 17 AND hospru = "01011"  AdultAgeGroup = "b. 25-39".
if AdultAgeGroup ne '' AdultSelect=1.

If hospProvname = "JOHN GEORGE PSY SVS INPATIENT" childselect = $sysmis.
If hospProvname = "TELECARE WILLOW ROCK PHF CHILD" adultselect=$sysmis.

If hospProvname = "ALTA BATES/HERRICK MEDICAL CTR" HospProvname = "Alta Bates".
If hospProvname = "BEHAVIORAL HEALTH CARE FREMONT" HospProvname = "Fremont".
If hospProvname = "EDEN HOSPITAL" HospProvname = "Eden".
If hospProvname = "JOHN GEORGE PSY SVS INPATIENT" HospProvname = "John George".
If hospProvname = "JOHN MUIR BEHAVIORAL HLTH CTR" HospProvname = "John Muir".
If hospProvname = "OUT-OF-COUNTY HOSPITAL" HospProvname = "Out of County".
If hospProvname = "TELECARE WILLOW ROCK PHF CHILD" HospProvname = "Willow Rock".
If hospProvname = "ST HELENA HOSP CTR BEHAV HLTH" HospProvname = "St Helena".
if hospprovname = "ST MARY'S HOSPITAL MEDICAL CTR" HospProvname = "Saint Mary’s".
*If hospProvname = "ST HELENA HOSP CTR BEHAV HLTH" HospProvname = "Out of County".

save outfile='//covenas/decisionsupport/temp/topgraph.sav'.

*pushbreak.
*sqlTable = 'AdultHospital_HospDays_Admits_Discharge'.
*spsstable='//covenas/decisionsupport/temp/topgraph.sav'.
*pushbreak.

*Follow up.
get file='//covenas/decisionsupport/temp/GlobHospPostSvc_Latency.sav' .

compute counter=1.
compute DischargeMonth = date.moyr(xdate.month(HospCloseDate), xdate.year(hospCloseDate)).
formats DischargeMonth (moyr6).

sort cases by ru DischargeMonth case HospOpdate.
*check.
match files/file=* /by ru DischargeMonth case /first=FUruCase1.
match files/file=* /by ru DischargeMonth case HospOpDate /first=FUruEp1.

If hospProvname = "ALTA BATES/HERRICK MEDICAL CTR" HospProvname = "Alta Bates".
If hospProvname = "BEHAVIORAL HEALTH CARE FREMONT" HospProvname = "Fremont".
If hospProvname = "EDEN HOSPITAL" HospProvname = "Eden".
If hospProvname = "JOHN GEORGE PSY SVS INPATIENT" HospProvname = "John George".
If hospProvname = "JOHN MUIR BEHAVIORAL HLTH CTR" HospProvname = "John Muir".
If hospProvname = "OUT-OF-COUNTY HOSPITAL" HospProvname = "Out of County".
If hospProvname = "TELECARE WILLOW ROCK PHF CHILD" HospProvname = "Willow Rock".
If hospProvname = "ST HELENA HOSP CTR BEHAV HLTH" HospProvname = "St Helena".
if hospprovname = "ST MARY'S HOSPITAL MEDICAL CTR" HospProvname = "Saint Mary’s".
*If hospProvname = "ST HELENA HOSP CTR BEHAV HLTH" HospProvname = "Out of County".

recode SvcTeamClient HasMedical(sysmis=0).
string  SvcClient HasMedicalText Gender(a22).
if SvcTeamClient=0 SvcClient='Not Case Managed'.
if SvcTeamClient=1 SvcClient='Case Managed'.
if HasMedical=0 HasMedicalText='None'.
if HasMedical=1 HasMedicalText='Medi-Cal'.
if sex='M' Gender='Male'.
if sex='F' Gender='Female'.
if sex='U' Gender='Unknown'.

aggregate outfile='//covenas/decisionsupport/DashboardDataSets/AdultFollowUpCareDetail.sav'
	/break=DischargeMonth  Ru Provname  HospProvname  case hospOpdate HospCloseDate TayAgeGroup ChildAgeGroup OAAgeGroup AdultAgeGroup agegroup TaySelect ChildSelect OAselect  AdultSelect  gender hasmedical dx_grpdsm admitage
	/Latent7 = max(Latent7)
	/Latent30= max(Latent30)
	/Visits =sum(counter)
	/SvcClient=max(SvcClient)
	/HasMedicalText=max(HasMedicalText)
	/SvcTeamClient=max(SvcTeamClient).

aggregate outfile=*
	/break=DischargeMonth  Ru Provname  HospProvname  case hospOpdate HospCloseDate TayAgeGroup ChildAgeGroup OAAgeGroup AdultAgeGroup agegroup TaySelect ChildSelect OAselect  AdultSelect  SvcClient hasmedicaltext gender hasmedical dx_grpdsm
	/Clients = sum(FURUcase1)
	/DischargeEps = sum(FURUep1).

compute createDate = $time.
formats createDate(date11).

rename vars 
Hospprovname=HospitalProviderName .

sort cases by case.
match files /table ='//covenas/spssdata/clinfo.sav' /file=*  /by case /keep ethnic hispanic DischargeMonth ru Provname HospitalProviderName case HospOpDate HospCloseDate TayAgeGroup
ChildAgeGroup OAAgeGroup AdultAgeGroup AgeGroup TaySelect ChildSelect OAselect AdultSelect SvcClient HasMedicalText Gender HasMediCal dx_grpDSM Clients
DischargeEps createDate.
insert file='//covenas/decisionsupport/modules/ethnicity.sps'.
match files /file=* /drop RaceEthnicityCode hispanic.
save outfile='//covenas/decisionsupport/meinzer/temp/adulthosfollowupru.sav'.

*pushbreak.
*sqlTable = 'AdultHosp_FollowUpRus'.
*spsstable='//covenas/decisionsupport/meinzer/temp/adulthosfollowupru.sav'.
*pushbreak.

get file='//covenas/decisionsupport/DashboardDataSets/AdultFollowUpCareDetail.sav'.

compute createDate = $time.
formats createDate(datetime17).

sort cases by case.
match files /table='//covenas/spssdata/clinfo.sav' /file=* /by case /drop  bornname language disab educ created cin marital minors ssn.
insert file= '//covenas/decisionsupport/modules/ethnicity.sps'.
match files/file=*/drop raceethnicitycode hispanic.

compute DischargeAge = Trunc((xdate.tday(hospClosedate) - xdate.tday(bday))/365.25).

recode latent7 latent30 SvcTeamClient (sysmis=0).
rename vars 
hospopdate=HospitalOpDate 
HospCloseDate = HospitalCloseDate 
Hospprovname=HospitalProvName.

formats createDate(date11).

string Latent7client Latent30client (a12).
if latent7=1 Latent7Client='Yes'.
if latent7=0  latent7client='No'.
if Latent30=0 latent30client='No'.
if Latent30=1 Latent30Client='Yes'.

sort cases by ru.
match files /table="//covenas/decisionsupport/rutable.sav" /file=* /by ru /keep psmask2 Ethnicity case name Gender bday DischargeAge DischargeMonth RU provname HospitalProvName 
HospitalOpDate HospitalCloseDate admitage TayAgeGroup ChildAgeGroup OAAgeGroup AdultAgeGroup agegroup TaySelect ChildSelect OAselect  AdultSelect 
Visits SvcTeamClient createDate Latent7Client Latent30Client  SvcClient HasMedicalText hasmedical dx_grpdsm.

*day treatment?.
 * select if not psmask2=257.

save outfile='//covenas/decisionsupport/meinzer/temp/adulthosfollowuprudetailx.sav'.

*pushbreak.
*sqlTable = 'AdultHosp_FollowUpCareDetail'.
*spsstable='//covenas/decisionsupport/meinzer/temp/adulthosfollowuprudetailx.sav'.
*pushbreak.

*** face sheet code. 
*What eps do i want? this file has eps since dbstart date.

*global face sheet is everyone.

add files
	/file='//covenas/decisionsupport/temp/GuidanceClinicALLkids.sav'
	/file='//covenas/decisionsupport/temp/GlobalHospers.sav'.
compute keepMe=1.
aggregate outfile='//covenas/decisionsupport/temp/Adult_or_global_KeepEps.sav' 
   /break=case
   /keepMe=max(keepMe).

*this file still has uncooked svcs and is only 2 years of svcs.
get file='//covenas/decisionsupport/temp/Glob_svcs.sav' .

sort cases by case.
match files/table='//covenas/decisionsupport/temp/Adult_or_global_KeepEps.sav' /file=* /by case.
select if keepme=1.
match files/table='//covenas/spssdata/clinfo.sav'//file=* /by case/drop sex .
rename vars name = ClientName.
sort cases by staff.
match files /table='//covenas/decisionsupport/staff.sav' /file=* /by staff.
rename vars Name = StaffName.


 * aggregate outfile='//covenas/decisionsupport/temp/EpsAdult.sav'
   /break=ClientName RU case opdate epflag PrimaryTherapist agency provname 
  	/closedate  = max(closdate) 
   /LastSvc = max(Svcdate).


save outfile='//covenas/decisionsupport/temp/Adult_Svcsx.sav' /keep ru case opdate agency provname StaffName proclong svcdate ClientName .

*pushbreak.
*sqlTable = 'adult_allSVCSforLastSvc90Clients'.
*spsstable='//covenas/decisionsupport/temp/adult_Svcsx.sav'.
*pushbreak.



get file='//covenas/decisionsupport/temp/GlobalFaceSheet.sav'.

sort cases by case.
match files /table='//covenas/decisionsupport/temp/Adult_or_global_KeepEps.sav'  /file=* /by case.
 * select if NoSVCClient=1.
match files/table='//covenas/decisionsupport/clinfoCG.sav'//file=* /by case/drop sex .
rename vars name = ClientName.
sort cases by staff.
match files /table='//covenas/decisionsupport/staff.sav' /file=* /by staff.
rename vars Name = StaffName.

save outfile='//covenas/decisionsupport/temp/GlobalHospEps.sav' /keep ru case opdate agency provname StaffName ClientName primarytherapist Lst_Svc closdate.


*pushbreak.
*sqlTable ='adult_allSVCSforLastSvc90Clients'.
*spsstable='//covenas/decisionsupport/temp/GlobalHospEps.sav'.
*pushbreak.

*pushbreak.
*sqlTable = 'CSOCTerms'.
*spsstable='//covenas/decisionsupport/TermsAndDefinitionsForEmanio.sav'.
*pushbreak.
