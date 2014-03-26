*Use for running at PHD. 
 * GET DATA
  /TYPE=ODBC
  /CONNECT='DSN=Excel Files;DBQ=\\acphd.ph.local\dept\PHD\Cape\Projects-Reports\School Health '+
    'Services\CHSC Standard Indicators\Datasets\EAP Data\EAP_Lookup '+
    'files.xlsx;DriverId=1046;MaxBufferSize=2048;PageTimeout=5;;QuotedId=Yes'
  /SQL='SELECT `Number`, Number1, `Subgroup detail` AS Subgroup_detail, Subgroup  FROM `Subgroups$`'    
  /ASSUMEDSTRWIDTH=255.
 * CACHE.
 * EXECUTE.
 * ALTER TYPE ALL(A=AMIN).
 * DATASET NAME DataSet5 WINDOW=FRONT.

*Use for running at BHCS - Start. 

GET DATA
  /TYPE=ODBC
  /CONNECT='DSN=Excel Files;DBQ=//covenas/decisionsupport/Orozco\ACPHD\EAP_Lookup '+
    'files.xlsx;DriverId=1046;MaxBufferSize=2048;PageTimeout=5;'
  /SQL='SELECT `Number`, Number1, `Subgroup detail` AS Subgroup_detail, Subgroup FROM `Subgroups$`'
  /ASSUMEDSTRWIDTH=255.
VARIABLE LABELS Subgroup_detail 'Subgroup detail'.
CACHE.
EXECUTE.
ALTER TYPE ALL(A=AMIN).
DATASET NAME DataSet2 WINDOW=FRONT.
*Use for running at BHCS - End. 


rename variables number=SubGroupNumber.
sort cases by SubGroupNumber.

save outfile = '//covenas/decisionsupport/Orozco/ACPHD/sub group data.sav'.

*Use for running at PHD. 
 * GET DATA
  /TYPE=ODBC
  /CONNECT='DSN=Excel Files;DBQ=\\acphd.ph.local\dept\PHD\Cape\Projects-Reports\School Health '+
    'Services\CHSC Standard Indicators\Datasets\EAP Data\EAP_Alameda '+
    'County_2013_ALL_CSV_v1.xlsx;DriverId=1046;MaxBufferSize=2048;PageTimeout=5;;QuotedId=Yes'
  /SQL="SELECT `County Code` AS County_Code, `District Code` AS District_Code, `School Code` AS "+
    "School_Code, `Charter Number` AS Charter_Number, `Year`, Subgroup, Test, `Total STAR "+
    "Enrollment` AS Total_STAR_Enrollment, `Total Tested At Entity Level` AS "+
    "Total_Tested_At_Entity_Level, `Total Tested At Subgroup Level` AS "+
    "Total_Tested_At_Subgroup_Level, Grade, `Test Id` AS Test_Id, `EAP Students Tested` AS "+
    "EAP_Students_Tested, `CST Students Tested` AS CST_Students_Tested, `Participation Percentage` "+
    "AS Participation_Percentage, `EAP Percent Ready for College` AS "+
    "EAP_Percent_Ready_for_College, `EAP Percent Ready for College - Conditional` AS "+
    "EAP_Percent_Ready_for_College__Conditional, `EAP Percent Not Ready for College Yet` AS "+
    "EAP_Percent_Not_Ready_for_College_Yet, `EAP Students Ready for College` AS "+
    "EAP_Students_Ready_for_College, `EAP Students Ready for College - Conditional` AS "+
    "EAP_Students_Ready_for_College__Conditional, `EAP Students Not Ready for College Yet` AS "+
    "EAP_Students_Not_Ready_for_College_Yet  FROM `'EAP Alameda County 2013$'`"
  /ASSUMEDSTRWIDTH=255.
 * CACHE.
 * EXECUTE.
 * AUTORECODE Test
 /INTO tm1.
 * DELETE VARIABLES Test.
 * RENAME VARIABLES(tm1=Test).
 * ALTER TYPE ALL(A=AMIN).

 * DATASET NAME DataSet7 WINDOW=FRONT.

*Use for running at BHCS - Start. 
GET DATA
  /TYPE=ODBC
  /CONNECT='DSN=Excel Files;DBQ=//covenas/decisionsupport/Orozco\ACPHD\EAP_Alameda '+
    'County_2013_ALL_CSV_v1.xlsx;DriverId=1046;MaxBufferSize=2048;PageTimeout=5;'
  /SQL="SELECT `County Code` AS County_Code, `District Code` AS District_Code, `School Code` AS "+
    "School_Code, `Charter Number` AS Charter_Number, `Year`, Subgroup, Test, `Total STAR "+
    "Enrollment` AS Total_STAR_Enrollment, `Total Tested At Entity Level` AS "+
    "Total_Tested_At_Entity_Level, `Total Tested At Subgroup Level` AS "+
    "Total_Tested_At_Subgroup_Level, Grade, `Test Id` AS Test_Id, `EAP Students Tested` AS "+
    "EAP_Students_Tested, `CST Students Tested` AS CST_Students_Tested, `Participation Percentage` "+
    ""+
    "AS Participation_Percentage, `EAP Percent Ready for College` AS "+
    "EAP_Percent_Ready_for_College, `EAP Percent Ready for College - Conditional` AS "+
    "EAP_Percent_Ready_for_College__Conditional, `EAP Percent Not Ready for College Yet` AS "+
    "EAP_Percent_Not_Ready_for_College_Yet, `EAP Students Ready for College` AS "+
    "EAP_Students_Ready_for_College, `EAP Students Ready for College - Conditional` AS "+
    "EAP_Students_Ready_for_College__Conditional, `EAP Students Not Ready for College Yet` AS "+
    "EAP_Students_Not_Ready_for_College_Yet FROM `'EAP Alameda County 2013$'`"
  /ASSUMEDSTRWIDTH=255.
VARIABLE LABELS County_Code 'County Code'.
VARIABLE LABELS District_Code 'District Code'.
VARIABLE LABELS School_Code 'School Code'.
VARIABLE LABELS Charter_Number 'Charter Number'.
VARIABLE LABELS Total_STAR_Enrollment 'Total STAR Enrollment'.
VARIABLE LABELS Total_Tested_At_Entity_Level 'Total Tested At Entity Level'.
VARIABLE LABELS Total_Tested_At_Subgroup_Level 'Total Tested At Subgroup Level'.
VARIABLE LABELS Test_Id 'Test Id'.
VARIABLE LABELS EAP_Students_Tested 'EAP Students Tested'.
VARIABLE LABELS CST_Students_Tested 'CST Students Tested'.
VARIABLE LABELS Participation_Percentage 'Participation Percentage'.
VARIABLE LABELS EAP_Percent_Ready_for_College 'EAP Percent Ready for College'.
VARIABLE LABELS EAP_Percent_Ready_for_College__Conditional 'EAP Percent Ready for College - '+
    'Conditional'.
VARIABLE LABELS EAP_Percent_Not_Ready_for_College_Yet 'EAP Percent Not Ready for College Yet'.
VARIABLE LABELS EAP_Students_Ready_for_College 'EAP Students Ready for College'.
VARIABLE LABELS EAP_Students_Ready_for_College__Conditional 'EAP Students Ready for College - '+
    'Conditional'.
VARIABLE LABELS EAP_Students_Not_Ready_for_College_Yet 'EAP Students Not Ready for College Yet'.
CACHE.
EXECUTE.
ALTER TYPE ALL(A=AMIN).
AUTORECODE Test
 /INTO tm1.
DELETE VARIABLES Test.
RENAME VARIABLES (tm1=Test).
DATASET NAME DataSet3 WINDOW=FRONT.
*Use for running at BHCS - End. 

rename variables subgroup=SubGroupNumber.

sort cases by SubGroupNumber.

save outfile =  '//covenas/decisionsupport/Orozco/ACPHD/EAP_AlamedaCounty_2013_ALL.sav'.
get file =  '//covenas/decisionsupport/Orozco/ACPHD/EAP_AlamedaCounty_2013_ALL.sav'.

select if Charter_Number=0.

match files /table='//covenas/decisionsupport/Orozco/ACPHD/sub group data.sav' /file=* /by SubGroupNumber 
/keep
SubGroupNumber
Subgroup_detail
Subgroup
District_Code
School_Code
Year
Grade
Test_Id
EAP_Students_Tested
CST_Students_Tested
EAP_Students_Ready_for_College.

select if any(Test_Id, 34, 37).

sort cases by School_Code.
match files /table= '//covenas/decisionsupport/Orozco/ACPHD/school.sav' /file=* /by School_Code.

sort cases by District_Code.
match files /table= '//covenas/decisionsupport/Orozco/ACPHD/district.sav' /file=* /by District_Code.

select if District_Code gt 0.
Aggregate outfile = * Mode=ADDVARIABLES
   /Break=District Year Test_Id
   /DistrictEAP_Students_Tested =max(EAP_Students_Tested)
   /DistrictCST_Students_Tested =max(CST_Students_Tested)
   /DistrictEAP_Students_Ready_for_College =max(EAP_Students_Ready_for_College).

Select if School_Code gt 0. 
Aggregate outfile = * Mode=ADDVARIABLES
   /Break=District School_Code Year Test_Id
   /SchoolEAP_Students_Tested =max(EAP_Students_Tested)
   /SchoolCST_Students_Tested =max(CST_Students_Tested)
   /SchoolEAP_Students_Ready_for_College =max(EAP_Students_Ready_for_College).

recode SchoolEAP_Students_Ready_for_College (sysmis=0). 
recode EAP_Students_Tested CST_Students_Tested EAP_Students_Ready_for_College (sysmis=0). 
recode DistrictEAP_Students_Tested DistrictCST_Students_Tested DistrictEAP_Students_Ready_for_College (sysmis=0). 

If School_Code=1 School='Unknown'. 

String Filter (a100).
if subgroup= ' Gender' Filter='Gender'.
if any(subgroup, ' Ethnicity for Not Economically Disadvantaged', ' Ethnicity for Economically Disadvantaged') Filter='Ethnicity and SES'.
if subgroup= ' English-Language Fluency' Filter= 'English Language Learner Status'.

SORT CASES BY DISTRICT_CODE.
match files /table= '//covenas/decisionsupport/Orozco/ACPHD/SELPA.sav' /file=* /by District_code. 

Save outfile = '//covenas/decisionsupport/Orozco/ACPHD/EAP_Work.sav' /drop SubGroupNumber.
 * get file =  '//covenas/decisionsupport/Orozco/ACPHD/EAP_Work.sav'.
 * select if district_code = 61242.00.

Compute EAP_Students_Tested=0.
Compute CST_Students_Tested=0.
Compute EAP_Students_Ready_for_College=0. 
If Subgroup_detail ne " " Subgroup_detail= "Unknown".

Select if filter ne " ". 

Aggregate outfile = '//covenas/decisionsupport/Orozco/ACPHD/EAP_UnknownsShell.sav'
   /Break=Filter Subgroup_detail SELPA District district_code school school_code Year Grade Test_Id SchoolEAP_Students_Tested 
   SchoolCST_Students_Tested SchoolEAP_Students_Ready_for_College DistrictEAP_Students_Tested DistrictCST_Students_Tested DistrictEAP_Students_Ready_for_College 
   /EAP_Students_Tested=max(EAP_Students_Tested)
   /CST_Students_Tested=max(CST_Students_Tested)
   /EAP_Students_Ready_for_College=max(EAP_Students_Ready_for_College).

*Gender Portion of dataset - Also Calculate unknown gender data. 

Add files
   file = '//covenas/decisionsupport/Orozco/ACPHD/EAP_Work.sav'
   file =  '//covenas/decisionsupport/Orozco/ACPHD/EAP_UnknownsShell.sav'.

select if Filter= 'Gender'. 

Aggregate outfile = * mode= addvariables
   /Break District School_Code Year Test_Id
   /FilteredN_EAPTested= sum(EAP_Students_Tested)
   /FilteredN_CST_Students=sum(CST_Students_Tested)
   /FilteredN_EAP_Students_Ready=sum(EAP_Students_Ready_for_College).

Do if Subgroup_detail = 'Unknown'.
compute EAP_Students_Tested = SchoolEAP_Students_Tested - FilteredN_EAPTested.
compute CST_Students_Tested = SchoolCST_Students_Tested - FilteredN_CST_Students.
compute EAP_Students_Ready_for_College = SchoolEAP_Students_Ready_for_College - FilteredN_EAP_Students_Ready.
End if. 

 * if EAP_Students_Tested lt 0 EAP_Students_Tested=0.
 * if CST_Students_Tested lt 0 CST_Students_Tested=0. 
 * if EAP_Students_Ready_for_College lt 0 EAP_Students_Ready_for_College=0.

Compute drop=0.
if  Subgroup_detail = 'Unknown' and EAP_Students_Tested=0 and CST_Students_Tested=0 and EAP_Students_Ready_for_College=0 drop=1.
select if drop=0. 

Rename Variables Subgroup_Detail = Gender.

Save outfile =  '//covenas/decisionsupport/Orozco/ACPHD/EAP_Gender.sav' /drop drop FilteredN_EAPTested FilteredN_CST_Students FilteredN_EAP_Students_Ready subgroup.

*English Language Learner Status Unknown Rows. 

Add files
   file = '//covenas/decisionsupport/Orozco/ACPHD/EAP_Work.sav'
   file =  '//covenas/decisionsupport/Orozco/ACPHD/EAP_UnknownsShell.sav'.

select if Filter= 'English Language Learner Status'. 
select if any(subgroup_detail, " Fluent-English Proficient and English Only", " English Learner", "Unknown").

Aggregate outfile = * mode= addvariables
   /Break District School_Code Year Test_Id
   /FilteredN_EAPTested= sum(EAP_Students_Tested)
   /FilteredN_CST_Students=sum(CST_Students_Tested)
   /FilteredN_EAP_Students_Ready=sum(EAP_Students_Ready_for_College).

Do if Subgroup_detail = 'Unknown'.
compute EAP_Students_Tested = SchoolEAP_Students_Tested - FilteredN_EAPTested.
compute CST_Students_Tested = SchoolCST_Students_Tested - FilteredN_CST_Students.
compute EAP_Students_Ready_for_College = SchoolEAP_Students_Ready_for_College - FilteredN_EAP_Students_Ready.
End if. 

 * select if school_code = 106401.00. 
 * select if test_id = 37. 

Compute drop=0.
if  Subgroup_detail = 'Unknown' and EAP_Students_Tested=0 and CST_Students_Tested=0 and EAP_Students_Ready_for_College=0 drop=1.
select if drop=0. 

Rename Variables  subgroup_detail = ELL_Status.
If ELL_Status  = "Unknown" ELL_Status = "Other/Unknown". 

Save outfile =  '//covenas/decisionsupport/Orozco/ACPHD/EAP_ELL.sav'  /drop drop FilteredN_EAPTested FilteredN_CST_Students FilteredN_EAP_Students_Ready subgroup.
*SES Unknown Rows. 

Add files
   file = '//covenas/decisionsupport/Orozco/ACPHD/EAP_Work.sav'
   file =  '//covenas/decisionsupport/Orozco/ACPHD/EAP_UnknownsShell.sav'.

select if Filter= 'Ethnicity and SES'. 

Aggregate outfile = * mode= addvariables
   /Break District School_Code Year Test_Id
   /FilteredN_EAPTested= sum(EAP_Students_Tested)
   /FilteredN_CST_Students=sum(CST_Students_Tested)
   /FilteredN_EAP_Students_Ready=sum(EAP_Students_Ready_for_College).

Do if Subgroup_detail = 'Unknown'.
compute EAP_Students_Tested = SchoolEAP_Students_Tested - FilteredN_EAPTested.
compute CST_Students_Tested = SchoolCST_Students_Tested - FilteredN_CST_Students.
compute EAP_Students_Ready_for_College = SchoolEAP_Students_Ready_for_College - FilteredN_EAP_Students_Ready.
End if. 

Compute drop=0.
if  Subgroup_detail = 'Unknown' and EAP_Students_Tested=0 and CST_Students_Tested=0 and EAP_Students_Ready_for_College=0 drop=1.
select if drop=0. 

Rename Variables Subgroup = SES.
Rename Variables Subgroup_detail = Ethnicity.

If Ethnicity = 'Unknown' SES= 'Unknown'. 

Save outfile =  '//covenas/decisionsupport/Orozco/ACPHD/EAP_SES.sav'  /drop drop FilteredN_EAPTested FilteredN_CST_Students FilteredN_EAP_Students_Ready.

 * select if school_code= 106401.00.
 * select if test_id=37.

Add files 
   /file =  '//covenas/decisionsupport/Orozco/ACPHD/EAP_Gender.sav'
   /file = '//covenas/decisionsupport/Orozco/ACPHD/EAP_SES.sav'
   /file = '//covenas/decisionsupport/Orozco/ACPHD/EAP_ELL.sav'  /drop DistrictEAP_Students_Tested DistrictCST_Students_Tested 
DistrictEAP_Students_Ready_for_College SchoolEAP_Students_Tested SchoolCST_Students_Tested SchoolEAP_Students_Ready_for_College.

Select if school ne "California School for the Deaf-Fremont ELEMHIGH". 

*Accuracy Test - Start. 
 * select if school_code = 131177.00.
 * select if test_id = 34. 

 * select if ELL_Status ne " ". 

 * Aggregate outfile = * mode= addvariables
   /Break District Year Test_Id
   /FilteredN_EAPTested= sum(EAP_Students_Tested)
   /FilteredN_CST_Students=sum(CST_Students_Tested)
   /FilteredN_EAP_Students_Ready=sum(EAP_Students_Ready_for_College).

 * compute EAP_Students_Tested_DIFF = DistrictEAP_Students_Tested - FilteredN_EAPTested.
 * compute CST_Students_Tested_DIFF = DistrictCST_Students_Tested - FilteredN_CST_Students.
 * compute EAP_Students_Ready_for_College_DIFF = DistrictEAP_Students_Ready_for_College - FilteredN_EAP_Students_Ready.

*Accuracy Test - End. 

Save outfile = '//covenas/decisionsupport/Orozco/Temp/HCSA_EAP_Filter.sav'.

Select if Filter = "Gender".
If Filter = "Gender" Filter = "None".
Compute Gender = " ".
Aggregate Outfile = *
   /break = SELPA District_Code District School_Code School Gender Year Grade Test_Id Filter Ethnicity SES ELL_Status
   /EAP_Students_Tested = SUM(EAP_Students_Tested)
   /CST_Students_Tested = sum(CST_Students_Tested)
   /EAP_Students_Ready_for_College = sum(EAP_Students_Ready_for_College).

Add files
   /File = *
   /file =  '//covenas/decisionsupport/Orozco/Temp/HCSA_EAP_Filter.sav'.

Save outfile = '//covenas/decisionsupport/Orozco/ACPHD/HCSA_EAP.sav'. 

get file = '//covenas/decisionsupport/Orozco/ACPHD/HCSA_EAP.sav'. 

*pushbreak.
*sqlTable = 'HCSA_EAP'.
*spsstable='//covenas/decisionsupport/Orozco/ACPHD/HCSA_EAP.sav'.
*pushbreak.









