 * add files
   /file ='//covenas/decisionsupport/services13_qtr3.sav'
   /file ='//covenas/decisionsupport/services13_qtr4.sav'
   /file ='//covenas/decisionsupport/services14_qtr1.sav'.

get file = '//covenas/decisionsupport/dbsvc.sav'.
*Use this file. 

select if ru = '01FB1'.
exe.
select if xdate.tday(svcdate) ge yrmoda(2013,07,01).
insert file='//covenas/decisionsupport/meinzer/modules/NoShow.sps'.
insert file='//covenas/decisionsupport/meinzer/modules/calsvcdate.sps'.
insert file='//covenas/decisionsupport/meinzer/modules/calfiscalyear.sps'.
 * insert file='//covenas/decisionsupport/modules/duration.sps'.
insert file='//covenas/decisionsupport/modules/uncookedmonth.sps'.
select if svcdate lt UncookedMonth.

sort cases by ru.
match files /Table='//covenas/decisionsupport/ruTable.sav' /file=*/by ru. 

sort cases by ru case opdate.
match files /table='//covenas/decisionsupport/epscg.sav' /file=* /by ru case opdate.  

sort cases by proced. 
match files /Table='//covenas/decisionsupport/procedsma.sav' /file=*/by proced
/keep agency provname ru case opdate svcdate duration proced proclong MCSvcCat unit cost svcMode psMask2 calendar fiscalyear refsrce.
 
* sort cases by proced.
 * split file by proced.
 * freq proclong. 
 * split file off. 

 * sort cases by mcsvccat.
 * split file by mcsvccat.
 * freq proced. 
 * split file off. 

Sort cases by case calendar.
match files /table= '//covenas/decisionsupport/medicaltable.sav' /file=* /by case calendar.

rename variables refsrce = refcode.
Sort cases by refcode. 
match files /table= '//covenas/spssdata/RefSource.sav' /file=* /by refcode.
freq reftext.

temp. 
select if reftext= "Other Human Services Org.".
freq case opdate. 

recode Full (sysmis=0).

Do if (MCSvcCat='B. Mental Health Services' or any(proced, 557, 577)) and full=1.
Compute MentalHealthServicesUnits = duration.
Compute MentalHealthServicesAmount = duration * 156.54.
End if. 

Do if MCSvcCat='A. Case Management Services' and full=1.
Compute CaseManagementUnits = duration.
Compute CaseManagementAmount = duration*121.16.
End if. 

Do if MCSvcCat='D. Crisis Intervention'  and full=1.
Compute CrisisInterventionUnits = duration.
Compute CrisisInterventionAmount = duration*232.72.
End if. 

Do if MCSvcCat='C. Medication Support'  and full=1.
Compute MedicationSupportUnits = duration.
Compute MedicationSupportAmount = duration*232.72.
End if. 

 * Do if (MCSvcCat=' ' and not any(proced, 557, 571)) or full=0.
 * Compute NonMCServicesUnits = duration.
 * Compute NonMCServicesAmount = duration*156.54.
 * End if. 

Do if (MCSvcCat ne ' ' or any(proced, 557, 577)) and full=0.
Compute MCServiceToNonMCClientUnits= duration.
Compute MCServiceToNonMCClientAmount = duration*156.54.
End if. 

Do if (MCSvcCat=' ' and not any(proced, 557, 577)).
Compute NonMCServicesUnits = duration.
Compute NonMCServicesAmount = duration*156.54.
End if. 

Recode MentalHealthServicesUnits MentalHealthServicesAmount CaseManagementUnits CaseManagementAmount CrisisInterventionUnits CrisisInterventionAmount MedicationSupportUnits 
MedicationSupportAmount NonMCServicesUnits NonMCServicesAmount MCServiceToNonMCClientUnits MCServiceToNonMCClientAmount (sysmis=0).

Compute TotalMCUnits = sum(MentalHealthServicesUnits, CaseManagementUnits, CrisisInterventionUnits, MedicationSupportUnits).
Compute TotalMCAmount = sum(MentalHealthServicesAmount, CaseManagementAmount, CrisisInterventionAmount, MedicationSupportAmount).

 * sort cases by ru calendar case.
 * match files /file=* /by  ru calendar case /first=RuCalCase1.
 * Aggregate outfile = * Mode=ADDVARIABLES 
   /Break=ru calendar 
   /CalClients = sum(RuCalCase1).

sort cases by refcode ru calendar case.
match files /file=* /by  refcode ru calendar case /first=RefRuCalCase1.
 * freq reftext. 

if case= 75205167 reftext= "Criminal Justice".
if any(case, 75190854, 75205953) reftext =  "SAR Sacramento/Los Angeles". 
If reftext = "Dept. Social Services" RUAmount=2369828. 
If reftext= "Criminal Justice" NonMCMax=300000.
If reftext = "Dept. Social Services" NonMCMax=216000. 


Save outfile = '//covenas/decisionsupport/Orozco/Temp/Lincoln_Work.sav'.
 get file = '//covenas/decisionsupport/Orozco/Temp/Lincoln_Work.sav'.

Aggregate outfile = '//covenas/decisionsupport/Orozco/Temp/ProjPerm_CFS_Prob1.sav'
   /Break= reftext agency provname ru fiscalyear Calendar RUAmount NonMCMax
   /Client=sum(RefRuCalCase1)
   /MentalHealthServicesUnits = sum(MentalHealthServicesUnits)
   /MentalHealthServicesAmount = sum(MentalHealthServicesAmount)
   /CaseManagementUnits = sum(CaseManagementUnits)
   /CaseManagementAmount = sum(CaseManagementAmount)
   /CrisisInterventionUnits = sum(CrisisInterventionUnits)
   /CrisisInterventionAmount = sum(CrisisInterventionAmount)
   /MedicationSupportUnits = sum(MedicationSupportUnits)
   /MedicationSupportAmount = sum(MedicationSupportAmount)
   /TotalMCUnits=sum(TotalMCUnits)
   /TotalMCAmount =sum(TotalMCAmount)
   /NonMCServicesUnits= sum(NonMCServicesUnits)
   /NonMCServicesAmount= sum(NonMCServicesAmount)
   /MCServiceToNonMCClientUnits= sum(MCServiceToNonMCClientUnits)
   /MCServiceToNonMCClientAmount= sum(MCServiceToNonMCClientAmount).

Compute reftext = 'Total'.
if reftext = 'Total' RUAmount =2669828.
if reftext = 'Total' NonMCMax = 516000.

Aggregate outfile = '//covenas/decisionsupport/Orozco/Temp/ProjPerm_CFS_Prob2.sav'
   /Break= reftext agency provname ru fiscalyear Calendar RUAmount NonMCMax
   /Client=sum(RefRuCalCase1)
   /MentalHealthServicesUnits = sum(MentalHealthServicesUnits)
   /MentalHealthServicesAmount = sum(MentalHealthServicesAmount)
   /CaseManagementUnits = sum(CaseManagementUnits)
   /CaseManagementAmount = sum(CaseManagementAmount)
   /CrisisInterventionUnits = sum(CrisisInterventionUnits)
   /CrisisInterventionAmount = sum(CrisisInterventionAmount)
   /MedicationSupportUnits = sum(MedicationSupportUnits)
   /MedicationSupportAmount = sum(MedicationSupportAmount)
   /TotalMCUnits=sum(TotalMCUnits)
   /TotalMCAmount =sum(TotalMCAmount)
   /NonMCServicesUnits= sum(NonMCServicesUnits)
   /NonMCServicesAmount= sum(NonMCServicesAmount)
   /MCServiceToNonMCClientUnits= sum(MCServiceToNonMCClientUnits)
   /MCServiceToNonMCClientAmount= sum(MCServiceToNonMCClientAmount).

Add files 
   /File= '//covenas/decisionsupport/Orozco/Temp/ProjPerm_CFS_Prob1.sav'
   /File= '//covenas/decisionsupport/Orozco/Temp/ProjPerm_CFS_Prob2.sav'.

Save outfile = '//covenas/decisionsupport/Orozco/Temp/ProjPerm_CFS_Prob.sav'.
   

*pushbreak.
*sqlTable = 'ProjPerm_CFS_Prob'.
*spsstable='//covenas/decisionsupport/Orozco/Temp/ProjPerm_CFS_Prob.sav'.
*pushbreak.



