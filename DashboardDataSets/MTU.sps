DEFINE 	DBStartDate() date.dmy(1,1,2011) !ENDDEFINE.

add files
            /file='//covenas/spssdata/temp\MTUtwo.sav' /in=file2
            /file='//covenas/spssdata/temp\MTUone.sav' /in=file1.

compute svcdate = xdate.date(svcdate).

insert file = '//covenas/decisionsupport/modules\calsvcdate.sps'.

rename variables SVCDATE = date.
insert file = '//covenas/decisionsupport/meinzer\modules\datefy.sps'.
rename variables date = SVCDATE.

sort cases by Mtuname case encounterid svcdate.
match files /file = * /by Mtuname case encounterid svcdate /first = Visit.

compute Cost = Units * Rate.

sort cases by case.
match files /table = '//covenas/decisionsupport/clinfocg.sav' /file = * /by case
   /keep MTUname TherapyTypeName ServiceTypeName MTUID ClientID encounterID HCPCS
   DiagnosisCode units Rate SVCDATE file2 file1 calendar FiscalYear Visit Cost bday case cin.

 * sort cases by case.
 * match files/ file = * /by case /first = case1.

 * sort cases by cin.
 * match files /file = * /by cin /first = cin1.

 * sort cases by cin1.
 * split file by cin1.
 * freq case1.
 * split file off.
***4 Clients without a CIN!.

aggregate outfile = * mode = addvariables
   /break = case
   /MinSvcDate=min(svcdate).

compute Age = trun(xdate.tday(MinSvcDate) - xdate.tday(bday))/365.25.

sort cases by case calendar.
match files /table = '//covenas/decisionsupport/medicaltable.sav' /file = * /by case calendar.

sort cases by cin calendar.
match files /table='//covenas/spssdata/MediCalData\medsCCS_aug13.sav' /file=* /by cin calendar.
match files /table='//covenas/spssdata/MediCalData\medsCCS_sep13.sav' /file=* /by cin calendar.
match files /table='//covenas/spssdata/MediCalData\medsCCS_oct13.sav' /file=* /by cin calendar.

sort cases by case calendar.
match files /table = '//covenas/decisionsupport/medicaltable.sav' /file = * /by case calendar.

****If in medicalTable (insyst) and CCS thing as well medicalTable trumps.
compute MCins = 0.
if CCSaidcode = "9K" MCins = 1.
if full = 1 MCins = 1.

 * sort cases by full.
 * split file by full.
 * freq ccsaidcode.
 * split file off.

aggregate outfile=* mode= addvariables 
/break fiscalyear calendar case
/MediCal=max(MCins).

recode MediCal (sysmis=0).

save outfile = '//covenas/decisionsupport/hall\temp\MTUWorkFile.sav'.
get file =  '//covenas/decisionsupport/hall\temp\MTUWorkFile.sav'.

***Will need Therapist/StaffPerson added to the break!.
 aggregate outfile = '//covenas/decisionsupport/hall\temp\MTUTrimmedFile.sav'
   /break = FiscalYear calendar MTUName ClientId TherapyTypeName ServiceTypeName MediCal
   /Visits = sum(Visit)
   /Units = sum(units)
   /Cost = sum(Cost).

get file = '//covenas/decisionsupport/hall\temp\MTUTrimmedFile.sav'.
format cost(dollar15.2).

insert file = '//covenas/decisionsupport/modules/uncookedmonth.sps'.

compute datathru = datesum((uncookedmonth), - 1,"days").
formats datathru(date11).

 * sort cases by calendar.
 * split file by calendar.
 * freq medical.
 * freq cost visits units/format = notable /stat = min max median mean.
 * split file off.

save outfile = '//covenas/decisionsupport/temp/MTUTrimmedFile.sav'.
*pushbreak.
*sqlTable = 'MTU_Dashboard'.
*spsstable='//covenas/decisionsupport/temp\MTUTrimmedFile.sav'.
*pushbreak.

get file = '//covenas/decisionsupport/hall\mtu matters\StaffActivity.sav'.

rename variables name = TherapistName.

String TherapistType(a25).
if type = "PT" TherapistType = "Physical Therapist".
if type = "OT" TherapistType = "Occupational Therapist".

string mtuname(a25).
if mtuabb = "CC" mtuname = "Cesar Chavez".
if mtuabb = "Bay" mtuname = "Bay".
if mtuabb = "Glank" mtuname = "Glankler".
if mtuabb = "VAL" mtuname = "Valley".
if mtuabb = "WOAK" mtuname = "West Oakland".

rename variables serviceDate = svcdate.
insert file = '//covenas/decisionsupport/modules\calsvcdate.sps'.

rename variables SVCDATE = date.
insert file = '//covenas/decisionsupport/meinzer\modules\datefy.sps'.
rename variables date = servicedate.

save outfile = '//covenas/decisionsupport/hall\temp\workfile2.sav'.
 * get file = '//covenas/decisionsupport/hall\temp\workfile2.sav'.

select if any (TherapistType,"Physical Therapist","Occupational Therapist").

***Must make and use a case1********************.
 * aggregate outfile = '//covenas/decisionsupport/hall\mtu matters\StaffHoursAgg.sav'
   /break = FiscalYear Calendar mtuname TherapistType TherapistName
   /ServiceHours=sum(SvcHrs)
   /CancelledHours =sum(CanclHrs)
   /DocumentationHours=sum(DocHrs)
   /DocumentationUnits=sum(DocUnits)
   /TreatmentHours=sum(Treatmt)
   /EvaluationHours=sum(Eval)
   /ConferenceHours=sum(conf)
   /ConsultationHours=sum(conslt)
   /LTGT=sum(ltgt)
   /PatientIllCancellations=sum(p1)
   /SchoolCancellations=sum(p2)
   /ParentCancellations=sum(p3)
   /PatientNoShows=sum(p4)
   /TherapistSickCancellations=sum(t1)
   /TherapistMedicalAppointmentCancellations=sum(t2)
   /TherapistAttendingAMeetingElsewhereCancellations=sum(t3)
   /TherapistOtherCancellations=sum(t4).

 * get file =  '//covenas/decisionsupport/hall\mtu matters\StaffHoursAgg.sav'.

 * save outfile = '//covenas/decisionsupport/temp/MTUStaffHours.sav'.

*pushbreak.
*DO NOT PUSH.
*sqlTable = 'MTU_StaffHours'.
*spsstable='//covenas/decisionsupport/temp/MTUStaffHours.sav'.
*pushbreak.
***New code 3/18/2014 full code to follow.

get file ='//covenas/decisionsupport/temp\MTUwork2.sav'.
************************************************.
 * aggregate outfile = '//covenas/decisionsupport/temp\MTUOverall.sav'
   /break = FiscalYear calendar MTUName datathru
   /Visits=sum(Visits) 
   /Units=sum(Units)
   /Cost =sum(Cost).


 * aggregate outfile = '//covenas/decisionsupport/temp\MTUByTherapist.sav'
   /break = FiscalYear calendar MTUName TherapyTypeName StaffID StaffName  
   /Visits=sum(Visits) 
   /Units=sum(Units)
   /Cost =sum(Cost).

 * aggregate outfile = '//covenas/decisionsupport/temp\MTUByTherapistByClient.sav'
   /break = FiscalYear calendar MTUName TherapyTypeName StaffID StaffName 
   case ClientName DOB age ssn Eligbstatus
   /Visits=sum(Visits) 
   /Units=sum(Units)
   /Cost =sum(Cost).

 * get file =  '//covenas/decisionsupport/temp\MTUByTherapistByClient.sav'.

aggregate outfile =  '//covenas/decisionsupport/temp/MTUPatientANDTherapistCancellationsOverall.sav'
   /break = FiscalYear Calendar mtuname 
   /TotalCancellations=sum(cancel)
   /PatientCancellations = sum(PatientCancel)
   /PatientIllCancellations=sum(p1)
   /SchoolCancellations=sum(p2)
   /ParentCancellations=sum(p3)
   /PatientNoShows=sum(p4)
   /PatientCancellationDueToHoliday = sum(p5)
   /PatientCancellationOther = sum(p6)
   /TherapistCancellations = sum(TherapistCancel)
   /TherapistSickCancellations=sum(t1)
   /TherapistMedicalAppointmentCancellations=sum(t2)
   /TherapistAttendingAMeetingElsewhereCancellations=sum(t3)
   /TherapistOtherCancellations=sum(t4).

*pushbreak.
*sqlTable = 'MTU_PatientANDTherapistCancellationsOverall'.
*spsstable=  '//covenas/decisionsupport/temp/MTUPatientANDTherapistCancellationsOverall.sav'.
*pushbreak.

aggregate outfile =  '//covenas/decisionsupport/temp/MTUPatientAndTherapistCancellationsByTherapist.sav'
   /break = FiscalYear Calendar mtuname TherapyTypeName StaffID StaffName  
   /TotalCancellations=sum(cancel)
   /PatientCancellations = sum(PatientCancel)
   /PatientIllCancellations=sum(p1)
   /SchoolCancellations=sum(p2)
   /ParentCancellations=sum(p3)
   /PatientNoShows=sum(p4)
   /PatientCancellationDueToHoliday = sum(p5)
   /PatientCancellationOther = sum(p6)
   /TherapistCancellations = sum(TherapistCancel)
   /TherapistSickCancellations=sum(t1)
   /TherapistMedicalAppointmentCancellations=sum(t2)
   /TherapistAttendingAMeetingElsewhereCancellations=sum(t3)
   /TherapistOtherCancellations=sum(t4).

*pushbreak.
*sqlTable = 'MTU_PatientANDTherapistCancellationsByTherapist'.
*spsstable= '//covenas/decisionsupport/temp/MTUPatientAndTherapistCancellationsByTherapist.sav'.
*pushbreak.

 * aggregate outfile =  '//covenas/decisionsupport/temp/MTUPatientCancellationsByClient.sav'
   /break = FiscalYear Calendar mtuname TherapyTypeName StaffID StaffName TherapyTypeName case 
   ClientName DOB age ssn Eligbstatus 
   /TotalCancellations=sum(cancel)
   /PatientCancellations = sum(PatientCancel)
   /PatientIllCancellations=sum(p1)
   /SchoolCancellations=sum(p2)
   /ParentCancellations=sum(p3)
   /PatientNoShows=sum(p4)
   /PatientCancellationDueToHoliday = sum(p5)
   /PatientCancellationOther = sum(p6)
   /TherapistCancellations = sum(TherapistCancel)
   /TherapistSickCancellations=sum(t1)
   /TherapistMedicalAppointmentCancellations=sum(t2)
   /TherapistAttendingAMeetingElsewhereCancellations=sum(t3)
   /TherapistOtherCancellations=sum(t4).

 * get file =  '//covenas/decisionsupport/temp/MTUPatientCancellationsByClient.sav'.

*pushbreak.
*DO NOT PUSH.
*sqlTable = 'MTU_PatientANDTherapistCancellationsByClient'.
*spsstable=  '//covenas/decisionsupport/temp/MTUPatientCancellationsByClient.sav'.
*pushbreak.

 * aggregate outfile =  '//covenas/decisionsupport/temp/MTUStaffHoursOverall.sav'
   /break = FiscalYear Calendar mtuname
   /TotalHours = max(MTUMonthlyTotalHours)
   /BillableHours = max(MTUMonthlyBillableHours)
   /NonBillableHours = max(MTUMonthlyNonBillableHours)
   /OtherHours=sum(other)
   /DocumentationHours=sum(DocumentationHours)
   /DocumentationUnits=sum(DocumentationUnits)
   /TreatmentHours=sum(TreatmentHours)
   /EvaluationHours=sum(EvalHours)
   /ConferenceHours=sum(CaseConferenceHours)
   /ConsultationHours=sum(ConsultationHours).


aggregate outfile =  '//covenas/decisionsupport/temp/MTUStaffHoursOverall.sav'
   /break = FiscalYear Calendar mtuname
   /TotalHours = max(MTUMonthlyTotalHours)
   /BillableHours = max(MTUMonthlyBillableHours)
   /NonBillableHours = max(MTUMonthlyNonBillableHours)
   /DocumentationHours = sum(DocumentationHours)
   /TreatmentHours = sum(TreatmentHours)
   /EvaluationHours = sum(EvalHours)
   /CaseConferenceHours = sum(CaseConferenceHours)
   /ConsultationHours = sum(ConsultationHours).

*pushbreak.
*sqlTable = 'MTU_MonthlyHours'.
*spsstable=  '//covenas/decisionsupport/temp/MTUStaffHoursOverall.sav'.
*pushbreak.

aggregate outfile =  '//covenas/decisionsupport/temp/MTUStaffHoursByTherapyType.sav'
   /break = FiscalYear Calendar mtuname TherapyTypeName
   /TotalHours = max(MTUMonthlyTherapyTypeTotalHours)
   /BillableHours = max(MTUMonthlyTherapyTypeBillableHours)
   /NonBillableHours = max(MTUMonthlyTherapyTypeNonBillableHours)
   /DocumentationHours = sum(DocumentationHours)
   /TreatmentHours = sum(TreatmentHours)
   /EvaluationHours = sum(EvalHours)
   /CaseConferenceHours = sum(CaseConferenceHours)
   /ConsultationHours = sum(ConsultationHours).

 * pushbreak.
 * sqlTable = 'MTU_MonthlyHoursByTherapyType'.
 * spsstable=   '//covenas/decisionsupport/temp/MTUStaffHoursByTherapyType.sav'.
 * pushbreak.

aggregate outfile =  '//covenas/decisionsupport/temp/MTUStaffHoursByStaff.sav'
   /break = FiscalYear Calendar mtuname TherapyTypeName StaffId StaffName
   /TotalHours = max(MTUMonthlyTherapyTypeMonthlyTotalHours)
   /BillableHours = max(MTUMonthlyTherapyTypeMonthlyBillableHours)
   /NonBillableHours = max(MTUMonthlyTherapyTypeMonthlyNonBillableHours)
   /DocumentationHours = sum(DocumentationHours)
   /TreatmentHours = sum(TreatmentHours)
   /EvaluationHours = sum(EvalHours)
   /CaseConferenceHours = sum(CaseConferenceHours)
   /ConsultationHours = sum(ConsultationHours).

 * pushbreak.
 * sqlTable = 'MTU_MonthlyHoursByTherapyTypeByStaff'.
 * spsstable=   '//covenas/decisionsupport/temp/MTUStaffHoursByStaff.sav'.
 * pushbreak.

aggregate outfile =  '//covenas/decisionsupport/temp/MTUStaffHoursByTherapist.sav'
   /break = FiscalYear Calendar mtuname TherapyTypeName StaffId StaffName 
   /TotalHours = max(MTUMonthlyTherapyTypeMonthlyTotalHours)
   /BillableHours = max(MTUMonthlyTherapyTypeMonthlyBillableHours)
   /NonBillableHours = max(MTUMonthlyTherapyTypeMonthlyNonBillableHours) 
   /DocumentationHours=sum(DocumentationHours)
   /DocumentationUnits=sum(DocumentationUnits)
   /TreatmentHours=sum(TreatmentHours)
   /EvaluationHours=sum(EvalHours)
   /ConferenceHours=sum(CaseConferenceHours)
   /ConsultationHours=sum(ConsultationHours)
   /AdjustedHours = max(AdjWKHRS).

 * pushbreak.
 * sqlTable = 'MTU_StaffHoursByTherapist'.
 * spsstable=  '//covenas/decisionsupport/temp/MTUStaffHoursByTherapist.sav'.
 * pushbreak.

 * aggregate outfile =  '//covenas/decisionsupport/temp/MTUStaffHoursByClient.sav'
   /break = FiscalYear Calendar mtuname TherapyTypeName StaffName TherapyTypeName ServiceTypeName case 
   Clientname Eligbstatus datathru
   /DocumentationHours=sum(DocumentationHours)
   /DocumentationUnits=sum(DocumentationUnits)
   /TreatmentHours=sum(TreatmentHours)
   /EvaluationHours=sum(EvalHours)
   /ConferenceHours=sum(CaseConferenceHours)
   /ConsultationHours=sum(ConsultationHours)
   /TotalHours = sum(TotalHours)
   /BillableHours = sum(BillableHours)
   /NonBillableHours = sum(NonBillableHours)
   /AdjustedHours = sum(AdjWKHRS).

 * get file =  '//covenas/decisionsupport/temp/MTUStaffHoursByClient.sav'.

*pushbreak.
*DO NOT PUSH.
*sqlTable = 'MTU_StaffHoursByClient'.
*spsstable=  '//covenas/decisionsupport/temp/MTUStaffHoursByClient.sav'.
*pushbreak.





