********** //covenas/decisionsupport/DashboardDataSets\Demographics.sps.
DEFINE 	DBStartDate() date.dmy(1,1,2011) !ENDDEFINE.

get file =  '//covenas/spssdata/MediCalData\MedsCurrentUncut.sav'.

if substr(street,1,2)='0' street=" ".
select if street ne " ".

save outfile = '//covenas/decisionsupport/temp\MediCalCurrentAddress.sav' 
/keep CIN Street city zip State Region.

get file = '//covenas/spssdata/dbsvc.sav'
   /keep agency provname ru case opdate closdate svcdate  psmask2 proced county
   MCSvcCat kidsru calendar duration duration2 cost LastService ProcLong svcAge PrimaryTherapist
   staff bday epflag primdx unit ab3632RU DayTx RU2 service_Stamp svc_Stmp.

select if svcdate ge dbstartdate.
insert file = '//covenas/decisionsupport/modules/uncookedmonth.sps'.
select if svcdate lt uncookedmonth.

sort cases by case calendar.
match files /table = '//covenas/decisionsupport/medicaltable.sav' /file = * /by case calendar.
match files /table = '//covenas/decisionsupport/medicarepolicies.sav' /file = * /by case.

rename variables SVCDATE = date.
insert file = '//covenas/decisionsupport/meinzer\modules\datefy.sps'.
rename variables date = SVCDATE.

recode full medicarepartb(sysmis=0).
aggregate outfile=* mode=ADDVARIABLES
/break fiscalyear case
/MediCalOnly=max(full)
/medicareOnly=max(medicarepartb).

If MediCalOnly=1 and MedicareOnly=1 MediMediOnly=1.
if medimediOnly=1 medicalOnly=0.
if medimediOnly=1 medicareOnly=0.
recode medimediOnly MediCalOnly MedicareOnly (sysmis=0).
If MediMediOnly =0 and (medicalOnly =0 and medicareOnly =0)  UninsuredOnly=1.
recode UninsuredOnly (sysmis=0).

aggregate outfile=*
   /break agency provname ru case opdate fiscalyear closdate psmask2 county MCSvcCat kidsru LastService PrimaryTherapist epflag proced primdx unit ab3632RU DayTx 
   /ClientAnnualCostperCatandPSMASK2 = sum(cost)
   /medicare=max(medicareOnly)
   /uninsured=max(uninsuredOnly)
   /medimedi=max(medimediOnly)
   /medical=max(medicalOnly)
   /SVCDATE=min(svcdate).

string InsuranceType(a22).
if medicare=1 InsuranceType='Medicare'.
if uninsured=1 InsuranceType='Uninsured'.
if medimedi=1 InsuranceType='Medi-Medi'.
if medical=1  InsuranceType='Medi-Cal'.

insert file = '//covenas/decisionsupport/modules\noshow.sps'.

 * save outfile = '//covenas/decisionsupport/hall\tempDemoTest.sav'.
 * get file =  '//covenas/decisionsupport/hall\tempDemoTest.sav'.

sort cases by ru.
match files /table = '//covenas/decisionsupport/rutable.sav' /file = * /by ru.

recode level3classic(sysmis = 0).
select if level3classic eq 0.

rename variables dbservicemodality=dbservicemodalityShort.
string dbservicemodality(a50).
compute dbservicemodality = dbservicemodalityShort.

match files /file = * /drop dbservicemodalityShort.

if dbservicemodality = "CrisisStabilization" dbservicemodality = "Crisis Stabilization".
if dbservicemodality = "JailOrJuvJusticeCenter" dbservicemodality = "Jail or Juvenile Justice Center".
if dbservicemodality = "SvcTeamFSP" dbservicemodality = "Service Team or FSP".
if dbservicemodality = "SubAcute" dbservicemodality = "Subacute".

sort cases by case.
match files /table='//covenas/spssdata/clinfo.sav' /file = * /by case.

insert file='//covenas/decisionsupport/modules\language.sps'.

rename variables primdx=dx.

sort cases by dx.
match files /table = '//covenas/decisionsupport/dxTable.sav' /file = * /by dx.

rename variables dx=primdx.

sort cases by ethnic.
Match Files /Table='//covenas/decisionsupport/ethnicity.sav' /File=* /by ethnic.

rename vars EthnicDetail=EthnicDetailShort.
string EthnicDetail(a50).
compute EthnicDetail = EthnicDetailShort.
match files /file = * /drop EthnicDetailShort PacificIslander ethnic.

If hispanic="G" or hispanic="M" or hispanic="N" or hispanic="S" or hispanic="5" or hispanic="2" or hispanic = "4" Ethnicity="Latino".
If hispanic="G"  EthnicDetail = "Guatemalan".
If hispanic="N"  EthnicDetail = "Nicaraguan".
If hispanic="S"  EthnicDetail = "Salvadoran".
If hispanic="5"  EthnicDetail = "Latino Not Specified".
If hispanic="2"  EthnicDetail = "Mexican/Mexican American".
If hispanic="4"  EthnicDetail = "Puerto Rican".
If hispanic="M"  EthnicDetail = "South American".
If Ethnicity=" " Ethnicity="Unknown".
if EthnicDetail = " " EthnicDetail = "Unknown".
if EthnicDetail = "Missing" EthnicDetail = "Unknown".
If EthnicDetail = "Latino" EthnicDetail =  "Latino Not Specified".

compute svcdate = xdate.date(svcdate).

aggregate outfile = * mode = addvariables
   /break = FiscalYear case
   /FyFirstSvcDate = min(svcdate).

compute Age = Trunc((xdate.tday(FyFirstSvcDate) - xdate.tday(bday))/365.25).
select if age le 100.

 * save outfile='//covenas/decisionsupport/temp\DemoTemp1.sav'.
 * get file='//covenas/decisionsupport/temp\DemoTemp1.sav'.

sort cases by case.
match files /table='//covenas/decisionsupport/addressmhs.sav'  /file=* /by case. 

rename variables street = streetInsyst.
rename variables zipcode = zipcodeInsyst.
rename variables City = CityInsyst.  
rename variables region= RegionInsyst.
rename variables outcty=outctyInsyst.

rename variables sex=sexMHS.
rename variables language = languageMHS.
rename variables ethnicity = ethnicityMHS.

sort cases by cin.
match files /table= '//covenas/spssdata/MediCalData\MedsCurrentUncut.sav' /file = * /by cin
   /drop Street city zip State Region.
match files /table =  '//covenas/decisionsupport/temp\MediCalCurrentAddress.sav' /file = * /by cin
   /drop region. 

rename variables homeless = HomelessInsyst.

sort cases by aidcode.
match files /table='//covenas/spssdata/AidCodes.sav'/file=* /by aidCode.

insert file = '//covenas/decisionsupport/modules\cities.sps'.

 * save outfile='//covenas/decisionsupport/temp\DemoTemp1a.sav'.
 * get file='//covenas/decisionsupport/temp\DemoTemp1a.sav'.

string CityMC(a28).
compute CityMC=city.
if region="5. Out of County" cityMC = CityInsyst.
if region="6. Unknown" and cityMC="UNKNOWN" CityMC = CityInsyst.

match files/ file = * /drop city.
rename variables cityMC = city.

Do if Street=" ".
Compute Street=StreetAddressINSYST.
Compute  City=CityInsyst.
Compute  zip=zipcodeinsyst. 
Compute Region=RegionInsyst.
Compute Homeless=homelessinsyst.
End if.

Do if street='HOMELESS' and substr(StreetAddressINSYST,1,1) ne '0' and outctyInsyst =0.
Compute Street=StreetAddressINSYST.
Compute  City=CityInsyst.
Compute  zip=zipcodeinsyst. 
Compute Region=RegionInsyst.
Compute Homeless=homelessinsyst.
End if.

Do if Region='5. Out of County' and outctyinsyst=0 and RegionInsyst ne '6. Unknown'.
Compute Street=StreetAddressINSYST.
Compute  City=CityInsyst.
Compute  zip=zipcodeinsyst. 
Compute Region=RegionInsyst.
Compute Homeless=homelessinsyst.
End if.

Do if Region='6. Unknown' and outctyinsyst=0 and RegionInsyst ne '6. Unknown'.
Compute Street=StreetAddressINSYST.
Compute  City=CityInsyst.
Compute  zip=zipcodeinsyst. 
Compute Region=RegionInsyst.
Compute Homeless=homelessinsyst.
End if.

Do if substr(street,1,3)='PO' and outctyinsyst=0 and substr(StreetAddressINSYST,1,1) ne '0'.
Compute Street=StreetAddressINSYST.
Compute  City=CityInsyst.
Compute  zip=zipcodeinsyst. 
Compute Region=RegionInsyst.
Compute Homeless=homelessinsyst.
End if.

if any (street, '0  HOMELESS',  '0  CHERRYHILL-HOMELESS', '0  HOMELESS AV', '1010  HOMELESS', '999999  HOMELESS', 'HOMELESS', 'HOMELESS IN', 'TRANSIENT',  '0  TRANSIENT', '0  HOMELES',  '0  NOMAD') Homeless=1.
if street='GENERAL DELIVERY' and homelessinsyst=1 Homeless=1. 

IF city= 'HOMELESS' Homeless=1. 
IF city= 'HOMELESS' city= 'UNKNOWN'.

if blind=1 Disabled=1.
recode disabled foster(sysmis=0).
if Disabled = 1 and foster = 1 foster = 0.

aggregate outfile=* mode=ADDVARIABLES
   /break FiscalYear case
   /FYDisabled=max(Disabled)
   /FYFoster=max(foster).

recode FYdisabled FYfoster(sysmis=0).

string SpecialPopulation(a15).
if FYDisabled=1 SpecialPopulation = "Disabled".
if FYFoster=1 SpecialPopulation = "Foster Care".

 * save outfile='//covenas/decisionsupport/temp\DemoTemp1b.sav'.
 * get file='//covenas/decisionsupport/temp\DemoTemp1b.sav'.

if sex=" " sex=sexMHS.
if language=" " language=languageMHS.
if language=" " language="Unknown/Unreported".
if ethnicityMHS = " " ethnicityMHS = ethnicity.
if ethnicityMHS=" " ethnicityMHS="Unknown".

match files /file=* /drop ethnicity.

rename variables ethnicityMHS = ethnicity.

if Region =" " Region="6. Unknown".    
if Region = "Unknown" Region="6. Unknown".    
if city = "UNKNOWN" Region = "6. Unknown".
if city = "  " Region = "6. Unknown".
if city = "  " City = "UNKNOWN".
if city= "Confidential" Region="Confidential".

compute RegionSort = 0.
if  Region = "5. Out of County" RegionSort = 1.
if Region =  "6. Unknown" RegionSort = 2.
if Region = "7. Confidential" RegionSort = 3.

compute EthnicSort = 0.
if any (Ethnicity, "Other") EthnicSort = 1.
if any (Ethnicity, "Unknown") EthnicSort = 2.

compute EthnicDetailSort = 0.
if EthnicDetail = "Unknown" EthnicDetailSort = 1.

string Gender(a15).
if sex='M' Gender='Male'.
if sex='F' Gender='Female'.
if sex='U' or sex='O' Gender='Unknown'.

rename variables language =LanguageDetail.
string Language(a35).
compute Language = "Other".

if languageDetail = "English" language = "English".
if languageDetail = "Spanish" language = "Spanish".
if languageDetail = "Cantonese" language = "Cantonese".
if languageDetail = "Mandarin" language = "Mandarin".
if languageDetail = "Vietnamese" language = "Vietnamese".
if languageDetail = "Farsi" language = "Farsi".
if languageDetail = "Missing" or languageDetail = "Unknown/Unreported" or language = "Other" language = "Other/Unknown".

if languageDetail = "Other Non-English" languageDetail = "Other".
if languageDetail = "Portugese" languageDetail = "Portuguese".

compute LanguageSort = 0.
if Language="Other/Unknown" LanguageSort = 1.

compute LanguageDetailSort = 0.
if LanguageDetail = "Missing" LanguageDetailSort = 1.
if LanguageDetail = "Other" LanguageDetailSort = 2.
if  languageDetail = "Unknown/Unreported" LanguageDetailSort = 3.

String ClientAge(a3).
do if age lt 75.
compute ClientAge=string(Age,f3).
else if age ge 75.
compute ClientAge="75+".
end if.

insert file = '//covenas/decisionsupport/meinzer\modules\psmask2text.sps'.

String DxCategory (a40).
If any(dx_grpDSM, "Depressive Disorders", "Psychotic Disorders", "Anxiety Disorders", "Bipolar Disorders", "Schizophrenia Disorders", "Adjustment Disorders", "Attention-Deficit Disorders")  DxCategory= dx_grpDSM.
If any(dx_grpDSM, "Substance Related Disorders", "Substance/Alcohol Induced Disorders") DxCategory = "Substance/Alcohol Related Disorders".
if dx_grpDSM = "  " dx_grpDSM = "Other NOS".
if DxCategory=" " DxCategory="Other".

string ClientCostGroup(a20).
if ClientAnnualCostperCatandPSMASK2 lt 5000 ClientCostGroup = "a. Low Cost".
if ClientAnnualCostperCatandPSMASK2 ge 5000 and ClientAnnualCostperCatandPSMASK2 lt 20000 
   ClientCostGroup = "b. Moderate Cost".
if  ClientAnnualCostperCatandPSMASK2 ge 20000 ClientCostGroup = "c. High Cost".

string RUProgram(a40).
compute RUProgram = concat(RU,"    ",rtrim(provname)).

insert file = '//covenas/decisionsupport/modules/uncookedmonth.sps'.

compute datathru = datesum((uncookedmonth), - 1,"days").
formats datathru(date11).

save outfile = '//covenas/decisionsupport/temp\DemographicsWork.sav'
   /keep FiscalYear agency ru provname RUProgram case opdate closdate SVCDATE primdx dx_descr DxCategory 
    SPMI SED potSPMI dx_grpDSM dx_grpAdult language languageDetail LanguageSort LanguageDetailSort calendar 
   Age ClientAge sex Gender ethnicity EthnicSort EthnicDetail EthnicDetailSort city region RegionSort psmask2 MCSvcCat 
   ClientAnnualCostperCatandPSMASK2 InsuranceType medical medicare SpecialPopulation FYFoster FYdisabled 
   uninsured medimedi FyFirstSvcDate ClientCostGroup epflag dbservicemodality psmasktext uncookedmonth datathru.

*pushbreak.
*sqlTable = 'Demographic_Dashboard'.
*spsstable='//covenas/decisionsupport/temp\DemographicsWork.sav'.
*pushbreak.


