
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

sort cases by proced.
Match files /table='//covenas/decisionsupport/procedsma.sav' / file=* /by proced.

if any(svcMode,"05","10") AND MCSvcCat ne "F. Crisis Stabilization" Day=1.
if day=1 Duration=$sysmis.

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

Aggregate outfile = '//covenas/decisionsupport/Orozco/Temp/RUClientsAndCostTrends_Work_B.sav'
   /Break= CSOCProgramModel Agency Provname RU KidsRUText TAYruText OAruText AdultRUText FiscalYear Case primdx
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
CSOCProgramModel Agency Provname RU KidsRUText TAYruText OAruText AdultRUText FiscalYear Case Cost Hours Days Age DxCategory dx_grpDSM Ethnicity language Gender. 


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

sort cases by proced.
Match files /table='//covenas/decisionsupport/procedsma.sav' / file=* /by proced.

if any(svcMode,"05","10") AND MCSvcCat ne "F. Crisis Stabilization" Day=1.
if day=1 Duration=$sysmis.

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

Aggregate outfile = '//covenas/decisionsupport/Orozco/Temp/RUClientsAndCostTrends_Work_A.sav'
   /Break= CSOCProgramModel Agency Provname RU KidsRUText TAYruText OAruText AdultRUText FiscalYear Case primdx
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
CSOCProgramModel Agency Provname RU KidsRUText TAYruText OAruText AdultRUText FiscalYear Case Cost Hours Days Age DxCategory dx_grpDSM Ethnicity language Gender. 

Add files 
   /file='//covenas/decisionsupport/Orozco/Temp/RUClientsAndCostTrends_A.sav'
   /file='//covenas/decisionsupport/Orozco/Temp/RUClientsAndCostTrends_B.sav'.

if dx_grpDSM= " " dx_grpDSM='Unknown'. 

save outfile = '//covenas/decisionsupport/Orozco/Temp/RUClientsAndCostTrends.sav'.

*pushbreak.
*sqlTable = 'RUClientsAndCostTrends'.
*spsstable='//covenas/decisionsupport/Orozco/Temp/RUClientsAndCostTrends.sav'.
*pushbreak.


