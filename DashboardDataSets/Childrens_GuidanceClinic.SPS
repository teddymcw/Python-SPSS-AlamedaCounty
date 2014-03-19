*removed lst_Svc and PrimDX and EpFlag b/c the adjusted episodes need finesse to fix those.
DEFINE StartDateGC() date.dmy(1,1,2011) !ENDDEFINE.
get file='//covenas/decisionsupport/epsCG.sav' / keep ru case opdate closDate.

match files /table='//covenas/decisionsupport/ruTable.sav '/file=* /by ru/keep agency ru case opdate closDate psmask2 Provname.
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

select if opdate lt UnCookedMonth and (Closdate ge StartDateGC or sysmis(closdate)).

match files/table='//covenas/decisionsupport/temp\KidTeamEp1.sav' /file=* /by case.
if xdate.tday(TeamOpdate) lt xdate.tday(opdate) AND xdate.tday(TeamCloseDate) ge xdate.tday(opdate) FspSvcTeamClient=1.
match files/table='//covenas/decisionsupport/temp\KidTeamEp2.sav' /file=* /by case.
if xdate.tday(TeamOpdate) lt xdate.tday(opdate) AND xdate.tday(TeamCloseDate) ge xdate.tday(opdate) FspSvcTeamClient=1.
match files/table='//covenas/decisionsupport/temp\KidTeamEp3.sav' /file=* /by case.
if xdate.tday(TeamOpdate) lt xdate.tday(opdate) AND xdate.tday(TeamCloseDate) ge xdate.tday(opdate) FspSvcTeamClient=1.
match files/table='//covenas/decisionsupport/temp\KidTeamEp4.sav' /file=* /by case.
if xdate.tday(TeamOpdate) lt xdate.tday(opdate) AND xdate.tday(TeamCloseDate) ge xdate.tday(opdate) FspSvcTeamClient=1.

if closdate gt $time closdate=$sysmis.
freq FspSvcTeamClient.

compute calendar = date.moyr(xdate.month(closdate), xdate.year(closdate)).
formats calendar (moyr6).

sort cases by case calendar.
match files/table='//covenas/decisionsupport/MEdicalTable.sav' /file=* /by Case calendar.

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

*aggregate outfile=* mode=ADDVARIABLES
   /break case
   /epcount=sum(counter).

*rename variables primDx=Dx.
*sort cases by dx.
*match files/table='//covenas/decisionsupport/dx_Table2.sav'/file=* /by dx.
*compute counter=1.

*aggregate outfile=* mode=addVars /break=Case /admits=sum(counter).
*freq admits.

*freq ep1.	/*total number of hosp admissions for 2 different sections on the form.
*4298.

sort cases by case.
match files/table='//covenas/decisionsupport/clinfoCG.sav' /file=* /by case /drop name ssn CLIENT_STAMP birthName cin.
save outfile='//covenas/decisionsupport/temp\GuidanceClinicALLkids.sav' /drop 
Full InMedsTable InsystPrimAidCode eCounty calendar UserName TeamOpDate TeamCloseDate
Medical_Number medical_Eligibility_Stamp.



get file='//covenas/decisionsupport/temp\GuidanceClinicALLkids.sav'.

if opdateNext = 0 OpDateNext = date.dmy(01,01,2020).

compute AdmitAge = Trunc((xdate.tday(Opdate) - xdate.tday(bday))/365.25).
*select if admitAge lt 18.

agg outfile=* mode=addVars /break=case /records = N.
freq records.

string AgeGroup(a15).
compute ageGroup = "a. 0-5".
if AdmitAge ge 6 ageGroup = "b. 6-11".
if AdmitAge ge 12 ageGroup = "c. 12-17".

sort cases by case opdate.
match files /file=* /by case /first=HospEp1.

rename variables opdate=HospOpDate.
rename variables provname=HospProvname.
rename variables ClosDate= HospCloseDate.
rename vars ru=hospru.
*freq hospep1.	/*2790.	

TEMPORARY.
select if HospEp1=1.
save outfile='//covenas/decisionsupport/Temp\guidanceEp1K_kids.sav'
 /keep ageGroup  FspSvcTeamClient    bday sex HasMediCal hospru case hospep1 HospOpdate OpdatePrevious OpdateNext  HospProvname HospCloseDate.
select if HospEp1 = 0.
match files /file=* /by  case/first=HospEp2.

*freq hospep2.	/*793.

TEMPORARY.
select if HospEp2=1.
save outfile='//covenas/decisionsupport/Temp\guidanceEp2K_kids.sav' 
/keep ageGroup  FspSvcTeamClient    bday sex HasMediCal hospru case hospep1 HospOpdate OpdatePrevious OpdateNext  HospProvname HospCloseDate.

select if HospEp2=0.
match files /file=* /by case /first=HospEp3.
*freq hospep3.	/*350.

TEMPORARY.
select if HospEp3 = 1.
save outfile='//covenas/decisionsupport/Temp\guidanceEp3K_kids.sav' /keep FspSvcTeamClient ageGroup     bday sex HasMediCal  hospru case HospOpdate OpdatePrevious OpdateNext  HospProvname HospCloseDate.
 
select if HospEp3 =  0.
match files /file=* /by case /first=HospEp4.
freq hospep4.	/*159.

TEMPORARY.
select if HospEp4 = 1.
save outfile='//covenas/decisionsupport/Temp\guidanceEp4K_kids.sav'/keep FspSvcTeamClient ageGroup     bday sex HasMediCal  hospru case HospOpdate OpdatePrevious OpdateNext  HospProvname HospCloseDate.

select if HospEp4 =  0.
match files /file=* /by case /first=HospEp5.
freq hospep5.	/*159.

TEMPORARY.
select if HospEp5 = 1.
save outfile='//covenas/decisionsupport/Temp\guidanceEp5K_kids.sav' /keep FspSvcTeamClient ageGroup     bday sex HasMediCal  hospru case HospOpdate OpdatePrevious OpdateNext  HospProvname HospCloseDate.

 * select if HospEp5 =  0.
 * match files /file=* /by case /first=HospEp6.

 * TEMPORARY.
 * select if HospEp6 = 1.
 * save outfile='//covenas/decisionsupport/Temp\guidanceEp6K_kids.sav' /keep FspSvcTeamClient ageGroup     bday sex HasMediCal  hospru case HospOpdate OpdatePrevious OpdateNext  HospProvname HospCloseDate.

 * select if HospEp6 =  0.
 * match files /file=* /by case /first=HospEp7.
 * freq hospep7.

 * TEMPORARY.
 * select if HospEp7 = 1.
 * save outfile='//covenas/decisionsupport/Temp\guidanceEp7K_kids.sav' /keep FspSvcTeamClient ageGroup     bday sex HasMediCal  hospru case HospOpdate OpdatePrevious OpdateNext  HospProvname HospCloseDate.

 * select if HospEp7 =  0.
 * match files /file=* /by case /first=HospEp8.
 * freq hospep8.

 * TEMPORARY.
 * select if HospEp8 = 1.
 * save outfile='//covenas/decisionsupport/Temp\guidanceEp8K_kids.sav' /keep FspSvcTeamClient ageGroup     bday sex HasMediCal  hospru case HospOpdate OpdatePrevious OpdateNext  HospProvname HospCloseDate.

 * select if HospEp8 =  0.
 * match files /file=* /by case /first=HospEp9.
 * freq hospep9.

 * TEMPORARY.
 * select if HospEp9 = 1.
 * save outfile='//covenas/decisionsupport/Temp\guidanceEp9K_kids.sav' /keep FspSvcTeamClient ageGroup     bday sex HasMediCal  hospru case HospOpdate OpdatePrevious OpdateNext  HospProvname HospCloseDate.

 * select if HospEp9 =  0.
 * match files /file=* /by case /first=HospEp10.
 * freq hospep10.

 * TEMPORARY.
 * select if HospEp10 = 1.
 * save outfile='//covenas/decisionsupport/Temp\guidanceEp10K_kids.sav' /keep FspSvcTeamClient ageGroup     bday sex HasMediCal  hospru case HospOpdate OpdatePrevious OpdateNext  HospProvname HospCloseDate.

*select if HospEp10 =  0.
*match files /file=* /by case /first=HospEp11.
*freq hospep11.

*TEMPORARY.
*select if HospEp11 = 1.
*save outfile='//covenas/decisionsupport/Temp\guidanceEp11K_kids.sav'/keep FspSvcTeamClient ageGroup     bday sex HasMediCal  hospru case HospOpdate OpdatePrevious OpdateNext  HospProvname HospCloseDate.

*select if HospEp11 =  0.
*match files /file=* /by case /first=HospEp12.
*freq hospep12.

*TEMPORARY.
*select if HospEp12 = 1.
*save outfile='//covenas/decisionsupport/Temp\guidanceEp12K_kids.sav'/keep FspSvcTeamClient ageGroup     bday sex HasMediCal  hospru case HospOpdate OpdatePrevious OpdateNext  HospProvname HospCloseDate.

*select if HospEp12 =  0.
*match files /file=* /by case /first=HospEp13.
*freq hospep13.

*TEMPORARY.
*select if HospEp13 = 1.
*save outfile='//covenas/decisionsupport/Temp\guidanceEp13K_kids.sav'/keep FspSvcTeamClient ageGroup     bday sex HasMediCal  hospru case HospOpdate OpdatePrevious OpdateNext  HospProvname HospCloseDate.

*select if HospEp13 =  0.
*match files /file=* /by case /first=HospEp14.
*freq hospep14.

*TEMPORARY.
*select if HospEp14 = 1.
*save outfile='//covenas/decisionsupport/Temp\guidanceEp14K_kids.sav'/keep FspSvcTeamClient ageGroup     bday sex HasMediCal  hospru case HospOpdate OpdatePrevious OpdateNext  HospProvname HospCloseDate.

*select if HospEp14 =  0.
*match files /file=* /by case /first=HospEp15.
*freq hospep15.

*TEMPORARY.
*select if HospEp15 = 1.
*save outfile='//covenas/decisionsupport/Temp\guidanceEp15K_kids.sav'/keep FspSvcTeamClient ageGroup     bday sex HasMediCal  hospru case HospOpdate OpdatePrevious OpdateNext  HospProvname HospCloseDate.

*select if HospEp15 =  0.
*match files /file=* /by case /first=HospEp16.
*freq hospep16.

*TEMPORARY.
*select if HospEp16 = 1.
*save outfile='//covenas/decisionsupport/Temp\guidanceEp16K_kids.sav'/keep FspSvcTeamClient ageGroup     bday sex HasMediCal  hospru case HospOpdate OpdatePrevious OpdateNext  HospProvname HospCloseDate.

*select if HospEp16 =  0.
*match files /file=* /by case /first=HospEp17.
*freq hospep17.

*TEMPORARY.
*select if HospEp17 = 1.
*save outfile='//covenas/decisionsupport/Temp\guidanceEp17K_kids.sav'/keep FspSvcTeamClient ageGroup     bday sex HasMediCal  hospru case HospOpdate OpdatePrevious OpdateNext  HospProvname HospCloseDate.

*select if HospEp17 =  0.
*match files /file=* /by case /first=HospEp18.
*freq hospep18.

*TEMPORARY.
*select if HospEp18 = 1.
*save outfile='//covenas/decisionsupport/Temp\guidanceEp18K_kids.sav'/keep FspSvcTeamClient ageGroup     bday sex HasMediCal  hospru case HospOpdate OpdatePrevious OpdateNext  HospProvname HospCloseDate.

*select if HospEp18 =  0.
*match files /file=* /by case /first=HospEp19.
*freq hospep19.

*TEMPORARY.
*select if HospEp19 = 1.
*save outfile='//covenas/decisionsupport/Temp\guidanceEp19K_kids.sav'/keep FspSvcTeamClient ageGroup     bday sex HasMediCal  hospru case HospOpdate OpdatePrevious OpdateNext  HospProvname HospCloseDate.

*select if HospEp19 =  0.
*match files /file=* /by case /first=HospEp20.
*freq hospep20.

*TEMPORARY.
*select if HospEp20 = 1.
*save outfile='//covenas/decisionsupport/Temp\guidanceEp20K_kids.sav'/keep FspSvcTeamClient ageGroup     bday sex HasMediCal  hospru case HospOpdate OpdatePrevious OpdateNext  HospProvname HospCloseDate.

*select if HospEp20 =  0.
*match files /file=* /by case /first=HospEp21.
*freq hospep21.

*FOLLOWUP FOR EP1 START.

get file='//covenas/decisionsupport/temp\ServicesByType_Kid.sav'.
sort cases by case.
match files/table='//covenas/decisionsupport/Temp/guidanceEp1K_kids.sav' /file=* /by case.
select if HospProvname ne  " ".

select if xdate.tday(svcdate) ge (xdate.tday(HospClosedate)).
compute lapse = xdate.tday(svcdate) - (xdate.tday(HospClosedate)).
select if lapse lt 91.

if xdate.tday(svcdate) lt xdate.tday(OpDateNext) AND lapse lt 8 AND FUsvc=1 Latent7=1.
if xdate.tday(svcdate) lt xdate.tday(OpDateNext) AND lapse lt 31 AND FUsvc=1 Latent30=1.

agg outfile=* mode=addVars /break=ru case/gotCare = max(latent30).
select if gotCare=1.

*select if latent7=1 OR latent30=1.

agg outfile='//covenas/decisionsupport/temp/guidancePostSvc1.sav'
	/break= case hospRU HospOpdate
	/latent7 = max(latent7)
	/Latent30 = max(Latent30).

save outfile='//covenas/decisionsupport/temp/guidancePostSvc1_WORK.sav' /drop GotCare.

*get file='//covenas/decisionsupport/temp/guidancePostSvc1LASTSVC.sav'.

get file='//covenas/decisionsupport/Temp/guidanceEp1K_kids.sav'.
sort cases by case hospRU hospOpdate.
match files/table='//covenas/decisionsupport/temp/guidancePostSvc1.sav' /file=* /by case hospRU hospOpdate.
freq latent7 latent30.

if xdate.tday(OpdateNext) ne yrmoda(2020,01,01) AND xdate.tday(OpdateNext) - xdate.tday(HospCloseDate) lt 11 HospRecid10=1.
if xdate.tday(OpdateNext) ne yrmoda(2020,01,01) AND xdate.tday(OpdateNext) - xdate.tday(HospCloseDate) lt 31 HospRecid30=1.

compute calendar = date.moyr(xdate.month(HospCloseDate),xdate.year(HospCloseDate)).
formats calendar(moyr6).

compute LOS = xdate.tday(HospCloseDate) - xdate.tday(HospOpDate)+1.

save outfile='//covenas/decisionsupport/temp/guidanceResults1_WORK.sav'.
aggregate outfile='//covenas/decisionsupport/temp/guidanceResults1_kids.sav'
	/break=case HOSPRU HospOpdate HospCloseDate HospProvname    bday sex HasMediCal LOS AgeGroup FspSvcTeamClient
	/Latent7 = max(Latent7)
	/Latent30= max(latent30)
	/HospRecid10= max(HospRecid10)	
	/HospRecid30= max(HospRecid30).		
	


get file='//covenas/decisionsupport/temp\ServicesByType_Kid.sav'.
sort cases by case.
match files/table='//covenas/decisionsupport/Temp/guidanceEp2K_kids.sav' /file=* /by case.
select if HospProvname ne  " ".

select if xdate.tday(svcdate) ge (xdate.tday(HospClosedate)).
compute lapse = xdate.tday(svcdate) - (xdate.tday(HospClosedate)).
select if lapse lt 91.

if xdate.tday(svcdate) lt xdate.tday(OpDateNext) AND lapse lt 8 AND FUsvc=1 Latent7=1.
if xdate.tday(svcdate) lt xdate.tday(OpDateNext) AND lapse lt 31 AND FUsvc=1 Latent30=1.

agg outfile=* mode=addVars /break=ru case/gotCare = max(latent30).
select if gotCare=1.

*select if latent7=1 OR latent30=1.

agg outfile='//covenas/decisionsupport/temp/guidancePostSvc2.sav'
	/break= case hospRU HospOpdate
	/latent7 = max(latent7)
	/Latent30 = max(Latent30).

save outfile='//covenas/decisionsupport/temp/guidancePostSvc2_WORK.sav' /drop GotCare.

get file='//covenas/decisionsupport/Temp/guidanceEp2K_kids.sav'.
sort cases by case hospRU hospOpdate.
match files/table='//covenas/decisionsupport/temp/guidancePostSvc2.sav' /file=* /by case hospRU hospOpdate.

if xdate.tday(OpdateNext) ne yrmoda(2020,01,01) AND xdate.tday(OpdateNext) - xdate.tday(HospCloseDate) lt 11 HospRecid10=1.
if xdate.tday(OpdateNext) ne yrmoda(2020,01,01) AND xdate.tday(OpdateNext) - xdate.tday(HospCloseDate) lt 31 HospRecid30=1.

compute calendar = date.moyr(xdate.month(HospCloseDate),xdate.year(HospCloseDate)).
formats calendar(moyr6).

compute LOS = xdate.tday(HospCloseDate) - xdate.tday(HospOpDate)+1.

save outfile='//covenas/decisionsupport/temp/guidanceResults2_WORK.sav'.
aggregate outfile='//covenas/decisionsupport/temp/guidanceResults2_kids.sav'
	/break=case HOSPRU HospOpdate HospCloseDate HospProvname    bday sex HasMediCal LOS AgeGroup FspSvcTeamClient
	/Latent7 = max(Latent7)
	/Latent30= max(latent30)
	/HospRecid10= max(HospRecid10)	
	/HospRecid30= max(HospRecid30).		
	


get file='//covenas/decisionsupport/temp\ServicesByType_Kid.sav'.
sort cases by case.
match files/table='//covenas/decisionsupport/Temp/guidanceEp3K_kids.sav' /file=* /by case.
select if HospProvname ne  " ".

select if xdate.tday(svcdate) ge (xdate.tday(HospClosedate)).
compute lapse = xdate.tday(svcdate) - (xdate.tday(HospClosedate)).
select if lapse lt 91.

if xdate.tday(svcdate) lt xdate.tday(OpDateNext) AND lapse lt 8 AND FUsvc=1 Latent7=1.
if xdate.tday(svcdate) lt xdate.tday(OpDateNext) AND lapse lt 31 AND FUsvc=1 Latent30=1.

agg outfile=* mode=addVars /break=ru case/gotCare = max(latent30).
select if gotCare=1.

*select if latent7=1 OR latent30=1.

agg outfile='//covenas/decisionsupport/temp/guidancePostSvc3.sav'
	/break= case hospRU HospOpdate
	/latent7 = max(latent7)
	/Latent30 = max(Latent30).

save outfile='//covenas/decisionsupport/temp/guidancePostSvc3_WORK.sav' /drop GotCare.

get file='//covenas/decisionsupport/Temp/guidanceEp3K_kids.sav'.
sort cases by case hospRU hospOpdate.
match files/table='//covenas/decisionsupport/temp/guidancePostSvc3.sav' /file=* /by case hospRU hospOpdate.

if xdate.tday(OpdateNext) ne yrmoda(2020,01,01) AND xdate.tday(OpdateNext) - xdate.tday(HospCloseDate) lt 11 HospRecid10=1.
if xdate.tday(OpdateNext) ne yrmoda(2020,01,01) AND xdate.tday(OpdateNext) - xdate.tday(HospCloseDate) lt 31 HospRecid30=1.

compute calendar = date.moyr(xdate.month(HospCloseDate),xdate.year(HospCloseDate)).
formats calendar(moyr6).

compute LOS = xdate.tday(HospCloseDate) - xdate.tday(HospOpDate)+1.

save outfile='//covenas/decisionsupport/temp/guidanceResults3_WORK.sav'.
aggregate outfile='//covenas/decisionsupport/temp/guidanceResults3_kids.sav'
	/break=case HOSPRU HospOpdate HospCloseDate HospProvname    bday sex HasMediCal LOS AgeGroup FspSvcTeamClient
	/Latent7 = max(Latent7)
	/Latent30= max(latent30)
	/HospRecid10= max(HospRecid10)	
	/HospRecid30= max(HospRecid30).		
	


get file='//covenas/decisionsupport/temp\ServicesByType_Kid.sav'.
sort cases by case.
match files/table='//covenas/decisionsupport/Temp/guidanceEp4K_kids.sav' /file=* /by case.
select if HospProvname ne  " ".

select if xdate.tday(svcdate) ge (xdate.tday(HospClosedate)).
compute lapse = xdate.tday(svcdate) - (xdate.tday(HospClosedate)).
select if lapse lt 91.

if xdate.tday(svcdate) lt xdate.tday(OpDateNext) AND lapse lt 8 AND FUsvc=1 Latent7=1.
if xdate.tday(svcdate) lt xdate.tday(OpDateNext) AND lapse lt 31 AND FUsvc=1 Latent30=1.

agg outfile=* mode=addVars /break=ru case/gotCare = max(latent30).
select if gotCare=1.

*select if latent7=1 OR latent30=1.

agg outfile='//covenas/decisionsupport/temp/guidancePostSvc4.sav'
	/break= case hospRU HospOpdate
	/latent7 = max(latent7)
	/Latent30 = max(Latent30).

save outfile='//covenas/decisionsupport/temp/guidancePostSvc4_WORK.sav' /drop GotCare.

get file='//covenas/decisionsupport/Temp/guidanceEp4K_kids.sav'.
sort cases by case hospRU hospOpdate.
match files/table='//covenas/decisionsupport/temp/guidancePostSvc4.sav' /file=* /by case hospRU hospOpdate.

if xdate.tday(OpdateNext) ne yrmoda(2020,01,01) AND xdate.tday(OpdateNext) - xdate.tday(HospCloseDate) lt 11 HospRecid10=1.
if xdate.tday(OpdateNext) ne yrmoda(2020,01,01) AND xdate.tday(OpdateNext) - xdate.tday(HospCloseDate) lt 31 HospRecid30=1.

compute calendar = date.moyr(xdate.month(HospCloseDate),xdate.year(HospCloseDate)).
formats calendar(moyr6).

compute LOS = xdate.tday(HospCloseDate) - xdate.tday(HospOpDate)+1.

save outfile='//covenas/decisionsupport/temp/guidanceResults4_WORK.sav'.
aggregate outfile='//covenas/decisionsupport/temp/guidanceResults4_kids.sav'
	/break=case HOSPRU HospOpdate HospCloseDate HospProvname    bday sex HasMediCal LOS AgeGroup FspSvcTeamClient
	/Latent7 = max(Latent7)
	/Latent30= max(latent30)
	/HospRecid10= max(HospRecid10)	
	/HospRecid30= max(HospRecid30).		
	


get file='//covenas/decisionsupport/temp\ServicesByType_Kid.sav'.
sort cases by case.
match files/table='//covenas/decisionsupport/Temp/guidanceEp5K_kids.sav' /file=* /by case.
select if HospProvname ne  " ".

select if xdate.tday(svcdate) ge (xdate.tday(HospClosedate)).
compute lapse = xdate.tday(svcdate) - (xdate.tday(HospClosedate)).
select if lapse lt 91.

if xdate.tday(svcdate) lt xdate.tday(OpDateNext) AND lapse lt 8 AND FUsvc=1 Latent7=1.
if xdate.tday(svcdate) lt xdate.tday(OpDateNext) AND lapse lt 31 AND FUsvc=1 Latent30=1.

agg outfile=* mode=addVars /break=ru case/gotCare = max(latent30).
select if gotCare=1.

*select if latent7=1 OR latent30=1.

agg outfile='//covenas/decisionsupport/temp/guidancePostSvc5.sav'
	/break= case hospRU HospOpdate
	/latent7 = max(latent7)
	/Latent30 = max(Latent30).

save outfile='//covenas/decisionsupport/temp/guidancePostSvc5_WORK.sav' /drop GotCare.

get file='//covenas/decisionsupport/Temp/guidanceEp5K_kids.sav'.
sort cases by case hospRU hospOpdate.
match files/table='//covenas/decisionsupport/temp/guidancePostSvc5.sav' /file=* /by case hospRU hospOpdate.

if xdate.tday(OpdateNext) ne yrmoda(2020,01,01) AND xdate.tday(OpdateNext) - xdate.tday(HospCloseDate) lt 11 HospRecid10=1.
if xdate.tday(OpdateNext) ne yrmoda(2020,01,01) AND xdate.tday(OpdateNext) - xdate.tday(HospCloseDate) lt 31 HospRecid30=1.

compute calendar = date.moyr(xdate.month(HospCloseDate),xdate.year(HospCloseDate)).
formats calendar(moyr6).

compute LOS = xdate.tday(HospCloseDate) - xdate.tday(HospOpDate)+1.

save outfile='//covenas/decisionsupport/temp/guidanceResults5_WORK.sav'.
aggregate outfile='//covenas/decisionsupport/temp/guidanceResults5_kids.sav'
	/break=case HOSPRU HospOpdate HospCloseDate HospProvname    bday sex HasMediCal LOS AgeGroup FspSvcTeamClient
	/Latent7 = max(Latent7)
	/Latent30= max(latent30)
	/HospRecid10= max(HospRecid10)	
	/HospRecid30= max(HospRecid30).		
	


 * get file='//covenas/decisionsupport/temp\ServicesByType_Kid.sav'.
 * sort cases by case.
 * match files/table='//covenas/decisionsupport/Temp/guidanceEp7K_kids.sav' /file=* /by case.
 * select if HospProvname ne  " ".

 * select if xdate.tday(svcdate) ge (xdate.tday(HospClosedate)).
 * compute lapse = xdate.tday(svcdate) - (xdate.tday(HospClosedate)).
 * select if lapse lt 91.

 * if xdate.tday(svcdate) lt xdate.tday(OpDateNext) AND lapse lt 8 AND FUsvc=1 Latent7=1.
 * if xdate.tday(svcdate) lt xdate.tday(OpDateNext) AND lapse lt 31 AND FUsvc=1 Latent30=1.

 * agg outfile=* mode=addVars /break=ru case/gotCare = max(latent30).
 * select if gotCare=1.

*select if latent7=1 OR latent30=1.

 * agg outfile='//covenas/decisionsupport/temp/guidancePostSvc7.sav'
	/break= case hospRU HospOpdate
	/latent7 = max(latent7)
	/Latent30 = max(Latent30).

 * save outfile='//covenas/decisionsupport/temp/guidancePostSvc7_WORK.sav' /drop GotCare.

 * get file='//covenas/decisionsupport/Temp/guidanceEp7K_kids.sav'.
 * sort cases by case hospRU hospOpdate.
 * match files/table='//covenas/decisionsupport/temp/guidancePostSvc7.sav' /file=* /by case hospRU hospOpdate.

 * if xdate.tday(OpdateNext) ne yrmoda(2020,01,01) AND xdate.tday(OpdateNext) - xdate.tday(HospCloseDate) lt 11 HospRecid10=1.
 * if xdate.tday(OpdateNext) ne yrmoda(2020,01,01) AND xdate.tday(OpdateNext) - xdate.tday(HospCloseDate) lt 31 HospRecid30=1.

 * compute calendar = date.moyr(xdate.month(HospCloseDate),xdate.year(HospCloseDate)).
 * formats calendar(moyr6).

 * compute LOS = xdate.tday(HospCloseDate) - xdate.tday(HospOpDate)+1.

 * save outfile='//covenas/decisionsupport/temp/guidanceResults7_WORK.sav'.
 * aggregate outfile='//covenas/decisionsupport/temp/guidanceResults7_kids.sav'
	/break=case HOSPRU HospOpdate HospCloseDate HospProvname    bday sex HasMediCal LOS AgeGroup FspSvcTeamClient
	/Latent7 = max(Latent7)
	/Latent30= max(latent30)
	/HospRecid10= max(HospRecid10)	
	/HospRecid30= max(HospRecid30).		
	


 * get file='//covenas/decisionsupport/temp\ServicesByType_Kid.sav'.
 * sort cases by case.
 * match files/table='//covenas/decisionsupport/Temp/guidanceEp8K_kids.sav' /file=* /by case.
 * select if HospProvname ne  " ".

 * select if xdate.tday(svcdate) ge (xdate.tday(HospClosedate)).
 * compute lapse = xdate.tday(svcdate) - (xdate.tday(HospClosedate)).
 * select if lapse lt 91.

 * if xdate.tday(svcdate) lt xdate.tday(OpDateNext) AND lapse lt 8 AND FUsvc=1 Latent7=1.
 * if xdate.tday(svcdate) lt xdate.tday(OpDateNext) AND lapse lt 31 AND FUsvc=1 Latent30=1.

 * agg outfile=* mode=addVars /break=ru case/gotCare = max(latent30).
 * select if gotCare=1.

*select if latent7=1 OR latent30=1.

 * agg outfile='//covenas/decisionsupport/temp/guidancePostSvc8.sav'
	/break= case hospRU HospOpdate
	/latent7 = max(latent7)
	/Latent30 = max(Latent30).

 * save outfile='//covenas/decisionsupport/temp/guidancePostSvc8_WORK.sav' /drop GotCare.

 * get file='//covenas/decisionsupport/Temp/guidanceEp8K_kids.sav'.
 * sort cases by case hospRU hospOpdate.
 * match files/table='//covenas/decisionsupport/temp/guidancePostSvc8.sav' /file=* /by case hospRU hospOpdate.

 * if xdate.tday(OpdateNext) ne yrmoda(2020,01,01) AND xdate.tday(OpdateNext) - xdate.tday(HospCloseDate) lt 11 HospRecid10=1.
 * if xdate.tday(OpdateNext) ne yrmoda(2020,01,01) AND xdate.tday(OpdateNext) - xdate.tday(HospCloseDate) lt 31 HospRecid30=1.

 * compute calendar = date.moyr(xdate.month(HospCloseDate),xdate.year(HospCloseDate)).
 * formats calendar(moyr6).

 * compute LOS = xdate.tday(HospCloseDate) - xdate.tday(HospOpDate)+1.

 * save outfile='//covenas/decisionsupport/temp/guidanceResults8_WORK.sav'.
 * aggregate outfile='//covenas/decisionsupport/temp/guidanceResults8_kids.sav'
	/break=case HOSPRU HospOpdate HospCloseDate HospProvname    bday sex HasMediCal LOS AgeGroup FspSvcTeamClient
	/Latent7 = max(Latent7)
	/Latent30= max(latent30)
	/HospRecid10= max(HospRecid10)	
	/HospRecid30= max(HospRecid30).		
	


 * get file='//covenas/decisionsupport/temp\ServicesByType_Kid.sav'.
 * sort cases by case.
 * match files/table='//covenas/decisionsupport/Temp/guidanceEp9K_kids.sav' /file=* /by case.
 * select if HospProvname ne  " ".

 * select if xdate.tday(svcdate) ge (xdate.tday(HospClosedate)).
 * compute lapse = xdate.tday(svcdate) - (xdate.tday(HospClosedate)).
 * select if lapse lt 91.

 * if xdate.tday(svcdate) lt xdate.tday(OpDateNext) AND lapse lt 8 AND FUsvc=1 Latent7=1.
 * if xdate.tday(svcdate) lt xdate.tday(OpDateNext) AND lapse lt 31 AND FUsvc=1 Latent30=1.

 * agg outfile=* mode=addVars /break=ru case/gotCare = max(latent30).
 * select if gotCare=1.

*select if latent7=1 OR latent30=1.

 * agg outfile='//covenas/decisionsupport/temp/guidancePostSvc9.sav'
	/break= case hospRU HospOpdate
	/latent7 = max(latent7)
	/Latent30 = max(Latent30).

 * save outfile='//covenas/decisionsupport/temp/guidancePostSvc9_WORK.sav' /drop GotCare.

 * get file='//covenas/decisionsupport/Temp/guidanceEp9K_kids.sav'.
 * sort cases by case hospRU hospOpdate.
 * match files/table='//covenas/decisionsupport/temp/guidancePostSvc9.sav' /file=* /by case hospRU hospOpdate.

 * if xdate.tday(OpdateNext) ne yrmoda(2020,01,01) AND xdate.tday(OpdateNext) - xdate.tday(HospCloseDate) lt 11 HospRecid10=1.
 * if xdate.tday(OpdateNext) ne yrmoda(2020,01,01) AND xdate.tday(OpdateNext) - xdate.tday(HospCloseDate) lt 31 HospRecid30=1.

 * compute calendar = date.moyr(xdate.month(HospCloseDate),xdate.year(HospCloseDate)).
 * formats calendar(moyr6).

 * compute LOS = xdate.tday(HospCloseDate) - xdate.tday(HospOpDate)+1.

 * save outfile='//covenas/decisionsupport/temp/guidanceResults9_WORK.sav'.
 * aggregate outfile='//covenas/decisionsupport/temp/guidanceResults9_kids.sav'
	/break=case HOSPRU HospOpdate HospCloseDate HospProvname    bday sex HasMediCal LOS AgeGroup FspSvcTeamClient
	/Latent7 = max(Latent7)
	/Latent30= max(latent30)
	/HospRecid10= max(HospRecid10)	
	/HospRecid30= max(HospRecid30).		
	


 * get file='//covenas/decisionsupport/temp\ServicesByType_Kid.sav'.
 * sort cases by case.
 * match files/table='//covenas/decisionsupport/Temp/guidanceEp10K_kids.sav' /file=* /by case.
 * select if HospProvname ne  " ".

 * select if xdate.tday(svcdate) ge (xdate.tday(HospClosedate)).
 * compute lapse = xdate.tday(svcdate) - (xdate.tday(HospClosedate)).
 * select if lapse lt 91.

 * if xdate.tday(svcdate) lt xdate.tday(OpDateNext) AND lapse lt 8 AND FUsvc=1 Latent7=1.
 * if xdate.tday(svcdate) lt xdate.tday(OpDateNext) AND lapse lt 31 AND FUsvc=1 Latent30=1.

 * agg outfile=* mode=addVars /break=ru case/gotCare = max(latent30).
 * select if gotCare=1.

*select if latent7=1 OR latent30=1.

 * agg outfile='//covenas/decisionsupport/temp/guidancePostSvc10.sav'
	/break= case hospRU HospOpdate
	/latent7 = max(latent7)
	/Latent30 = max(Latent30).

 * save outfile='//covenas/decisionsupport/temp/guidancePostSvc10_WORK.sav' /drop GotCare.

 * get file='//covenas/decisionsupport/Temp/guidanceEp10K_kids.sav'.
 * sort cases by case hospRU hospOpdate.
 * match files/table='//covenas/decisionsupport/temp/guidancePostSvc10.sav' /file=* /by case hospRU hospOpdate.

 * if xdate.tday(OpdateNext) ne yrmoda(2020,01,01) AND xdate.tday(OpdateNext) - xdate.tday(HospCloseDate) lt 11 HospRecid10=1.
 * if xdate.tday(OpdateNext) ne yrmoda(2020,01,01) AND xdate.tday(OpdateNext) - xdate.tday(HospCloseDate) lt 31 HospRecid30=1.

 * compute calendar = date.moyr(xdate.month(HospCloseDate),xdate.year(HospCloseDate)).
 * formats calendar(moyr6).

 * compute LOS = xdate.tday(HospCloseDate) - xdate.tday(HospOpDate)+1.

 * save outfile='//covenas/decisionsupport/temp/guidanceResults10_WORK.sav'.
 * aggregate outfile='//covenas/decisionsupport/temp/guidanceResults10_kids.sav'
	/break=case HOSPRU HospOpdate HospCloseDate HospProvname    bday sex HasMediCal LOS AgeGroup FspSvcTeamClient
 /Latent7 = max(Latent7)
 /Latent30= max(latent30)
 /HospRecid10= max(HospRecid10)	
 /HospRecid30= max(HospRecid30).		



 * get file='//covenas/decisionsupport/temp\ServicesByType_Kid.sav'.
 * sort cases by case.
 * match files/table='//covenas/decisionsupport/Temp/guidanceEp11K_kids.sav' /file=* /by case.
 * select if HospProvname ne  " ".

 * select if xdate.tday(svcdate) ge (xdate.tday(HospClosedate)).
 * compute lapse = xdate.tday(svcdate) - (xdate.tday(HospClosedate)).
 * select if lapse lt 91.

 * if xdate.tday(svcdate) lt xdate.tday(OpDateNext) AND lapse lt 8 AND FUsvc=1 Latent7=1.
 * if xdate.tday(svcdate) lt xdate.tday(OpDateNext) AND lapse lt 31 AND FUsvc=1 Latent30=1.

 * agg outfile=* mode=addVars /break=ru case/gotCare = max(latent30).
 * select if gotCare=1.

*select if latent7=1 OR latent30=1.

 * agg outfile='//covenas/decisionsupport/temp/guidancePostSvc11.sav'
	/break= case hospRU HospOpdate
	/latent7 = max(latent7)
	/Latent30 = max(Latent30).

 * save outfile='//covenas/decisionsupport/temp/guidancePostSvc11_WORK.sav' /drop GotCare.

 * get file='//covenas/decisionsupport/Temp/guidanceEp11K_kids.sav'.
 * sort cases by case hospRU hospOpdate.
 * match files/table='//covenas/decisionsupport/temp/guidancePostSvc11.sav' /file=* /by case hospRU hospOpdate.

 * if xdate.tday(OpdateNext) ne yrmoda(2020,01,01) AND xdate.tday(OpdateNext) - xdate.tday(HospCloseDate) lt 11 HospRecid10=1.
 * if xdate.tday(OpdateNext) ne yrmoda(2020,01,01) AND xdate.tday(OpdateNext) - xdate.tday(HospCloseDate) lt 31 HospRecid30=1.

 * compute calendar = date.moyr(xdate.month(HospCloseDate),xdate.year(HospCloseDate)).
 * formats calendar(moyr6).

 * compute LOS = xdate.tday(HospCloseDate) - xdate.tday(HospOpDate)+1.

 * save outfile='//covenas/decisionsupport/temp/guidanceResults11_WORK.sav'.
 * aggregate outfile='//covenas/decisionsupport/temp/guidanceResults11_kids.sav'
	/break=case HOSPRU HospOpdate HospCloseDate HospProvname    bday sex HasMediCal LOS AgeGroup FspSvcTeamClient
	/Latent7 = max(Latent7)
	/Latent30= max(latent30)
	/HospRecid10= max(HospRecid10)	
	/HospRecid30= max(HospRecid30).		
	


 * get file='//covenas/decisionsupport/temp\ServicesByType_Kid.sav'.
 * sort cases by case.
 * match files/table='//covenas/decisionsupport/Temp/guidanceEp12K_kids.sav' /file=* /by case.
 * select if HospProvname ne  " ".

 * select if xdate.tday(svcdate) ge (xdate.tday(HospClosedate)).
 * compute lapse = xdate.tday(svcdate) - (xdate.tday(HospClosedate)).
 * select if lapse lt 91.

 * if xdate.tday(svcdate) lt xdate.tday(OpDateNext) AND lapse lt 8 AND FUsvc=1 Latent7=1.
 * if xdate.tday(svcdate) lt xdate.tday(OpDateNext) AND lapse lt 31 AND FUsvc=1 Latent30=1.

 * agg outfile=* mode=addVars /break=ru case/gotCare = max(latent30).
 * select if gotCare=1.

*select if latent7=1 OR latent30=1.

 * agg outfile='//covenas/decisionsupport/temp/guidancePostSvc12.sav'
	/break= case hospRU HospOpdate
	/latent7 = max(latent7)
	/Latent30 = max(Latent30).

 * save outfile='//covenas/decisionsupport/temp/guidancePostSvc12_WORK.sav' /drop GotCare.

 * get file='//covenas/decisionsupport/Temp/guidanceEp12K_kids.sav'.
 * sort cases by case hospRU hospOpdate.
 * match files/table='//covenas/decisionsupport/temp/guidancePostSvc12.sav' /file=* /by case hospRU hospOpdate.

 * if xdate.tday(OpdateNext) ne yrmoda(2020,01,01) AND xdate.tday(OpdateNext) - xdate.tday(HospCloseDate) lt 11 HospRecid10=1.
 * if xdate.tday(OpdateNext) ne yrmoda(2020,01,01) AND xdate.tday(OpdateNext) - xdate.tday(HospCloseDate) lt 31 HospRecid30=1.

 * compute calendar = date.moyr(xdate.month(HospCloseDate),xdate.year(HospCloseDate)).
 * formats calendar(moyr6).

 * compute LOS = xdate.tday(HospCloseDate) - xdate.tday(HospOpDate)+1.

 * save outfile='//covenas/decisionsupport/temp/guidanceResults12_WORK.sav'.
 * aggregate outfile='//covenas/decisionsupport/temp/guidanceResults12_kids.sav'
	/break=case HOSPRU HospOpdate HospCloseDate HospProvname    bday sex HasMediCal LOS AgeGroup FspSvcTeamClient
	/Latent7 = max(Latent7)
	/Latent30= max(latent30)
	/HospRecid10= max(HospRecid10)	
	/HospRecid30= max(HospRecid30).		
	


 * get file='//covenas/decisionsupport/temp\ServicesByType_Kid.sav'.
 * sort cases by case.
 * match files/table='//covenas/decisionsupport/Temp/guidanceEp13K_kids.sav' /file=* /by case.
 * select if HospProvname ne  " ".

 * select if xdate.tday(svcdate) ge (xdate.tday(HospClosedate)).
 * compute lapse = xdate.tday(svcdate) - (xdate.tday(HospClosedate)).
 * select if lapse lt 91.

 * if xdate.tday(svcdate) lt xdate.tday(OpDateNext) AND lapse lt 8 AND FUsvc=1 Latent7=1.
 * if xdate.tday(svcdate) lt xdate.tday(OpDateNext) AND lapse lt 31 AND FUsvc=1 Latent30=1.

 * agg outfile=* mode=addVars /break=ru case/gotCare = max(latent30).
 * select if gotCare=1.

*select if latent7=1 OR latent30=1.

 * agg outfile='//covenas/decisionsupport/temp/guidancePostSvc13.sav'
	/break= case hospRU HospOpdate
	/latent7 = max(latent7)
	/Latent30 = max(Latent30).

 * save outfile='//covenas/decisionsupport/temp/guidancePostSvc13_WORK.sav' /drop GotCare.

 * get file='//covenas/decisionsupport/Temp/guidanceEp13K_kids.sav'.
 * sort cases by case hospRU hospOpdate.
 * match files/table='//covenas/decisionsupport/temp/guidancePostSvc13.sav' /file=* /by case hospRU hospOpdate.

 * if xdate.tday(OpdateNext) ne yrmoda(2020,01,01) AND xdate.tday(OpdateNext) - xdate.tday(HospCloseDate) lt 11 HospRecid10=1.
 * if xdate.tday(OpdateNext) ne yrmoda(2020,01,01) AND xdate.tday(OpdateNext) - xdate.tday(HospCloseDate) lt 31 HospRecid30=1.

 * compute calendar = date.moyr(xdate.month(HospCloseDate),xdate.year(HospCloseDate)).
 * formats calendar(moyr6).

 * compute LOS = xdate.tday(HospCloseDate) - xdate.tday(HospOpDate)+1.

 * save outfile='//covenas/decisionsupport/temp/guidanceResults13_WORK.sav'.
 * aggregate outfile='//covenas/decisionsupport/temp/guidanceResults13_kids.sav'
	/break=case HOSPRU HospOpdate HospCloseDate HospProvname    bday sex HasMediCal LOS AgeGroup FspSvcTeamClient
	/Latent7 = max(Latent7)
	/Latent30= max(latent30)
	/HospRecid10= max(HospRecid10)	
	/HospRecid30= max(HospRecid30).		
	


 * get file='//covenas/decisionsupport/temp\ServicesByType_Kid.sav'.
 * sort cases by case.
 * match files/table='//covenas/decisionsupport/Temp/guidanceEp14K_kids.sav' /file=* /by case.
 * select if HospProvname ne  " ".

 * select if xdate.tday(svcdate) ge (xdate.tday(HospClosedate)).
 * compute lapse = xdate.tday(svcdate) - (xdate.tday(HospClosedate)).
 * select if lapse lt 91.

 * if xdate.tday(svcdate) lt xdate.tday(OpDateNext) AND lapse lt 8 AND FUsvc=1 Latent7=1.
 * if xdate.tday(svcdate) lt xdate.tday(OpDateNext) AND lapse lt 31 AND FUsvc=1 Latent30=1.

 * agg outfile=* mode=addVars /break=ru case/gotCare = max(latent30).
 * select if gotCare=1.

*select if latent7=1 OR latent30=1.

 * agg outfile='//covenas/decisionsupport/temp/guidancePostSvc14.sav'
	/break= case hospRU HospOpdate
	/latent7 = max(latent7)
	/Latent30 = max(Latent30).

 * save outfile='//covenas/decisionsupport/temp/guidancePostSvc14_WORK.sav' /drop GotCare.

 * get file='//covenas/decisionsupport/Temp/guidanceEp14K_kids.sav'.
 * sort cases by case hospRU hospOpdate.
 * match files/table='//covenas/decisionsupport/temp/guidancePostSvc14.sav' /file=* /by case hospRU hospOpdate.

 * if xdate.tday(OpdateNext) ne yrmoda(2020,01,01) AND xdate.tday(OpdateNext) - xdate.tday(HospCloseDate) lt 11 HospRecid10=1.
 * if xdate.tday(OpdateNext) ne yrmoda(2020,01,01) AND xdate.tday(OpdateNext) - xdate.tday(HospCloseDate) lt 31 HospRecid30=1.

 * compute calendar = date.moyr(xdate.month(HospCloseDate),xdate.year(HospCloseDate)).
 * formats calendar(moyr6).

 * compute LOS = xdate.tday(HospCloseDate) - xdate.tday(HospOpDate)+1.

 * save outfile='//covenas/decisionsupport/temp/guidanceResults14_WORK.sav'.
 * aggregate outfile='//covenas/decisionsupport/temp/guidanceResults14_kids.sav'
	/break=case HOSPRU HospOpdate HospCloseDate HospProvname    bday sex HasMediCal LOS AgeGroup FspSvcTeamClient
	/Latent7 = max(Latent7)
	/Latent30= max(latent30)
	/HospRecid10= max(HospRecid10)	
	/HospRecid30= max(HospRecid30).		
	


 * get file='//covenas/decisionsupport/temp\ServicesByType_Kid.sav'.
 * sort cases by case.
 * match files/table='//covenas/decisionsupport/Temp/guidanceEp15K_kids.sav' /file=* /by case.
 * select if HospProvname ne  " ".

 * select if xdate.tday(svcdate) ge (xdate.tday(HospClosedate)).
 * compute lapse = xdate.tday(svcdate) - (xdate.tday(HospClosedate)).
 * select if lapse lt 91.

 * if xdate.tday(svcdate) lt xdate.tday(OpDateNext) AND lapse lt 8 AND FUsvc=1 Latent7=1.
 * if xdate.tday(svcdate) lt xdate.tday(OpDateNext) AND lapse lt 31 AND FUsvc=1 Latent30=1.

 * agg outfile=* mode=addVars /break=ru case/gotCare = max(latent30).
 * select if gotCare=1.

*select if latent7=1 OR latent30=1.

 * agg outfile='//covenas/decisionsupport/temp/guidancePostSvc15.sav'
	/break= case hospRU HospOpdate
	/latent7 = max(latent7)
	/Latent30 = max(Latent30).

 * save outfile='//covenas/decisionsupport/temp/guidancePostSvc15_WORK.sav' /drop GotCare.

 * get file='//covenas/decisionsupport/Temp/guidanceEp15K_kids.sav'.
 * sort cases by case hospRU hospOpdate.
 * match files/table='//covenas/decisionsupport/temp/guidancePostSvc15.sav' /file=* /by case hospRU hospOpdate.

 * if xdate.tday(OpdateNext) ne yrmoda(2020,01,01) AND xdate.tday(OpdateNext) - xdate.tday(HospCloseDate) lt 11 HospRecid10=1.
 * if xdate.tday(OpdateNext) ne yrmoda(2020,01,01) AND xdate.tday(OpdateNext) - xdate.tday(HospCloseDate) lt 31 HospRecid30=1.

 * compute calendar = date.moyr(xdate.month(HospCloseDate),xdate.year(HospCloseDate)).
 * formats calendar(moyr6).

 * compute LOS = xdate.tday(HospCloseDate) - xdate.tday(HospOpDate)+1.

 * save outfile='//covenas/decisionsupport/temp/guidanceResults15_WORK.sav'.
 * aggregate outfile='//covenas/decisionsupport/temp/guidanceResults15_kids.sav'
	/break=case HOSPRU HospOpdate HospCloseDate HospProvname    bday sex HasMediCal LOS AgeGroup FspSvcTeamClient
	/Latent7 = max(Latent7)
	/Latent30= max(latent30)
	/HospRecid10= max(HospRecid10)	
	/HospRecid30= max(HospRecid30).		
	


 * get file='//covenas/decisionsupport/temp\ServicesByType_Kid.sav'.
 * sort cases by case.
 * match files/table='//covenas/decisionsupport/Temp/guidanceEp16K_kids.sav' /file=* /by case.
 * select if HospProvname ne  " ".

 * select if xdate.tday(svcdate) ge (xdate.tday(HospClosedate)).
 * compute lapse = xdate.tday(svcdate) - (xdate.tday(HospClosedate)).
 * select if lapse lt 91.

 * if xdate.tday(svcdate) lt xdate.tday(OpDateNext) AND lapse lt 8 AND FUsvc=1 Latent7=1.
 * if xdate.tday(svcdate) lt xdate.tday(OpDateNext) AND lapse lt 31 AND FUsvc=1 Latent30=1.

 * agg outfile=* mode=addVars /break=ru case/gotCare = max(latent30).
 * select if gotCare=1.

*select if latent7=1 OR latent30=1.

 * agg outfile='//covenas/decisionsupport/temp/guidancePostSvc16.sav'
	/break= case hospRU HospOpdate
	/latent7 = max(latent7)
	/Latent30 = max(Latent30).

 * save outfile='//covenas/decisionsupport/temp/guidancePostSvc16_WORK.sav' /drop GotCare.

 * get file='//covenas/decisionsupport/Temp/guidanceEp16K_kids.sav'.
 * sort cases by case hospRU hospOpdate.
 * match files/table='//covenas/decisionsupport/temp/guidancePostSvc16.sav' /file=* /by case hospRU hospOpdate.

 * if xdate.tday(OpdateNext) ne yrmoda(2020,01,01) AND xdate.tday(OpdateNext) - xdate.tday(HospCloseDate) lt 11 HospRecid10=1.
 * if xdate.tday(OpdateNext) ne yrmoda(2020,01,01) AND xdate.tday(OpdateNext) - xdate.tday(HospCloseDate) lt 31 HospRecid30=1.

 * compute calendar = date.moyr(xdate.month(HospCloseDate),xdate.year(HospCloseDate)).
 * formats calendar(moyr6).

 * compute LOS = xdate.tday(HospCloseDate) - xdate.tday(HospOpDate)+1.

 * save outfile='//covenas/decisionsupport/temp/guidanceResults16_WORK.sav'.
 * aggregate outfile='//covenas/decisionsupport/temp/guidanceResults16_kids.sav'
	/break=case HOSPRU HospOpdate HospCloseDate HospProvname    bday sex HasMediCal LOS AgeGroup FspSvcTeamClient
	/Latent7 = max(Latent7)
	/Latent30= max(latent30)
	/HospRecid10= max(HospRecid10)	
	/HospRecid30= max(HospRecid30).		
	


 * get file='//covenas/decisionsupport/temp\ServicesByType_Kid.sav'.
 * sort cases by case.
 * match files/table='//covenas/decisionsupport/Temp/guidanceEp17K_kids.sav' /file=* /by case.
 * select if HospProvname ne  " ".

 * select if xdate.tday(svcdate) ge (xdate.tday(HospClosedate)).
 * compute lapse = xdate.tday(svcdate) - (xdate.tday(HospClosedate)).
 * select if lapse lt 91.

 * if xdate.tday(svcdate) lt xdate.tday(OpDateNext) AND lapse lt 8 AND FUsvc=1 Latent7=1.
 * if xdate.tday(svcdate) lt xdate.tday(OpDateNext) AND lapse lt 31 AND FUsvc=1 Latent30=1.

 * agg outfile=* mode=addVars /break=ru case/gotCare = max(latent30).
 * select if gotCare=1.

*select if latent7=1 OR latent30=1.

 * agg outfile='//covenas/decisionsupport/temp/guidancePostSvc17.sav'
	/break= case hospRU HospOpdate
	/latent7 = max(latent7)
	/Latent30 = max(Latent30).

 * save outfile='//covenas/decisionsupport/temp/guidancePostSvc17_WORK.sav' /drop GotCare.

 * get file='//covenas/decisionsupport/Temp/guidanceEp17K_kids.sav'.
 * sort cases by case hospRU hospOpdate.
 * match files/table='//covenas/decisionsupport/temp/guidancePostSvc17.sav' /file=* /by case hospRU hospOpdate.

 * if xdate.tday(OpdateNext) ne yrmoda(2020,01,01) AND xdate.tday(OpdateNext) - xdate.tday(HospCloseDate) lt 11 HospRecid10=1.
 * if xdate.tday(OpdateNext) ne yrmoda(2020,01,01) AND xdate.tday(OpdateNext) - xdate.tday(HospCloseDate) lt 31 HospRecid30=1.

 * compute calendar = date.moyr(xdate.month(HospCloseDate),xdate.year(HospCloseDate)).
 * formats calendar(moyr6).

 * compute LOS = xdate.tday(HospCloseDate) - xdate.tday(HospOpDate)+1.

 * save outfile='//covenas/decisionsupport/temp/guidanceResults17_WORK.sav'.
 * aggregate outfile='//covenas/decisionsupport/temp/guidanceResults17_kids.sav'
	/break=case HOSPRU HospOpdate HospCloseDate HospProvname    bday sex HasMediCal LOS AgeGroup FspSvcTeamClient
	/Latent7 = max(Latent7)
	/Latent30= max(latent30)
	/HospRecid10= max(HospRecid10)	
	/HospRecid30= max(HospRecid30).		
	


 * get file='//covenas/decisionsupport/temp\ServicesByType_Kid.sav'.
 * sort cases by case.
 * match files/table='//covenas/decisionsupport/Temp/guidanceEp18K_kids.sav' /file=* /by case.
 * select if HospProvname ne  " ".

 * select if xdate.tday(svcdate) ge (xdate.tday(HospClosedate)).
 * compute lapse = xdate.tday(svcdate) - (xdate.tday(HospClosedate)).
 * select if lapse lt 91.

 * if xdate.tday(svcdate) lt xdate.tday(OpDateNext) AND lapse lt 8 AND FUsvc=1 Latent7=1.
 * if xdate.tday(svcdate) lt xdate.tday(OpDateNext) AND lapse lt 31 AND FUsvc=1 Latent30=1.

 * agg outfile=* mode=addVars /break=ru case/gotCare = max(latent30).
 * select if gotCare=1.

*select if latent7=1 OR latent30=1.

 * agg outfile='//covenas/decisionsupport/temp/guidancePostSvc18.sav'
	/break= case hospRU HospOpdate
	/latent7 = max(latent7)
	/Latent30 = max(Latent30).

 * save outfile='//covenas/decisionsupport/temp/guidancePostSvc18_WORK.sav' /drop GotCare.

 * get file='//covenas/decisionsupport/Temp/guidanceEp18K_kids.sav'.
 * sort cases by case hospRU hospOpdate.
 * match files/table='//covenas/decisionsupport/temp/guidancePostSvc18.sav' /file=* /by case hospRU hospOpdate.

 * if xdate.tday(OpdateNext) ne yrmoda(2020,01,01) AND xdate.tday(OpdateNext) - xdate.tday(HospCloseDate) lt 11 HospRecid10=1.
 * if xdate.tday(OpdateNext) ne yrmoda(2020,01,01) AND xdate.tday(OpdateNext) - xdate.tday(HospCloseDate) lt 31 HospRecid30=1.

 * compute calendar = date.moyr(xdate.month(HospCloseDate),xdate.year(HospCloseDate)).
 * formats calendar(moyr6).

 * compute LOS = xdate.tday(HospCloseDate) - xdate.tday(HospOpDate)+1.

 * save outfile='//covenas/decisionsupport/temp/guidanceResults18_WORK.sav'.
 * aggregate outfile='//covenas/decisionsupport/temp/guidanceResults18_kids.sav'
	/break=case HOSPRU HospOpdate HospCloseDate HospProvname    bday sex HasMediCal LOS AgeGroup FspSvcTeamClient
	/Latent7 = max(Latent7)
	/Latent30= max(latent30)
	/HospRecid10= max(HospRecid10)	
	/HospRecid30= max(HospRecid30).		

add files
	/file='//covenas/decisionsupport/temp/GuidanceResults1_kids.sav'
	/file='//covenas/decisionsupport/temp/GuidanceResults2_kids.sav'
	/file='//covenas/decisionsupport/temp/GuidanceResults3_kids.sav'
	/file='//covenas/decisionsupport/temp/GuidanceResults4_kids.sav'
	/file='//covenas/decisionsupport/temp/GuidanceResults5_kids.sav'
	/file='//covenas/decisionsupport/temp/GuidanceResults6_kids.sav'.


save outfile='//covenas/decisionsupport/temp/guidresults_kidsALL.sav'.

get file='//covenas/decisionsupport/temp/guidresults_kidsALL.sav'.
*freq hospProvname.
compute DischargeAge = Trunc((xdate.tday(HospClosedate) - xdate.tday(bday))/365.25).
recode Latent7 Latent30 HospRecid10 HospRecid30 (sysmis=0).
recode HasMediCal FspSvcTeamClient (sysmis=0).
compute counter=1.

rename vars FSPsvcTeamClient=SEDsvcKid.

compute DischargeMonth = date.moyr(xdate.month(HospCloseDate), xdate.year(hospCloseDate)).
formats DischargeMonth (moyr6).

compute createDate = $time.

formats createDate(date11).
rename variables sex=Gender.
sort cases by case.
match files /table='//covenas/spssdata/clinfo.sav' /file=* /by case /drop bornname language disab educ created cin marital minors ssn. 
insert file= '//covenas/decisionsupport/modules/ethnicity.sps'.

match files/file=*/drop raceethnicitycode hispanic.

compute HospRU = "BOGUS".
compute HospProvname =  "Guidance BOGUS".

rename vars 
hospru = GuidanceRU 
hospopdate=GuidanceOpDate 
HospCloseDate = GuidanceCloseDate 
Hospprovname=GuidanceProviderName 
hosprecid10=GuidanceRecidivism10 
hosprecid30=GuidanceRecidivism30.
*display vars.
string Latent7Client Latent30Client sedkid (a3).
if latent7=1 Latent7Client='Yes'.
if latent7=0  latent7client='No'.
if Latent30=0 latent30client='No'.
if Latent30=1 Latent30Client='Yes'.
if SEDSVCkid=0 SEDKid='No'.
if SEDSVCkid=1 SEDKid='Yes'.

insert file='//covenas/decisionsupport/modules/uncookedmonth.sps'.
if guidanceCloseDate ge datesum(uncookedmonth,-1,'months') possiblefu30=0.
if guidancecloseDate lt datesum(uncookedmonth,-1,'months') possiblefu30=1.

if xdate.mday($time) le 15 dateFU30 = DateSum($time,-2,"months").
if xdate.mday($time) gt 15 dateFU30 = DateSum($time,-1,"months").
compute dateFU30 =date.moyr(xdate.month(dateFU30), xdate.year(dateFU30)).
formats dateFU30(date12).

if guidanceCloseDate ge datefu30 possiblefu30=0.
if guidancecloseDate lt datefu30 possiblefu30=1.

select if possiblefu30 =1.



save outfile='//covenas/decisionsupport/dashboardDataSets\GuidanceEpisodes_kids.sav'.

select if latent30=0.

compute createDate = $time.
formats createDate(datetime17).

compute NoLatencyCare=1.


save outfile='//covenas/decisionsupport/temp/GuidanceNoLatencyCareDetailx.sav'.
get file='//covenas/decisionsupport/temp/GuidanceNoLatencyCareDetailx.sav'.
 * SAVE TRANSLATE /TYPE=ODBC
 /Connect ='DSN=DashboardData;UID=;APP=SPSS For'+
 ' Windows;WSID=HPMXL9360ZDD;DATABASE=DashboardData;Trusted_Connection=Yes'
 /table= 'GuidanceNoLatencyCareDetail' /MAP/REPLACE.



get file='//covenas/decisionsupport/dashboardDataSets\GuidanceEpisodes_kids.sav' .

 * SAVE TRANSLATE /TYPE=ODBC
 /Connect ='DSN=DashboardData;UID=;APP=SPSS For'+
 ' Windows;WSID=HPMXL9360ZDD;DATABASE=DashboardData;Trusted_Connection=Yes'
 /table= 'GuidanceEpisodes_kids' /MAP/REPLACE.


add files
	/file='//covenas/decisionsupport/temp/GuidancePostSvc1_WORK.sav'
	/file='//covenas/decisionsupport/temp/GuidancePostSvc2_WORK.sav'
	/file='//covenas/decisionsupport/temp/GuidancePostSvc3_WORK.sav'
	/file='//covenas/decisionsupport/temp/GuidancePostSvc4_WORK.sav'
	/file='//covenas/decisionsupport/temp/GuidancePostSvc5_WORK.sav'
	/file='//covenas/decisionsupport/temp/GuidancePostSvc6_WORK.sav'
	/file='//covenas/decisionsupport/temp/GuidancePostSvc7_WORK.sav'
	/file='//covenas/decisionsupport/temp/GuidancePostSvc8_WORK.sav'
	/file='//covenas/decisionsupport/temp/GuidancePostSvc9_WORK.sav'
	/file='//covenas/decisionsupport/temp/GuidancePostSvc10_WORK.sav'.


sort cases by case hospOpdate.
match files/file=* /by case hospOpdate /first=ep1.
*match files/file=* /by case/first=case1.

*match files/file=* /keep case HospCloseDate provname svcdate all.

*display vars.

compute counter=1.
compute DischargeMonth = date.moyr(xdate.month(HospCloseDate), xdate.year(hospCloseDate)).
formats DischargeMonth (moyr6).

sort cases by ru DischargeMonth case HospOpdate.

match files/file=* /by ru DischargeMonth case /first=FUruCase1.
match files/file=* /by ru DischargeMonth case HospOpDate /first=FURUep1.

agg outfile='//covenas/decisionsupport/DashboardDataSets\guidanceFollowUpRus.sav'
	/break=DischargeMonth  Ru Provname  HospProvname
	/Clients = sum(FURUcase1)
	/DischargeEps = sum(FURUep1).

agg outfile='//covenas/decisionsupport/DashboardDataSets\guidanceFollowUpCareDetail.sav'
	/break=DischargeMonth  Ru Provname  HospProvname case hospOpdate HospCloseDate agegroup
	/Latent7 = max(Latent7)
	/Latent30= max(Latent30)
	/Visits =sum(counter)
 /SEDsvcKid=max(fspsvcteamclient).

get file='//covenas/decisionsupport/DashboardDataSets\GuidanceFollowUpRus.sav'.
compute createDate = $time.
formats createDate(date11).

rename vars 
Hospprovname=GuidanceProviderName .
*display vars.

 * SAVE TRANSLATE /TYPE=ODBC
 /Connect ='DSN=DashboardData;UID=;APP=SPSS For'+
 ' Windows;WSID=HPMXL9360ZDD;DATABASE=DashboardData;Trusted_Connection=Yes'
 /table= 'GuidanceFollowUpRus' /MAP/REPLACE.

get file='//covenas/decisionsupport/DashboardDataSets\GuidanceFollowUpCareDetail.sav'.
compute createDate = $time.
formats createDate(datetime17).

sort cases by case.
match files /table='//covenas/spssdata/clinfo.sav' /file=* /by case /drop  bornname language disab educ created cin marital minors ssn. 
insert file= '//covenas/decisionsupport/modules/ethnicity.sps'.
match files/file=*/drop raceethnicitycode hispanic.

*compute HospRU = "BOGUS".
compute HospProvname =  "Guidance BOGUS".

recode SEDsvcKid(sysmis=0).
rename vars 
sex=Gender
hospopdate=GuidanceOpDate 
HospCloseDate = GuidanceCloseDate 
Hospprovname=GuidanceProvName
latent7 = DaysLatent7
latent30=DaysLatent30 .

formats createDate(date11).
recode dayslatent7 dayslatent30 sedsvckid(sysmis=0).

string Latent7Client Latent30Client sedkid (a3).
if dayslatent7=1 Latent7Client='Yes'.
if dayslatent7=0  latent7client='No'.
if dayslatent30=0 latent30client='No'.
if dayslatent30=1 Latent30Client='Yes'.
if SEDSVCkid=0 SEDKid='No'.
if SEDSVCkid=1 SEDKid='Yes'.

sort cases by ru.
match files /table="//covenas/decisionsupport/rutable.sav" /file=* /by ru /keep psmask2  Ethnicity case name Gender bday DischargeMonth RU provname GuidanceProvName GuidanceOpDate
GuidanceCloseDate AgeGroup DaysLatent7 DaysLatent30 Visits SEDsvcKid createDate Latent7Client Latent30Client sedkid.

select if not psmask2=700.


save outfile='//covenas/decisionsupport/temp/GuidanceFollowUpCareDetailx.sav'.
get file='//covenas/decisionsupport/temp/GuidanceFollowUpCareDetailx.sav'.

 * SAVE TRANSLATE /TYPE=ODBC
 /Connect ='DSN=DashboardData;UID=;APP=SPSS For'+
 ' Windows;WSID=HPMXL9360ZDD;DATABASE=DashboardData;Trusted_Connection=Yes'
 /table= 'GuidanceFollowUpCareDetail' /MAP/REPLACE.



