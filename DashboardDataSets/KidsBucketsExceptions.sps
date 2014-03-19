
get file='//covenas/spssdata/dbsvc.sav'.
select if svcdate ge date.dmy(01,07,2011).

insert file = '//covenas/decisionsupport/modules/NoShow.sps'.
* insert file = '//covenas/decisionsupport/modules/duration.sps'.
insert file = '//covenas/decisionsupport/meinzer/modules/calsvcdate.sps'.
insert file = '//covenas/decisionsupport/meinzer/modules/calfiscalyear.sps'.
insert file='//covenas/decisionsupport/modules/uncookedmonth.sps'.
select if svcdate lt UncookedMonth.

sort cases by ru.
match files /table='//covenas/decisionsupport/ruTable.sav'/file=* /by ru.
select if kidsru=1.
 * select if end_dt=0.
insert file = '//covenas/decisionsupport/modules/RuDateFix.sps'.

sort cases by proced.
match files /table= '//covenas/decisionsupport/procedsma.sav'/file=* /by proced /Keep Agency ru provname svcType svcType3 psmask2 EPSDTGroup StartRU EndRU school 
ab3632ru CESDC residential daytx case opdate closdate svcdate proced proclong mcsvccat svc_cat County svcMode level3classic duration duration2 grpsize cost calendar fiscalyear lastservice.

if any(svcMode,"05","10") AND MCSvcCat ne "F. Crisis Stabilization" Day=1.
if day=1 Duration=$sysmis.
if day=1 Duration2=$sysmis.

Do if closdate ge date.dmy(01,07,2011).
Compute LOS = xdate.tday(lastservice) -  xdate.tday(opdate).
Compute AllDischarge=1.
End if. 

save outfile = '//covenas/decisionsupport/Orozco/Temp/KidsExceptionWork.sav'.
get file = '//covenas/decisionsupport/Orozco/Temp/KidsExceptionWork.sav'.
 * select if ru = '812114'.

*Program Type. 

Aggregate outfile=*
   /Break = Agency ru provname svcType svcType3 psmask2 school county ab3632RU CESDC Residential daytx EPSDTGroup SvcMode level3classic 
   /TotalHours = sum(Duration)
   /TotalDays=sum(Day).

compute drop=0.
if level3classic=1 Drop=1.
if psmask2 = 900 Drop=1.
if Agency = 'Milhous' Drop=1.
select if Drop=0.

If any(ru, '01FQ1', '01IG1', '01H71', '01IS1', '01IR1', '01JH1', '01EB1', '01059', '010510', '81422') CESDC=0.
If any(ru, '01FQ1', '01IG1', '01H71', '01IS1', '01IR1', '01JH1', '01EB1', '01059', '010510', '81422') ab3632ru=0.
*From Liz and Linda.
 * 01FQ1	CHILDREN'S LEARNING ES MHS CHD
01IG1	CSS JOHN MUIR MID SCH MHS CHLD
01H71	CSS BRENKWITZ HIGH SCH MHS CHD
01IS1	CSS ITS COMM UNITED SCH MHS CH
01IR1	CSS CASTRO VALLEY USD MHS CHLD
01JH1	CSS ARROYO HIGH SCH MHS CHILD
01EB1	CHILDREN HC ESTHER CLK SCH MHS
01059	LA FAMILIA JOHN MUIR SC MHS CH
010510	LAFAMILIA ROOSEVELT SCH MHS CH
01AR5	FFYC BHART MNTRAESY MHS CHILD.
 * 81422	SENECA BUILDING BLKS DAYINT FL	Not ERMHS only K-1 is ERMHS.

recode school county ab3632ru CESDC residential daytx (sysmis=0).

If any(provname, 'SENECA REDWOOD HS MHS CHILD', 'SENECA LORIN EDEN MHS CHILD', 'SENECA BRENKWITZ HS MHS CHILD', 'SENECA SOUTHGATE ESY MHS CHILD', 'SENECA TENNYSON HS MHS CHILD') school=1.

String ProgramModel(a60).
If svcType= "Crisis" or psmask2=34 ProgramModel= 'Crisis Program'.
Freq ProgramModel.
If psmask2=5 ProgramModel= "Hospital".
Freq ProgramModel.
If ((DayTx=1 or psmask2=65537) AND svcMode = "10") and TotalDays ge 1 ProgramModel = "DayTx".
Freq ProgramModel.
If (DayTx=1 AND svcMode="15") and TotalHours ge 1 ProgramModel = "DayTx - MHS".
Freq ProgramModel.
If school=1 and ab3632ru=0 and CESDC=0 and DayTx=0 ProgramModel= "School - SBBH".
Freq ProgramModel.
If ((school=1 and ab3632ru=1) or CESDC=1) and DayTx=0 ProgramModel=  "School ERMHS - Counseling Enriched".


Freq ProgramModel.
If psmask2= 262145 ProgramModel= "Level1 - Child Community Support Services".
Freq ProgramModel.
If (ProgramModel=" " and SvcType="TBS") or index(provname, 'TBS') GE 1 ProgramModel= "TBS".
If ProgramModel=" " and EPSDTGroup= 'Foster' ProgramModel= 'ChildWelfare'.
If ProgramModel=" " and (EPSDTGroup= 'JuvJustice' or svctype = 'JuvJustice') ProgramModel= 'JuvenileJustice'.
If ProgramModel=" " and EPSDTGroup= '0-5' ProgramModel= 'EarlyChildhood'.
If ProgramModel=" " and (index(svcType, 'Level 3') or EPSDTGroup= 'Level 3 Org') ProgramModel= 'Other - Level 3'.
if any(ru,"81813","81814" ) ProgramModel= 'JuvenileJustice'.
if ru = "81781" ProgramModel= 'ChildWelfare'.
If ProgramModel=" " ProgramModel= 'Other' .

if provname = 'EARLY CHILD CONSLT & TRMNT MHS' ProgramModel =  'EarlyChildhood'.
if cesdc=1 ProgramModel =  "School ERMHS - Counseling Enriched".
if ANY (RU, '01AR4', '018437', '018436', '81403', '81393', '01G92','811845','811846','01HA2','811847','01G82','01HB2','01GO2') ProgramModel =  "School ERMHS - Counseling Enriched - Intensive".
 * Freq ProgramModel.

*From Liz and Linda. 
 * 01AR4	FFYC BHART MNTRAESY R FLDY CHL	All will need new "Unbundled" RU
018436	FFYC MONTERA SCH MHS DT CHILD	Pending Unbundled RU=Intensive CESDC
81403	FFYC SKYLINE H SCH MHS CHILD	Pending Unbundled RU=Intensive CESDC
81393	FFYC WESTLAKE SCHOOL MHS CHILD	Pending Unbundled RU=Intensive CESDC
01G92	SENECA BRENKWITZ HS MHS CHILD	pending Unbundled RU=Intensive CESDC
811845	SENECA H GREEN SCH MHS CHILD	pending Unbundled RU=Intensive CESDC
811846	SENECA LONGWOOD SCH MHS CHILD	pending Unbundled RU=Intensive CESDC
01HA2	SENECA LORIN EDEN MHS CHILD	pending Unbundled RU=Intensive CESDC
811847	SENECA MT EDEN SCH MHS CHILD	pending Unbundled RU=Intensive CESDC
01G82	SENECA REDWOOD HS MHS CHILD	pending Unbundled RU=Intensive CESDC
01HB2	SENECA TENNYSON HS MHS CHILD	pending Unbundled RU=Intensive CESDC
01GO2	SENECA WINTON SCH MHS TAY	pending Unbundled RU=Intensive CESDC.


sort cases by ru. 
Save outfile = '//covenas/decisionsupport/Orozco/Temp/ProgramModels.sav' /keep ru ProgramModel. 
 * get file = '//covenas/decisionsupport/Orozco/Temp/ProgramModels.sav'.

Get file = '//covenas/decisionsupport/Orozco/Temp/KidsExceptionWork.sav'.
sort cases by ru.
match files /table= '//covenas/decisionsupport/Orozco/Temp/ProgramModels.sav' /file=* /by ru /keep 
ProgramModel Agency ru provname case opdate closdate LOS AllDischarge svcdate proced proclong mcsvccat svc_cat duration duration2 grpsize cost calendar fiscalyear.

 * sort cases by proced.
 * split file by proced.
 * freq proclong. 

if any(proced, 321, 322, 323, 324, 331, 332, 334, 337, 415, 417, 431, 433, 535, 565) EvalSvc=1. 
recode EvalSvc(sysmis=0). 
 * 321	Evaluation
322	Evaluation-AB3632
323	90791 Psychiatric Diag Eval
324	96151 Behavioral Eval
331	Assessment
332	Assessment-AB3632
334	Assessment FFS
337	Assessment FFS AB3632
415	96101 PSYCH TESTING
417	96118 NEUROPSYCH TESTING
431	Court Ordered Diagnostic Eval
433	90801 Initial Psych Evaluation
535	96111 EXT DEV TEST  INTERP RPT
565	90792 Psychiatric DiagEval E/M.


aggregate outfile = * mode addvariables
   /break = ru case opdate 
   /EvalOnlyEp=Min(EvalSvc).

Compute EligibleDischarge=AllDischarge. 
if EvalOnlyEp=1 EligibleDischarge=0. 
if EvalOnlyEp=1 LOS=$sysmis. 

 * sort cases by ru case opdate.
 * match files /file=* /by ru case opdate /first=ep1.
 * select if ep1=1. 
 * select if AllDischarge=1. 
 * select if EvalOnlyEp=1. 

 * TEMPORARY.
 * select if programmodel='EarlyChildhood'.
 * freq LOS. 

If LOS ge 180 and LOS le 730 LOSBtw6and24Mos=1.
If LOS ge 90 and LOS le 180 LOSBtw3and6Mos=1.

if index(proclong,"FAM") ge 1  and proclong ne "COMMUNITY/FAMILY CONSULTATION" FamilyHrs= duration. 
if proced = 317 FamilyHrs= duration. 

if index(proclong,"FAM") ge 1  and proclong ne "COMMUNITY/FAMILY CONSULTATION" FamilyHrsRcvd= duration2. 
if proced = 317 FamilyHrsRcvd= duration2. 

if any(proced, 311, 312, 314) CollateralHrs=duration. 

 * 311	Collateral
312	Collateral-AB3632
314	Collateral FFS.


 * if svc_cat= "grp therapy" and grpsize ge 2 GroupSvc=1.
 * temp.
 * select if grpsize ge 2.
 * freq svc_cat.

Compute GroupSvc=0.
if grpsize ge 2 GroupSvc=1.
if GroupSvc=1 GroupHrs= duration2. 

compute Svc_Week = xdate.week(svcdate).
if Svc_Week lt 27 FYSvc_Week= sum(Svc_Week + 27).
if Svc_Week ge 27 FYSvc_Week= sum(Svc_Week - 26).

Aggregate outfile = * mode= ADDVARIABLES over=yes
   /break= ru case opdate fiscalyear
   /FirstFYSvcWeek= min(FYSvc_Week)
   /LastFYSvcWeek=max(FYSvc_Week).

Select if any(ProgramModel, 'EarlyChildhood', 'School - SBBH', 'School ERMHS - Counseling Enriched', 'School ERMHS - Counseling Enriched - Intensive'). 

Save outfile =  '//covenas/decisionsupport/Orozco/Temp/KidsExceptionWork2.sav'.
 * get file =  '//covenas/decisionsupport/Orozco/Temp/KidsExceptionWork2.sav'.

Sort cases by FiscalYear ru case.
Match Files /file=* /by FiscalYear ru case /first= FYRUCase1.

Aggregate outfile = '//covenas/decisionsupport/Orozco/Temp/ProgramModelRUShell.sav'
   /Break FiscalYear ProgramModel Agency RU Provname 
   /FYClients = sum(FYRUCase1).

**LENGTH OF STAY.
*0-5.
**60% of clients who exit will have a LOS between six and 24 months.
*SBMH.
**25 clients per FTE (30), LOS of 3 to 6 months (75% of clients).

get file =  '//covenas/decisionsupport/Orozco/Temp/KidsExceptionWork2.sav' /drop fiscalyear.
Select if ProgramModel= 'EarlyChildhood' or ProgramModel = 'School - SBBH'.

insert file = '//covenas/decisionsupport/meinzer/modules/ClosdateFiscalYear.sps'.

Select if AllDischarge=1. 
Aggregate Outfile = *
   /Break FiscalYear RU ProgramModel Case Closdate LOS LOSBtw6and24Mos LOSBtw3and6Mos  
   /AllDischarge= max(AllDischarge)
   /EligibleDischarge= max(EligibleDischarge).  

Compute LOSMonths= LOS/30.
Sort cases by FiscalYear RU ProgramModel. 

Aggregate outfile = *
   /Break FiscalYear RU ProgramModel 
   /AllDischarges=sum(AllDischarge)
   /EligibleDischarges=sum(EligibleDischarge)
   /LOSBtw6and24Mos=sum(LOSBtw6and24Mos)
   /LOSBtw3and6Mos=sum(LOSBtw3and6Mos)
   /AverageLOS=mean(LOSMonths)
   /MedianLOS=median(LOSMonths)
   /MaxLOS= Max(LOSMonths). 

Do if EligibleDischarges ge 1.
Recode LOSBtw6and24Mos LOSBtw3and6Mos (sysmis=0).
End If.

Compute PctLOS6to24Mos =  LOSBtw6and24Mos/EligibleDischarges.
Compute PctLOS3to6Mos = LOSBtw3and6Mos/EligibleDischarges.

String ColorPctLOS3to6Mos(a10).
String ColorPctLOS6to24Mos(a10).

If ProgramModel = 'EarlyChildhood' and PctLOS6to24Mos ge .7 ColorPctLOS6to24Mos='Green'. 
If ProgramModel = 'EarlyChildhood' and PctLOS6to24Mos lt .7 ColorPctLOS6to24Mos='Yellow'. 
If ProgramModel = 'EarlyChildhood' and PctLOS6to24Mos lt .5 ColorPctLOS6to24Mos='Red'. 

If ProgramModel = 'School - SBBH' and PctLOS3to6Mos lt .75 ColorPctLOS3to6Mos='Yellow'. 
If ProgramModel = 'School - SBBH' and PctLOS3to6Mos ge .75 ColorPctLOS3to6Mos='Green'.
If ProgramModel = 'School - SBBH' and PctLOS3to6Mos lt .5 ColorPctLOS3to6Mos='Red'. 

Sort cases by ru fiscalyear. 
exe.
Save outfile = '//covenas/decisionsupport/Orozco/Temp/ProgramModelLOS.sav' /drop ProgramModel.

*Eligible LOS detailed breakdown. 

get file =  '//covenas/decisionsupport/Orozco/Temp/KidsExceptionWork2.sav' /drop fiscalyear.
Select if ProgramModel= 'EarlyChildhood' or ProgramModel = 'School - SBBH'.
Select if EligibleDischarge=1. 
insert file = '//covenas/decisionsupport/meinzer/modules/ClosdateFiscalYear.sps'.

Compute LOSMonths= trunc(LOS/30).

Aggregate Outfile = *
   /Break FiscalYear Agency RU Provname ProgramModel Case Closdate LOS  LOSMonths
   /EligibleDischarge= max(EligibleDischarge).

Aggregate outfile = '//covenas/decisionsupport/Orozco/Temp/KidsException_LOSDetails.sav'
   /Break ProgramModel FiscalYear Agency RU Provname LOSMonths
   /EligibleDischarges=sum(EligibleDischarge).


 get file = '//covenas/decisionsupport/Orozco/Temp/KidsException_LOSDetails.sav'.

*pushbreak.
*sqlTable = 'KidsException_LOSDetails'.
*spsstable= '//covenas/decisionsupport/Orozco/Temp/KidsException_LOSDetails.sav'.
*pushbreak.


***Percent of Total Hours. 
*SBMH.
**15% of Hours are Family Services, 30% of Clients get group services.
*0-5.
**50% of services are Family Services.

get file =  '//covenas/decisionsupport/Orozco/Temp/KidsExceptionWork2.sav'.
select if ProgramModel = 'School - SBBH' or ProgramModel = 'EarlyChildhood'.
select if evalonlyep=0. 

sort cases by GroupSvc(d).
Sort cases by ru fiscalyear case.
match files /file=* /by ru fiscalyear case /first=RuFYcase1.
If RuFYcase1=1 and GroupSvc=1 GroupSvcFYRUCase1=1. 

Aggregate outfile=* 
   /Break= FiscalYear RU ProgramModel
   /Clients=sum(RuFYcase1)
   /GroupClients=sum(GroupSvcFYRUCase1)
   /FamilyHrs=sum(FamilyHrs)
   /CollateralHrs=sum(CollateralHrs)
   /FYHrs=sum(duration).

recode GroupClients FamilyHrs CollateralHrs FYHrs(sysmis=0).

Compute PctFamilyHrs = FamilyHrs/FYHrs.
Compute PctCollateralHrs = CollateralHrs/FYHrs.
Compute PctClientsGrp = GroupClients/Clients.

String ColorPctFamilyHrs(a10).
String ColorPctClientsGrp(a10).

If ProgramModel = 'EarlyChildhood' and PctFamilyHrs lt .5 ColorPctFamilyHrs='Yellow'. 
If ProgramModel = 'School - SBBH' and PctFamilyHrs lt .15 ColorPctFamilyHrs='Yellow'. 
If ProgramModel = 'School - SBBH' and PctClientsGrp lt .3 ColorPctClientsGrp='Yellow'. 

If ProgramModel = 'EarlyChildhood' and PctFamilyHrs ge .5 ColorPctFamilyHrs='Green'. 
If ProgramModel = 'School - SBBH' and PctFamilyHrs ge .15 ColorPctFamilyHrs='Green'. 
If ProgramModel = 'School - SBBH' and PctClientsGrp ge .3 ColorPctClientsGrp='Green'. 

If ProgramModel = 'EarlyChildhood' and PctFamilyHrs lt .25 ColorPctFamilyHrs='Red'. 
If ProgramModel = 'School - SBBH' and PctFamilyHrs le .05 ColorPctFamilyHrs='Red'. 
If ProgramModel = 'School - SBBH' and PctClientsGrp le .05  ColorPctClientsGrp='Red'. 


Sort cases by ru fiscalyear. 
exe.
Save outfile = '//covenas/decisionsupport/Orozco/Temp/ProgramModelFamAndGrpSvcs.sav' /drop ProgramModel Clients.

*School ERMHS - Counseling Enriched.
**1 hour per week per kid of group something (exception at less than 3 weeks in month).
**1 hour per week per kid of individual therapy (exception at less than 3 weeks in month).
**4 hours per month per kid total services (exception <75% of kids). 20 hours per kid per month total services for Intensive CESDC.
**2 hours per month of family something (exception zero only).

get file =  '//covenas/decisionsupport/Orozco/Temp/KidsExceptionWork2.sav'.
select if ProgramModel= "School ERMHS - Counseling Enriched - Intensive" or ProgramModel= "School ERMHS - Counseling Enriched". 

Sort cases by ru FiscalYear.
Match files /file=* /by ru FiscalYear /first=RuFY1.

Sort cases by ru FiscalYear FYSvc_Week.
Match files /file=* /by ru FiscalYear FYSvc_Week /first=RuFYSvcWk1.

Aggregate outfile = * mode= ADDVARIABLES
   /Break= FiscalYear
   /FY_CESDC_RUs = sum(RuFY1).

Aggregate outfile = * mode= ADDVARIABLES
   /Break= FiscalYear  FYSvc_Week
   /FY_CESDC_Wkly_RUs = sum(RuFYSvcWk1).

Compute PctRUsWithSvcInWeek = FY_CESDC_Wkly_RUs/FY_CESDC_RUs.

 * Sort cases by FiscalYear FYSvc_Week.
 * Split file by FiscalYear FYSvc_Week.
 * Freq PctRUsWithSvcInWeek.
 * split file off.

Aggregate outfile = * mode= ADDVARIABLES
   /Break = FiscalYear FYSvc_Week
   /MinWeekDay = min(svcdate)
   /MaxWeekDay = max(svcdate).

Compute SvcWeekDays = ((xdate.tday(MaxWeekDay) - xdate.tday(MinWeekDay))+1). 

 * Sort cases by FiscalYear FYSvcWeek.
 * Split file by Sort cases by SvcWeek.
 * Freq SvcWeekDays.
 * split file off.

Compute DropWeek=0.
If PctRUsWithSvcInWeek lt .33 or SvcWeekDays lt 4 DropWeek=1. 
 * TEMPORARY.
 * Select if DropWeek=1.
 * Freq MinWeekDay.
Select if DropWeek=0.

Save outfile =  '//covenas/decisionsupport/Orozco/Temp/KidsExceptionWork_CESDCWkly.sav'.
 *  get file  =  '//covenas/decisionsupport/Orozco/Temp/KidsExceptionWork_CESDCWkly.sav'. 

Aggregate outfile = '//covenas/decisionsupport/Orozco/Temp/ServiceWeekWork.sav'
   /Break=FiscalYear FYSvc_Week
   /PctRUsWithSvcInWeek= max(PctRUsWithSvcInWeek). 

Get file = '//covenas/decisionsupport/Orozco/Temp/ServiceWeekWork.sav' /Drop PctRUsWithSvcInWeek.

CASESTOVARS
/id=FiscalYear.  
Save outfile ='//covenas/decisionsupport/Orozco/Temp/ServiceWeekShell.sav'.

Get file =  '//covenas/decisionsupport/Orozco/Temp/KidsExceptionWork_CESDCWkly.sav' /keep FiscalYear Ru FYSvc_Week Case Svcdate Proclong MCSvcCat svc_cat duration GroupHrs FirstFYSvcWeek LastFYSvcWeek.
if svc_cat = 'ind therapy' Ind_therapyHrs= duration. 

Aggregate outfile = * 
   /Break = FiscalYear Ru FYSvc_Week Case FirstFYSvcWeek LastFYSvcWeek
   /WeekGroupHrs = sum(GroupHrs)
   /WeekInd_therapyHrs= sum(Ind_therapyHrs). 

sort cases by FiscalYear.
Match files /table= '//covenas/decisionsupport/Orozco/Temp/ServiceWeekShell.sav' /file=* /by FiscalYear. 

Recode WeekGroupHrs WeekInd_therapyHrs (sysmis=0). 

compute FYSvc_Weekx=999999999999999.

sort variables by name.
VARSTOCASES
/make FYSvc_WeekShell from FYSvc_Week.1 to FYSvc_Weekx.

select if FYSvc_WeekShell ne 999999999999999. 

Compute Drop=0.
If FYSvc_WeekShell lt FirstFYsvcWeek Drop=1.
If FYSvc_WeekShell gt LastFYsvcWeek Drop=1.
Select if Drop=0.

Compute GroupHours=0.
Compute Ind_therapyHrs=0.
If FYSvc_WeekShell = FYSvc_Week GroupHours= WeekGroupHrs.
If FYSvc_WeekShell = FYSvc_Week Ind_therapyHrs= WeekInd_therapyHrs.

Aggregate outfile = *
   /Break= FiscalYear Ru Case FYSvc_WeekShell FirstFYsvcWeek LastFYSvcWeek 
   /GroupHours = sum(GroupHours)
   /Ind_therapyHrs = sum(Ind_therapyHrs). 

 * select if case= 75100966.
 * select if ru ='018436'.
   
Compute WeekCounter=1. 
Compute SufficientGrpWeek=0.
exe.
If GroupHours ge 1 SufficientGrpWeek=1.
Compute SufficientIndivThrpyWeek=0.
If Ind_therapyHrs ge 1 SufficientIndivThrpyWeek=1.

Aggregate outfile = * 
   /Break=FiscalYear RU Case 
   /FYWeeks = sum(WeekCounter)
   /SufficientGrpWeeks=sum(SufficientGrpWeek)
   /SufficientIndivThrpyWeeks=sum(SufficientIndivThrpyWeek).

Compute FYRUCase1=1.

Compute PctSufficientGrpWeeks = SufficientGrpWeeks/FYWeeks.
Compute PctSufficientIndivThrpyWeeks = SufficientIndivThrpyWeeks/FYWeeks.

If PctSufficientGrpWeeks ge .75 SufficientGrpWeekCase=1.
If PctSufficientIndivThrpyWeeks ge .75 SufficientIndivThrpyWeekCase=1.
Recode SufficientGrpWeekCase SufficientIndivThrpyWeekCase (sysmis=0). 

String ColorPctSufficientGrpWeekClient (a10).
If PctSufficientGrpWeeks lt .75 ColorPctSufficientGrpWeekClient='Yellow'. 
If PctSufficientGrpWeeks ge .75 ColorPctSufficientGrpWeekClient='Green'. 
If PctSufficientGrpWeeks le .05  ColorPctSufficientGrpWeekClient='Red'. 

String ColorPctSufficientIndivThrpyWeekClient (a10).
If PctSufficientIndivThrpyWeeks lt .75 ColorPctSufficientIndivThrpyWeekClient ='Yellow'. 
If PctSufficientIndivThrpyWeeks ge .75 ColorPctSufficientIndivThrpyWeekClient ='Green'. 
If PctSufficientIndivThrpyWeeks le .05  ColorPctSufficientIndivThrpyWeekClient ='Red'. 

Sort cases by ru fiscalyear. 
Save outfile ='//covenas/decisionsupport/Orozco/Temp/KidsException_CESDCCaseList_WklyGoals.sav'.
 * GET FILE = '//covenas/decisionsupport/Orozco/Temp/KidsException_CESDCCaseList_WklyGoals.sav'.

Aggregate outfile= *
   /Break= FiscalYear Ru 
   /FYClients = sum(FYRUCase1)
   /SufficientGrpClients = sum(SufficientGrpWeekCase)
   /SufficientIndivThrpyClients = sum(SufficientIndivThrpyWeekCase).

Compute PctSufficientGrpClients = SufficientGrpClients/FYClients.
Compute PctSufficientIndivThrpyClients = SufficientIndivThrpyClients/FYClients.

String ColorPctSufficientGrpClients(a10).
If PctSufficientGrpClients lt .75 ColorPctSufficientGrpClients='Yellow'. 
If PctSufficientGrpClients ge .75 ColorPctSufficientGrpClients='Green'. 
If PctSufficientGrpClients le .05  ColorPctSufficientGrpClients='Red'. 

String ColorPctSufficientIndivThrpyClients(a10).
If PctSufficientIndivThrpyClients lt .75 ColorPctSufficientIndivThrpyClients='Yellow'. 
If PctSufficientIndivThrpyClients ge .75 ColorPctSufficientIndivThrpyClients='Green'. 
If PctSufficientIndivThrpyClients le .05  ColorPctSufficientIndivThrpyClients='Red'. 

Sort cases by ru fiscalyear. 
Save outfile ='//covenas/decisionsupport/Orozco/Temp/KidsException_CESDC_WklyGoalsbyRU.sav' /drop FYClients.

 * Temp.
 * Select if DropWeek=1.
 * freq MinWeekDay.

***CESDC.
*14 hours per month per kid total services (exception 75 % ) 20 hours per kid per month total services for 'Intensive CESDC'.
*2 hours per monh of family something (exception zero only).
**Need to be open for at least 25 days of month.
**Merge November and December when do monthly Agg.

get file =  '//covenas/decisionsupport/Orozco/Temp/KidsExceptionWork2.sav'.
select if ProgramModel= "School ERMHS - Counseling Enriched - Intensive" or ProgramModel= "School ERMHS - Counseling Enriched". 

Aggregate outfile = *
   /Break= ru fiscalyear calendar 
   /Hours=sum(duration)
   /MinSvcDate= Min(Svcdate)
   /MaxSvcDate=max(Svcdate). 

Compute Drop=0. 
if xdate.month(Calendar) =  6 drop=1.
if xdate.month(Calendar) =  7 drop=1. 
if xdate.month(Calendar) =  8 drop=1. 
Select if Drop=0.

if xdate.mday(MinSvcDate) ge 20 Drop = 1.
if xdate.mday(MaxSvcDate) le 10 Drop = 1.
if xdate.month(Calendar) =  11 drop=0. 
if xdate.month(Calendar) =  12 drop=0. 
Select if Drop=0.

Aggregate outfile = *
   /Break= ru fiscalyear calendar 
   /Bogus=sum(Drop).

Match files /file=* /by ru /drop bogus. 

sort cases by ru fiscalyear.

CASESTOVARS
/id=RU fiscalyear.  
Save outfile ='//covenas/decisionsupport/Orozco/Temp/CESDCServiceMonthlyShell.sav'.

get file =  '//covenas/decisionsupport/Orozco/Temp/KidsExceptionWork2.sav'.

compute year=xdate.year(opdate).
compute month = xdate.month(opdate).
compute Opdatecalendar = date.MOYR(month,year).
formats Opdatecalendar(MOYR6).
match files /file=* /drop month year.

insert file = '//covenas/decisionsupport/modules/nullclosdate.sps'.

compute year=xdate.year(closdate).
compute month = xdate.month(closdate).
compute Closcalendar = date.MOYR(month,year).
formats Closcalendar(MOYR6).
match files /file=* /drop month year.

Aggregate outfile = * mode=ADDVARIABLES
   /Break case ru Calendar
   /MonthFamHours = sum(FamilyHrsRcvd) 
   /TotalMonthHours=sum(duration2).

Aggregate outfile = * mode=ADDVARIABLES
   /Break case ru fiscalyear
   /LastFYSvc=max(svcdate).

Aggregate outfile = *
   /BREAK = ProgramModel ru fiscalyear calendar case MonthFamHours TotalMonthHours opdate Opdatecalendar closdate LastFYSvc
   /Closcalendar=max(Closcalendar).

Sort cases by ru fiscalyear.

match files /table= '//covenas/decisionsupport/Orozco/Temp/CESDCServiceMonthlyShell.sav' /file=* /by ru fiscalyear.
Recode MonthFamHours TotalMonthHours (sysmis=0). 

Save outfile = '//covenas/decisionsupport/Orozco/Temp/CESDCServiceMonthlyWork.sav'.
 * get file =  '//covenas/decisionsupport/Orozco/Temp/CESDCServiceMonthlyWork.sav'.

compute Calendarx=9999999999999999.
exe.

sort variables by name.
VARSTOCASES
/make CalendarShell from Calendar.1 to Calendarx.
exe.

select if CalendarShell ne 9999999999999999.
Compute Drop=0.
if CalendarShell gt date.dmy(01,01,2040) drop=1.
Select if Drop=0.

*Eliminate months where clients were only in program for part of month (less than 25 days) Unless they started in late November or ended in early Decmeber because those months will be merged.
If (CalendarShell) = (Opdatecalendar) and (xdate.mday(opdate) gt  5 and xdate.month(Opdatecalendar) ne 11) Drop = 1.
If (CalendarShell) = (Closcalendar) and (xdate.mday(closdate) lt 25 and xdate.month(Closcalendar) ne 12) Drop = 1.
select if drop=0.

If xdate.tday(CalendarShell) lt xdate.tday(Opdatecalendar) Drop=1.
If xdate.tday(CalendarShell) gt xdate.tday(LastFYSvc) Drop=1.
Select if Drop=0.

Compute MonthlyFamilyHours=0.
Compute TotalMonthlyHours=0.
If CalendarShell = Calendar MonthlyFamilyHours= MonthFamHours.
If CalendarShell = Calendar TotalMonthlyHours= TotalMonthHours.

Do if xdate.month(CalendarShell) = 12.
Compute CalendarShell =  datesum(CalendarShell,-1,"month").
End if. 

Aggregate outfile = *
   /Break= FiscalYear ProgramModel Ru Case CalendarShell
   /MonthlyFamilyHours = sum(MonthlyFamilyHours)
   /TotalMonthlyHours = sum(TotalMonthlyHours). 

recode MonthlyFamilyHours TotalMonthlyHours (sysmis=0).

***CESDC.
*14 hours per month per kid total services (exception 75%) 20 hours per kid per month total services for 'Intensive CESDC'.
*2 hours per monh of family something (exception zero only).
**Need to be open for at least 25 days of month.
**Merge November and December when do monthly Agg.

Compute SufficientFamMonth=0.
If MonthlyFamilyHours ge 2 SufficientFamMonth=1.
if ProgramModel= "School ERMHS - Counseling Enriched" and TotalMonthlyHours ge 14 SufficientTotalHoursMonth=1.
if ProgramModel= "School ERMHS - Counseling Enriched - Intensive" and TotalMonthlyHours ge 20 SufficientTotalHoursMonth=1.

recode SufficientTotalHoursMonth SufficientTotalHoursMonth(sysmis=0).

Compute MonthCounter=1.

Aggregate outfile = *
   /Break=ProgramModel FiscalYear RU Case 
   /FYMonths = sum(MonthCounter)
   /SufficientTotalHoursMonths=sum(SufficientTotalHoursMonth)
   /SufficientFamMonths=sum(SufficientFamMonth).

Compute PctSufficientTotalHoursMonths = SufficientTotalHoursMonths/FYMonths.
Compute PctSufficientFamMonths = SufficientFamMonths/FYMonths.

String ColorPctSufficientTotalHoursMonths(a10).
If PctSufficientTotalHoursMonths ge .75 ColorPctSufficientTotalHoursMonths='Green'.
If PctSufficientTotalHoursMonths ge .75 SufficientTotalHrsClient=1. 
If PctSufficientTotalHoursMonths lt .75 ColorPctSufficientTotalHoursMonths='Yellow'.
If PctSufficientTotalHoursMonths le .05  ColorPctSufficientTotalHoursMonths='Red'.

String ColorPctSufficientFamHoursMonths(a10).
If PctSufficientFamMonths ge .75 ColorPctSufficientFamHoursMonths='Green'.
If PctSufficientFamMonths ge .75 SufficientFamHoursClient=1. 
If PctSufficientFamMonths lt .75 ColorPctSufficientFamHoursMonths='Yellow'.
If PctSufficientFamMonths le .05  ColorPctSufficientFamHoursMonths='Red'.

Recode SufficientTotalHrsClient SufficientFamHoursClient(sysmis=0).

Save outfile ='//covenas/decisionsupport/Orozco/Temp/KidsException_CESDCCaseList_MonthlyGoals.sav'.
GET FILE ='//covenas/decisionsupport/Orozco/Temp/KidsException_CESDCCaseList_MonthlyGoals.sav'.

Sort cases by FiscalYear ru case.
Match Files /file=* /by FiscalYear ru case /first= FYRUCase1.

Aggregate outfile= *
   /Break= ProgramModel FiscalYear Ru 
   /FYClients = sum(FYRUCase1)
   /SufficientFamMonthsClients = sum(SufficientFamHoursClient)
   /SufficientTotalHrsMonthsClients = sum(SufficientTotalHrsClient).

Compute PctSufficientFamMonthsClients = SufficientFamMonthsClients/FYClients.
Compute PctSufficientTotalHrsMonthsClients = SufficientTotalHrsMonthsClients/FYClients.

String ColorFamMonthsClients(a10).
String ColorTotalHrsMonthsClients(a10).

If PctSufficientFamMonthsClients lt .75 ColorFamMonthsClients='Yellow'. 
If PctSufficientFamMonthsClients ge .75 ColorFamMonthsClients='Green'. 
If PctSufficientFamMonthsClients le .05  ColorFamMonthsClients='Red'. 

If PctSufficientTotalHrsMonthsClients lt .75 ColorTotalHrsMonthsClients='Yellow'. 
If PctSufficientTotalHrsMonthsClients ge .75 ColorTotalHrsMonthsClients='Green'. 
If PctSufficientTotalHrsMonthsClients le .05  ColorTotalHrsMonthsClients='Red'. 

Sort cases by ru fiscalyear. 
Save outfile = '//covenas/decisionsupport/Orozco/Temp/KidsException_CESDC_RU_MonthlyGoals.sav'/Drop ProgramModel FYClients. 

Get file =  '//covenas/decisionsupport/Orozco/Temp/ProgramModelRUShell.sav'.
sort cases by ru fiscalyear. 
exe.

match files /table = '//covenas/decisionsupport/Orozco/Temp/ProgramModelLOS.sav' /file=* /by ru fiscalyear. 

match files /table = '//covenas/decisionsupport/Orozco/Temp/ProgramModelFamAndGrpSvcs.sav' /file=* /by ru fiscalyear. 

match files /table = '//covenas/decisionsupport/Orozco/Temp/KidsException_CESDC_WklyGoalsbyRU.sav' /file=* /by ru fiscalyear. 

match files /table ='//covenas/decisionsupport/Orozco/Temp/KidsException_CESDC_RU_MonthlyGoals.sav' /file=* /by ru fiscalyear. 

match files /file=* /by ru fiscalyear /first= rufy1.

Aggregate outfile = * mode=ADDVARIABLES
   /Break = ProgramModel FiscalYear
   /ProgramModelFYRUs = sum(rufy1).

String RUColor(a10).
if (ColorFamMonthsClients ='Green' or ColorTotalHrsMonthsClients='Green' or ColorPctSufficientGrpClients='Green' 
or ColorPctSufficientIndivThrpyClients='Green' or ColorPctFamilyHrs='Green' or ColorPctClientsGrp='Green' 
or ColorPctLOS3to6Mos='Green' or ColorPctLOS6to24Mos='Green') RUColor='Green'. 

if (ColorFamMonthsClients ='Yellow' or ColorTotalHrsMonthsClients='Yellow' or ColorPctSufficientGrpClients='Yellow' 
or ColorPctSufficientIndivThrpyClients='Yellow' or ColorPctFamilyHrs='Yellow' or ColorPctClientsGrp='Yellow' 
or ColorPctLOS3to6Mos='Yellow' or ColorPctLOS6to24Mos='Yellow') RUColor='Yellow'. 

if (ColorFamMonthsClients ='Red' or ColorTotalHrsMonthsClients='Red' or ColorPctSufficientGrpClients='Red' 
or ColorPctSufficientIndivThrpyClients='Red' or ColorPctFamilyHrs='Red' or ColorPctClientsGrp='Red' 
or ColorPctLOS3to6Mos='Red' or ColorPctLOS6to24Mos='Red') RUColor='Red'. 

Do if ProgramModel= 'EarlyChildhood' or ProgramModel= 'School - SBBH'.
Recode AllDischarges EligibleDischarges LOSBtw3and6Mos LOSBtw6and24Mos (Sysmis=0). 
End if. 

 * sort cases by fiscalyear.
 * split file by fiscalyear.
 * Freq RUColor. 

Save outfile = '//covenas/decisionsupport/Orozco/Temp/KidsException_ByRuFY.sav' /drop rufy1. 


*pushbreak.
*sqlTable = 'KidsException_ByRuFY'.
*spsstable='//covenas/decisionsupport/Orozco/Temp/KidsException_ByRuFY.sav'.
*pushbreak.


 *Performance Standards.

*0-5.
**60% of clients who exit will have a LOS between six and 24 months.
**50% of services are Family Services.

*SBMH.
**25 clients per FTE (30), LOS of 3 to 6 months (75% of clients), 15% of Hours are Family Services, 30% of Clients get group services.

*School ERMHS - Counseling Enriched.
**4 hours per month per kid total services (exception <75% of kids) 20 hours per kid per month total services for Intensive CESDC.
**2 hours per month of family something (exception zero only).
**1 hour per week per kid of group something (exception at less than 3 weeks in month).
**1 hour per week per kid of individual therapy (exception at less than 3 weeks in month).


















