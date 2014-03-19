DEFINE StartDateCSOC() date.dmy(1,1,2011) !ENDDEFINE.

*who was open to intensive services at Guidence Opdate.
get file='//covenas/decisionsupport/epsCG.sav' /keep ru case opdate epFlag closDate .
*select if xdate.year(opdate) ge 2011 OR xdate.year(Closdate) ge 2011.
select if opdate ge StartDateCSOC OR (Closdate ge StartDateCSOC or missing(closdate)).

match files /table='//covenas/decisionsupport/ruTable.sav '/file=* /by ru/keep ru case opdate closDate psmask2 program svcType.

*keep = Connected to Intensive Service.

if SvcType="TBS" keep=1.

*project permance.
if ru = "01FB1" keep=1.

*1959. 
if any(ru,"01DW2", "81934") keep=1.

*Catch 21.
if ru = "81935" keep=1.

*County clinic.
if any(psmask2, 65537,262145)  keep=1.

**CollabCourt, MST?.

if any(ru,"01DY1","01DY2") keep=1.

select if keep=1.

if missing(closdate) closdate = Date.dmy(01,01,2020).

rename vars Opdate = TeamOpDate ClosDate = TeamCloseDate.
sort cases by case TeamOpDate .
match files/file=* /by case /first=case1.
temp.
select if case1=1.
save outfile='//covenas/decisionsupport/temp\KidTeamEp1.sav' /keep case TeamOpDate TeamCloseDate.
select if case1=0.
match files/file=* /by case /first=case2.
temp.
select if case2=1.
save outfile='//covenas/decisionsupport/temp\KidTeamEp2.sav' /keep case TeamOpDate TeamCloseDate.

select if case2=0.
match files/file=* /by case /first=case3.
temp.
select if case3=1.
save outfile='//covenas/decisionsupport/temp\KidTeamEp3.sav' /keep case TeamOpDate TeamCloseDate.
select if case3=0.
match files/file=* /by case /first=case4.
temp.
select if case4=1.
save outfile='//covenas/decisionsupport/temp\KidTeamEp4.sav' /keep case TeamOpDate TeamCloseDate.
freq case4.


*get file='//covenas/spssdata/temp\MEdicalTable.sav'.

get file='//covenas/decisionsupport/epsCG.sav' / keep ru case opdate epFlag lst_svc closDate primDx .

*select if xdate.tday(opdate) ge yrmoda(2011,07,01) OR xdate.tday(closdate) ge yrmoda(2011,07,01).

insert file='//covenas/decisionsupport/modules\UncookedMonth.sps'.

select if opdate lt UnCookedMonth and (opdate ge StartDateCSOC OR Closdate ge StartDateCSOC or missing(closdate)).

match files /table='//covenas/decisionsupport/ruTable.sav '/file=* /by ru/keep ru case opdate lst_svc closDate psmask2 PrimDx Provname.
select if psMask2=5.

include file='//covenas/decisionsupport/modules\CalOpdate.sps'.
sort cases by case calendar.
match files/table='//covenas/decisionsupport/MEdicalTable.sav' /file=* /by Case calendar.


if missing(closdate) closdate = Date.dmy(01,01,2020).

match files/table='//covenas/decisionsupport/temp\KidTeamEp1.sav' /file=* /by case.
if xdate.tday(TeamOpdate) lt xdate.tday(opdate) AND xdate.tday(TeamCloseDate) ge xdate.tday(opdate) FspSvcTeamClient=1.
match files/table='//covenas/decisionsupport/temp\KidTeamEp2.sav' /file=* /by case.
if xdate.tday(TeamOpdate) lt xdate.tday(opdate) AND xdate.tday(TeamCloseDate) ge xdate.tday(opdate) FspSvcTeamClient=1.
match files/table='//covenas/decisionsupport/temp\KidTeamEp3.sav' /file=* /by case.
if xdate.tday(TeamOpdate) lt xdate.tday(opdate) AND xdate.tday(TeamCloseDate) ge xdate.tday(opdate) FspSvcTeamClient=1.
match files/table='//covenas/decisionsupport/temp\KidTeamEp4.sav' /file=* /by case.
if xdate.tday(TeamOpdate) lt xdate.tday(opdate) AND xdate.tday(TeamCloseDate) ge xdate.tday(opdate) FspSvcTeamClient=1.

freq FspSvcTeamClient.

if closdate = Date.dmy(01,01,2020) closdate=$sysmis.
if TeamCloseDate=date.dmy(1,1,2020) TeamCloseDate=$sysmis.

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
 
rename variables primDx=Dx.
sort cases by dx.
match files/table='//covenas/decisionsupport/dx_Table2.sav'/file=* /by dx.

*aggregate outfile=* mode=addVars /break=Case /admits=sum(ep1).
*freq admits.

*freq ep1.	/*total number of hosp admissions for 2 different sections on the form.
*4298.

sort cases by case.
match files/table='//covenas/decisionsupport/clinfoCG.sav' /file=* /by case /drop name ssn CLIENT_STAMP birthName cin.
save outfile='//covenas/decisionsupport/temp\HospALLkids.sav' /drop Full
InMedsTable InsystPrimAidCode eCounty calendar
UserName TeamOpDate TeamCloseDate
Medical_Number medical_Eligibility_Stamp.



get file='//covenas/decisionsupport/temp\HospALLkids.sav'.

if opdateNext = 0 OpDateNext = date.dmy(01,01,2020).

compute AdmitAge = Trunc((xdate.tday(Opdate) - xdate.tday(bday))/365).
select if admitAge lt 18 and admitage gt 1.

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
save outfile='//covenas/decisionsupport/Temp\HospEp1K_kids.sav'
 /keep ageGroup  FspSvcTeamClient dx dx_descr dx_grpDSM bday sex HasMediCal hospru case hospep1 HospOpdate OpdatePrevious OpdateNext  HospProvname HospCloseDate.
select if HospEp1 = 0.
match files /file=* /by  case/first=HospEp2.

*freq hospep2.	/*793.

TEMPORARY.
select if HospEp2=1.
save outfile='//covenas/decisionsupport/Temp\HospEp2K_kids.sav' /keep FspSvcTeamClient ageGroup  dx dx_descr dx_grpDSM bday sex HasMediCal  hospru case lst_svc HospOpdate OpdatePrevious OpdateNext  HospProvname HospCloseDate.

select if HospEp2=0.
match files /file=* /by case /first=HospEp3.
*freq hospep3.	/*350.

TEMPORARY.
select if HospEp3 = 1.
save outfile='//covenas/decisionsupport/Temp\HospEp3K_kids.sav' /keep FspSvcTeamClient ageGroup  dx dx_descr dx_grpDSM bday sex HasMediCal  hospru case HospOpdate OpdatePrevious OpdateNext  HospProvname HospCloseDate.
 
select if HospEp3 =  0.
match files /file=* /by case /first=HospEp4.
freq hospep4.	/*159.

TEMPORARY.
select if HospEp4 = 1.
save outfile='//covenas/decisionsupport/Temp\HospEp4K_kids.sav'/keep FspSvcTeamClient ageGroup  dx dx_descr dx_grpDSM bday sex HasMediCal  hospru case HospOpdate OpdatePrevious OpdateNext  HospProvname HospCloseDate.

select if HospEp4 =  0.
match files /file=* /by case /first=HospEp5.
freq hospep5.	/*159.

TEMPORARY.
select if HospEp5 = 1.
save outfile='//covenas/decisionsupport/Temp\HospEp5K_kids.sav' /keep FspSvcTeamClient ageGroup  dx dx_descr dx_grpDSM bday sex HasMediCal  hospru case HospOpdate OpdatePrevious OpdateNext  HospProvname HospCloseDate.

select if HospEp5 =  0.
match files /file=* /by case /first=HospEp6.

TEMPORARY.
select if HospEp6 = 1.
save outfile='//covenas/decisionsupport/Temp\HospEp6K_kids.sav' /keep FspSvcTeamClient ageGroup  dx dx_descr dx_grpDSM bday sex HasMediCal  hospru case HospOpdate OpdatePrevious OpdateNext  HospProvname HospCloseDate.

select if HospEp6 =  0.
match files /file=* /by case /first=HospEp7.
freq hospep7.

TEMPORARY.
select if HospEp7 = 1.
save outfile='//covenas/decisionsupport/Temp\HospEp7K_kids.sav' /keep FspSvcTeamClient ageGroup  dx dx_descr dx_grpDSM bday sex HasMediCal  hospru case HospOpdate OpdatePrevious OpdateNext  HospProvname HospCloseDate.

select if HospEp7 =  0.
match files /file=* /by case /first=HospEp8.
freq hospep8.

TEMPORARY.
select if HospEp8 = 1.
save outfile='//covenas/decisionsupport/Temp\HospEp8K_kids.sav' /keep FspSvcTeamClient ageGroup  dx dx_descr dx_grpDSM bday sex HasMediCal  hospru case HospOpdate OpdatePrevious OpdateNext  HospProvname HospCloseDate.

select if HospEp8 =  0.
match files /file=* /by case /first=HospEp9.
freq hospep9.

TEMPORARY.
select if HospEp9 = 1.
save outfile='//covenas/decisionsupport/Temp\HospEp9K_kids.sav' /keep FspSvcTeamClient ageGroup  dx dx_descr dx_grpDSM bday sex HasMediCal  hospru case HospOpdate OpdatePrevious OpdateNext  HospProvname HospCloseDate.

select if HospEp9 =  0.
match files /file=* /by case /first=HospEp10.
freq hospep10.

TEMPORARY.
select if HospEp10 = 1.
save outfile='//covenas/decisionsupport/Temp\HospEp10K_kids.sav' /keep FspSvcTeamClient ageGroup  dx dx_descr dx_grpDSM bday sex HasMediCal  hospru case HospOpdate OpdatePrevious OpdateNext  HospProvname HospCloseDate.

select if HospEp10 =  0.
match files /file=* /by case /first=HospEp11.
freq hospep11.

TEMPORARY.
select if HospEp11 = 1.
save outfile='//covenas/decisionsupport/Temp\HospEp11K_kids.sav'/keep FspSvcTeamClient ageGroup  dx dx_descr dx_grpDSM bday sex HasMediCal  hospru case HospOpdate OpdatePrevious OpdateNext  HospProvname HospCloseDate.

select if HospEp11 =  0.
match files /file=* /by case /first=HospEp12.
freq hospep12.

TEMPORARY.
select if HospEp12 = 1.
save outfile='//covenas/decisionsupport/Temp\HospEp12K_kids.sav'/keep FspSvcTeamClient ageGroup  dx dx_descr dx_grpDSM bday sex HasMediCal  hospru case HospOpdate OpdatePrevious OpdateNext  HospProvname HospCloseDate.

select if HospEp12 =  0.
match files /file=* /by case /first=HospEp13.
freq hospep13.

TEMPORARY.
select if HospEp13 = 1.
save outfile='//covenas/decisionsupport/Temp\HospEp13K_kids.sav'/keep FspSvcTeamClient ageGroup  dx dx_descr dx_grpDSM bday sex HasMediCal  hospru case HospOpdate OpdatePrevious OpdateNext  HospProvname HospCloseDate.

select if HospEp13 =  0.
match files /file=* /by case /first=HospEp14.
freq hospep14.

TEMPORARY.
select if HospEp14 = 1.
save outfile='//covenas/decisionsupport/Temp\HospEp14K_kids.sav'/keep FspSvcTeamClient ageGroup  dx dx_descr dx_grpDSM bday sex HasMediCal  hospru case HospOpdate OpdatePrevious OpdateNext  HospProvname HospCloseDate.

select if HospEp14 =  0.
match files /file=* /by case /first=HospEp15.
freq hospep15.

TEMPORARY.
select if HospEp15 = 1.
save outfile='//covenas/decisionsupport/Temp\HospEp15K_kids.sav'/keep FspSvcTeamClient ageGroup  dx dx_descr dx_grpDSM bday sex HasMediCal  hospru case HospOpdate OpdatePrevious OpdateNext  HospProvname HospCloseDate.

select if HospEp15 =  0.
match files /file=* /by case /first=HospEp16.
freq hospep16.

TEMPORARY.
select if HospEp16 = 1.
save outfile='//covenas/decisionsupport/Temp\HospEp16K_kids.sav'/keep FspSvcTeamClient ageGroup  dx dx_descr dx_grpDSM bday sex HasMediCal  hospru case HospOpdate OpdatePrevious OpdateNext  HospProvname HospCloseDate.

select if HospEp16 =  0.
match files /file=* /by case /first=HospEp17.
freq hospep17.

TEMPORARY.
select if HospEp17 = 1.
save outfile='//covenas/decisionsupport/Temp\HospEp17K_kids.sav'/keep FspSvcTeamClient ageGroup  dx dx_descr dx_grpDSM bday sex HasMediCal  hospru case HospOpdate OpdatePrevious OpdateNext  HospProvname HospCloseDate.

select if HospEp17 =  0.
match files /file=* /by case /first=HospEp18.
freq hospep18.

TEMPORARY.
select if HospEp18 = 1.
save outfile='//covenas/decisionsupport/Temp\HospEp18K_kids.sav'/keep FspSvcTeamClient ageGroup  dx dx_descr dx_grpDSM bday sex HasMediCal  hospru case HospOpdate OpdatePrevious OpdateNext  HospProvname HospCloseDate.

*select if HospEp18 =  0.
*match files /file=* /by case /first=HospEp19.
*freq hospep19.

*TEMPORARY.
*select if HospEp19 = 1.
*save outfile='//covenas/decisionsupport/Temp\HospEp19K_kids.sav'/keep FspSvcTeamClient ageGroup  dx dx_descr dx_grpDSM bday sex HasMediCal  hospru case HospOpdate OpdatePrevious OpdateNext  HospProvname HospCloseDate.

*select if HospEp19 =  0.
*match files /file=* /by case /first=HospEp20.
*freq hospep20.

*TEMPORARY.
*select if HospEp20 = 1.
*save outfile='//covenas/decisionsupport/Temp\HospEp20K_kids.sav'/keep FspSvcTeamClient ageGroup  dx dx_descr dx_grpDSM bday sex HasMediCal  hospru case HospOpdate OpdatePrevious OpdateNext  HospProvname HospCloseDate.

*select if HospEp20 =  0.
*match files /file=* /by case /first=HospEp21.
*freq hospep21.

*FOLLOWUP FOR EP1 START.



get file='//covenas/decisionsupport/temp\INSYSTservicesALLXX.sav'
   /keep case svcdate proced ru  opdate agency provname psMask2 svcage.

****don't we need to cap services to cooked months?.
 * if xdate.mday($time) le 15  UnCookedMonth = DateSum($time,-1,"months").
 * if xdate.mday($time) gt 15  UnCookedMonth = DateSum($time,-0,"months").
 * compute  UnCookedMonth =date.moyr(xdate.month( UnCookedMonth), xdate.year( UnCookedMonth)).
 * formats  UnCookedMonth(moyr6).

 * select if svcdate lt  UnCookedMonth.
insert file='//covenas/decisionsupport/modules\UncookedMonth.sps'.
select if svcdate lt UnCookedMonth and svcdate gt StartDateCSOC.
select if svcage lt 19.
*select if not any(proced ,300,400,197).

*sort cases by ru case svcdate.
*match files /table='//covenas/spssdata/RUTable.sav' /file=* /by ru
 /keep proced ru case svcdate Provname opdate svcType svcType3 COunty Kidsru PSMask2 Agency.
 
if any(PsMask2,5,34,17,19,33) drop=1.
***add?.
*if psmask2 =700 drop=1.




if ru ne "01193" AND psmask2=4097 Drop=1.

*Assessment Center.
if any(ru,"01DW1", "81933") drop=1.

*SENECA MOBILE RESP TEAM MHS CH  .
if RU = "811825" drop=1.

select if missing(Drop). 

compute svcdate = xdate.date(svcdate).
sort cases by ru case svcdate .
match files/file=* /by ru case svcdate/last=visit1.
select if visit1=1.

select if ru ne "765001".
select if ru ne "01871".
select if ru ne "01013".
select if agency ne "Vocational".

*freq provname /format=DFreq.

compute FUsvc=1.


save outfile='//covenas/decisionsupport/temp\ServicesByType_Kid.sav' /keep ru case svcdate provname FUsvc agency.


get file='//covenas/decisionsupport/temp\ServicesByType_Kid.sav'.
sort cases by case.
match files/table='//covenas/decisionsupport/Temp\HospEp1K_kids.sav' /file=* /by case.
select if HospProvname ne  " ".

select if xdate.tday(svcdate) ge (xdate.tday(HospClosedate)-1).
compute lapse = xdate.tday(svcdate) - (xdate.tday(HospClosedate)-1).
select if lapse lt 91.

if xdate.tday(svcdate) lt xdate.tday(OpDateNext) AND lapse lt 8 AND FUsvc=1 Latent7=1.
if xdate.tday(svcdate) lt xdate.tday(OpDateNext) AND lapse lt 31 AND FUsvc=1 Latent30=1.

agg outfile=* mode=addVars /break=ru case/gotCare = max(latent30).
select if gotCare=1.

*select if latent7=1 OR latent30=1.

agg outfile='//covenas/decisionsupport/temp\HospPostSvc_kid1.sav'
	/break= case hospRU HospOpdate
	/latent7 = max(latent7)
	/Latent30 = max(Latent30).

save outfile='//covenas/decisionsupport/temp\HospPostSvc1_WORK.sav' /drop GotCare.

get file='//covenas/decisionsupport/Temp\HospEp1K_kids.sav'.
sort cases by case hospRU hospOpdate.
match files/table='//covenas/decisionsupport/temp\HospPostSvc_kid1.sav' /file=* /by case hospRU hospOpdate.

if xdate.tday(OpdateNext) ne yrmoda(2020,01,01) AND xdate.tday(OpdateNext) - xdate.tday(HospCloseDate) lt 11 HospRecid10=1.
if xdate.tday(OpdateNext) ne yrmoda(2020,01,01) AND xdate.tday(OpdateNext) - xdate.tday(HospCloseDate) lt 31 HospRecid30=1.

compute calendar = date.moyr(xdate.month(HospCloseDate),xdate.year(HospCloseDate)).
formats calendar(moyr6).

compute LOS = xdate.tday(HospCloseDate) - xdate.tday(HospOpDate)+1.

save outfile='//covenas/decisionsupport/temp\HospResults1_WORK.sav'.
aggregate outfile='//covenas/decisionsupport/temp\HospResults1_kids.sav'
	/break=case HOSPRU HospOpdate HospCloseDate HospProvname dx dx_descr dx_grpDSM bday sex HasMediCal LOS AgeGroup FspSvcTeamClient
	/Latent7 = max(Latent7)
	/Latent30= max(latent30)
	/HospRecid10= max(HospRecid10)	
	/HospRecid30= max(HospRecid30).	

*****************************.

get file='//covenas/decisionsupport/temp/ServicesByType_Kid.sav'.
sort cases by case.
match files/table='//covenas/decisionsupport/Temp/HospEp2K_kids.sav' /file=* /by case.
select if HospProvname ne  " ".

select if xdate.tday(svcdate) ge (xdate.tday(HospClosedate)-1).
compute lapse = xdate.tday(svcdate) - (xdate.tday(HospClosedate)-1).
select if lapse lt 91.

if xdate.tday(svcdate) lt xdate.tday(OpDateNext) AND lapse lt 8 AND FUsvc=1 Latent7=1.
if xdate.tday(svcdate) lt xdate.tday(OpDateNext) AND lapse lt 31 AND FUsvc=1 Latent30=1.

agg outfile=* mode=addVars /break=ru case/gotCare = max(latent30).
select if gotCare=1.

*select if latent7=1 OR latent30=1.

agg outfile='//covenas/decisionsupport/temp\HospPostSvc_kid2.sav'
	/break= case hospRU HospOpdate
	/latent7 = max(latent7)
	/Latent30 = max(Latent30).

save outfile='//covenas/decisionsupport/temp/HospPostSvc2_WORK.sav' /drop GotCare.

get file='//covenas/decisionsupport/Temp/HospEp2K_kids.sav'.
sort cases by case hospRU hospOpdate.
match files/table='//covenas/decisionsupport/temp\HospPostSvc_kid2.sav' /file=* /by case hospRU hospOpdate.

if xdate.tday(OpdateNext) ne yrmoda(2020,01,01) AND xdate.tday(OpdateNext) - xdate.tday(HospCloseDate) lt 11 HospRecid10=1.
if xdate.tday(OpdateNext) ne yrmoda(2020,01,01) AND xdate.tday(OpdateNext) - xdate.tday(HospCloseDate) lt 31 HospRecid30=1.

compute calendar = date.moyr(xdate.month(HospCloseDate),xdate.year(HospCloseDate)).
formats calendar(moyr6).

compute LOS = xdate.tday(HospCloseDate) - xdate.tday(HospOpDate)+1.

save outfile='//covenas/decisionsupport/temp/HospResults2_WORK.sav'.
aggregate outfile='//covenas/decisionsupport/temp/HospResults2_kids.sav'
	/break=case HOSPRU HospOpdate HospCloseDate HospProvname dx dx_descr dx_grpDSM bday sex HasMediCal LOS AgeGroup FspSvcTeamClient
	/Latent7 = max(Latent7)
	/Latent30= max(latent30)
	/HospRecid10= max(HospRecid10)	
	/HospRecid30= max(HospRecid30).	
	

get file='//covenas/decisionsupport/temp/ServicesByType_Kid.sav'.
sort cases by case.
match files/table='//covenas/decisionsupport/Temp/HospEp3K_kids.sav' /file=* /by case.
select if HospProvname ne  " ".

select if xdate.tday(svcdate) ge (xdate.tday(HospClosedate)-1).
compute lapse = xdate.tday(svcdate) - (xdate.tday(HospClosedate)-1).
select if lapse lt 91.

if xdate.tday(svcdate) lt xdate.tday(OpDateNext) AND lapse lt 8 AND FUsvc=1 Latent7=1.
if xdate.tday(svcdate) lt xdate.tday(OpDateNext) AND lapse lt 31 AND FUsvc=1 Latent30=1.

agg outfile=* mode=addVars /break=ru case/gotCare = max(latent30).
select if gotCare=1.

*select if latent7=1 OR latent30=1.

agg outfile='//covenas/decisionsupport/temp\HospPostSvc_kid3.sav'
	/break= case hospRU HospOpdate
	/latent7 = max(latent7)
	/Latent30 = max(Latent30).

save outfile='//covenas/decisionsupport/temp/HospPostSvc3_WORK.sav' /drop GotCare.

get file='//covenas/decisionsupport/Temp/HospEp3K_kids.sav'.
sort cases by case hospRU hospOpdate.
match files/table='//covenas/decisionsupport/temp\HospPostSvc_kid3.sav' /file=* /by case hospRU hospOpdate.

if xdate.tday(OpdateNext) ne yrmoda(2020,01,01) AND xdate.tday(OpdateNext) - xdate.tday(HospCloseDate) lt 11 HospRecid10=1.
if xdate.tday(OpdateNext) ne yrmoda(2020,01,01) AND xdate.tday(OpdateNext) - xdate.tday(HospCloseDate) lt 31 HospRecid30=1.

compute calendar = date.moyr(xdate.month(HospCloseDate),xdate.year(HospCloseDate)).
formats calendar(moyr6).

compute LOS = xdate.tday(HospCloseDate) - xdate.tday(HospOpDate)+1.

save outfile='//covenas/decisionsupport/temp/HospResults3_WORK.sav'.
aggregate outfile='//covenas/decisionsupport/temp/HospResults3_kids.sav'
	/break=case HOSPRU HospOpdate HospCloseDate HospProvname dx dx_descr dx_grpDSM bday sex HasMediCal LOS AgeGroup FspSvcTeamClient
	/Latent7 = max(Latent7)
	/Latent30= max(latent30)
	/HospRecid10= max(HospRecid10)	
	/HospRecid30= max(HospRecid30).	
	

get file='//covenas/decisionsupport/temp/ServicesByType_Kid.sav'.
sort cases by case.
match files/table='//covenas/decisionsupport/Temp/HospEp4K_kids.sav' /file=* /by case.
select if HospProvname ne  " ".

select if xdate.tday(svcdate) ge (xdate.tday(HospClosedate)-1).
compute lapse = xdate.tday(svcdate) - (xdate.tday(HospClosedate)-1).
select if lapse lt 91.

if xdate.tday(svcdate) lt xdate.tday(OpDateNext) AND lapse lt 8 AND FUsvc=1 Latent7=1.
if xdate.tday(svcdate) lt xdate.tday(OpDateNext) AND lapse lt 31 AND FUsvc=1 Latent30=1.

agg outfile=* mode=addVars /break=ru case/gotCare = max(latent30).
select if gotCare=1.

*select if latent7=1 OR latent30=1.

agg outfile='//covenas/decisionsupport/temp\HospPostSvc_kid4.sav'
	/break= case hospRU HospOpdate
	/latent7 = max(latent7)
	/Latent30 = max(Latent30).

save outfile='//covenas/decisionsupport/temp/HospPostSvc4_WORK.sav' /drop GotCare.

get file='//covenas/decisionsupport/Temp/HospEp4K_kids.sav'.
sort cases by case hospRU hospOpdate.
match files/table='//covenas/decisionsupport/temp\HospPostSvc_kid4.sav' /file=* /by case hospRU hospOpdate.

if xdate.tday(OpdateNext) ne yrmoda(2020,01,01) AND xdate.tday(OpdateNext) - xdate.tday(HospCloseDate) lt 11 HospRecid10=1.
if xdate.tday(OpdateNext) ne yrmoda(2020,01,01) AND xdate.tday(OpdateNext) - xdate.tday(HospCloseDate) lt 31 HospRecid30=1.

compute calendar = date.moyr(xdate.month(HospCloseDate),xdate.year(HospCloseDate)).
formats calendar(moyr6).

compute LOS = xdate.tday(HospCloseDate) - xdate.tday(HospOpDate)+1.

save outfile='//covenas/decisionsupport/temp/HospResults4_WORK.sav'.
aggregate outfile='//covenas/decisionsupport/temp/HospResults4_kids.sav'
	/break=case HOSPRU HospOpdate HospCloseDate HospProvname dx dx_descr dx_grpDSM bday sex HasMediCal LOS AgeGroup FspSvcTeamClient
	/Latent7 = max(Latent7)
	/Latent30= max(latent30)
	/HospRecid10= max(HospRecid10)	
	/HospRecid30= max(HospRecid30).	
	

get file='//covenas/decisionsupport/temp/ServicesByType_Kid.sav'.
sort cases by case.
match files/table='//covenas/decisionsupport/Temp/HospEp5K_kids.sav' /file=* /by case.
select if HospProvname ne  " ".

select if xdate.tday(svcdate) ge (xdate.tday(HospClosedate)-1).
compute lapse = xdate.tday(svcdate) - (xdate.tday(HospClosedate)-1).
select if lapse lt 91.

if xdate.tday(svcdate) lt xdate.tday(OpDateNext) AND lapse lt 8 AND FUsvc=1 Latent7=1.
if xdate.tday(svcdate) lt xdate.tday(OpDateNext) AND lapse lt 31 AND FUsvc=1 Latent30=1.

agg outfile=* mode=addVars /break=ru case/gotCare = max(latent30).
select if gotCare=1.

*select if latent7=1 OR latent30=1.

agg outfile='//covenas/decisionsupport/temp\HospPostSvc_kid5.sav'
	/break= case hospRU HospOpdate
	/latent7 = max(latent7)
	/Latent30 = max(Latent30).

save outfile='//covenas/decisionsupport/temp/HospPostSvc5_WORK.sav' /drop GotCare.

get file='//covenas/decisionsupport/Temp/HospEp5K_kids.sav'.
sort cases by case hospRU hospOpdate.
match files/table='//covenas/decisionsupport/temp\HospPostSvc_kid5.sav' /file=* /by case hospRU hospOpdate.

if xdate.tday(OpdateNext) ne yrmoda(2020,01,01) AND xdate.tday(OpdateNext) - xdate.tday(HospCloseDate) lt 11 HospRecid10=1.
if xdate.tday(OpdateNext) ne yrmoda(2020,01,01) AND xdate.tday(OpdateNext) - xdate.tday(HospCloseDate) lt 31 HospRecid30=1.

compute calendar = date.moyr(xdate.month(HospCloseDate),xdate.year(HospCloseDate)).
formats calendar(moyr6).

compute LOS = xdate.tday(HospCloseDate) - xdate.tday(HospOpDate)+1.

save outfile='//covenas/decisionsupport/temp/HospResults5_WORK.sav'.
aggregate outfile='//covenas/decisionsupport/temp/HospResults5_kids.sav'
	/break=case HOSPRU HospOpdate HospCloseDate HospProvname dx dx_descr dx_grpDSM bday sex HasMediCal LOS AgeGroup FspSvcTeamClient
	/Latent7 = max(Latent7)
	/Latent30= max(latent30)
	/HospRecid10= max(HospRecid10)	
	/HospRecid30= max(HospRecid30).	
	

get file='//covenas/decisionsupport/temp/ServicesByType_Kid.sav'.
sort cases by case.
match files/table='//covenas/decisionsupport/Temp/HospEp6K_kids.sav' /file=* /by case.
select if HospProvname ne  " ".

select if xdate.tday(svcdate) ge (xdate.tday(HospClosedate)-1).
compute lapse = xdate.tday(svcdate) - (xdate.tday(HospClosedate)-1).
select if lapse lt 91.

if xdate.tday(svcdate) lt xdate.tday(OpDateNext) AND lapse lt 8 AND FUsvc=1 Latent7=1.
if xdate.tday(svcdate) lt xdate.tday(OpDateNext) AND lapse lt 31 AND FUsvc=1 Latent30=1.

agg outfile=* mode=addVars /break=ru case/gotCare = max(latent30).
select if gotCare=1.

*select if latent7=1 OR latent30=1.

agg outfile='//covenas/decisionsupport/temp\HospPostSvc_kid6.sav'
	/break= case hospRU HospOpdate
	/latent7 = max(latent7)
	/Latent30 = max(Latent30).

save outfile='//covenas/decisionsupport/temp/HospPostSvc6_WORK.sav' /drop GotCare.

get file='//covenas/decisionsupport/Temp/HospEp6K_kids.sav'.
sort cases by case hospRU hospOpdate.
match files/table='//covenas/decisionsupport/temp\HospPostSvc_kid6.sav' /file=* /by case hospRU hospOpdate.

if xdate.tday(OpdateNext) ne yrmoda(2020,01,01) AND xdate.tday(OpdateNext) - xdate.tday(HospCloseDate) lt 11 HospRecid10=1.
if xdate.tday(OpdateNext) ne yrmoda(2020,01,01) AND xdate.tday(OpdateNext) - xdate.tday(HospCloseDate) lt 31 HospRecid30=1.

compute calendar = date.moyr(xdate.month(HospCloseDate),xdate.year(HospCloseDate)).
formats calendar(moyr6).

compute LOS = xdate.tday(HospCloseDate) - xdate.tday(HospOpDate)+1.

save outfile='//covenas/decisionsupport/temp/HospResults6_WORK.sav'.
aggregate outfile='//covenas/decisionsupport/temp/HospResults6_kids.sav'
	/break=case HOSPRU HospOpdate HospCloseDate HospProvname dx dx_descr dx_grpDSM bday sex HasMediCal LOS AgeGroup FspSvcTeamClient
	/Latent7 = max(Latent7)
	/Latent30= max(latent30)
	/HospRecid10= max(HospRecid10)	
	/HospRecid30= max(HospRecid30).	
	

get file='//covenas/decisionsupport/temp/ServicesByType_Kid.sav'.
sort cases by case.
match files/table='//covenas/decisionsupport/Temp/HospEp7K_kids.sav' /file=* /by case.
select if HospProvname ne  " ".

select if xdate.tday(svcdate) ge (xdate.tday(HospClosedate)-1).
compute lapse = xdate.tday(svcdate) - (xdate.tday(HospClosedate)-1).
select if lapse lt 91.

if xdate.tday(svcdate) lt xdate.tday(OpDateNext) AND lapse lt 8 AND FUsvc=1 Latent7=1.
if xdate.tday(svcdate) lt xdate.tday(OpDateNext) AND lapse lt 31 AND FUsvc=1 Latent30=1.

agg outfile=* mode=addVars /break=ru case/gotCare = max(latent30).
select if gotCare=1.

*select if latent7=1 OR latent30=1.

agg outfile='//covenas/decisionsupport/temp\HospPostSvc_kid7.sav'
	/break= case hospRU HospOpdate
	/latent7 = max(latent7)
	/Latent30 = max(Latent30).

save outfile='//covenas/decisionsupport/temp/HospPostSvc7_WORK.sav' /drop GotCare.

get file='//covenas/decisionsupport/Temp/HospEp7K_kids.sav'.
sort cases by case hospRU hospOpdate.
match files/table='//covenas/decisionsupport/temp\HospPostSvc_kid7.sav' /file=* /by case hospRU hospOpdate.

if xdate.tday(OpdateNext) ne yrmoda(2020,01,01) AND xdate.tday(OpdateNext) - xdate.tday(HospCloseDate) lt 11 HospRecid10=1.
if xdate.tday(OpdateNext) ne yrmoda(2020,01,01) AND xdate.tday(OpdateNext) - xdate.tday(HospCloseDate) lt 31 HospRecid30=1.

compute calendar = date.moyr(xdate.month(HospCloseDate),xdate.year(HospCloseDate)).
formats calendar(moyr6).

compute LOS = xdate.tday(HospCloseDate) - xdate.tday(HospOpDate)+1.

save outfile='//covenas/decisionsupport/temp/HospResults7_WORK.sav'.
aggregate outfile='//covenas/decisionsupport/temp/HospResults7_kids.sav'
	/break=case HOSPRU HospOpdate HospCloseDate HospProvname dx dx_descr dx_grpDSM bday sex HasMediCal LOS AgeGroup FspSvcTeamClient
	/Latent7 = max(Latent7)
	/Latent30= max(latent30)
	/HospRecid10= max(HospRecid10)	
	/HospRecid30= max(HospRecid30).	
	

get file='//covenas/decisionsupport/temp/ServicesByType_Kid.sav'.
sort cases by case.
match files/table='//covenas/decisionsupport/Temp/HospEp8K_kids.sav' /file=* /by case.
select if HospProvname ne  " ".

select if xdate.tday(svcdate) ge (xdate.tday(HospClosedate)-1).
compute lapse = xdate.tday(svcdate) - (xdate.tday(HospClosedate)-1).
select if lapse lt 91.

if xdate.tday(svcdate) lt xdate.tday(OpDateNext) AND lapse lt 8 AND FUsvc=1 Latent7=1.
if xdate.tday(svcdate) lt xdate.tday(OpDateNext) AND lapse lt 31 AND FUsvc=1 Latent30=1.

agg outfile=* mode=addVars /break=ru case/gotCare = max(latent30).
select if gotCare=1.

*select if latent7=1 OR latent30=1.

agg outfile='//covenas/decisionsupport/temp\HospPostSvc_kid8.sav'
	/break= case hospRU HospOpdate
	/latent7 = max(latent7)
	/Latent30 = max(Latent30).

save outfile='//covenas/decisionsupport/temp/HospPostSvc8_WORK.sav' /drop GotCare.

get file='//covenas/decisionsupport/Temp/HospEp8K_kids.sav'.
sort cases by case hospRU hospOpdate.
match files/table='//covenas/decisionsupport/temp\HospPostSvc_kid8.sav' /file=* /by case hospRU hospOpdate.

if xdate.tday(OpdateNext) ne yrmoda(2020,01,01) AND xdate.tday(OpdateNext) - xdate.tday(HospCloseDate) lt 11 HospRecid10=1.
if xdate.tday(OpdateNext) ne yrmoda(2020,01,01) AND xdate.tday(OpdateNext) - xdate.tday(HospCloseDate) lt 31 HospRecid30=1.

compute calendar = date.moyr(xdate.month(HospCloseDate),xdate.year(HospCloseDate)).
formats calendar(moyr6).

compute LOS = xdate.tday(HospCloseDate) - xdate.tday(HospOpDate)+1.

save outfile='//covenas/decisionsupport/temp/HospResults8_WORK.sav'.
aggregate outfile='//covenas/decisionsupport/temp/HospResults8_kids.sav'
	/break=case HOSPRU HospOpdate HospCloseDate HospProvname dx dx_descr dx_grpDSM bday sex HasMediCal LOS AgeGroup FspSvcTeamClient
	/Latent7 = max(Latent7)
	/Latent30= max(latent30)
	/HospRecid10= max(HospRecid10)	
	/HospRecid30= max(HospRecid30).	
	

get file='//covenas/decisionsupport/temp/ServicesByType_Kid.sav'.
sort cases by case.
match files/table='//covenas/decisionsupport/Temp/HospEp9K_kids.sav' /file=* /by case.
select if HospProvname ne  " ".

select if xdate.tday(svcdate) ge (xdate.tday(HospClosedate)-1).
compute lapse = xdate.tday(svcdate) - (xdate.tday(HospClosedate)-1).
select if lapse lt 91.

if xdate.tday(svcdate) lt xdate.tday(OpDateNext) AND lapse lt 8 AND FUsvc=1 Latent7=1.
if xdate.tday(svcdate) lt xdate.tday(OpDateNext) AND lapse lt 31 AND FUsvc=1 Latent30=1.

agg outfile=* mode=addVars /break=ru case/gotCare = max(latent30).
select if gotCare=1.

*select if latent7=1 OR latent30=1.

agg outfile='//covenas/decisionsupport/temp\HospPostSvc_kid9.sav'
	/break= case hospRU HospOpdate
	/latent7 = max(latent7)
	/Latent30 = max(Latent30).

save outfile='//covenas/decisionsupport/temp/HospPostSvc9_WORK.sav' /drop GotCare.

get file='//covenas/decisionsupport/Temp/HospEp9K_kids.sav'.
sort cases by case hospRU hospOpdate.
match files/table='//covenas/decisionsupport/temp\HospPostSvc_kid9.sav' /file=* /by case hospRU hospOpdate.

if xdate.tday(OpdateNext) ne yrmoda(2020,01,01) AND xdate.tday(OpdateNext) - xdate.tday(HospCloseDate) lt 11 HospRecid10=1.
if xdate.tday(OpdateNext) ne yrmoda(2020,01,01) AND xdate.tday(OpdateNext) - xdate.tday(HospCloseDate) lt 31 HospRecid30=1.

compute calendar = date.moyr(xdate.month(HospCloseDate),xdate.year(HospCloseDate)).
formats calendar(moyr6).

compute LOS = xdate.tday(HospCloseDate) - xdate.tday(HospOpDate)+1.

save outfile='//covenas/decisionsupport/temp/HospResults9_WORK.sav'.
aggregate outfile='//covenas/decisionsupport/temp/HospResults9_kids.sav'
	/break=case HOSPRU HospOpdate HospCloseDate HospProvname dx dx_descr dx_grpDSM bday sex HasMediCal LOS AgeGroup FspSvcTeamClient
	/Latent7 = max(Latent7)
	/Latent30= max(latent30)
	/HospRecid10= max(HospRecid10)	
	/HospRecid30= max(HospRecid30).	
	

get file='//covenas/decisionsupport/temp/ServicesByType_Kid.sav'.
sort cases by case.
match files/table='//covenas/decisionsupport/Temp/HospEp10K_kids.sav' /file=* /by case.
select if HospProvname ne  " ".

select if xdate.tday(svcdate) ge (xdate.tday(HospClosedate)-1).
compute lapse = xdate.tday(svcdate) - (xdate.tday(HospClosedate)-1).
select if lapse lt 91.

if xdate.tday(svcdate) lt xdate.tday(OpDateNext) AND lapse lt 8 AND FUsvc=1 Latent7=1.
if xdate.tday(svcdate) lt xdate.tday(OpDateNext) AND lapse lt 31 AND FUsvc=1 Latent30=1.

agg outfile=* mode=addVars /break=ru case/gotCare = max(latent30).
select if gotCare=1.

*select if latent7=1 OR latent30=1.

agg outfile='//covenas/decisionsupport/temp\HospPostSvc_kid10.sav'
	/break= case hospRU HospOpdate
	/latent7 = max(latent7)
	/Latent30 = max(Latent30).

save outfile='//covenas/decisionsupport/temp/HospPostSvc10_WORK.sav' /drop GotCare.

get file='//covenas/decisionsupport/Temp/HospEp10K_kids.sav'.
sort cases by case hospRU hospOpdate.
match files/table='//covenas/decisionsupport/temp\HospPostSvc_kid10.sav' /file=* /by case hospRU hospOpdate.

if xdate.tday(OpdateNext) ne yrmoda(2020,01,01) AND xdate.tday(OpdateNext) - xdate.tday(HospCloseDate) lt 11 HospRecid10=1.
if xdate.tday(OpdateNext) ne yrmoda(2020,01,01) AND xdate.tday(OpdateNext) - xdate.tday(HospCloseDate) lt 31 HospRecid30=1.

compute calendar = date.moyr(xdate.month(HospCloseDate),xdate.year(HospCloseDate)).
formats calendar(moyr6).

compute LOS = xdate.tday(HospCloseDate) - xdate.tday(HospOpDate)+1.

save outfile='//covenas/decisionsupport/temp/HospResults10_WORK.sav'.
aggregate outfile='//covenas/decisionsupport/temp/HospResults10_kids.sav'
	/break=case HOSPRU HospOpdate HospCloseDate HospProvname dx dx_descr dx_grpDSM bday sex HasMediCal LOS AgeGroup FspSvcTeamClient
	/Latent7 = max(Latent7)
	/Latent30= max(latent30)
	/HospRecid10= max(HospRecid10)	
	/HospRecid30= max(HospRecid30).	
	

get file='//covenas/decisionsupport/temp/ServicesByType_Kid.sav'.
sort cases by case.
match files/table='//covenas/decisionsupport/Temp/HospEp11K_kids.sav' /file=* /by case.
select if HospProvname ne  " ".

select if xdate.tday(svcdate) ge (xdate.tday(HospClosedate)-1).
compute lapse = xdate.tday(svcdate) - (xdate.tday(HospClosedate)-1).
select if lapse lt 91.

if xdate.tday(svcdate) lt xdate.tday(OpDateNext) AND lapse lt 8 AND FUsvc=1 Latent7=1.
if xdate.tday(svcdate) lt xdate.tday(OpDateNext) AND lapse lt 31 AND FUsvc=1 Latent30=1.

agg outfile=* mode=addVars /break=ru case/gotCare = max(latent30).
select if gotCare=1.

*select if latent7=1 OR latent30=1.

agg outfile='//covenas/decisionsupport/temp\HospPostSvc_kid11.sav'
	/break= case hospRU HospOpdate
	/latent7 = max(latent7)
	/Latent30 = max(Latent30).

save outfile='//covenas/decisionsupport/temp/HospPostSvc11_WORK.sav' /drop GotCare.

get file='//covenas/decisionsupport/Temp/HospEp11K_kids.sav'.
sort cases by case hospRU hospOpdate.
match files/table='//covenas/decisionsupport/temp\HospPostSvc_kid11.sav' /file=* /by case hospRU hospOpdate.

if xdate.tday(OpdateNext) ne yrmoda(2020,01,01) AND xdate.tday(OpdateNext) - xdate.tday(HospCloseDate) lt 11 HospRecid10=1.
if xdate.tday(OpdateNext) ne yrmoda(2020,01,01) AND xdate.tday(OpdateNext) - xdate.tday(HospCloseDate) lt 31 HospRecid30=1.

compute calendar = date.moyr(xdate.month(HospCloseDate),xdate.year(HospCloseDate)).
formats calendar(moyr6).

compute LOS = xdate.tday(HospCloseDate) - xdate.tday(HospOpDate)+1.

save outfile='//covenas/decisionsupport/temp/HospResults11_WORK.sav'.
aggregate outfile='//covenas/decisionsupport/temp/HospResults11_kids.sav'
	/break=case HOSPRU HospOpdate HospCloseDate HospProvname dx dx_descr dx_grpDSM bday sex HasMediCal LOS AgeGroup FspSvcTeamClient
	/Latent7 = max(Latent7)
	/Latent30= max(latent30)
	/HospRecid10= max(HospRecid10)	
	/HospRecid30= max(HospRecid30).	
	

get file='//covenas/decisionsupport/temp/ServicesByType_Kid.sav'.
sort cases by case.
match files/table='//covenas/decisionsupport/Temp/HospEp12K_kids.sav' /file=* /by case.
select if HospProvname ne  " ".

select if xdate.tday(svcdate) ge (xdate.tday(HospClosedate)-1).
compute lapse = xdate.tday(svcdate) - (xdate.tday(HospClosedate)-1).
select if lapse lt 91.

if xdate.tday(svcdate) lt xdate.tday(OpDateNext) AND lapse lt 8 AND FUsvc=1 Latent7=1.
if xdate.tday(svcdate) lt xdate.tday(OpDateNext) AND lapse lt 31 AND FUsvc=1 Latent30=1.

agg outfile=* mode=addVars /break=ru case/gotCare = max(latent30).
select if gotCare=1.

*select if latent7=1 OR latent30=1.

agg outfile='//covenas/decisionsupport/temp\HospPostSvc_kid12.sav'
	/break= case hospRU HospOpdate
	/latent7 = max(latent7)
	/Latent30 = max(Latent30).

save outfile='//covenas/decisionsupport/temp/HospPostSvc12_WORK.sav' /drop GotCare.

get file='//covenas/decisionsupport/Temp/HospEp12K_kids.sav'.
sort cases by case hospRU hospOpdate.
match files/table='//covenas/decisionsupport/temp\HospPostSvc_kid12.sav' /file=* /by case hospRU hospOpdate.

if xdate.tday(OpdateNext) ne yrmoda(2020,01,01) AND xdate.tday(OpdateNext) - xdate.tday(HospCloseDate) lt 11 HospRecid10=1.
if xdate.tday(OpdateNext) ne yrmoda(2020,01,01) AND xdate.tday(OpdateNext) - xdate.tday(HospCloseDate) lt 31 HospRecid30=1.

compute calendar = date.moyr(xdate.month(HospCloseDate),xdate.year(HospCloseDate)).
formats calendar(moyr6).

compute LOS = xdate.tday(HospCloseDate) - xdate.tday(HospOpDate)+1.

save outfile='//covenas/decisionsupport/temp/HospResults12_WORK.sav'.
aggregate outfile='//covenas/decisionsupport/temp/HospResults12_kids.sav'
	/break=case HOSPRU HospOpdate HospCloseDate HospProvname dx dx_descr dx_grpDSM bday sex HasMediCal LOS AgeGroup FspSvcTeamClient
	/Latent7 = max(Latent7)
	/Latent30= max(latent30)
	/HospRecid10= max(HospRecid10)	
	/HospRecid30= max(HospRecid30).	
	

get file='//covenas/decisionsupport/temp/ServicesByType_Kid.sav'.
sort cases by case.
match files/table='//covenas/decisionsupport/Temp/HospEp13K_kids.sav' /file=* /by case.
select if HospProvname ne  " ".

select if xdate.tday(svcdate) ge (xdate.tday(HospClosedate)-1).
compute lapse = xdate.tday(svcdate) - (xdate.tday(HospClosedate)-1).
select if lapse lt 91.

if xdate.tday(svcdate) lt xdate.tday(OpDateNext) AND lapse lt 8 AND FUsvc=1 Latent7=1.
if xdate.tday(svcdate) lt xdate.tday(OpDateNext) AND lapse lt 31 AND FUsvc=1 Latent30=1.

agg outfile=* mode=addVars /break=ru case/gotCare = max(latent30).
select if gotCare=1.

*select if latent7=1 OR latent30=1.

agg outfile='//covenas/decisionsupport/temp\HospPostSvc_kid13.sav'
	/break= case hospRU HospOpdate
	/latent7 = max(latent7)
	/Latent30 = max(Latent30).

save outfile='//covenas/decisionsupport/temp/HospPostSvc13_WORK.sav' /drop GotCare.

get file='//covenas/decisionsupport/Temp/HospEp13K_kids.sav'.
sort cases by case hospRU hospOpdate.
match files/table='//covenas/decisionsupport/temp\HospPostSvc_kid13.sav' /file=* /by case hospRU hospOpdate.

if xdate.tday(OpdateNext) ne yrmoda(2020,01,01) AND xdate.tday(OpdateNext) - xdate.tday(HospCloseDate) lt 11 HospRecid10=1.
if xdate.tday(OpdateNext) ne yrmoda(2020,01,01) AND xdate.tday(OpdateNext) - xdate.tday(HospCloseDate) lt 31 HospRecid30=1.

compute calendar = date.moyr(xdate.month(HospCloseDate),xdate.year(HospCloseDate)).
formats calendar(moyr6).

compute LOS = xdate.tday(HospCloseDate) - xdate.tday(HospOpDate)+1.

save outfile='//covenas/decisionsupport/temp/HospResults13_WORK.sav'.
aggregate outfile='//covenas/decisionsupport/temp/HospResults13_kids.sav'
	/break=case HOSPRU HospOpdate HospCloseDate HospProvname dx dx_descr dx_grpDSM bday sex HasMediCal LOS AgeGroup FspSvcTeamClient
	/Latent7 = max(Latent7)
	/Latent30= max(latent30)
	/HospRecid10= max(HospRecid10)	
	/HospRecid30= max(HospRecid30).	
	

get file='//covenas/decisionsupport/temp/ServicesByType_Kid.sav'.
sort cases by case.
match files/table='//covenas/decisionsupport/Temp/HospEp14K_kids.sav' /file=* /by case.
select if HospProvname ne  " ".

select if xdate.tday(svcdate) ge (xdate.tday(HospClosedate)-1).
compute lapse = xdate.tday(svcdate) - (xdate.tday(HospClosedate)-1).
select if lapse lt 91.

if xdate.tday(svcdate) lt xdate.tday(OpDateNext) AND lapse lt 8 AND FUsvc=1 Latent7=1.
if xdate.tday(svcdate) lt xdate.tday(OpDateNext) AND lapse lt 31 AND FUsvc=1 Latent30=1.

agg outfile=* mode=addVars /break=ru case/gotCare = max(latent30).
select if gotCare=1.

*select if latent7=1 OR latent30=1.

agg outfile='//covenas/decisionsupport/temp\HospPostSvc_kid14.sav'
	/break= case hospRU HospOpdate
	/latent7 = max(latent7)
	/Latent30 = max(Latent30).

save outfile='//covenas/decisionsupport/temp/HospPostSvc14_WORK.sav' /drop GotCare.

get file='//covenas/decisionsupport/Temp/HospEp14K_kids.sav'.
sort cases by case hospRU hospOpdate.
match files/table='//covenas/decisionsupport/temp\HospPostSvc_kid14.sav' /file=* /by case hospRU hospOpdate.

if xdate.tday(OpdateNext) ne yrmoda(2020,01,01) AND xdate.tday(OpdateNext) - xdate.tday(HospCloseDate) lt 11 HospRecid10=1.
if xdate.tday(OpdateNext) ne yrmoda(2020,01,01) AND xdate.tday(OpdateNext) - xdate.tday(HospCloseDate) lt 31 HospRecid30=1.

compute calendar = date.moyr(xdate.month(HospCloseDate),xdate.year(HospCloseDate)).
formats calendar(moyr6).

compute LOS = xdate.tday(HospCloseDate) - xdate.tday(HospOpDate)+1.

save outfile='//covenas/decisionsupport/temp/HospResults14_WORK.sav'.
aggregate outfile='//covenas/decisionsupport/temp/HospResults14_kids.sav'
	/break=case HOSPRU HospOpdate HospCloseDate HospProvname dx dx_descr dx_grpDSM bday sex HasMediCal LOS AgeGroup FspSvcTeamClient
	/Latent7 = max(Latent7)
	/Latent30= max(latent30)
	/HospRecid10= max(HospRecid10)	
	/HospRecid30= max(HospRecid30).	
	

get file='//covenas/decisionsupport/temp/ServicesByType_Kid.sav'.
sort cases by case.
match files/table='//covenas/decisionsupport/Temp/HospEp15K_kids.sav' /file=* /by case.
select if HospProvname ne  " ".

select if xdate.tday(svcdate) ge (xdate.tday(HospClosedate)-1).
compute lapse = xdate.tday(svcdate) - (xdate.tday(HospClosedate)-1).
select if lapse lt 91.

if xdate.tday(svcdate) lt xdate.tday(OpDateNext) AND lapse lt 8 AND FUsvc=1 Latent7=1.
if xdate.tday(svcdate) lt xdate.tday(OpDateNext) AND lapse lt 31 AND FUsvc=1 Latent30=1.

agg outfile=* mode=addVars /break=ru case/gotCare = max(latent30).
select if gotCare=1.

*select if latent7=1 OR latent30=1.

agg outfile='//covenas/decisionsupport/temp\HospPostSvc_kid15.sav'
	/break= case hospRU HospOpdate
	/latent7 = max(latent7)
	/Latent30 = max(Latent30).

save outfile='//covenas/decisionsupport/temp/HospPostSvc15_WORK.sav' /drop GotCare.

get file='//covenas/decisionsupport/Temp/HospEp15K_kids.sav'.
sort cases by case hospRU hospOpdate.
match files/table='//covenas/decisionsupport/temp\HospPostSvc_kid15.sav' /file=* /by case hospRU hospOpdate.

if xdate.tday(OpdateNext) ne yrmoda(2020,01,01) AND xdate.tday(OpdateNext) - xdate.tday(HospCloseDate) lt 11 HospRecid10=1.
if xdate.tday(OpdateNext) ne yrmoda(2020,01,01) AND xdate.tday(OpdateNext) - xdate.tday(HospCloseDate) lt 31 HospRecid30=1.

compute calendar = date.moyr(xdate.month(HospCloseDate),xdate.year(HospCloseDate)).
formats calendar(moyr6).

compute LOS = xdate.tday(HospCloseDate) - xdate.tday(HospOpDate)+1.

save outfile='//covenas/decisionsupport/temp/HospResults15_WORK.sav'.
aggregate outfile='//covenas/decisionsupport/temp/HospResults15_kids.sav'
	/break=case HOSPRU HospOpdate HospCloseDate HospProvname dx dx_descr dx_grpDSM bday sex HasMediCal LOS AgeGroup FspSvcTeamClient
	/Latent7 = max(Latent7)
	/Latent30= max(latent30)
	/HospRecid10= max(HospRecid10)	
	/HospRecid30= max(HospRecid30).	
	

get file='//covenas/decisionsupport/temp/ServicesByType_Kid.sav'.
sort cases by case.
match files/table='//covenas/decisionsupport/Temp/HospEp16K_kids.sav' /file=* /by case.
select if HospProvname ne  " ".

select if xdate.tday(svcdate) ge (xdate.tday(HospClosedate)-1).
compute lapse = xdate.tday(svcdate) - (xdate.tday(HospClosedate)-1).
select if lapse lt 91.

if xdate.tday(svcdate) lt xdate.tday(OpDateNext) AND lapse lt 8 AND FUsvc=1 Latent7=1.
if xdate.tday(svcdate) lt xdate.tday(OpDateNext) AND lapse lt 31 AND FUsvc=1 Latent30=1.

agg outfile=* mode=addVars /break=ru case/gotCare = max(latent30).
select if gotCare=1.

*select if latent7=1 OR latent30=1.

agg outfile='//covenas/decisionsupport/temp\HospPostSvc_kid16.sav'
	/break= case hospRU HospOpdate
	/latent7 = max(latent7)
	/Latent30 = max(Latent30).

save outfile='//covenas/decisionsupport/temp/HospPostSvc16_WORK.sav' /drop GotCare.

get file='//covenas/decisionsupport/Temp/HospEp16K_kids.sav'.
sort cases by case hospRU hospOpdate.
match files/table='//covenas/decisionsupport/temp\HospPostSvc_kid16.sav' /file=* /by case hospRU hospOpdate.

if xdate.tday(OpdateNext) ne yrmoda(2020,01,01) AND xdate.tday(OpdateNext) - xdate.tday(HospCloseDate) lt 11 HospRecid10=1.
if xdate.tday(OpdateNext) ne yrmoda(2020,01,01) AND xdate.tday(OpdateNext) - xdate.tday(HospCloseDate) lt 31 HospRecid30=1.

compute calendar = date.moyr(xdate.month(HospCloseDate),xdate.year(HospCloseDate)).
formats calendar(moyr6).

compute LOS = xdate.tday(HospCloseDate) - xdate.tday(HospOpDate)+1.

save outfile='//covenas/decisionsupport/temp/HospResults16_WORK.sav'.
aggregate outfile='//covenas/decisionsupport/temp/HospResults16_kids.sav'
	/break=case HOSPRU HospOpdate HospCloseDate HospProvname dx dx_descr dx_grpDSM bday sex HasMediCal LOS AgeGroup FspSvcTeamClient
	/Latent7 = max(Latent7)
	/Latent30= max(latent30)
	/HospRecid10= max(HospRecid10)	
	/HospRecid30= max(HospRecid30).	
	

get file='//covenas/decisionsupport/temp/ServicesByType_Kid.sav'.
sort cases by case.
match files/table='//covenas/decisionsupport/Temp/HospEp17K_kids.sav' /file=* /by case.
select if HospProvname ne  " ".

select if xdate.tday(svcdate) ge (xdate.tday(HospClosedate)-1).
compute lapse = xdate.tday(svcdate) - (xdate.tday(HospClosedate)-1).
select if lapse lt 91.

if xdate.tday(svcdate) lt xdate.tday(OpDateNext) AND lapse lt 8 AND FUsvc=1 Latent7=1.
if xdate.tday(svcdate) lt xdate.tday(OpDateNext) AND lapse lt 31 AND FUsvc=1 Latent30=1.

agg outfile=* mode=addVars /break=ru case/gotCare = max(latent30).
select if gotCare=1.

*select if latent7=1 OR latent30=1.

agg outfile='//covenas/decisionsupport/temp\HospPostSvc_kid17.sav'
	/break= case hospRU HospOpdate
	/latent7 = max(latent7)
	/Latent30 = max(Latent30).

save outfile='//covenas/decisionsupport/temp/HospPostSvc17_WORK.sav' /drop GotCare.
*dont want to lose people that do not have svcs, so...
get file='//covenas/decisionsupport/Temp/HospEp17K_kids.sav'.
sort cases by case hospRU hospOpdate.
match files/table='//covenas/decisionsupport/temp\HospPostSvc_kid17.sav' /file=* /by case hospRU hospOpdate.

if xdate.tday(OpdateNext) ne yrmoda(2020,01,01) AND xdate.tday(OpdateNext) - xdate.tday(HospCloseDate) lt 11 HospRecid10=1.
if xdate.tday(OpdateNext) ne yrmoda(2020,01,01) AND xdate.tday(OpdateNext) - xdate.tday(HospCloseDate) lt 31 HospRecid30=1.

compute calendar = date.moyr(xdate.month(HospCloseDate),xdate.year(HospCloseDate)).
formats calendar(moyr6).

compute LOS = xdate.tday(HospCloseDate) - xdate.tday(HospOpDate)+1.

save outfile='//covenas/decisionsupport/temp/HospResults17_WORK.sav'.
aggregate outfile='//covenas/decisionsupport/temp/HospResults17_kids.sav'
	/break=case HOSPRU HospOpdate HospCloseDate HospProvname dx dx_descr dx_grpDSM bday sex HasMediCal LOS AgeGroup FspSvcTeamClient
	/Latent7 = max(Latent7)
	/Latent30= max(latent30)
	/HospRecid10= max(HospRecid10)	
	/HospRecid30= max(HospRecid30).	
	

get file='//covenas/decisionsupport/temp/ServicesByType_Kid.sav'.
sort cases by case.
match files/table='//covenas/decisionsupport/Temp/HospEp18K_kids.sav' /file=* /by case.
select if HospProvname ne  " ".

select if xdate.tday(svcdate) ge (xdate.tday(HospClosedate)-1).
compute lapse = xdate.tday(svcdate) - (xdate.tday(HospClosedate)-1).
select if lapse lt 91.

if xdate.tday(svcdate) lt xdate.tday(OpDateNext) AND lapse lt 8 AND FUsvc=1 Latent7=1.
if xdate.tday(svcdate) lt xdate.tday(OpDateNext) AND lapse lt 31 AND FUsvc=1 Latent30=1.

agg outfile=* mode=addVars /break=ru case/gotCare = max(latent30).
select if gotCare=1.

*select if latent7=1 OR latent30=1.

agg outfile='//covenas/decisionsupport/temp\HospPostSvc_kid18.sav'
	/break= case hospRU HospOpdate
	/latent7 = max(latent7)
	/Latent30 = max(Latent30).

save outfile='//covenas/decisionsupport/temp/HospPostSvc18_WORK.sav' /drop GotCare.

get file='//covenas/decisionsupport/Temp/HospEp18K_kids.sav'.
sort cases by case hospRU hospOpdate.
match files/table='//covenas/decisionsupport/temp\HospPostSvc_kid18.sav' /file=* /by case hospRU hospOpdate.

if xdate.tday(OpdateNext) ne yrmoda(2020,01,01) AND xdate.tday(OpdateNext) - xdate.tday(HospCloseDate) lt 11 HospRecid10=1.
if xdate.tday(OpdateNext) ne yrmoda(2020,01,01) AND xdate.tday(OpdateNext) - xdate.tday(HospCloseDate) lt 31 HospRecid30=1.

compute calendar = date.moyr(xdate.month(HospCloseDate),xdate.year(HospCloseDate)).
formats calendar(moyr6).

compute LOS = xdate.tday(HospCloseDate) - xdate.tday(HospOpDate)+1.

save outfile='//covenas/decisionsupport/temp/HospResults18_WORK.sav'.
aggregate outfile='//covenas/decisionsupport/temp/HospResults18_kids.sav'
	/break=case HOSPRU HospOpdate HospCloseDate HospProvname dx dx_descr dx_grpDSM bday sex HasMediCal LOS AgeGroup FspSvcTeamClient
	/Latent7 = max(Latent7)
	/Latent30= max(latent30)
	/HospRecid10= max(HospRecid10)	
	/HospRecid30= max(HospRecid30).	
	

*get file='//covenas/decisionsupport/temp\HospResults1_kids.sav'.

add files
	/file='//covenas/decisionsupport/temp\HospResults1_kids.sav'
	/file='//covenas/decisionsupport/temp\HospResults2_kids.sav'
	/file='//covenas/decisionsupport/temp\HospResults3_kids.sav'
	/file='//covenas/decisionsupport/temp\HospResults4_kids.sav'
	/file='//covenas/decisionsupport/temp\HospResults5_kids.sav'
	/file='//covenas/decisionsupport/temp\HospResults6_kids.sav'
	/file='//covenas/decisionsupport/temp\HospResults7_kids.sav'
	/file='//covenas/decisionsupport/temp\HospResults8_kids.sav'
	/file='//covenas/decisionsupport/temp\HospResults9_kids.sav'
	/file='//covenas/decisionsupport/temp\HospResults10_kids.sav'
	/file='//covenas/decisionsupport/temp\HospResults11_kids.sav'
	/file='//covenas/decisionsupport/temp\HospResults12_kids.sav'
	/file='//covenas/decisionsupport/temp\HospResults13_kids.sav'
	/file='//covenas/decisionsupport/temp\HospResults14_kids.sav'
	/file='//covenas/decisionsupport/temp\HospResults15_kids.sav'
	/file='//covenas/decisionsupport/temp\HospResults16_kids.sav'
	/file='//covenas/decisionsupport/temp\HospResults17_kids.sav'
	/file='//covenas/decisionsupport/temp\HospResults18_kids.sav'.

save outfile='//covenas/decisionsupport/temp/hospresults_kidsALL.sav'.

get file='//covenas/decisionsupport/temp/hospresults_kidsALL.sav'.

*freq hospProvname.
compute DischargeAge = Trunc((xdate.tday(HospClosedate) - xdate.tday(bday))/365).
recode Latent7 Latent30 HospRecid10 HospRecid30 (sysmis=0).
recode HasMediCal FspSvcTeamClient (sysmis=0).
compute counter=1.

rename vars FSPsvcTeamClient=SEDsvcKid.

If hospProvname = "TELECARE WILLOW ROCK PHF CHILD" HospProvname = "Willow Rock".
If hospProvname = "ALTA BATES/HERRICK MEDICAL CTR" HospProvname = "Alta Bates".
If hospProvname = "BEHAVIORAL HEALTH CARE FREMONT" HospProvname = "Fremont".
If hospProvname = "EDEN HOSPITAL" HospProvname = "Eden".
If hospProvname = "JOHN GEORGE PSY SVS INPATIENT" HospProvname = "John George".
If hospProvname = "JOHN MUIR BEHAVIORAL HLTH CTR" HospProvname = "John Muir".
If hospProvname = "OUT-OF-COUNTY HOSPITAL" HospProvname = "Out of County".
If hospProvname = "ST HELENA HOSP CTR BEHAV HLTH" HospProvname = "St Helena".
If hospProvname = "ST MARY'S HOSPITAL MEDICAL CTR" HospProvname = "St Mary's".

compute DischargeMonth = date.moyr(xdate.month(HospCloseDate), xdate.year(hospCloseDate)).
formats DischargeMonth (moyr6).

compute createDate = $time.
formats createDate(date11).

save outfile="//covenas/decisionsupport/dashboardDataSets\HospitalEpisodes_kids.sav".

get file='//covenas/decisionsupport/dashboardDataSets\HospitalEpisodes_kids.sav' .

rename variables sex=Gender.
sort cases by case.
match files /table='//covenas/spssdata/clinfo.sav' /file=* /by case /drop name bornname language disab educ created cin marital minors ssn. 
insert file= '//covenas/decisionsupport/modules/ethnicity.sps'.

*display vars.
*This removes the non-possible follow up. if it turns out that we want those records for another graph, we can take out the select.
if xdate.mday($time) le 15 dateFU30 = DateSum($time,-2,"months").
if xdate.mday($time) gt 15 dateFU30 = DateSum($time,-1,"months").
compute dateFU30 =date.moyr(xdate.month(dateFU30), xdate.year(dateFU30)).
formats dateFU30(date12).

if HospCloseDate ge datefu30 possiblefu30=0.
if HospCloseDate lt datefu30 possiblefu30=1.

select if possiblefu30 =1.

insert file='//covenas/decisionsupport/modules/uncookedmonth.sps'.
if dischargemonth ge datesum(uncookedmonth,-12,"months") Reporting_Period=1.

save outfile='//covenas/decisionsupport/dashboardDataSets\HospitalEpisodes_kids.sav' /drop RaceEthnicityCode hispanic gender.

get file='//covenas/decisionsupport/dashboardDataSets\HospitalEpisodes_kids.sav' .
select if not missing(HospCloseDate).


SAVE TRANSLATE /TYPE=ODBC
 /Connect ='DSN=DashboardData;UID=;APP=SPSS For'+
 ' Windows;WSID=HPMXL9360ZDD;DATABASE=DashboardData;Trusted_Connection=Yes'
 /table= 'HospitalEpisodes_kids' /MAP/REPLACE.


get file='//covenas/decisionsupport/dashboardDataSets\HospitalEpisodes_kids.sav' .

select if latent30=0.

sort cases by case.
match files /table='//covenas/spssdata/clinfo.sav' /file=* /by case
 /drop bornname language disab educ created cin marital minors ssn dateFU30 possiblefu30. 

insert file= '//covenas/decisionsupport/modules/ethnicity.sps'.

match files/file=*/drop raceethnicitycode hispanic.

string sedkid (a3).
if SEDSVCkid=0 SEDKid='No'.
if SEDSVCkid=1 SEDKid='Yes'.

compute createDate = $time.
formats createDate(datetime17).

compute NoLatencyCare=1.

save outfile='//covenas/decisionsupport/dashboardDataSets\HospitalEpisodes_kidsnolatency.sav' .
get file='//covenas/decisionsupport/dashboardDataSets\HospitalEpisodes_kidsnolatency.sav' .
SAVE TRANSLATE /TYPE=ODBC
 /Connect ='DSN=DashboardData;UID=;APP=SPSS For'+
 ' Windows;WSID=HPMXL9360ZDD;DATABASE=DashboardData;Trusted_Connection=Yes'
 /table= 'NoLatencyCareDetail' /MAP/REPLACE /keep=case name hospopdate hospclosedate hospprovname dischargeage createdate sedsvckid sedkid Ethnicity sex DischargeMonth AgeGroup .




add files
	/file='//covenas/decisionsupport/temp\HospPostSvc1_WORK.sav'
	/file='//covenas/decisionsupport/temp\HospPostSvc2_WORK.sav'
	/file='//covenas/decisionsupport/temp\HospPostSvc3_WORK.sav'
	/file='//covenas/decisionsupport/temp\HospPostSvc4_WORK.sav'
	/file='//covenas/decisionsupport/temp\HospPostSvc5_WORK.sav'
	/file='//covenas/decisionsupport/temp\HospPostSvc6_WORK.sav'
	/file='//covenas/decisionsupport/temp\HospPostSvc7_WORK.sav'
	/file='//covenas/decisionsupport/temp\HospPostSvc8_WORK.sav'
	/file='//covenas/decisionsupport/temp\HospPostSvc9_WORK.sav'
	/file='//covenas/decisionsupport/temp\HospPostSvc10_WORK.sav'
	/file='//covenas/decisionsupport/temp\HospPostSvc11_WORK.sav'
	/file='//covenas/decisionsupport/temp\HospPostSvc12_WORK.sav'
	/file='//covenas/decisionsupport/temp\HospPostSvc13_WORK.sav'
	/file='//covenas/decisionsupport/temp\HospPostSvc14_WORK.sav'	
	/file='//covenas/decisionsupport/temp\HospPostSvc15_WORK.sav'
	/file='//covenas/decisionsupport/temp\HospPostSvc16_WORK.sav'
	/file='//covenas/decisionsupport/temp\HospPostSvc17_WORK.sav'
	/file='//covenas/decisionsupport/temp\HospPostSvc18_WORK.sav'.


sort cases by case hospOpdate.
match files/file=* /by case hospOpdate /first=ep1.
match files/file=* /by case/first=case1.

*match files/file=* /keep case HospCloseDate provname svcdate all.

*display vars.

compute counter=1.
compute DischargeMonth = date.moyr(xdate.month(HospCloseDate), xdate.year(hospCloseDate)).
formats DischargeMonth (moyr6).

freq DischargeMonth.
sort cases by ru DischargeMonth case HospOpdate.

match files/file=* /by ru DischargeMonth case /first=FUCase1.
match files/file=* /by ru DischargeMonth case HospOpDate /first=FUep1.

If hospProvname = "TELECARE WILLOW ROCK PHF CHILD" HospProvname = "Willow Rock".
If hospProvname = "ALTA BATES/HERRICK MEDICAL CTR" HospProvname = "Alta Bates".
If hospProvname = "BEHAVIORAL HEALTH CARE FREMONT" HospProvname = "Fremont".
If hospProvname = "EDEN HOSPITAL" HospProvname = "Eden".
If hospProvname = "JOHN GEORGE PSY SVS INPATIENT" HospProvname = "John George".
If hospProvname = "JOHN MUIR BEHAVIORAL HLTH CTR" HospProvname = "John Muir".
If hospProvname = "OUT-OF-COUNTY HOSPITAL" HospProvname = "Out of County".
If hospProvname = "ST HELENA HOSP CTR BEHAV HLTH" HospProvname = "St Helena".
If hospProvname = "ST MARY'S HOSPITAL MEDICAL CTR" HospProvname = "St Mary's".

if xdate.mday($time) le 15 dateFU30 = DateSum($time,-2,"months").
if xdate.mday($time) gt 15 dateFU30 = DateSum($time,-1,"months").
compute dateFU30 =date.moyr(xdate.month(dateFU30), xdate.year(dateFU30)).
formats dateFU30(date12).

if HospCloseDate ge datefu30 possiblefu30=0.
if HospCloseDate lt datefu30 possiblefu30=1.

select if possiblefu30 =1.


 * aggregate outfile=*
	/break=DischargeMonth  Ru Provname  HospProvname  case hospOpdate HospCloseDate agegroup
	/Latent7 = max(Latent7)
	/Latent30= max(Latent30)
	/Visits =sum(counter)
	 /SEDsvcKid=max(fspsvcteamclient).


agg outfile='//covenas/decisionsupport/DashboardDataSets\FollowUpRus.sav'
	/break=DischargeMonth  Ru Provname  HospProvname 
	/Clients = sum(FUcase1)
	/DishchargeEps = sum(FUep1).


aggregate outfile='//covenas/decisionsupport/DashboardDataSets\FollowUpCareDetail.sav'
	/break=DischargeMonth  Ru Provname  HospProvname  case hospOpdate HospCloseDate agegroup
	/Latent7 = max(Latent7)
	/Latent30= max(Latent30)
	/Visits =sum(counter)
	 /SEDsvcKid=max(fspsvcteamclient).




get file='//covenas/decisionsupport/DashboardDataSets\FollowUpRus.sav'.

compute createDate = $time.
formats createDate(datetime17).

SAVE TRANSLATE /TYPE=ODBC
 /Connect ='DSN=DashboardData;UID=;APP=SPSS For'+
 ' Windows;WSID=HPMXL9360ZDD;DATABASE=DashboardData;Trusted_Connection=Yes'
 /table= 'FollowUpRus' /MAP/REPLACE.


get file='//covenas/decisionsupport/DashboardDataSets\FollowUpCareDetail.sav'.

sort cases by case.
match files /table='//covenas/spssdata/clinfo.sav' /file=* /by case /drop bornname language disab educ created cin marital minors ssn. 
insert file= '//covenas/decisionsupport/modules/ethnicity.sps'.

match files/file=*/drop raceethnicitycode hispanic.

compute createDate = $time.
formats createDate(datetime17).

recode latent7 latent30 sedsvckid(sysmis=0).


string Latent7Client Latent30Client sedkid (a3).
if latent7=1 Latent7Client='Yes'.
if latent7=0  latent7client='No'.
if Latent30=0 latent30client='No'.
if Latent30=1 Latent30Client='Yes'.
if SEDSVCkid=0 SEDKid='No'.
if SEDSVCkid=1 SEDKid='Yes'.
*save outfile ="//covenas/decisionsupport/meinzer/temp/kid30.sav".
sort cases by ru.
match files /table="//covenas/decisionsupport/rutable.sav" /file=* /by ru /keep psmask2  Ethnicity case name sex bday DischargeMonth RU SEDsvcKid createDate
provname HospProvname HospOpDate HospCloseDate AgeGroup Latent7 Latent30 Visits Latent7Client Latent30Client sedkid.

select if not psmask2=700.

save outfile='//covenas/decisionsupport/DashboardDataSets\FollowUpCareDetailcsoc.sav'.
get file='//covenas/decisionsupport/DashboardDataSets\FollowUpCareDetailcsoc.sav'.
SAVE TRANSLATE /TYPE=ODBC
 /Connect ='DSN=DashboardData;UID=;APP=SPSS For'+
 ' Windows;WSID=HPMXL9360ZDD;DATABASE=DashboardData;Trusted_Connection=Yes'
 /table= 'FollowUpCareDetail' /MAP/REPLACE.




