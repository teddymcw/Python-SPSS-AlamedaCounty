*test1. Get services, label when service took place.

get file='//covenas/decisionsupport/dbsvc.sav' /keep ru case svcdate proced cost primdx opdate closdate duration duration2.
insert file='//covenas/decisionsupport/modules/uncookedmonth.sps'.
select if svcdate ge date.dmy(01,07,2010) and svcdate lt UnCookedMonth.
insert file='//covenas/decisionsupport/meinzer/modules/NoShow.sps'.
insert file='//covenas/decisionsupport/meinzer/modules/calsvcdate.sps'.

string FiscalYear (a10).
do if xdate.month(calendar) lt 7.
compute fiscalyear=concat("FY ",substr(string(xdate.year(calendar)-1,n4),3,2),"-",substr(string(xdate.year(calendar),n4),3,2)).
else if xdate.month(calendar) ge 7.
compute fiscalyear=concat("FY ",substr(string(xdate.year(calendar),n4),3,2),"-",substr(string(xdate.year(calendar)+1,n4),3,2)).
end if.


sort cases by ru.
match files /table='//covenas/decisionsupport/RUTable.sav' /file=* /by ru.
select if kidsru=1. 

*New *CREATE PROGRAM TYPES. 

recode school county ab3632ru CESDC residential daytx (sysmis=0).

If any(provname, 'SENECA REDWOOD HS MHS CHILD', 'SENECA LORIN EDEN MHS CHILD', 'SENECA BRENKWITZ HS MHS CHILD', 'SENECA SOUTHGATE ESY MHS CHILD', 'SENECA TENNYSON HS MHS CHILD') school=1.

String ProgramType(a60).
If svcType= "Crisis" or psmask2=34 ProgramType= "Crisis Program".
If psmask2=5 ProgramType= "Hospital".
If ((DayTx=1 or psmask2=65537) AND svcMode = "10") ProgramType = "DayTx".
If (DayTx=1 AND svcMode="15") ProgramType = "DayTx - MHS".
If school=1 and ab3632ru=0 and CESDC=0 and DayTx=0 ProgramType= "School - SBBH".
If ((school=1 and ab3632ru=1) or CESDC=1) and DayTx=0 ProgramType=  "School ERMHS - Counseling Enriched".
If psmask2= 262145 ProgramType= "Level1 - Child Community Support Services".
If (ProgramType=" " and SvcType="TBS") or index(provname, 'TBS') GE 1 ProgramType= "TBS".
If ProgramType=" " and EPSDTGroup= 'Foster' ProgramType=  'Child Welfare'.
If ProgramType=" " and (EPSDTGroup= 'JuvJustice' or svctype = 'JuvJustice') ProgramType= 'Juvenile Justice'.
If ProgramType=" " and EPSDTGroup= '0-5' ProgramType= 'Early Childhood'.
If ProgramType=" " and (index(svcType, 'Level 3') or EPSDTGroup= 'Level 3 Org') ProgramType= 'Other - Level 3'.
if any(ru,"81813","81814" ) programType= 'Juvenile Justice'.
if ru = "81781" programtype=  'Child Welfare'.
If ProgramType=" " ProgramType= 'Other' .

If any (ProgramType, "Crisis Program", "Hospital") Drop=1. 
recode Drop(sysmis=0).
select if Drop=0.

 * recode school(sysmis=0).
 * select if school=1.
 * recode AB3632RU (sysmis=0).
 * select if AB3632RU =0.

Insert file= '//covenas/decisionsupport/modules\RenameCountySites.sps'.

IF xdate.tday(SVCDATE) ge yrmoda(2010,07,01) and xdate.tday(SVCDATE) lt yrmoda(2011,07,01) FYServed1011=1.
IF xdate.tday(SVCDATE) ge yrmoda(2011,07,01) and xdate.tday(SVCDATE) lt yrmoda(2012,07,01) FYServed1112=1.
IF xdate.tday(SVCDATE) ge yrmoda(2012,07,01) and xdate.tday(SVCDATE) lt yrmoda(2013,07,01) FYServed1213=1.
IF xdate.tday(SVCDATE) ge yrmoda(2013,07,01) and xdate.tday(SVCDATE) lt yrmoda(2014,07,01) FYServed1314=1.

IF xdate.tday(SVCDATE) ge yrmoda(2014,07,01) and xdate.tday(SVCDATE) lt yrmoda(2015,07,01) FYServed1415=1.
IF xdate.tday(SVCDATE) ge yrmoda(2015,07,01) and xdate.tday(SVCDATE) lt yrmoda(2016,07,01) FYServed1516=1.
IF xdate.tday(SVCDATE) ge yrmoda(2016,07,01) and xdate.tday(SVCDATE) lt yrmoda(2017,07,01) FYServed1617=1.

IF xdate.tday(SVCDATE) ge yrmoda(2017,07,01) and xdate.tday(SVCDATE) lt yrmoda(2018,07,01) FYServed1718=1.
IF xdate.tday(SVCDATE) ge yrmoda(2018,07,01) and xdate.tday(SVCDATE) lt yrmoda(2019,07,01) FYServed1819=1.
IF xdate.tday(SVCDATE) ge yrmoda(2019,07,01) and xdate.tday(SVCDATE) lt yrmoda(2020,07,01) FYServed1920=1.


compute calendarServed = date.MOYR(xdate.month(SVCDATE),xdate.year(SVCDATE)).
formats calendarServed (date11).

recode FYServed1011 FYServed1112 FYServed1213 FYServed1314 FYServed1415 FYServed1516 FYServed1617 FYServed1718 FYServed1819 FYServed1920 (sysmis=0).

*2. Create a Marker on each service line indicating what FYs clients received services from that RU.

aggregate outfile=* Mode= ADDVARIABLES
   /break ru case 
   /FYServed_1011=max(FYServed1011)
   /FYServed_1112=max(FYServed1112)
   /FYServed_1213=max(FYServed1213)
   /FYServed_1314=max(FYServed1314)
   /FYServed_1415=max(FYServed1415)
   /FYServed_1516=max(FYServed1516)
   /FYServed_1617=max(FYServed1617)
   /FYServed_1718=max(FYServed1718)
   /FYServed_1819=max(FYServed1819)
   /FYServed_1920=max(FYServed1920).

*3. Indicate what FY the Admit and Discharge took place.

 * insert file='//covenas/decisionsupport/meinzer/modules/admitdischarge.sps'.
string Admit Discharge(a10).
do if xdate.month(opdate) lt 7.
compute Admit=concat("FY ",substr(string(xdate.year(opdate)-1,n4),3,2),"-",substr(string(xdate.year(opdate),n4),3,2)).
else if xdate.month(opdate) ge 7.
compute Admit=concat("FY ",substr(string(xdate.year(opdate),n4),3,2),"-",substr(string(xdate.year(opdate)+1,n4),3,2)).
end if.
do if xdate.month(closdate) lt 7.
compute Discharge=concat("FY ",substr(string(xdate.year(closdate)-1,n4),3,2),"-",substr(string(xdate.year(closdate),n4),3,2)).
else if xdate.month(closdate) ge 7.
compute Discharge=concat("FY ",substr(string(xdate.year(closdate),n4),3,2),"-",substr(string(xdate.year(closdate)+1,n4),3,2)).
end if.

compute calendarOpen = date.MOYR(xdate.month(opdate),xdate.year(opdate)).
compute calendarClose = date.MOYR(xdate.month(closdate),xdate.year(closdate)).
formats calendarOpen calendarClose(MOYR6).

compute calendarOpen = date.MOYR(xdate.month(opdate),xdate.year(opdate)).
compute calendarClose = date.MOYR(xdate.month(closdate),xdate.year(closdate)).
formats calendarOpen calendarClose(MOYR6).

save outfile = '//covenas/decisionsupport/Orozco/Temp/SBMHWork.sav'.
 *  get file = '//covenas/decisionsupport/Orozco/Temp/SBMHWork.sav'.

*4.Provide a FY and calendar marker for new admits. 

string NewFYAdmit(a10).
if admit ="FY 11-12" and (FYServed_1011 = 0 or missing(fyserved_1011)) NewFYAdmit="FY 11-12".
if admit ="FY 12-13" and (FYServed_1112 = 0 or missing(fyserved_1112)) NewFYAdmit="FY 12-13".
if admit ="FY 13-14" and (FYServed_1213 = 0 or missing(fyserved_1213)) NewFYAdmit="FY 13-14".
if admit ="FY 14-15" and (FYServed_1314 = 0 or missing(fyserved_1314)) NewFYAdmit="FY 14-15".
if admit ="FY 15-16" and (FYServed_1415 = 0 or missing(fyserved_1415)) NewFYAdmit="FY 15-16".
if admit ="FY 16-17" and (FYServed_1516 = 0 or missing(fyserved_1516)) NewFYAdmit="FY 16-17".
if admit ="FY 17-18" and (FYServed_1617 = 0 or missing(fyserved_1617)) NewFYAdmit="FY 17-18".
if admit ="FY 18-19" and (FYServed_1718 = 0 or missing(fyserved_1718)) NewFYAdmit="FY 18-19".
if admit ="FY 19-20" and (FYServed_1819 = 0 or missing(fyserved_1819)) NewFYAdmit="FY 19-20".

if NewFYAdmit ne " " NewCalAdmits = calendarOpen.

sort cases by cds_code.
match files /table='//covenas/spssdata/SchoolTable.sav' /file=* /by cds_code.
do if safePassages=1.
compute schoolName=Concat(rtrim(schoolName),' Our Kids').
end if.

sort cases by proced.
match files /table='//covenas/decisionsupport/procedSMA.sav'/file=*/by proced /keep
ProgramType
Agency
ru
provname
case
svcType
cds_Code
school
SchoolName
District
svcmode
MCSvcCat
svcdate
proced
svc_cat
proclong
cost
duration
duration2
calendar
FiscalYear
ProgramType
calendarServed
Admit
Discharge
calendarOpen
calendarClose
admit
NewFYAdmit
NewCalAdmits.

if any(svcMode,"05","10") AND MCSvcCat ne "F. Crisis Stabilization" Day=1.
if day=1 Duration=$sysmis.
if day=1 Duration2=$sysmis.

sort cases by proclong.
 * split file by proclong.
 * freq proced. 
 * split file off. 

 * temporary.
 * select if proced=427.
 * freq provname. 

*New Start.
if svc_cat= "family therapy" and proced ne 317 FamilyHrs_Other=duration.
if svc_cat= "grp therapy" and proced ne 317 GroupHrs=duration.
if proced = 317 FamilyHrs_Group=duration.
if svc_cat= "collateral" CollateralHrs=duration.

*New End 1-31-14. 

 * if svc_cat= "ind therapy" IndivHrs=duration. 
 * if svc_cat= "grp therapy" GroupHrs=duration.
*Gone. 
 * if svc_cat= "family therapy" and index(proclong, 'COL') GE 1 FamilyHrs_Collateral=duration.
 * if svc_cat= "family therapy" and index(proclong, 'GR') GE 1 FamilyHrs_Group=duration.
 * if svc_cat= "family therapy" and index(proclong, 'GR')=0 and  index(proclong, 'Col')=0 FamilyHrs_Other=duration.
 * if svc_cat= "meds" MedsHrs=duration.
 * if svc_cat= "crisis intervention" CrisisHrs=duration.      
 * if svc_cat= "collateral" CollateralHrs=duration.
 * freq FamilyHrs_Collateral FamilyHrs_Group FamilyHrs_Other.

if district="Alameda County Office of Education                      " district="ACOE".

if ru = "01KA1" AND district=" " district="Emeryville Unified". 

*Asian Pacific is now CHAA.

if RU="81794" SchoolName="Multiple Sites".
if RU="88035" SchoolName="Mulitple Sites".

if RU="81794" District="Fremont Unified                                                 ".
if RU="88035" District="Berkeley Unified                                                ".

if RU="01IR1" SchoolName="Multiple Sites".

 * save outfile='//covenas/spssdata/epsdt\school_recent.sav'.

 * get file='//covenas/spssdata/epsdt\school_recent.sav'.

*this is to check for schools that need CDS codes in the RUtable.
*select if schoolname=" ".
*sort cases by ru provname.
*split file by ru.
*freq provname.
*split file off.

*RU Totals. 

sort cases by ru case FiscalYear.
match files /file=* /by ru case FiscalYear /first=rucasefy1.
Aggregate outfile = * Mode= ADDVARIABLES
   /Break= ru fiscalyear  
   /FyRuKids=sum(rucasefy1).

sort cases by ru case NewFYAdmit calendar.
match files /file=* /by ru case NewFYAdmit /first= RuCaseNewAdmit1.
if NewFYAdmit = " " RuCaseNewAdmit1=0.
Aggregate outfile = * Mode= ADDVARIABLES
   /Break= ru fiscalyear 
   /FyRuNewKids=sum(RuCaseNewAdmit1).

*District Totals.

sort cases by district case FiscalYear.
match files /file=* /by district case FiscalYear /first=districtcasefy1.
Aggregate outfile = * Mode= ADDVARIABLES
   /Break= district fiscalyear  
   /FyDistrictKids=sum(districtcasefy1).

sort cases by district case NewFYAdmit calendar.
match files /file=* /by district case NewFYAdmit /first= DistrictCaseNewAdmit1.
if NewFYAdmit = " " DistrictCaseNewAdmit1=0.
Aggregate outfile = * Mode= ADDVARIABLES
   /Break= district fiscalyear 
   /FyDistrictNewKids=sum(DistrictCaseNewAdmit1).

Aggregate outfile = * Mode= ADDVARIABLES
   /Break= district calendar 
   /CalDistrictNewKids=sum(DistrictCaseNewAdmit1).

sort cases by district case calendar.
match files /file=* /by district case calendar /first=districtcaseCal1.
Aggregate outfile = * Mode= ADDVARIABLES
   /Break= district calendar 
   /CalDistrictKids=sum(districtcaseCal1).

*Agency Totals.

sort cases by agency case FiscalYear.
match files /file=* /by agency case FiscalYear /first=agencycasefy1.
Aggregate outfile = * Mode= ADDVARIABLES
   /Break= agency fiscalyear  
   /FyAgencyKids=sum(agencycasefy1).

sort cases by agency case NewFYAdmit calendar.
match files /file=* /by agency case NewFYAdmit /first= agencyCaseNewAdmit1.
if NewFYAdmit = " " agencyCaseNewAdmit1=0.
Aggregate outfile = * Mode= ADDVARIABLES
   /Break= agency fiscalyear 
   /FyAgencyNewKids=sum(AgencyCaseNewAdmit1).

Aggregate outfile = * Mode= ADDVARIABLES
   /Break= agency calendar 
   /CalAgencyNewKids=sum(AgencyCaseNewAdmit1).

sort cases by agency  case calendar.
match files /file=* /by agency  case calendar /first=agencycaseCal1.
Aggregate outfile = * Mode= ADDVARIABLES
   /Break= agency  calendar 
   /CalAgencyKids=sum(agencycaseCal1).

*for RU Calendar Clients.
sort cases by ru case calendar.
match files /file=* /by ru case Calendar /first=rucaseCal1.

sort cases by ru case Admit calendar.
match files /file=* /by ru case admit /first= RuCaseAdmit1.

select if calendar ge date.dmy(01,07,2011).

recode FamilyHrs_Group FamilyHrs_Other groupHrs CollateralHrs (sysmis=0). 

AGGREGATE OUTFILE='//covenas/decisionsupport/temp\SBMHReport.sav'
 /BREAK= ProgramType agency ru provname school schoolName cds_code district fiscalyear calendar
 /RuCalKids = SUM(rucaseCal1) 
 /RuCalAdmit= Sum(RuCaseAdmit1)
 /RuCalNewKids=sum(RuCaseNewAdmit1)
 /HoursBilled = sum(Duration) 
 /HoursReceived = SUM(duration2) 
 /Days = sum(Day)
 /FamilyHours_Group=sum(FamilyHrs_Group)
 /FamilyHours_Other=sum(FamilyHrs_Other)
 /GroupHours=sum(groupHrs)
 /CollateralHrs=sum(CollateralHrs)
 /FirstService=min(svcdate) 
 /LastService=max(svcdate)  
 /Cost = sum(cost)
 /FyRuNewKids=max(FyRuNewKids)
 /FyRuKids=max(FyRuKids)
 /DistrictKids = max(CalDistrictKids)
 /DistrictNewKids=max(CalDistrictNewKids)
 /FyDistrictKids=max(FyDistrictKids)
 /FyDistrictNewKids=max(FyDistrictNewKids)
 /FyAgencyKids=max(FyAgencyKids)
 /FyAgencyNewKids=max(FyAgencyNewKids)
 /CalAgencyNewKids=max(CalAgencyNewKids)
 /CalAgencyKids=max(CalAgencyKids).

 get file ='//covenas/decisionsupport/temp\SBMHReport.sav'.

*pushbreak.
*sqlTable = 'SBMHReport'.
*spsstable='//covenas/decisionsupport/temp\SBMHReport.sav'.
*pushbreak.


*GO - Next - Drill to SvcCat based on buckets SvcCats. 




