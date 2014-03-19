
DEFINE famDBStartDate() date.dmy(1,7,2011) !ENDDEFINE.

GET FILE='//covenas/decisionsupport/dbsvc.sav'
/KEEP ru case proced svcdate proclong calendar duration provname agency kidsru psmask2 svcmode.

select if svcdate ge famDBStartDate.

select if kidsru=1.
recode psmask2(sysmis=0).
select if psmask2 ne 900.
*select if end_Dt=0.
select if svcMode="15".
select if not any(ru, "01DW1", "81933", "811825").
If index(provname, 'TBS') GE 1 Drop=1.
If agency='Pathways to Wellness' Drop=1.
recode Drop(sysmis=0).
select if Drop=0.

insert file='//covenas/decisionsupport/modules/uncookedmonth.sps'.

select if svcdate lt Uncookedmonth.

insert file='//covenas/decisionsupport/meinzer/modules/calfiscalyear.sps'.

if index(proclong,"FAM") ge 1  and proclong ne "COMMUNITY/FAMILY CONSULTATION" family=1.
If proced=317 family=1.

if family=1 familyHours=duration.

sort cases by ru fiscalYear case family.
match files/file=* /by ru fiscalYEar case /last=FYrucase1.

sort cases by ru calendar case family.
match files /file=* /by ru calendar case /last=RuCalCase1.

if FYrucase1=1 AND family =1 FYrufamCase1=1.

if RuCalCase1=1 AND family =1 RuCalFamCase1=1.

save outfile='//covenas/decisionsupport/temp\FamWork.sav'.

*get file='//covenas/decisionsupport/temp\FamWork.sav'.

aggregate outfile='//covenas/decisionsupport/dashboardDataSets\FamilyRU_byFY.sav'
	/break = agency provname ru FiscalYear  
	/TotalClients = sum(FYrucase1)
	/FamilyClients = sum(FYruFamCase1)
	/TotalHours= sum(Duration)
	/FamilyHours = sum(FamilyHours).

aggregate outfile='//covenas/decisionsupport/dashboardDataSets\FamilyRU_byMonth.sav'
	/break = agency provname  ru calendar  
	/TotalClients = sum(RuCalCase1)
	/FamilyClients = sum(RuCalFamCase1)
	/TotalHours= sum(Duration)
	/FamilyHours = sum(FamilyHours).

get file='//covenas/decisionsupport/dashboardDataSets\FamilyRU_byFY.sav'.
 
compute FamilyWork=0.
if FamilyClients ge 1 FamilyWork=1.
compute pctFamClients = FamilyClients/TotalClients .
compute pctFamHours= FamilyHours/TotalHours.

string FamHoursPctGroup FamClientsPctGroup(a40).
compute FamHoursPctGroup = "C. less than 5% of total hours".
if pctFamHours ge .05 and pctFamHours lt .25 FamHoursPctGroup = "B. 5% - 24% of total hours".
if pctFamHours ge .25 FamHoursPctGroup = "A. 25+ % of total hours ".

compute FamClientsPctGroup = "C. less than 5% of clients".
if PctFamClients ge .05 and PctFamClients lt .35 FamClientsPctGroup = "B. 5% - 34% of clients".
if PctFamClients ge .35 FamClientsPctGroup = "A. 35+ % of clients".


formats  FamilyWork TotalClients FamilyClients TotalHOurs FamilyHOurs(f3.0).
recode FamilyWork TotalClients FamilyClients TotalHOurs FamilyHOurs pctFamClients pctFamHours(sysmis=0).
*if agency =" " agency = "No Agency".
string label(a75).
compute label = concat(rtrim(agency)," : ", rtrim(provname)," ", RU).
Sort cases by ru. 
Match files /table='//covenas/decisionsupport/Orozco/Temp/ProgramModels.sav' /file=* /by ru. 

save outfile='//covenas/decisionsupport/temp/familyEngageFYx.sav'.

*pushbreak.
*sqlTable = 'FamilyEngagementFY'.
*spsstable='//covenas/decisionsupport/temp/familyEngageFYx.sav'.
*pushbreak.


get file='//covenas/decisionsupport/dashboardDataSets\FamilyRU_byMonth.sav'.

compute FamilyWork=0.

if FamilyClients ge 1 FamilyWork=1.
compute pctFamClients = FamilyClients/TotalClients .
compute pctFamHours= FamilyHours/TotalHours.
*freq PctFamClients.

string FamHoursPctGroup FamClientsPctGroup(a40).
compute FamHoursPctGroup = "C. less than 5% of total hours".
if pctFamHours ge .05 and pctFamHours lt .25 FamHoursPctGroup = "B. 5% - 24% of total hours".
if pctFamHours ge .25 FamHoursPctGroup = "A. 25+ % of total hours ".

compute FamClientsPctGroup = "C. less than 5% of clients".
if PctFamClients ge .05 and PctFamClients lt .35 FamClientsPctGroup = "B. 5% - 34% of clients".
if PctFamClients ge .35 FamClientsPctGroup = "A. 35+ % of clients".

compute createDate = $time.
freq createdate.
formats CreateDate(date11).
formats  FamilyWork TotalClients FamilyClients TotalHours FamilyHours(f3.0).
recode FamilyWork TotalClients FamilyClients TotalHours FamilyHours pctFamClients pctFamHours(sysmis=0).
*if agency =" " agency = "No Agency".
string label(a75).
compute label = concat(rtrim(agency)," : ", rtrim(provname)," ", RU).

Sort cases by ru. 
Match files /table='//covenas/decisionsupport/Orozco/Temp/ProgramModels.sav' /file=* /by ru. 
If ProgramModel=" " ProgramModel= 'Other' .

save outfile='//covenas/decisionsupport/temp/FamilyEngagementMonthx.sav'.

*pushbreak.
*sqlTable = 'FamilyEngagementMonth'.
*spsstable='//covenas/decisionsupport/temp/FamilyEngagementMonthx.sav'.
*pushbreak.





