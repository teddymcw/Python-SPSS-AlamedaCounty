
*Services After FY 2007.
get file = '//covenas/decisionsupport/dbsvc.sav'.
select if svcdate ge date.dmy(01,07,2008).

insert file = '//covenas/decisionsupport/modules/NoShow.sps'.
insert file = '//covenas/decisionsupport/modules/CalSvcdate.sps'.
 * insert file = '//covenas/decisionsupport/modules/duration.sps'.

string FiscalYear (a10).
do if xdate.month(svcdate) lt 7.
compute fiscalyear=concat("FY ",substr(string(xdate.year(svcdate)-1,n4),3,2),"-",substr(string(xdate.year(svcdate),n4),3,2)).
else if xdate.month(svcdate) ge 7.
compute fiscalyear=concat("FY ",substr(string(xdate.year(svcdate),n4),3,2),"-",substr(string(xdate.year(svcdate)+1,n4),3,2)).
end if.

insert file='//covenas/decisionsupport/modules/uncookedmonth.sps'.

do if xdate.month(uncookedmonth) lt 9.
compute uncookedstart=date.dmy(1,7,xdate.year(uncookedmonth)-1).
else if xdate.month(uncookedmonth) ge 9.
compute uncookedstart=date.dmy(1,7,xdate.year(uncookedmonth)).
end if.
formats uncookedstart (datetime23).

select if svcdate lt  uncookedstart.

sort cases by ru.
Match files /table='//covenas/decisionsupport/rutable.sav' / file=* /by ru.

 * sort cases by proced.
 * Match files /table='//covenas/decisionsupport/procedsma.sav' / file=* /by proced.

 * if any(svcMode,"05","10") AND MCSvcCat ne "F. Crisis Stabilization" Day=1.
 * if day=1 Duration=$sysmis.

insert file = '//covenas/decisionsupport/orozco/modules/KidsBuckets.sps'.
 * match files /table='//covenas/decisionsupport/Orozco/Temp/ProgramModels.sav' /file=* /by ru.

recode kidsru TAYru OAru (sysmis=0).
If kidsru=0 AdultRU=1. 
recode AdultRU(sysmis=0). 

String KidsRUText(a5).
if kidsru=1 KidsRUText='Yes'.
if kidsru=0 KidsRUText='No'.

String TAYruText(a5).
if TAYru=1 TAYruText='Yes'.
if TAYru=0 TAYruText='No'.

String OAruText(a5).
if OAru=1 OAruText='Yes'.
if OAru=0 OAruText='No'.

String AdultRUText(a5).
if AdultRU=1 AdultRUText='Yes'.
if AdultRU=0 AdultRUText='No'.

rename variables ProgramModel=CSOCProgramModel.
if CSOCProgramModel= " " CSOCProgramModel="N/A". 
If CSOCProgramModel="N/A" and kidsru=1   CSOCProgramModel="Other". 
if kidsru=0 CSOCProgramModel="N/A". 

select if provname ne 'CONSERVATORSHIP CONT CARE SUP'.

Aggregate outfile = * mode=ADDVARIABLES
   /Break=FiscalYear
   /LastFYCalendar=max(Calendar)
   /FirstFYCalendar=min(Calendar). 

Aggregate outfile = '//covenas/decisionsupport/Orozco/Temp/RUClientsAndCostTrends_Work_B.sav'
   /Break= CSOCProgramModel Agency Provname RU DBserviceModality KidsRUText TAYruText OAruText AdultRUText FiscalYear Case primdx LastFYCalendar FirstFYCalendar
   /Cost=sum(cost)
   /Hours=sum(duration)
   /Days=sum(day)
   /MinSvcDate=min(svcdate).

Get file = '//covenas/decisionsupport/Orozco/Temp/RUClientsAndCostTrends_Work_B.sav'.

sort cases by case.
match files /table='//covenas/spssdata/clinfo.sav' /file = * /by case.

insert file='//covenas/decisionsupport/modules\language.sps'.
compute Age = Trunc((xdate.tday(MinSvcDate) - xdate.tday(bday))/365.25).

rename variables primdx=dx.

sort cases by dx.
match files /table = '//covenas/decisionsupport/dxTable.sav' /file = * /by dx.

rename variables dx=primdx.

String DxCategory (a40).
If any(dx_grpDSM, "Depressive Disorders", "Psychotic Disorders", "Anxiety Disorders", "Bipolar Disorders", "Schizophrenia Disorders", "Adjustment Disorders", "Attention-Deficit Disorders")  DxCategory= dx_grpDSM.
If any(dx_grpDSM, "Substance Related Disorders", "Substance/Alcohol Induced Disorders") DxCategory = "Substance/Alcohol Related Disorders".
if DxCategory=" " DxCategory="Other". 

 * freq DxCategory.
 * sort cases by dxcategory.
 * split file by dxcategory.
 * freq dx_grpDSM.
 * split file off. 

sort cases by ethnic.
Match Files /Table='//covenas/decisionsupport/ethnicity.sav' /File=* /by ethnic.

If hispanic="G" or hispanic="M" or hispanic="N" or hispanic="S" or hispanic="5" or hispanic="2" or hispanic = "4" Ethnicity="Latino".
If Ethnicity=" " Ethnicity="Unknown".

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

Save outfile = '//covenas/decisionsupport/Orozco/Temp/RUClientsAndCostTrends_B.sav' /keep 
CSOCProgramModel Agency Provname RU KidsRUText TAYruText OAruText AdultRUText FiscalYear Case Cost Hours Days Age DxCategory dx_grpDSM Ethnicity language Gender DBserviceModality LastFYCalendar FirstFYCalendar. 

*Services Before FY 2008.

get file = '//covenas/decisionsupport/DBSVC04_09.sav'.
select if svcdate lt date.dmy(01,07,2008).

insert file = '//covenas/decisionsupport/modules/NoShow.sps'.
insert file = '//covenas/decisionsupport/modules/CalSvcdate.sps'.
 * insert file = '//covenas/decisionsupport/modules/duration.sps'.

string FiscalYear (a10).
do if xdate.month(svcdate) lt 7.
compute fiscalyear=concat("FY ",substr(string(xdate.year(svcdate)-1,n4),3,2),"-",substr(string(xdate.year(svcdate),n4),3,2)).
else if xdate.month(svcdate) ge 7.
compute fiscalyear=concat("FY ",substr(string(xdate.year(svcdate),n4),3,2),"-",substr(string(xdate.year(svcdate)+1,n4),3,2)).
end if.

sort cases by ru.
Match files /table='//covenas/decisionsupport/rutable.sav' / file=* /by ru.

 * sort cases by proced.
 * Match files /table='//covenas/decisionsupport/procedsma.sav' / file=* /by proced.

 * if any(svcMode,"05","10") AND MCSvcCat ne "F. Crisis Stabilization" Day=1.
 * if day=1 Duration=$sysmis.

insert file = '//covenas/decisionsupport/orozco/modules/KidsBuckets.sps'.
 * match files /table='//covenas/decisionsupport/Orozco/Temp/ProgramModels.sav' /file=* /by ru.

recode kidsru TAYru OAru (sysmis=0).
If kidsru=0 AdultRU=1. 
recode AdultRU(sysmis=0). 

String KidsRUText(a5).
if kidsru=1 KidsRUText='Yes'.
if kidsru=0 KidsRUText='No'.

String TAYruText(a5).
if TAYru=1 TAYruText='Yes'.
if TAYru=0 TAYruText='No'.

String OAruText(a5).
if OAru=1 OAruText='Yes'.
if OAru=0 OAruText='No'.

String AdultRUText(a5).
if AdultRU=1 AdultRUText='Yes'.
if AdultRU=0 AdultRUText='No'.

rename variables ProgramModel=CSOCProgramModel.
if CSOCProgramModel= " " CSOCProgramModel="N/A". 
If CSOCProgramModel="N/A" and kidsru=1   CSOCProgramModel="Other". 
if kidsru=0 CSOCProgramModel="N/A". 

select if provname ne 'CONSERVATORSHIP CONT CARE SUP'.

Aggregate outfile = * mode= ADDVARIABLES
   /Break=FiscalYear
   /LastFYCalendar=max(Calendar)
   /FirstFYCalendar=Min(Calendar). 

Aggregate outfile = '//covenas/decisionsupport/Orozco/Temp/RUClientsAndCostTrends_Work_A.sav'
   /Break= CSOCProgramModel Agency Provname RU DBserviceModality KidsRUText TAYruText OAruText AdultRUText FiscalYear Case primdx LastFYCalendar FirstFYCalendar
   /Cost=sum(cost)
   /Hours=sum(duration)
   /Days=sum(day)
   /MinSvcDate=min(svcdate).

Get file = '//covenas/decisionsupport/Orozco/Temp/RUClientsAndCostTrends_Work_A.sav'. 

sort cases by case.
match files /table='//covenas/spssdata/clinfo.sav' /file = * /by case.

insert file='//covenas/decisionsupport/modules\language.sps'.
compute Age = Trunc((xdate.tday(MinSvcDate) - xdate.tday(bday))/365.25).

rename variables primdx=dx.

sort cases by dx.
match files /table = '//covenas/decisionsupport/dxTable.sav' /file = * /by dx.

rename variables dx=primdx.

String DxCategory (a40).
If any(dx_grpDSM, "Depressive Disorders", "Psychotic Disorders", "Anxiety Disorders", "Bipolar Disorders", "Schizophrenia Disorders", "Adjustment Disorders", "Attention-Deficit Disorders")  DxCategory= dx_grpDSM.
If any(dx_grpDSM, "Substance Related Disorders", "Substance/Alcohol Induced Disorders") DxCategory = "Substance/Alcohol Related Disorders".
if DxCategory=" " DxCategory="Other". 

sort cases by ethnic.
Match Files /Table='//covenas/decisionsupport/ethnicity.sav' /File=* /by ethnic.

If hispanic="G" or hispanic="M" or hispanic="N" or hispanic="S" or hispanic="5" or hispanic="2" or hispanic = "4" Ethnicity="Latino".
If Ethnicity=" " Ethnicity="Unknown".

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

Save outfile = '//covenas/decisionsupport/Orozco/Temp/RUClientsAndCostTrends_A.sav' /keep 
CSOCProgramModel Agency Provname RU KidsRUText TAYruText OAruText AdultRUText FiscalYear Case Cost Hours Days Age DxCategory dx_grpDSM Ethnicity language Gender DBserviceModality LastFYCalendar FirstFYCalendar. 

Add files 
   /file='//covenas/decisionsupport/Orozco/Temp/RUClientsAndCostTrends_A.sav'
   /file='//covenas/decisionsupport/Orozco/Temp/RUClientsAndCostTrends_B.sav'.

if dx_grpDSM= " " dx_grpDSM='Unknown'. 

save outfile = '//covenas/decisionsupport/Orozco/Temp/RUClientsAndCostTrends_AB.sav'.

*Region Work. 

 * Get file  = '//covenas/decisionsupport/Orozco/Temp/RUClientsAndCostTrends_AB.sav'.

Aggregate outfile = *
   /Break = Case FiscalYear 
   /FirstFYCalendar= Min(FirstFYCalendar) 
   /LastFYCalendar=Max(LastFYCalendar). 

Sort cases by case.
Match Files /table= '//covenas/decisionsupport/Clinfo.sav' /file=* /by case /keep Case FiscalYear FirstFYCalendar LastFYCalendar CIN. 

match files /table='//covenas/decisionsupport/addressmhs.sav'  /file=* /by case /keep Case FiscalYear FirstFYCalendar LastFYCalendar CIN Region City Outcty Homeless StreetAddressINSYST.  

 * insert file = '//covenas/decisionsupport/modules\cities.sps'.

rename variables region=regionMHS. 
rename variables city=cityMHS.
Rename variables outcty=outctyMHS.
rename variables homeless= homelessMHS.
if xdate.tday(FirstFYCalendar) lt yrmoda(2007,07,01) FirstFYCalendar = date.dmy(01,07,2007).
if xdate.tday(LastFYCalendar) lt yrmoda(2008,06,01) LastFYCalendar = date.dmy(01,06,2008).
Save outfile = '//covenas/decisionsupport/temp/RegionWork.sav'.

*Pre FY09 Medi-Cal Region Data. 

Get file =  '//covenas/spssdata/MediCalData/Meds_Jul07_uncut.sav'.
Compute FirstFYCalendar = Calendar.  
Compute HomelessMC1=0. 
if index(upcase(Street), "HOMELESS") ge 1 HomelessMC1=1. 
rename variables city = cityMC1.
rename variables region = regionMC1.

sort cases by CIN FirstFYCalendar.
Save outfile = '//covenas/decisionsupport/temp/MediCalAddress_JulPreFY09.sav' 
/keep  CIN FirstFYCalendar cityMC1 regionMC1 HomelessMC1.

Get file =  '//covenas/spssdata/MediCalData/meds_Jun08_uncut.sav'.
Compute LastFYCalendar = Calendar.  
Compute HomelessMC2=0. 
if index(upcase(Street), "HOMELESS") ge 1 HomelessMC2=1. 

rename variables city = cityMC2.
rename variables region = regionMC2.
sort cases by CIN LastFYCalendar.

Save outfile = '//covenas/decisionsupport/temp/MediCalAddress_JunPreFY09.sav' 
/keep  CIN LastFYCalendar cityMC2 regionMC2 HomelessMC2. 

 *  FY09 Medi-Cal Region Data. 
Get file =  '//covenas/spssdata/MediCalData/Meds_Jul08_uncut.sav'.

COMPUTE OUTCTY=1.
IF CITY = "OAKLAND" OUTCTY=0.
IF CITY="SAN LEANDRO" OUTCTY=0.
IF CITY="ALAMEDA" OUTCTY=0.
IF CITY="HAYWARD" OUTCTY=0.
IF CITY="DUBLIN" OUTCTY=0.
IF CITY="LIVERMORE" OUTCTY=0.
IF CITY="SAN LORENZO" OUTCTY=0.
IF CITY="FREMONT" OUTCTY=0.
IF CITY="PLEASANTON" OUTCTY=0.
IF CITY="EMERYVILLE" OUTCTY=0.
IF CITY="PIEDMONT" OUTCTY=0.
IF CITY="ALBANY" OUTCTY=0.
IF CITY="BERKELEY" OUTCTY=0.
IF CITY="UNION CITY" OUTCTY=0.
IF CITY="CASTRO VALLEY" OUTCTY=0.
IF CITY="NEWARK" OUTCTY=0.
IF CITY="HAYWARD" OUTCTY=0.
IF CITY = "SUNOL" OUTCTY=0.
IF CITY = "UNKNOWN" OUTCTY=0.
IF CITY = "HOMELESS"     OUTCTY=0.

string Region(a18).
if city = "ALAMEDA" Region="1. North".
if city = "ALBANY" Region="1. North".
if city = "BERKELEY" Region="1. North".
if city = "OAKLAND" Region="1. North".
if city = "EMERYVILLE" Region="1. North".
if city = "PIEDMONT" Region="1. North".         
if city = "HAYWARD" Region="2. Central".         
if city = "SAN LEANDRO" Region="2. Central".         
if city = "SAN LORENZO" Region="2. Central".       
if city  = "CASTRO VALLEY" Region="2. Central".
if city = "PLEASANTON" Region="4. East".         
if city = "LIVERMORE" Region="4. East".         
if city = "SUNOL" Region="4. East".         
if city = "DUBLIN" Region="4. East".     
if city = "UNION CITY" Region="3. South".         
if city = "FREMONT" Region="3. South".         
if city = "NEWARK" Region="3. South".                 
if city = "UNKNOWN" Region="6. Unknown".         
do if OUTCTY = 1.
compute  Region="5. Out of County".
end if.

Compute FirstFYCalendar = Calendar.  
Compute HomelessMC1=0. 
if index(upcase(Street), "HOMELESS") ge 1 HomelessMC1=1. 
rename variables city = cityMC1.
rename variables region = regionMC1.

sort cases by CIN FirstFYCalendar.
Save outfile = '//covenas/decisionsupport/temp/MediCalAddress_JulFY09.sav' 
/keep  CIN FirstFYCalendar cityMC1 regionMC1 HomelessMC1.

Get file =  '//covenas/spssdata/MediCalData/meds_Jun09_uncut.sav'.
Compute LastFYCalendar = Calendar.  
Compute HomelessMC2=0. 
if index(upcase(Street), "HOMELESS") ge 1 HomelessMC2=1. 

rename variables city = cityMC2.
rename variables region = regionMC2.
sort cases by CIN LastFYCalendar.

Save outfile = '//covenas/decisionsupport/temp/MediCalAddress_JunFY09.sav' 
/keep  CIN LastFYCalendar cityMC2 regionMC2 HomelessMC2. 

*Region - Medi-Cal FY10.

Get file =  '//covenas/spssdata/MediCalData/Meds_Jul09_uncut.sav'.
Compute FirstFYCalendar = Calendar.  
Compute HomelessMC1=0. 
if index(upcase(Street), "HOMELESS") ge 1 HomelessMC1=1. 
rename variables city = cityMC1.
rename variables region = regionMC1.

sort cases by CIN FirstFYCalendar.
Save outfile = '//covenas/decisionsupport/temp/MediCalAddress_JulFY10.sav' 
/keep  CIN FirstFYCalendar cityMC1 regionMC1 HomelessMC1.

Get file =  '//covenas/spssdata/MediCalData/meds_Jun10_uncut.sav'.
Compute LastFYCalendar = Calendar.  
Compute HomelessMC2=0. 
if index(upcase(Street), "HOMELESS") ge 1 HomelessMC2=1. 

rename variables city = cityMC2.
rename variables region = regionMC2.
sort cases by CIN LastFYCalendar.

Save outfile = '//covenas/decisionsupport/temp/MediCalAddress_JunFY10.sav' 
/keep  CIN LastFYCalendar cityMC2 regionMC2 HomelessMC2. 

*Region - Medi-Cal FY11.

Get file =  '//covenas/spssdata/MediCalData/Meds_Jul10_uncut.sav'.
Compute FirstFYCalendar = Calendar.  
Compute HomelessMC1=0. 
if index(upcase(Street), "HOMELESS") ge 1 HomelessMC1=1. 
rename variables city = cityMC1.
rename variables region = regionMC1.

sort cases by CIN FirstFYCalendar.
Save outfile = '//covenas/decisionsupport/temp/MediCalAddress_JulFY11.sav' 
/keep  CIN FirstFYCalendar cityMC1 regionMC1 HomelessMC1.

Get file =  '//covenas/spssdata/MediCalData/meds_Jun11_uncut.sav'.
Compute LastFYCalendar = Calendar.  
Compute HomelessMC2=0. 
if index(upcase(Street), "HOMELESS") ge 1 HomelessMC2=1. 

rename variables city = cityMC2.
rename variables region = regionMC2.
sort cases by CIN LastFYCalendar.

Save outfile = '//covenas/decisionsupport/temp/MediCalAddress_JunFY11.sav' 
/keep  CIN LastFYCalendar cityMC2 regionMC2 HomelessMC2. 

*Region - Medi-Cal FY12.

Get file =  '//covenas/spssdata/MediCalData/Meds_Jul11_uncut.sav'.
Compute FirstFYCalendar = Calendar.  
Compute HomelessMC1=0. 
if index(upcase(Street), "HOMELESS") ge 1 HomelessMC1=1. 
rename variables city = cityMC1.
rename variables region = regionMC1.

sort cases by CIN FirstFYCalendar.
Save outfile = '//covenas/decisionsupport/temp/MediCalAddress_JulFY12.sav' 
/keep  CIN FirstFYCalendar cityMC1 regionMC1 HomelessMC1.

Get file =  '//covenas/spssdata/MediCalData/meds_Jun12_uncut.sav'.
Compute LastFYCalendar = Calendar.  
Compute HomelessMC2=0. 
if index(upcase(Street), "HOMELESS") ge 1 HomelessMC2=1. 

rename variables city = cityMC2.
rename variables region = regionMC2.
sort cases by CIN LastFYCalendar.

Save outfile = '//covenas/decisionsupport/temp/MediCalAddress_JunFY12.sav' 
/keep  CIN LastFYCalendar cityMC2 regionMC2 HomelessMC2. 

*Region - Medi-Cal FY13.

Get file =  '//covenas/spssdata/MediCalData/Meds_Jul12_uncut.sav'.
Compute FirstFYCalendar = Calendar.  
Compute HomelessMC1=0. 
if index(upcase(Street), "HOMELESS") ge 1 HomelessMC1=1. 
rename variables city = cityMC1.
rename variables region = regionMC1.

sort cases by CIN FirstFYCalendar.
Save outfile = '//covenas/decisionsupport/temp/MediCalAddress_JulFY13.sav' 
/keep  CIN FirstFYCalendar cityMC1 regionMC1 HomelessMC1.

Get file =  '//covenas/spssdata/MediCalData/meds_Jun13_uncut.sav'.
Compute LastFYCalendar = Calendar.  
Compute HomelessMC2=0. 
if index(upcase(Street), "HOMELESS") ge 1 HomelessMC2=1. 

rename variables city = cityMC2.
rename variables region = regionMC2.
sort cases by CIN LastFYCalendar.

Save outfile = '//covenas/decisionsupport/temp/MediCalAddress_JunFY13.sav' 
/keep  CIN LastFYCalendar cityMC2 regionMC2 HomelessMC2. 

*GO - ADD COMMENTED OUT CODE BELOW IN SEPTEMBER OF 2014. 
*Region - Medi-Cal FY13.  

 * Get file =  '//covenas/spssdata/MediCalData/Meds_Jul13_uncut.sav'.
 * Compute FirstFYCalendar = Calendar.  
 * Compute HomelessMC1=0. 
 * if index(upcase(Street), "HOMELESS") ge 1 HomelessMC1=1. 
 * rename variables city = cityMC1.
 * rename variables region = regionMC1.

 * sort cases by CIN FirstFYCalendar.
 * Save outfile = '//covenas/decisionsupport/temp/MediCalAddress_JulFY14.sav' 
/keep  CIN FirstFYCalendar cityMC1 regionMC1 HomelessMC1.

 * Get file =  '//covenas/spssdata/MediCalData/meds_Jun14_uncut.sav'.
 * Compute LastFYCalendar = Calendar.  
 * Compute HomelessMC2=0. 
 * if index(upcase(Street), "HOMELESS") ge 1 HomelessMC2=1. 

 * rename variables city = cityMC2.
 * rename variables region = regionMC2.
 * sort cases by CIN LastFYCalendar.

 * Save outfile = '//covenas/decisionsupport/temp/MediCalAddress_JunFY14.sav' 
/keep  CIN LastFYCalendar cityMC2 regionMC2 HomelessMC2. 


*Match Cohort to Medi-Cal Region Data and select appropriate region and city. 

get file = '//covenas/decisionsupport/temp/RegionWork.sav'.
sort cases by CIN FirstFYCalendar.
match files /table= '//covenas/decisionsupport/temp/MediCalAddress_JulPreFY09.sav'  /file=* /by CIN FirstFYCalendar. 
match files /table= '//covenas/decisionsupport/temp/MediCalAddress_JulFY09.sav'  /file=* /by CIN FirstFYCalendar. 
match files /table= '//covenas/decisionsupport/temp/MediCalAddress_JulFY10.sav'  /file=* /by CIN FirstFYCalendar. 
match files /table= '//covenas/decisionsupport/temp/MediCalAddress_JulFY11.sav'  /file=* /by CIN FirstFYCalendar. 
match files /table= '//covenas/decisionsupport/temp/MediCalAddress_JulFY12.sav'  /file=* /by CIN FirstFYCalendar. 
match files /table= '//covenas/decisionsupport/temp/MediCalAddress_JulFY13.sav'  /file=* /by CIN FirstFYCalendar. 
 * GO - Add in September 2014. 
 * match files /table= '//covenas/decisionsupport/temp/MediCalAddress_JulFY14.sav'  /file=* /by CIN FirstFYCalendar. 
 * match files /table= '//covenas/decisionsupport/temp/MediCalAddress_JulFY15.sav'  /file=* /by CIN FirstFYCalendar. 
sort cases by CIN LastFYCalendar.
match files /table= '//covenas/decisionsupport/temp/MediCalAddress_JunPreFY09.sav'  /file=* /by CIN LastFYCalendar. 
match files /table= '//covenas/decisionsupport/temp/MediCalAddress_JunFY09.sav'  /file=* /by CIN LastFYCalendar. 
match files /table= '//covenas/decisionsupport/temp/MediCalAddress_JunFY10.sav'  /file=* /by CIN LastFYCalendar. 
match files /table= '//covenas/decisionsupport/temp/MediCalAddress_JunFY11.sav'  /file=* /by CIN LastFYCalendar. 
match files /table= '//covenas/decisionsupport/temp/MediCalAddress_JunFY12.sav'  /file=* /by CIN LastFYCalendar. 
match files /table= '//covenas/decisionsupport/temp/MediCalAddress_JunFY13.sav'  /file=* /by CIN LastFYCalendar. 
 * GO - Add in September 2014. 
 * match files /table= '//covenas/decisionsupport/temp/MediCalAddress_JunFY14.sav'  /file=* /by CIN LastFYCalendar. 
 * match files /table= '//covenas/decisionsupport/temp/MediCalAddress_JunFY15.sav'  /file=* /by CIN LastFYCalendar. 

If regionMHS = "6. Unknown" regionMHS=" ". 

String City(a20).
String Region(a18). 

Do if RegionMC1 ne "5. Out of County".
Compute City= CityMC1.
Compute Region=regionMC1. 
End if. 

Do if (RegionMC2 ne "5. Out of County") and Region=" ". 
Compute City= CityMC2.
Compute Region=regionMC2. 
End if. 

Do if (RegionMHS ne '5. Out of County') and Region=" ". 
Compute City= CityMHS.
Compute Region=regionMHS. 
End if. 

Do if ((index(upcase(StreetAddressINSYST), "HOMELESS") ge 1) or HomelessMHS=1) and Region=" ". 
Compute Region='Homeless'. 
End if. 

Do if (HomelessMC1=1 OR HomelessMC2=1) and Region=" ". 
Compute Region='Homeless'. 
End if. 

Do if RegionMC1 ne " " and Region=" ". 
Compute City= CityMC1.
Compute Region=regionMC1. 
End if. 

Do if RegionMC2 ne " " and Region=" ". 
Compute City= CityMC2.
Compute Region=regionMC2. 
End if. 

Do if RegionMHS ne " " and Region=" ". 
Compute City= CityMHS.
Compute Region=regionMHS. 
End if. 

 * sort cases by fiscalyear.
 * split file by fiscalyear.
 * freq region. 
 * freq City. 

If region = " " Region = '6. Unknown'.
If City  = " " City = 'UNKNOWN'.

Sort cases by FiscalYear Case.
Save outfile = '//covenas/decisionsupport/Orozco/Temp/CityAndRegion.sav' /keep FiscalYear Case Region City.
 * get file = '//covenas/decisionsupport/Orozco/Temp/CityAndRegion.sav'.
*END OF REGION Work.

Get file = '//covenas/decisionsupport/Orozco/Temp/RUClientsAndCostTrends_AB.sav'.
Sort cases by FiscalYear Case.
Match files /table = '//covenas/decisionsupport/Orozco/Temp/CityAndRegion.sav' /file=* /by FiscalYear Case /drop LastFYCalendar FirstFYCalendar.
if provname = 'BACS IRVINGTON CLC DAY REH FUL' dbservicemodality= 'Day Treatment'. 
if region = 'Homeless'  Region= "6. Unknown". 
 * freq city. 

*Variable not needed.
String AC_City(a20).
Do if (Region ne "6. Unknown") and (Region ne "5. Out of County"). 
Compute AC_City = City.
End if.
 * freq AC_City. 

Do If Region = "5. Out of County".
Compute City = "OUT OF COUNTY".
End if.

Do If Region = "6. Unknown".
Compute City = "UNKNOWN".
End if.
FREQ CITY. 


*Final Save. 
save outfile = '//covenas/decisionsupport/Orozco/Temp/RUClientsAndCostTrends.sav'.

*pushbreak.
*sqlTable = 'RUClientsAndCostTrends'.
*spsstable='//covenas/decisionsupport/Orozco/Temp/RUClientsAndCostTrends.sav'.
*pushbreak.


