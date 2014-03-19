**********//covenas/decisionsupport/Children\GuidanceSvcs&ProductivityByClinician_.sps.
**********Guidance Clinic Svcs & Productivity by clinician.
**********Code for quarterly report removed. Refer to Jan13 report for quarterly code. 
 
*Change service FILES as needed.
*Change yrmoda dates.
*Find and Replace MonthYr in file names (example - replace Apr12 with May12).
*Review at two "Stop" markers in the code. 

 * Get File='//covenas/decisionsupport/services13_qtr3.sav'/Keep Ru svcdate proced staff hours minute grpsize.

get file='//covenas/decisionsupport/dbsvc.sav'/ keep Agency svcdate case proced. 
Select if agency="Guidance Clinic".
select if not any (proced, 197, 200, 300, 400).
insert file='//covenas/decisionsupport/meinzer/modules/calsvcdate.sps'.

sort cases by case calendar.
match files /file=* /by case calendar /first= AgenCalCase1.
select if AgenCalCase1=1.

AGGREGATE outfile = '//covenas/decisionsupport/Temp\GuidanceCalClients.sav'
   /Break calendar
   /MonthClients = sum(AgenCalCase1).

get file='//covenas/decisionsupport/meinzer/temp/allsvcwork.sav' /Keep Ru svcdate proced staff hours minute grpsize agency svcMode.

Select if agency="Guidance Clinic".
Select if xdate.tday(svcdate) ge yrmoda(2012,07,01).
select if not any (proced, 197, 200, 300, 400).


 * Sort cases by ru.
 * Match files /table='//covenas/decisionsupport/RUTable.sav' /file=*/by Ru/Keep Ru svcdate proced staff hours minute grpsize agency svcMode.


insert file='//covenas/decisionsupport/modules/uncookedmonth.sps'.
insert file='//covenas/decisionsupport/meinzer/modules/calsvcdate.sps'.
insert file='//covenas/decisionsupport/meinzer/modules/calfiscalyear.sps'.
select if calendar lt uncookedmonth.

*DURATION CODE FOR STAFF PRODUCTIVITY--STAFF.
*Don't use "Include //covenas/decisionsupport/modules\Duration".

recode minute(sysmis=0).
recode hours(sysmis=0).
compute hours2=0.
compute hours2=(minute)/60.
recode grpsize(sysmis=1).
recode grpsize(0=1).
compute duration=(hours+hours2)/grpsize.

If svcMode="10" day=1.
If day=1 duration=0.

SAVE OUTFILE='//covenas/decisionsupport/Temp\GuidanceStaffWORK.sav'
	/Keep Ru svcdate proced staff duration svcmode calendar.

*GET FILE='//covenas/decisionsupport/Temp\GuidanceStaffWORK.sav'.


******************************Co_Staff.

get file='//covenas/decisionsupport/meinzer/temp/allsvcwork.sav' 	/keep ru svcdate proced co_staff cs_hours cs_mnts grpsize agency svcMode.

Select if agency="Guidance Clinic".
Select if xdate.tday(svcdate) ge yrmoda(2012,07,01).
select if not any (proced, 197, 200, 300, 400).

 * Sort cases by ru.
 * Match files /table='//covenas/decisionsupport/RUTable.sav' /file=*/by ru.

insert file='//covenas/decisionsupport/modules/uncookedmonth.sps'.
insert file='//covenas/decisionsupport/meinzer/modules/calsvcdate.sps'.
insert file='//covenas/decisionsupport/meinzer/modules/calfiscalyear.sps'.
select if calendar lt uncookedmonth.


*DURATION CODE TO USE FOR PRODUCTIVITY--CO_STAFF.

rename variables co_staff=staff.
rename variables cs_mnts=minute.
rename variables cs_hours=hours.
recode staff(sysmis=0).
select if staff ne 0.

recode minute(sysmis=0).
recode hours(sysmis=0).
recode grpsize(0=1).
compute duration=(hours+(minute/60))/grpsize.
if svcMode="10" day=1.
if day=1 duration=0.

SAVE OUTFILE='//covenas/decisionsupport/Temp\Guidance_Co_StaffWORK.sav'
	/Keep Ru svcdate proced staff duration svcmode calendar.

*GET FILE='//covenas/decisionsupport/Temp\Guidance_Co_StaffWORK.sav'.


******************************Indirect.

Get Files='//covenas/decisionsupport/temp/IndirectDBsvc.sav'/Keep Ru proced staff svcdate hours minute.

Select if xdate.tday(svcdate) ge yrmoda(2012,07,01).
Select if proced ne 300.

Sort cases by ru.
Match files /table='//covenas/decisionsupport/RUTable.sav' /file=*/by ru /Keep Ru svcdate proced staff hours minute svcMode agency.

Select if agency="Guidance Clinic".
insert file='//covenas/decisionsupport/modules/uncookedmonth.sps'.
insert file='//covenas/decisionsupport/meinzer/modules/calsvcdate.sps'.
insert file='//covenas/decisionsupport/meinzer/modules/calfiscalyear.sps'.
select if calendar lt uncookedmonth.

*DURATION CODE TO USE FOR PRODUCTIVITY--INDIRECT.
recode minute(sysmis=0).
recode hours(sysmis=0).
compute hours2=0.
compute hours2=(minute)/60.
compute duration=hours+hours2.

sort cases by proced.
Match Files /Table='//covenas/decisionsupport/procedSMA.sav'/File=*/by proced.

Select if substr(FSPSvcCatShort,1,1) = "4".

Rename vars Duration=MAA.

SAVE OUTFILE='//covenas/decisionsupport/Temp\Guidance_IndirectWORK.sav'
	/Keep Ru svcdate proced staff MAA svcmode fspSvcCatShort proclong calendar.

*GET FILE='//covenas/decisionsupport/Temp\Guidance_IndirectWORK.sav'.



Add files
	/file='//covenas/decisionsupport/Temp\GuidanceStaffWORK.sav'
	/file='//covenas/decisionsupport/Temp\Guidance_Co_StaffWORK.sav'
	/file='//covenas/decisionsupport/Temp\Guidance_IndirectWORK.sav'.

insert file='//covenas/decisionsupport/meinzer/modules/calsvcdate.sps'.

Sort cases by staff.
Match Files /Table='//covenas/decisionsupport/staff_id3.sav'/File=*/by staff
	/Keep Ru svcdate proced staff id duration MAA svcmode fspSvcCatShort proclong name daytxstaff doc calendar.
Recode staff(sysmis=0).


*Taking out DOCs & DayTxStaff BUT KEEP Audrey Banks 3667 Gabriel Almanza 8323 Fatimah Hadley 10898 (old 4535) Allen Sanders 1288 as requested.
*Take out Madeleine Nelson 5034, Dorothy Griffin 3043, Parker Chin 5073, and Vinita Lee 3820 if still TAP.

*Take out Alcorn 11302, Alkoury 11861, Friedman 12594, Garibay 12966, Johri 6888, K McCarthy 12596 and M. Torres 8746 for June 2011 report.
*Take out Montalvo 1111 for Jul 2011 report
*Take out M. Kothenbeutel 12595 and Robyn Riley 3943 (Alcorn's old position) for Dec 2011 report.
*Take out MARTH MARY, ALMANZA GABRIEL, CORNIST DHATI RODNEY for January 2013 report.

Recode Doc DayTxStaff(sysmis=0).

Compute Keep=1.
If Doc=1 Keep=0.
If DayTxStaff=1 Keep=0.

Do if staff=3667 or staff=8323 or staff=10898 or staff=4535 or staff=1288.
Compute Keep=1.
End if.

Do if staff = 5034 or staff = 3043 or staff = 5073 or staff = 3820.
Compute Keep=0.
End if.

Do if staff=11302 or staff=11861 or staff=12594 or staff=12966 or staff=6888 or staff=12596 or staff=8746 or staff=1111 or staff=12595 or staff=3943.
Compute Keep=0.
End if.

select if Keep=1.

Sort cases by proced.
Match Files /Table='//covenas/decisionsupport/ProcedSMA.sav'/File=*/by proced
 	/Keep name ru svcdate proced staff id duration MAA svcmode svc_cat proclong FSPsvcCatShort calendar.

String GCSvcGroup(A35).
If svc_cat="grp therapy" GCSvcGroup="Group".
If svc_cat="crisis intervention" GCSvcGroup="Crisis".
If svc_cat="assessment" or svc_cat="evaluation" or svc_cat="planning" GCSvcGroup="Assess_Eval_PlanDevel".
 * If svc_cat="ind therapy" or svc_cat="collateral" or svc_cat="family therapy" GCSvcGroup="Ind_Collat_Fam".
if svc_cat="ind therapy" GCSvcGroup= "Ind_Therapy".
if svc_cat="collateral" GCSvcGroup= "Collateral".
if svc_cat="family therapy" GCSvcGroup= "Family Therapy".
If svc_cat="brokerage" GCSvcGroup="Brokerage".
If svc_cat="court eval" GCSvcGroup="Court-Ordered Eval".
If FSPsvcCatShort="4. MAA Services" GCSvcGroup="MAA".

Compute drop=0.
If substr(Proclong,1,3)="Day" drop=1.
If svc_cat="meds" drop=1.

*Temp.
*select if GCsvcGroup = " ".
*freq proclong.

If GCsvcGroup = " " drop=1.
temp.
select if drop=1.
freq svc_cat proclong.

Select if drop=0.

Sort cases by staff GCSvcGroup calendar.
SAVE OUTFILE='//covenas/decisionsupport/Temp\Guidance_WORK.sav'.

*********************************.

 * Get File='//covenas/decisionsupport/Temp\Guidance_WORK.sav'.
 * Aggregate Outfile='//covenas/decisionsupport/Temp\Guidance_SvcDateCheck.sav'
	/Break=name staff calendar
	/MinSvcDate=min(SvcDate)
	/MaxSvcDate=max(SvcDate).

 * Get file='//covenas/decisionsupport/Temp\Guidance_SvcDateCheck.sav'.

**********************************Stop***Check for missing svcdates.

 * Get File='//covenas/decisionsupport/Temp\Guidance_WORK.sav'.

Sort cases by staff GCSvcGroup calendar.
Aggregate Outfile='//covenas/decisionsupport/Temp\Guidance_DirectSvcAndMAA.sav'
	/Break=staff calendar
	/DirectSvcHrs=sum(Duration)
	/MAAHours=sum(MAA).

sort cases by staff gcsvcgroup.
Aggregate Outfile='//covenas/decisionsupport/Temp\Guidance_SvcGrp_Staff.sav'
	/Break=Staff GCSvcGroup calendar
	/SvcTotal=sum(duration).

Compute Staff=1.
Aggregate Outfile='//covenas/decisionsupport/Temp\Guidance_SvcGrp_AllTots.sav'
	/Break=Staff GCSvcGroup calendar
	/SvcTotal=sum(duration).

Get File='//covenas/decisionsupport/Temp\Guidance_DirectSvcAndMAA.sav'.
Recode DirectSvcHrs MAAHours(sysmis=0).
Compute staff=1.
sort cases by staff calendar.
Aggregate Outfile='//covenas/decisionsupport/Temp\Guidance_DirectSvcAndMAATots.sav'
	/Break=staff calendar
	/DirectSvcHrs=sum(DirectSvcHrs)
	/MAAHours=sum(MAAHours).

**REALLY DO NEED TO GET WORKFILE HERE.
*To Calculate Total of each GCSvcGroup service.

Get File='//covenas/decisionsupport/Temp\Guidance_WORK.sav'.
Compute staff=1.
sort cases by Staff GCSvcGroup.

Aggregate Outfile='//covenas/decisionsupport/Temp\Guidance_SvcGrp_All.sav'
	/Break=Staff GCSvcGroup calendar
	/SvcTotal=sum(duration).

*Get File='//covenas/decisionsupport/Temp\Guidance_DirectSvcAndMAA.sav'.
*Get File='//covenas/decisionsupport/Temp\Guidance_SvcGrp_Staff.sav'.
*Get File='//covenas/decisionsupport/Temp\Guidance_SvcGrp_AllTots.sav'.
*Get File='//covenas/decisionsupport/Temp\Guidance_DirectSvcAndMAATots.sav'.
*Get File='//covenas/decisionsupport/Temp\Guidance_SvcGrp_All.sav'.


******************************Active Staff.

 * Get File='//covenas/decisionsupport/Temp\Guidance_WORK.sav'.
 * Sort cases by staff calendar.
 * Match Files /file=*/by staff calendar /first=staffCal1.
 * select if staffCal1=1.
 * rename vars staffCal1= ActiveCalStaff name=StaffName.
 * SAVE OUTFILE='//covenas/decisionsupport/Temp\Guidance_ActiveStaff.sav'/keep staff StaffName ActiveCalStaff calendar.
 * Get FILE='//covenas/decisionsupport/Temp\Guidance_ActiveStaff.sav'.


*Create Shell - start.
Get File='//covenas/decisionsupport/Temp\Guidance_WORK.sav'.
Aggregate Outfile=*
	/Break=Staff Name Calendar 
	/MaxSvcDate=max(SvcDate).

insert file='//covenas/decisionsupport/modules/uncookedmonth.sps'.
select if calendar lt uncookedmonth.

vector GCSvcGroup(9 a35).
compute GCSvcGroup1 = "Group".
compute GCSvcGroup2 ="Crisis".
compute GCSvcGroup3="Assess_Eval_PlanDevel".
compute GCSvcGroup4="Ind_Therapy".
compute GCSvcGroup5="Collateral".
compute GCSvcGroup6="Family Therapy".
compute GCSvcGroup7="Brokerage".
compute GCSvcGroup8="Court-Ordered Eval".
compute GCSvcGroup9="MAA".

VARSTOCASES
/make GCSvcGroup from GCSvcGroup1 to GCSvcGroup9
/keep Staff Name Calendar .

Save outfile ='//covenas/decisionsupport/Temp/GuidanceServiceShell_Staff.sav'.

get file ='//covenas/decisionsupport/Temp/GuidanceServiceShell_Staff.sav'.
Compute Staff=1.
Compute Name = 'All'.
Aggregate outfile = '//covenas/decisionsupport/Temp/GuidanceServiceShell_All.sav'
   /Break Calendar GCSvcGroup
   /Staff = max(staff).

Add files 
   /file= '//covenas/decisionsupport/Temp/GuidanceServiceShell_Staff.sav'
   /file = '//covenas/decisionsupport/Temp/GuidanceServiceShell_All.sav'.

sort cases by staff calendar GCSvcGroup.

save outfile ='//covenas/decisionsupport/Temp/GuidanceServiceShell.sav'.

*Create Shell - end.

*Get file='//covenas/decisionsupport/Temp/GuidanceServiceShell.sav'.
 * Sort cases by staff.
 * Match files /file=* /by staff /first=InTable.
 * Freq InTable.
 * select if InTable=1.
 * SAVE OUTFILE='//covenas/decisionsupport/Temp\Guidance_TableCheck.sav'/keep staff InTable.
 * Get File='//covenas/decisionsupport/Temp\Guidance_TableCheck.sav'.

 * Get file='//covenas/decisionsupport/Temp\Guidance_ActiveStaff.sav'.
 * Match files /table='//covenas/decisionsupport/Temp\Guidance_TableCheck.sav'/file=* /by staff.
 * Recode InTable(sysmis=0).
 * Select if InTable=0.
**STOP. If "InTable" is null these are active staff that are NOT in the GuidanceServiceShell - Add missing active GC staff to Shell. Run 253-256. 
*ADD STAFF TO "//covenas/decisionsupport/Temp\GuidanceMMM-yy_ActiveStaff.sav" Shell - and SAVE.

* BROWN           DAVID; KONOVER         KIMBERLE; NELSON          SANII; BERRIN          SEBASTIAN added to shell for June. 



Get file='//covenas/decisionsupport/Temp/GuidanceServiceShell.sav'.
Sort cases by staff GCSvcGroup calendar.
Match Files /Table='//covenas/decisionsupport/Temp\Guidance_SvcGrp_Staff.sav'/File=*/by staff GCSvcGroup calendar.
Match Files /Table='//covenas/decisionsupport/Temp\Guidance_SvcGrp_All.sav'/File=*/by staff GCSvcGroup calendar.
Match Files /Table='//covenas/decisionsupport/Temp\Guidance_SvcGrp_AllTots.sav'/File=*/by staff GCSvcGroup calendar.



sort cases by staff calendar.
Match Files /Table='//covenas/decisionsupport/Temp\Guidance_DirectSvcAndMAA.sav'/File=*/by staff calendar.
Match Files /Table='//covenas/decisionsupport/Temp\Guidance_DirectSvcAndMAATots.sav'/File=*/by staff  calendar.

If GCSvcGroup="MAA" SvcTotal=MAAHours.
RENAME VARIABLES Name = StaffName.

SAVE OUTFILE='//covenas/decisionsupport/Temp\Guidance_NoStaffTots.sav'.

Compute GCSvcGroup="Total Hours".
Recode DirectSvcHrs MAAHours(sysmis=0).
Compute SvcTotal=DirectSvcHrs+MAAHours.

Aggregate Outfile='//covenas/decisionsupport/Temp\Guidance_StaffTots.sav'
	/Break=staff GCSvcGroup StaffName calendar
	/SvcTotal=max(SvcTotal).


ADD FILES
	/FILE='//covenas/decisionsupport/Temp\Guidance_NoStaffTots.sav'
	/FILE='//covenas/decisionsupport/Temp\Guidance_StaffTots.sav'.

Sort cases by staff calendar GCSvcGroup.

SAVE OUTFILE='//covenas/decisionsupport/Temp\Guidance_SvcbyClinicianWORK.sav'
	/Keep Staff StaffName GCSvcGroup SvcTotal calendar.

*Get File='//covenas/decisionsupport/Temp\Guidance_SvcbyClinicianWORK.sav'.
*Get File='//covenas/decisionsupport/Temp\Guidance_NoStaffTots.sav'.
*Get File='//covenas/decisionsupport/Temp\Guidance_StaffTots.sav'.

*Get File='//covenas/decisionsupport/Temp\Guidance_SvcbyClinicianWORK.sav'.

insert file='//covenas/decisionsupport/meinzer/production/ps/guidance_product.sps'.

sort cases by id calendar. 

if ID = '204495' WorkedHours = WorkedHours/2. 
exe.

Save outfile = '//covenas/decisionsupport/temp/Worked_AllMonths.sav'. 
 * get file = '//covenas/decisionsupport/temp/Worked_AllMonths.sav'. 

ADD FILES
	/FILE='//covenas/decisionsupport/Temp\Guidance_DirectSvcAndMAA.sav'
	/FILE='//covenas/decisionsupport/Temp\Guidance_DirectSvcAndMAATots.sav'.
Sort cases by staff.
Match Files /Table='//covenas/decisionsupport/staff_id3.sav'/File=*/by staff /Keep staff Name DirectSvcHrs MAAHours id calendar.

Recode DirectSvcHrs MAAHours(sysmis=0).
Sort cases by id calendar.
Match Files /Table= '//covenas/decisionsupport/temp/Worked_AllMonths.sav'/file=*/by id calendar.
*Match Files/Table='//covenas/spssdata/productivity\Worked_.sav'/file=*/by id.


Sort cases by staff calendar.
SAVE OUTFILE='//covenas/decisionsupport/Temp\Guidance_ProductivityWORK.sav'.

*get file='//covenas/decisionsupport/Temp\Guidance_ProductivityWORK.sav'.
 
*****Stop, LOOK to make sure that all staff have worked hours.
*****If not, update tables (see examples at bottom of code) or find out if they were interns or TAP. 


Get File='//covenas/decisionsupport/Temp\Guidance_ProductivityWORK.sav'.
*If Intern=1 WorkedHours=0.
Compute staff=1.
sort cases by staff calendar. 
Aggregate Outfile='//covenas/decisionsupport/Temp\Guidance_WorkedHoursTot.sav'
	/Break=staff calendar
	/WorkedHours=sum(WorkedHours).

*Get File='//covenas/decisionsupport/Temp\Guidance_WorkedHoursTot.sav'.


Get File='//covenas/decisionsupport/Temp\Guidance_ProductivityWORK.sav'.
Match Files /Table='//covenas/decisionsupport/Temp\Guidance_WorkedHoursTot.sav'/File=*/by staff calendar.

If Staff=1 Name="ALL".

Compute MAAandDirectSvcHrs=(MAAHours + DirectSvcHrs).
Recode MAAandDirectSvcHrs(sysmis=0).
Compute MAAandDirectSvcHrsPCT = ((MAAHours + DirectSvcHrs)/WorkedHours)*100.
Compute DirectSvcPCT = (DirectSvcHrs/WorkedHours)*100.

Formats WorkedHours(f8.0) DirectSvcHrs(f8.0) MAAHours(f8.0) MAAandDirectSvcHrs(f8.0) DirectSvcPCT(PCT3.0) MAAandDirectSvcHrsPCT(PCT3.0).

sort cases by staff calendar. 
SAVE OUTFILE='//covenas/decisionsupport/temp\Guidance_Productivity.sav'
     /Keep staff Name WorkedHours DirectSvcHrs DirectSvcPCT MAAHours MAAandDirectSvcHrs MAAandDirectSvcHrsPCT id calendar.

*************.

Get File='//covenas/decisionsupport/Temp\Guidance_SvcbyClinicianWORK.sav'.
Match Files /Table='//covenas/decisionsupport/temp\Guidance_Productivity.sav'/File=*/by staff calendar
	/Keep Staff StaffName GCSvcGroup SvcTotal WorkedHours DirectSvcHrs DirectSvcPCT MAAHours MAAandDirectSvcHrs MAAandDirectSvcHrsPCT calendar.


Compute PCT_of_Total=(SvcTotal/MAAandDirectSvcHrs)*100.
Formats PCT_of_Total(PCT3.0).

SAVE OUTFILE='//covenas/decisionsupport/Temp\Guidance_PCTofTot.sav'.

Compute GCSvcGroup="Worked".
Aggregate Outfile='//covenas/decisionsupport/Temp\Guidance_WorkedAGG.sav'
	/Break=Staff StaffName GCSvcGroup calendar
	/SvcTotal=max(WorkedHours).

Compute GCSvcGroup="zDirectSvcHours".
Aggregate Outfile='//covenas/decisionsupport/Temp\Guidance_DirectSvcAGG.sav'
	/Break=Staff StaffName GCSvcGroup calendar
	/SvcTotal=max(DirectSvcHrs).

Compute GCSvcGroup="zMAAHours".
Aggregate Outfile='//covenas/decisionsupport/Temp\Guidance_MAAAGG.sav'
	/Break=Staff StaffName GCSvcGroup calendar
	/SvcTotal=max(MAAHours).

Compute GCSvcGroup="zzPCTDirectSvcAndMAA".
Aggregate Outfile='//covenas/decisionsupport/Temp\Guidance_PCTAGG.sav'
	/Break=Staff StaffName GCSvcGroup calendar
	/Pct_of_Total=max(MAAandDirectSvcHrsPCT).

*Get File='//covenas/decisionsupport/Temp\Guidance_WorkedAGG.sav'.
*Get File='//covenas/decisionsupport/Temp\Guidance_DirectSvcAGG.sav'.
*Get File='//covenas/decisionsupport/Temp\Guidance_MAAAGG.sav'.
*Get File='//covenas/decisionsupport/Temp\Guidance_PCTAGG.sav'.


ADD FILES
	/FILE='//covenas/decisionsupport/Temp\Guidance_PCTofTot.sav'
	/FILE='//covenas/decisionsupport/Temp\Guidance_WorkedAGG.sav'
	/FILE='//covenas/decisionsupport/Temp\Guidance_DirectSvcAGG.sav'
	/FILE='//covenas/decisionsupport/Temp\Guidance_MAAAGG.sav'
	/FILE='//covenas/decisionsupport/Temp\Guidance_PCTAGG.sav'.

Sort cases by Staff StaffName GCSvcGroup.
If GCSvcGroup="zDirectSvcHours" GCSvcGroup="DirectSvc".
If GCSvcGroup="zMAAHours" GCSvcGroup="MAA".
If GCSvcGroup="zzPCTDirectSvcAndMAA" GCSvcGroup="PCTDirectSvcAndMAA".
Rename vars StaffName=Name SvcTotal=Hours.

if staff=1 and WorkedHours ge 1 Keep=1.
If Staff=1 Name="ALL".

AGGREGATE outfile = * mode = ADDVARIABLES
   /Break Calendar
   /KeepMonth = max(Keep).

select if KeepMonth=1.

AGGREGATE outfile = * mode = ADDVARIABLES
   /Break KeepMonth
   /MostRecentMonth = max(Calendar). 

if MostRecentMonth=calendar CurrentReportingMonth=1.


If GCSvcGroup= 'Worked' Worked= Hours.

AGGREGATE outfile = * mode = ADDVARIABLES
   /Break calendar staff
   /PayrollHours = max(Worked). 

recode Hours PCT_OF_Total(sysmis=0).

select if not any(GCSvcGroup, 'PCTDirectSvcAndMAA', 'DirectSvc', 'Worked').

Compute DirectSvc=1.
if any(GCSvcGroup, 'Total Hours', 'MAA', 'Worked') DirectSvc=0.

sort cases by calendar.
match files /table= '//covenas/decisionsupport/Temp\GuidanceCalClients.sav' /file=* /by calendar.

Save Outfile='//covenas/decisionsupport/Temp\GuidanceSvcAndProductivityByClinician_.sav'
	/Keep Staff Name GCSvcGroup Hours PCT_of_Total calendar DirectSvc PayrollHours CurrentReportingMonth MonthClients.


**New - GO Start.

get file ='//covenas/decisionsupport/Temp\GuidanceSvcAndProductivityByClinician_.sav'.
sort cases by staff. 
AGGREGATE outfile = '//covenas/decisionsupport/Temp\GC_ProductivityStaff.sav'
   /Break=Staff
   /name= max(name).

get file='//covenas/decisionsupport/dbsvc.sav'/ keep Agency svcdate case proced staff duration. 
Select if agency="Guidance Clinic".
select if not any (proced, 197, 200, 300, 400).
insert file='//covenas/decisionsupport/meinzer/modules/calsvcdate.sps'.

Sort cases by proced.
Match Files /Table='//covenas/decisionsupport/ProcedSMA.sav'/File=*/by proced
 	/Keep Agency svcdate case staff proced svc_cat duration calendar proclong.

String GCSvcGroup(A35).
If svc_cat="grp therapy" GCSvcGroup="Group".
If svc_cat="crisis intervention" GCSvcGroup="Crisis".
If svc_cat="assessment" or svc_cat="evaluation" or svc_cat="planning" GCSvcGroup="Assess_Eval_PlanDevel".
 * If svc_cat="ind therapy" or svc_cat="collateral" or svc_cat="family therapy" GCSvcGroup="Ind_Collat_Fam".
if svc_cat="ind therapy" GCSvcGroup= "Ind_Therapy".
if svc_cat="collateral" GCSvcGroup= "Collateral".
if svc_cat="family therapy" GCSvcGroup= "Family Therapy".
If svc_cat="brokerage" GCSvcGroup="Brokerage".
If svc_cat="court eval" GCSvcGroup="Court-Ordered Eval".

sort cases by staff. 
match files /table= '//covenas/decisionsupport/Temp\GC_ProductivityStaff.sav' /file=* /by staff.
select if name ne " ".

compute drop=0.
If GCsvcGroup = " " drop=1.
temp.
select if drop=1.
freq svc_cat proclong.

Select if drop=0.

insert file='//covenas/decisionsupport/modules/uncookedmonth.sps'.
select if calendar lt uncookedmonth.

aggregate outfile = '//covenas/decisionsupport/Temp\GuidanceProductivity_ClientsByServiceType.sav'
   /Break=Staff Name Case Calendar GCSvcGroup
   /ServiceHours=sum(Duration).

 Get File='//covenas/decisionsupport/Temp\GuidanceProductivity_ClientsByServiceType.sav'.

*pushbreak.
*sqlTable = 'GuidanceProductivity_ClientsByServiceType'.
*spsstable='//covenas/decisionsupport/Temp\GuidanceProductivity_ClientsByServiceType.sav'.
*pushbreak.

**New - GO End - 12-27-13.

Get File='//covenas/decisionsupport/Temp\GuidanceSvcAndProductivityByClinician_.sav'.

*pushbreak.
*sqlTable = 'Guidance_Productivity'.
*spsstable='//covenas/decisionsupport/Temp\GuidanceSvcAndProductivityByClinician_.sav'.
*pushbreak.

