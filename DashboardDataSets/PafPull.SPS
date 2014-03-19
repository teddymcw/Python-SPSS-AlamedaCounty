GET DATA
  /TYPE=ODBC
  /CONNECT='DSN=CGReporting;UID=;Trusted_Connection=Yes;APP=IBM SPSS Products: '+
    'Statistics Common;WSID=HPMXL2221NXK;DATABASE=Reporting'
  /SQL='SELECT __row_id AS " PAFrow_id", client_number, reporting_unit, CreateDate, Opening_Date, '+
    'ServiceID, "Note ID" AS Note_ID, "Note Title" AS NoteTitle, note_text, NOTE_ARRESTPRIOR12, '+
    'NOTE_EDUCATIONCODECURRENTLY6, NOTE_RESIDENTIALSETTINGPASTTWELVEDAYS17, NOTE_CONSERVPAST12, '+
    'NOTE_PAYEEPAST12, NOTE_PAROLEPAST12, NOTE_RESIDENTIALSETTINGPASTTWELVEOCCURENCES7, '+
    'NOTE_FINANCIALSUPPORTPASTTWELVE10, NOTE_RESIDENTIALSETTINGPASTTWELVEOCCURENCES4, '+
    'NOTE_RESIDENTIALSETTINGPRIOR7, NOTE_REFERREDBY, NOTE_RESIDENTIALSETTINGPASTTWELVEDAYS15, '+
    'NOTE_RESIDENTIALSETTINGCURRENT, NOTE_FINANCIALSUPPORTCURRENT11, '+
    'NOTE_FINANCIALSUPPORTCURRENT10, NOTE_FINANCIALSUPPORTCURRENT13, '+
    'NOTE_FINANCIALSUPPORTCURRENT12, NOTE_FINANCIALSUPPORTCURRENT15, '+
    'NOTE_FINANCIALSUPPORTCURRENT14, NOTE_FINANCIALSUPPORTCURRENT17, '+
    'NOTE_FINANCIALSUPPORTCURRENT16, NOTE_FINANCIALSUPPORTPASTTWELVE6, NOTE_PAYEECURR, '+
    'NOTE_RESIDENTIALSETTINGPASTTWELVEOCCURENCES21, NOTE_EMPLOYMENTSTATUSPAST12NUMWEEKS4, '+
    'NOTE_EDUCATIONCODEWEEKS1, NOTE_FINANCIALSUPPORTCURRENT7, NOTE_EMPLOYMENTSTATUSPAST12HRWAGE6, '+    
    'NOTE_EMPLOYMENTSTATUSPAST12HRWAGE4, NOTE_EMPLOYMENTSTATUSPAST12HRWAGE3, '+
    'NOTE_EMPLOYMENTSTATUSPAST12HRWAGE2, NOTE_EMPLOYMENTSTATUSPAST12HRWAGE1, NOTE_PAYEEPRIOR12, '+
    'NOTE_MENTALILLNESS, NOTE_FINANCIALSUPPORTCURRENT8, NOTE_ACTIVEPROBLEM, '+
    'NOTE_FINANCIALSUPPORTPASTTWELVE4, NOTE_PHYSICIANCURR, NOTE_RECOVERYGOALS, '+
    'NOTE_FINANCIALSUPPORTPASTTWELVE11, NOTE_EMPLOYMENTSTATUSPAST12NUMWEEKS6, NOTE_MHSAHP, '+
    'NOTE_RESIDENTIALSETTINGPRIOR6, NOTE_EMPLOYMENTSTATUSCURRENTHRWAGE4, NOTE_PAROLEPRIOR12, '+
    'NOTE_RESIDENTIALSETTINGPASTTWELVEDAYS11, NOTE_FINANCIALSUPPORTPASTTWELVE7, '+
    'NOTE_FINANCIALSUPPORTCURRENT4, NOTE_FINANCIALSUPPORTPASTTWELVE1, NOTE_CHILDRENTOTALWI300, '+
    'NOTE_EDUCATIONCODECURRENTLY2, NOTE_FINANCIALSUPPORTCURRENT1, '+
    'NOTE_RESIDENTIALSETTINGPASTTWELVEOCCURENCES20, NOTE_FINANCIALSUPPORTCURRENT9, '+
    'NOTE_RESIDENTIALSETTINGPASTTWELVEDAYS14, NOTE_RESIDENTIALSETTINGPASTTWELVEOCCURENCES3, '+
    'NOTE_RESIDENTIALSETTINGPASTTWELVEDAYS2, NOTE_RESIDENTIALSETTINGPASTTWELVEDAYS3, '+
    'NOTE_FINANCIALSUPPORTPASTTWELVE12, NOTE_RESIDENTIALSETTINGPASTTWELVEDAYS1, '+
    'NOTE_RESIDENTIALSETTINGPASTTWELVEDAYS6, NOTE_RESIDENTIALSETTINGPASTTWELVEDAYS7, '+
    'NOTE_RESIDENTIALSETTINGPASTTWELVEDAYS4, NOTE_RESIDENTIALSETTINGPASTTWELVEDAYS5, '+
    'NOTE_EDUCATIONGRADE, NOTE_RESIDENTIALSETTINGPASTTWELVEDAYS8, '+
    'NOTE_RESIDENTIALSETTINGPASTTWELVEDAYS9, NOTE_RESIDENTIALSETTINGPASTTWELVEOCCURENCES11, '+
    'NOTE_GHI, NOTE_RESIDENTIALSETTINGPASTTWELVEOCCURENCES12, NOTE_FINANCIALSUPPORTCURRENT5, '+
    'NOTE_RESIDENTIALSETTINGPASTTWELVEOCCURENCES17, NOTE_RESIDENTIALSETTINGPASTTWELVEOCCURENCES6, '+    
    'NOTE_EDUCATIONCODEWEEKS6, NOTE_PROVIDERSITE, NOTE_EDUCATIONRECOVERYGOALS, '+
    'NOTE_EMPLOYMENTSTATUSCURRENTAVGHRSWEEK3, NOTE_EMPLOYMENTSTATUSCURRENTHRWAGE3, '+
    'NOTE_ABUSESERVICES, NOTE_EDUCATIONCODECURRENTLY5, NOTE_FINANCIALSUPPORTPASTTWELVE13, '+
    'NOTE_RESIDENTIALSETTINGPASTTWELVEDAYS20, NOTE_RESIDENTIALSETTINGPASTTWELVEDAYS10, '+
    'NOTE_EMPLOYMENTSTATUSCURRENTAVGHRSWEEK5, NOTE_PROBPRIOR12, NOTE_EDUCATIONCODEWEEKS4, '+
    'NOTE_RESIDENTIALSETTINGPRIOR18, NOTE_RESIDENTIALSETTINGPASTTWELVEOCCURENCES13, '+
    'NOTE_RESIDENTIALSETTINGPASTTWELVEOCCURENCES9, NOTE_RESIDENTIALSETTINGPASTTWELVEOCCURENCES1, '+
    'NOTE_RESIDENTIALSETTINGPRIOR8, NOTE_ARRESTPAST12, NOTE_FINANCIALSUPPORTCURRENT2, '+
    'NOTE_RESIDENTIALSETTINGPRIOR17, NOTE_RESIDENTIALSETTINGPASTTWELVEOCCURENCES14, '+
    'NOTE_RESIDENTIALSETTINGPASTTWELVEDAYS21, NOTE_EMPLOYMENTSTATUSPAST12NUMWEEKS1, '+
    'NOTE_CHILDRENTOTALFOSTER, NOTE_EMPLOYMENTSTATUSCURRENTHRWAGE6, NOTE_EDUCATIONCODECURRENTLY4, '+    
    'NOTE_FINANCIALSUPPORTPASTTWELVE14, NOTE_RESIDENTIALSETTINGPRIOR3, '+
    'NOTE_FINANCIALSUPPORTPASTTWELVE3, NOTE_EMPLOYMENTSTATUSPAST12NUMWEEKS3, '+
    'NOTE_RESIDENTIALSETTINGPASTTWELVEOCCURENCES18, NOTE_EMPLOYMENTSTATUSCURRENTAVGHRSWEEK1, '+
    'NOTE_RESIDENTIALSETTINGPASTTWELVEOCCURENCES10, NOTE_EMPLOYMENTSTATUSCURRENTHRWAGE2, '+
    'NOTE_FINANCIALSUPPORTCURRENT3, NOTE_RESIDENTIALSETTINGPASTTWELVEOCCURENCES15, '+
    'NOTE_RESIDENTIALSETTINGPASTTWELVEOCCURENCES2, NOTE_EDUCATIONCODEWEEKS2, '+
    'NOTE_RESIDENTIALSETTINGPASTTWELVEDAYS13, NOTE_RESIDENTIALSETTINGPRIOR4, '+
    'NOTE_EMPLOYMENTSTATUSCURRENTAVGHRSWEEK4, NOTE_EDUCATIONCODEWEEKS3, '+
    'NOTE_EDUCATIONCODECURRENTLY1, NOTE_EMPLOYMENTSTATUSCURRENTAVGHRSWEEK2, NOTE_COORDINATORID, '+
    'NOTE_FINANCIALSUPPORTPASTTWELVE8, NOTE_FINANCIALSUPPORTPASTTWELVE15, '+
    'NOTE_RESIDENTIALSETTINGPRIOR2, NOTE_FINANCIALSUPPORTPASTTWELVE5, NOTE_PROBPAST12, '+
    'NOTE_RESIDENTIALSETTINGPASTTWELVEDAYS16, NOTE_RESIDENTIALSETTINGYESTERDAY, '+
    'NOTE_RESIDENTIALSETTINGPASTTWELVEOCCURENCES19, NOTE_RESIDENTIALSETTINGPASTTWELVEOCCURENCES5, '+    
    'NOTE_PAROLECURR, NOTE_COUNTYPROGRAMID, NOTE_EDUCATIONCODEWEEKS5, NOTE_PHYRELATED, '+
    'NOTE_RESIDENTIALSETTINGPRIOR5, NOTE_FINANCIALSUPPORTPASTTWELVE9, '+
    'NOTE_EMPLOYMENTSTATUSCURRENTAVGHRSWEEK6, NOTE_EMPLOYMENTSTATUSPAST12NUMWEEKS5, '+
    'NOTE_PHYSICIANPAST12, NOTE_ASSESSMENTDATE, NOTE_FINANCIALSUPPORTPASTTWELVE16, '+
    'NOTE_RESIDENTIALSETTINGPRIOR1, NOTE_RESIDENTIALSETTINGPASTTWELVEOCCURENCES8, '+
    'NOTE_RESIDENTIALSETTINGPRIOR9, NOTE_RESIDENTIALSETTINGPASTTWELVEDAYS18, NOTE_PROBCURR, '+
    'NOTE_RESIDENTIALSETTINGPASTTWELVEOCCURENCES16, NOTE_EMPLOYMENTSTATUSPAST12NUMWEEKS7, '+
    'NOTE_FINANCIALSUPPORTPASTTWELVE2, NOTE_RESIDENTIALSETTINGPRIOR20, '+
    'NOTE_RESIDENTIALSETTINGPRIOR21, NOTE_RESIDENTIALSETTINGPASTTWELVEDAYS12, '+
    'NOTE_CHILDRENTOTALADOPTED, NOTE_CONSERVCURR, NOTE_EMPLOYED, NOTE_MENRELATED, '+
    'NOTE_EMPLOYMENTSTATUSCURRENTHRWAGE1, NOTE_AB2034, NOTE_CONSERVPRIOR12, '+
    'NOTE_RESIDENTIALSETTINGPASTTWELVEDAYS19, NOTE_EDUCATIONCODECURRENTLY3, '+
    'NOTE_EMPLOYMENTSTATUSPAST12NUMWEEKS2, NOTE_EMPLOYMENTSTATUSPAST12AVGHRSWEEK2, '+
    'NOTE_FINANCIALSUPPORTPASTTWELVE17, NOTE_CHILDRENTOTALREUNIFIED, '+
    'NOTE_EMPLOYMENTSTATUSPAST12AVGHRSWEEK6, NOTE_EMPLOYMENTSTATUSPAST12AVGHRSWEEK5, '+
    'NOTE_EMPLOYMENTSTATUSPAST12AVGHRSWEEK4, NOTE_EMPLOYMENTSTATUSPAST12AVGHRSWEEK3, '+
    'NOTE_RESIDENTIALSETTINGPRIOR19, NOTE_EMPLOYMENTSTATUSPAST12AVGHRSWEEK1, '+
    'NOTE_RESIDENTIALSETTINGPRIOR10, NOTE_RESIDENTIALSETTINGPRIOR11, '+
    'NOTE_RESIDENTIALSETTINGPRIOR12, NOTE_RESIDENTIALSETTINGPRIOR13, '+
    'NOTE_RESIDENTIALSETTINGPRIOR14, NOTE_RESIDENTIALSETTINGPRIOR15, '+
    'NOTE_RESIDENTIALSETTINGPRIOR16, NOTE_FINANCIALSUPPORTCURRENT6, NOTE_GRADESCURR, '+
    'NOTE_GRADESPAST12, NOTE_RESIDENTIALSETTINGPASTTWELVEDAYS25, '+
    'NOTE_RESIDENTIALSETTINGPASTTWELVEDAYS26, NOTE_RESIDENTIALSETTINGPASTTWELVEDAYS27, '+
    'NOTE_RESIDENTIALSETTINGPASTTWELVEDAYS22, NOTE_RESIDENTIALSETTINGPASTTWELVEDAYS23, '+
    'NOTE_FINANCIALSUPPORTCURRENT18, NOTE_SUSPENSIONPAST12, NOTE_DYNRADIOBUTTON22, '+
    'NOTE_FINANCIALSUPPORTPASTTWELVE18, NOTE_DYNRADIOBUTTON19, NOTE_DYNRADIOBUTTON152, '+
    'NOTE_DYNRADIOBUTTON154, NOTE_DYNRADIOBUTTON155, NOTE_DYNRADIOBUTTON97, NOTE_DYNRADIOBUTTON96, '+
    ''+
    'NOTE_DYNRADIOBUTTON94, NOTE_DYNRADIOBUTTON92, NOTE_DYNRADIOBUTTON86, NOTE_DYNRADIOBUTTON87, '+
    'NOTE_DYNRADIOBUTTON84, NOTE_EXPULSIONPAST12, NOTE_DYNRADIOBUTTON88, NOTE_DYNRADIOBUTTON89, '+
    'NOTE_RESIDENTIALSETTINGPASTTWELVEOCCURENCES23, NOTE_RESIDENTIALSETTINGPASTTWELVEOCCURENCES22, '+
    ''+
    'NOTE_RESIDENTIALSETTINGPASTTWELVEDAYS24, NOTE_TAYPROGRAM, NOTE_DYNRADIOBUTTON113, '+
    'NOTE_DYNRADIOBUTTON151, NOTE_DYNRADIOBUTTON111, NOTE_DYNRADIOBUTTON55, NOTE_DYNRADIOBUTTON54, '+
    ''+
    'NOTE_DYNRADIOBUTTON1, NOTE_ATTENDANCECURR, NOTE_DYNRADIOBUTTON18, NOTE_DYNRADIOBUTTON17, '+
    'NOTE_DYNRADIOBUTTON109, NOTE_DYNRADIOBUTTON108, NOTE_DYNRADIOBUTTON107, '+
    'NOTE_DYNRADIOBUTTON106, NOTE_DYNRADIOBUTTON105, NOTE_DYNRADIOBUTTON104, '+
    'NOTE_DYNRADIOBUTTON103, NOTE_DYNRADIOBUTTON102, NOTE_DYNRADIOBUTTON101, '+
    'NOTE_DYNRADIOBUTTON100, NOTE_DYNRADIOBUTTON93, NOTE_DYNRADIOBUTTON91, NOTE_DYNRADIOBUTTON90, '+    
    'NOTE_DYNRADIOBUTTON99, NOTE_DYNRADIOBUTTON98, NOTE_DYNRADIOBUTTON82, NOTE_DYNRADIOBUTTON110, '+    
    'NOTE_DYNRADIOBUTTON20, NOTE_DYNRADIOBUTTON21, NOTE_DEPENYEAR, NOTE_DYNRADIOBUTTON85, '+
    'NOTE_DYNRADIOBUTTON16, NOTE_DYNRADIOBUTTON15, NOTE_DYNRADIOBUTTON14, NOTE_DYNRADIOBUTTON13, '+
    'NOTE_RESIDENTIALSETTINGPRIOR22, NOTE_RESIDENTIALSETTINGPRIOR23, '+
    'NOTE_RESIDENTIALSETTINGPRIOR26, NOTE_RESIDENTIALSETTINGPRIOR27, '+
    'NOTE_RESIDENTIALSETTINGPRIOR24, NOTE_RESIDENTIALSETTINGPRIOR25, NOTE_DYNRADIOBUTTON153, '+
    'NOTE_DYNRADIOBUTTON150, NOTE_ATTENDANCEPAST12, NOTE_RESIDENTIALSETTINGPASTTWELVEOCCURENCES25, '+
    ''+
    'NOTE_RESIDENTIALSETTINGPASTTWELVEOCCURENCES24, NOTE_RESIDENTIALSETTINGPASTTWELVEOCCURENCES27, '+
    ''+
    'NOTE_RESIDENTIALSETTINGPASTTWELVEOCCURENCES26, NOTE_DYNRADIOBUTTON95, NOTE_DYNRADIOBUTTON83, '+    
    'NOTE_CGSTAFFNUMBER, NOTE_ADLFEEDING, NOTE_ADLTRANSFER, NOTE_ADLWALKING, NOTE_IADLMEDICATION, '+    
    'NOTE_ADLBATHING, NOTE_IADLWALKING, NOTE_IADLTELEPHONE, NOTE_IADLMEALS, NOTE_ADLTOILETING, '+
    'NOTE_ADLDRESSING, NOTE_IADLHOUSEWORK, NOTE_IADLLAUNDRY, NOTE_ADLCONTINENCE, NOTE_ADLCONFINE, '+    
    'NOTE_IADLSHOPPING, NOTE_IADLHANDYMAN, NOTE_IADLMONEY, NOTE_MHSA, '+
    'NOTE_FINANCIALSUPPORTCURRENT19, NOTE_FINANCIALSUPPORTPASTTWELVE19 FROM '+
    'Reporting.dbo.[PAF]'
  /ASSUMEDSTRWIDTH=255.
CACHE.
exe.

Compute AssessmentDate=num(note_AssessmentDate,adate10) .	
formats AssessmentDate(adate10).

rename vars 
client_number =Case 
reporting_unit=RU opening_date=opdate.

sort cases by ru.
match files/table='//covenas/spssdata/ruTableRU2.sav' /file=* /by ru.
if ru2 ne " " Ru = RU2.
sort cases by ru.
match files/table='//covenas/spssdata/ruTableRU2.sav' /file=* /by ru.

sort cases by ru case opdate.
match files /table='//covenas/decisionsupport/epsCG.sav' /file=* /by ru case opdate /drop primdx refsrce primarytherapist lst_svc epflag.
sort cases by case opdate.

*per Kate Cordell - partner status needs to use the first opdate when multiple opdates.
if lag(case)=case and  opdate ne lag(opdate) and datediff(opdate,lag(closdate),'years') ge 1 opdate=lag(opdate).

*check*.

Rename Variables PAFrow_id = PafStamp.

*convert to state requirements.

* Assigns FSPName to each RU.
String FSPName (a20).
if RU="018435" FSPName="FSP-3 STAY".
if RU="01EE1" FSPName="FSP-1 HOST".
if RU="01EG1"   FSPName="FSP-4 GH".
if RU="01EM1" FSPName="FSP-2 NCSHP".
if RU="81486"  FSPName="FSP-5 FACT".
if RU="88036" FSPName="FSP-6 TIP".
if RU="81487" FSPName="FSP-9 TRACT".
if RU="01FZ1" FSPName="FSP-7 CHOICES".
if RU="01028" FSPName="FSP-7 CHOICES".
if RU="0108T1" FSPName="FSP-7 CHOICES".
if RU="01221" FSPName="FSP-7 CHOICES".
if RU= "01911" FSPName="FSP-7 CHOICES".
if RU="8133T1" FSPName="FSP-7 CHOICES".
if RU="01333" FSPName="FSP-7 CHOICES".
if RU="01EE2" FSPName="FSP-7 CHOICES".
*below are new - added 5/15/12.
if RU="01521" FSPName="FSP-7 CHOICES".
if RU="0152M1" FSPName="FSP-7 CHOICES".
if RU="0112T1" FSPName="FSP-7 CHOICES".
if RU="0112T2" FSPName="FSP-7 CHOICES".
if RU="0112M1" FSPName="FSP-7 CHOICES".
if RU="0170T1" FSPName="FSP-7 CHOICES".
if RU="0170T2" FSPName="FSP-7 CHOICES".
if RU="01113" FSPName="FSP-7 CHOICES".


*Check to make sure all RU's have FSPNames.
 * temp. 
 * Select if FSPName=' '.
*freq ru.
*If there are any problems, add the fix to the ru fixing section.

 Rename Variables NOTE_REFERREDBY =ReferredBy.
 Rename Variables NOTE_AB2034 =AB2034.
 Rename Variables NOTE_ABUSESERVICES =AbuseServices.
 Rename Variables NOTE_ACTIVEPROBLEM =ActiveProblem.
 Rename Variables NOTE_MENTALILLNESS =CoOccurringEver.
 Rename Variables NOTE_ADLBATHING =Bathing.
 Rename Variables NOTE_ADLCONFINE =ConfinementHouse.
 Rename Variables NOTE_ADLCONTINENCE =Continence.
 Rename Variables NOTE_ADLDRESSING =Dressing.
 Rename Variables NOTE_ADLFEEDING =Feeding.
 Rename Variables NOTE_ADLTOILETING =Toileting.
 Rename Variables NOTE_ADLTRANSFER =Transfer.
 Rename Variables NOTE_ADLWALKING =Walking.
 Rename Variables NOTE_ARRESTPAST12 =ArrestPast12.
 Rename Variables NOTE_ARRESTPRIOR12 =ArrestPrior12.
 rename variables NOTE_ATTENDANCECURR = AttendanceCurr.
 rename variables NOTE_ATTENDANCEPAST12 = AttendancePast12.
 Rename Variables NOTE_CHILDRENTOTALADOPTED =KidsAdopt.
 Rename Variables NOTE_CHILDRENTOTALFOSTER =KidsFoster.
 Rename Variables NOTE_CHILDRENTOTALREUNIFIED =KidsReunif.
 Rename Variables NOTE_CHILDRENTOTALWI300 =KidsWI300.

Rename Variables NOTE_CONSERVCURR =ConservCurr.
Rename Variables NOTE_CONSERVPAST12 =ConservPast12.
Rename Variables NOTE_CONSERVPRIOR12 =ConservPrior12.

 *  Rename Variables NOTE_DEPENCURR =DependentCourtCurr.
 *  Rename Variables NOTE_DEPENPAST12 =DependentCourtPast12.
 *  Rename Variables NOTE_DEPENPRIOR12 =DependentCourtPrior.
Rename Variables NOTE_DEPENYEAR =DependentCourtYear.

 * Rename Variables NOTE_EMOTIONALDISTURBANCE =specialEDSED.
Rename Variables NOTE_EDUCATIONRECOVERYGOALS =educationrecoverygoal.

Rename Variables NOTE_PAROLECURR =ParoleCurr.
 Rename Variables NOTE_PAROLEPAST12 =ParolePast12.
 Rename Variables NOTE_PAROLEPRIOR12 =ParolePrior12.
 Rename Variables NOTE_PAYEECURR =PayeeCurr.
 Rename Variables NOTE_PAYEEPAST12 =PayeePast12.
 Rename Variables NOTE_PAYEEPRIOR12 =PayeePrior12.
 Rename Variables NOTE_PHYRELATED =PhyRelated.
 Rename Variables NOTE_PHYSICIANCURR =PhysicianCurr.
 Rename Variables NOTE_PHYSICIANPAST12 =PhysicianPast12.
 Rename Variables NOTE_PROBCURR =ProbationCurr.
 Rename Variables NOTE_PROBPAST12 =ProbationPast12.
 Rename Variables NOTE_PROBPRIOR12 =ProbationPrior12.
 Rename Variables NOTE_PROVIDERSITE =ProviderSite.
 Rename Variables NOTE_RECOVERYGOALS =EmploymentRecoveryGoals.
 Rename Variables NOTE_SUSPENSIONPAST12 =SuspensionPast12.
 Rename Variables NOTE_TAYPROGRAM =TAYProgram.


*****************EDUCATION.
 Rename Variables NOTE_EDUCATIONCODECURRENTLY1 =NotSchlC.
 Rename Variables NOTE_EDUCATIONCODECURRENTLY2 =HSAdEdC.
 Rename Variables NOTE_EDUCATIONCODECURRENTLY3 =TechVocC.
 Rename Variables NOTE_EDUCATIONCODECURRENTLY4 =CollegeC.
 Rename Variables NOTE_EDUCATIONCODECURRENTLY5 =GradSchC.
 Rename Variables NOTE_EDUCATIONCODECURRENTLY6 =OtherEdC.
 Rename Variables NOTE_EDUCATIONCODEWEEKS1 =NotSchlWk.
 Rename Variables NOTE_EDUCATIONCODEWEEKS2 =HSAdEdWk.
 Rename Variables NOTE_EDUCATIONCODEWEEKS3 =TechVocWk.
 Rename Variables NOTE_EDUCATIONCODEWEEKS4 =CollegeWk.
 Rename Variables NOTE_EDUCATIONCODEWEEKS5 =GradSchWk.
 Rename Variables NOTE_EDUCATIONCODEWEEKS6 =OtherEdWk.
 Rename Variables NOTE_EDUCATIONGRADE =EduHighGrade.

string CurrentSchoolSetting(a22).
if NotSchlC = "True" CurrentSchoolSetting ="Not in School".
if HSAdEdC = "True" CurrentSchoolSetting="HighSchol".
if techvocc = "True" CurrentSchoolSetting="Tech or Vocational".
if collegec = "True" CurrentSchoolSetting="College".
if gradschc = "True" CurrentSchoolSetting="Graduate School".
if otheredc = "True" CurrentSchoolSetting="Other".
if CurrentSchoolSetting = " " CurrentSchoolSetting="NoData".

*recode notSchlWk (convert) into notSchlWkYesNo.
*EXECUTE.
*recode HSAdEdWk (convert) into HSAdEdWkYesNo.
*EXECUTE.
*recode TechVocWk (convert) into TechVocWkYesNo.
*recode CollegeWk (convert) into CollegeWkYesNo.
*recode GradSchWk (convert) into GradSchWkYesNo.
*recode OtherEdWk (convert) into OtherEdWkYesNo.
*EXECUTE.

string SchoolPast12(a3).


if num(notSchlWk,f1) ge 1 SchoolPast12 = 'No'.
if num(HSAdEdWk,f1) ge 1 SchoolPast12 = 'Yes'.
if num(TechVocWk,f1) ge 1 SchoolPast12 = 'Yes'.
if num(CollegeWk,f1) ge 1 SchoolPast12 = 'Yes'.
if num(GradSchWk,f1) ge 1 SchoolPast12 = 'Yes'.
if num(OtherEdWk,f1) ge 1 SchoolPast12 = 'Yes'.

string RecoveryGoalsEducation(a3).

if educationrecoverygoal="True" RecoveryGoalsEducation="Yes".
if educationrecoverygoal="False" RecoveryGoalsEducation="No".

*freq EduHighGrade.

**these conversions take care of TAY also-- need to keep adding as new fields appear.

string EducHighGradeTextCONVERTED(a64).
if any(EduHighGrade,"Day Care", "Pre-School", "Kindergarten", "1st Grade", "2nd Grade", "3rd Grade", 
"4th Grade", "5th Grade", "6th Grade", "7th Grade","8th Grade","9th Grade", "10th Grade", "11th Grade", 
"Level Unknown (e.g., youth in non-public school)" ) 
	EducHighGradeTextCONVERTED= "No High School Diploma / No GED coursework".

if any(EduHighGrade,"12th Grade")
	EducHighGradeTextCONVERTED="High School Diploma / GED".

if any (EduHighGrade,"Some College" ,"Less than 2 years college / Some Technical / Vocational Training") 
EducHighGradeTextCONVERTED= "Some College/Some Technical or Voc Training".

if any(EduHighGrade, "AA degree", "Technical/Vocational Degree") 
EducHighGradeTextCONVERTED= "Associate's /Technical or Vocational Degree".


if EducHighGradeTextCONVERTED= " "  EducHighGradeTextCONVERTED=EduHighGrade.

* check for any EducHighGrade that is not on Adult PAF form.
*freq EducHighGradeTextCONVERTED.

if EducHighGradeTextCONVERTED="No High School Diploma / No GED coursework" EducLevel=0.
if EducHighGradeTextCONVERTED="GED Coursework" EducLevel=1.
if EducHighGradeTextCONVERTED="High School Diploma / GED" EducLevel=2.
if EducHighGradeTextCONVERTED="Some College/Some Technical or Voc Training" EducLevel=3.
if EducHighGradeTextCONVERTED="Associate's /Technical or Vocational Degree" EducLevel=4.
**NEED ORIG AA degree text here once it comes over (this is the diff text from the TAY form).
if EducHighGradeTextCONVERTED="Bachelor's Degree (B.A., B.S.)" EducLevel=5.
if EducHighGradeTextCONVERTED="Master's degree (e.g., M.A., M.S.W.)" EducLevel=6.
if EducHighGradeTextCONVERTED="Doctoral degree (e.g., M.D., Ph.D.)" EducLevel=7.

*freq educLevel.
temp.
select if missing(EducLevel).
EXECUTE.
aggregate outfile =* Mode=AddVariables 
	/break=case 
	/EducLevelHighPAF= max(EducLevel).

string EducLevelHighTextPAF(a50).
if EducLevelHighPAF=0 EducLevelHighTextPAF="No High School Diploma / No GED coursework".
if EducLevelHighPAF=1 EducLevelHighTextPAF="GED Coursework".
if EducLevelHighPAF=2 EducLevelHighTextPAF="High School Diploma / GED".
if EducLevelHighPAF=3 EducLevelHighTextPAF="Some College/Some Technical or Voc Training".
if EducLevelHighPAF=4 EducLevelHighTextPAF="Associate's /Technical or Vocational Degree".
if EducLevelHighPAF=5 EducLevelHighTextPAF="Bachelor's Degree (B.A., B.S.)".
if EducLevelHighPAF=6 EducLevelHighTextPAF="Master's degree (e.g., M.A., M.S.W.)".
if EducLevelHighPAF=7 EducLevelHighTextPAF="Doctoral degree (e.g., M.D., Ph.D.)".


rename variables eduhighgrade = gradetext.

sort cases by gradetext.
match files /table = '//covenas/decisionsupport/meinzer/tables/gradetext.sav' /file=* /by gradetext.
*freq grade.

*****************EMPLOYMENT.
*** Employment Current.

if Note_employed="True" Unemployed=1.
if Note_Employed="False" Unemployed=0.
 *Rename Variables NOTE_EMPLOYED =Unemployed.
 Rename Variables NOTE_EMPLOYMENTSTATUSCURRENTAVGHRSWEEK1 =EmpCompetHr.
 Rename Variables NOTE_EMPLOYMENTSTATUSCURRENTAVGHRSWEEK2 =EmpSuptHr.
 Rename Variables NOTE_EMPLOYMENTSTATUSCURRENTAVGHRSWEEK3 =EmpTransHr.
 Rename Variables NOTE_EMPLOYMENTSTATUSCURRENTAVGHRSWEEK4 =EmpPdInHseHr.
 Rename Variables NOTE_EMPLOYMENTSTATUSCURRENTAVGHRSWEEK5 =EmpVolHr.
 Rename Variables NOTE_EMPLOYMENTSTATUSCURRENTAVGHRSWEEK6 =EmpOtherHr.

 Rename Variables NOTE_EMPLOYMENTSTATUSCURRENTHRWAGE1 =EmpCompetWg.
 Rename Variables NOTE_EMPLOYMENTSTATUSCURRENTHRWAGE2 =EmpSuptWg.
 Rename Variables NOTE_EMPLOYMENTSTATUSCURRENTHRWAGE3 =EmpTransWg.
 Rename Variables NOTE_EMPLOYMENTSTATUSCURRENTHRWAGE4 =EmpPdInHseWg.
 Rename Variables NOTE_EMPLOYMENTSTATUSCURRENTHRWAGE6 =EmpOtherWg.

*freq unemployed.


string EmploymentTypeCurr(a40).

if Unemployed=1 EmploymentLevelCurr=0.
if missing(employmentLevelCurr) EmploymentLevelCurr=0.
if EmploymentLevelCurr=0 EmploymentTypeCurr="Unemployed".

if number(EmpVolHr,f1) gt 0 EmploymentLevelCurr=1.
if EmploymentLevelCurr=1 EmploymentTypeCurr="Volunteer Experience".

if number(EmpOtherHr,f1) gt 0 EmploymentLevelCurr=2 .
if EmploymentLevelCurr=2 EmploymentTypeCurr="Other Gainful Employ Activity".

if Number(EmpPdInHseHr,f1) gt 0 EmploymentLevelCurr=3.
if EmploymentLevelCurr=3 EmploymentTypeCurr="Paid In-House/Work Experience".

if Number(EmpTransHr,f1) gt 0 EmploymentLevelCurr=4.
if EmploymentLevelCurr=4 EmploymentTypeCurr="Transitional/Enclave".

if Number(EmpSuptHr,f1) gt 0 EmploymentLevelCurr=5.
if EmploymentLevelCurr=5 EmploymentTypeCurr="Supported".

if Number(EmpCompetHr,f1) gt 0 EmploymentLevelCurr=6.
if EmploymentLevelCurr=6 EmploymentTypeCurr="Competitive".

if missing(employmentLevelCurr) EmploymentLevelCurr=0.
if EmploymentLevelCurr=0 EmploymentTypeCurr="Unemployed".


Compute CompSalary=number(EmpCompetHr, f4)*Number(EmpCompetWg, f4).
Compute SuppSalary=number(EmpSuptHr, f4)*number(EmpSuptWg, f4).
Compute TransSalary=number(EmpTransHr, f4)*number(EmpTransWg, f4).
COmpute InHouseSalary=number(EmpPdInHseHr, f4)*number(EmpPdInHseWg, f4).
Compute OtherSalary=number(EmpOtherHr, f4)*number(EmpOtherWg, f4).

compute AvgWeeklySalaryCurr=sum(compSalary, SuppSalary, TransSalary, InHouseSalary, OTherSalary).
*freq avgWeeklySalaryCurr.

aggregate outfile =* Mode=AddVariables 
/break=case 
/EmpLevelHighCurrPAF = max(EmploymentLevelCurr).

String EmpTypeHighCurrPAF (a40).
if EmpLevelHighCurrPAF =0 EmpTypeHighCurrPAF="Unemployed".
if EmpLevelHighCurrPAF =.5 EmpTypeHighCurrPAF="Employed but No Hours Recorded".
if EmpLevelHighCurrPAF =1 EmpTypeHighCurrPAF="Volunteer Experience".
if EmpLevelHighCurrPAF =2 EmpTypeHighCurrPAF="Other Gainful Employ Activity".
if EmpLevelHighCurrPAF =3 EmpTypeHighCurrPAF="Paid In-House/Work Experience".
if EmpLevelHighCurrPAF =4 EmpTypeHighCurrPAF="Transitional/Enclave".
if EmpLevelHighCurrPAF =5 EmpTypeHighCurrPAF="Supported".
if EmpLevelHighCurrPAF =6 EmpTypeHighCurrPAF="Competitive".



***Employment Past 12.
rename vars NOTE_EMPLOYMENTSTATUSPAST12AVGHRSWEEK1=EmpCompetHrPastYr.
rename vars  NOTE_EMPLOYMENTSTATUSPAST12AVGHRSWEEK2=EmpSuptHrPastYr.
rename vars NOTE_EMPLOYMENTSTATUSPAST12AVGHRSWEEK3=EmpTransHrPastYr.
rename vars NOTE_EMPLOYMENTSTATUSPAST12AVGHRSWEEK4=EmpPdInHseHrPastYr.
rename vars NOTE_EMPLOYMENTSTATUSPAST12AVGHRSWEEK5=EmpVolHrPastYr.
rename vars NOTE_EMPLOYMENTSTATUSPAST12AVGHRSWEEK6=EmpOtherHrPastYr.

rename vars NOTE_EMPLOYMENTSTATUSPAST12NUMWEEKS7=EmpUnempWksPastYr.

rename vars NOTE_EMPLOYMENTSTATUSPAST12HRWAGE1=EmpCompetWgPastYr.
rename vars NOTE_EMPLOYMENTSTATUSPAST12HRWAGE2=EmpSuptWgPastYr.
rename vars NOTE_EMPLOYMENTSTATUSPAST12HRWAGE3=EmpTransWgPastYr.
rename vars NOTE_EMPLOYMENTSTATUSPAST12HRWAGE4=EmpPdInHseWgPastYr.
rename vars NOTE_EMPLOYMENTSTATUSPAST12HRWAGE6=EmpOtherWgPastYr.

if number(EmpUnempWksPastYr, f2) gt 0 unempPast12=1.

string EmploymentTypePastYr(a40).
if unempPast12=1 EmploymentLevelPastYr=0.
if EmploymentLevelPastYr=0 EmploymentTypePastYr="Unemployed".

if number(EmpVolHrPastYr,f1) gt 0 EmploymentLevelPastYr=1.
if EmploymentLevelPastYr=1 EmploymentTypePastYr="Volunteer Experience".

if number(EmpOtherHrPastYr,f1) gt 0 EmploymentLevelPastYr=2 .
if EmploymentLevelPastYr=2 EmploymentTypePastYr="Other Gainful Employ Activity".

if Number(EmpPdInHseHrPastYr,f1) gt 0 EmploymentLevelPastYr=3.
if EmploymentLevelPastYr=3 EmploymentTypePastYr="Paid In-House/Work Experience".

if Number(EmpTransHrPastYr,f1) gt 0 EmploymentLevelPastYr=4.
if EmploymentLevelPastYr=4 EmploymentTypePastYr="Transitional/Enclave".

if Number(EmpSuptHrPastYr,f1) gt 0 EmploymentLevelPastYr=5.
if EmploymentLevelPastYr=5 EmploymentTypePastYr="Supported".

if Number(EmpCompetHrPastYr,f1) gt 0 EmploymentLevelPastYr=6.
if EmploymentLevelPastYr=6 EmploymentTypePastYr="Competitive".

if missing(EmploymentLevelPastYr) EmploymentLevelPastYr=0.
if EmploymentLevelPastYr=0 EmploymentTypePastYr="Unemployed".

*freq EmploymentLevelPastYr. 

Compute CompSalaryPastYr=number(EmpCompetHrPastYr, f4)*Number(EmpCompetWgPastYr, f4).
Compute SuppSalaryPastYr=number(EmpSuptHrPastYr, f4)*number(EmpSuptWgPastYr, f4).
Compute TransSalaryPastYr=number(EmpTransHrPastYr, f4)*number(EmpTransWgPastYr, f4).
COmpute InHouseSalaryPastYr=number(EmpPdInHseHrPastYr, f4)*number(EmpPdInHseWgPastYr, f4).
Compute OtherSalaryPastYr=number(EmpOtherHrPastYr, f4)*number(EmpOtherWgPastYr, f4).

compute AvgWeeklySalaryPastYr=sum(compSalaryPastYr, SuppSalaryPastYr, TransSalaryPastYr, InHouseSalaryPastYr, OTherSalaryPastYr).
*freq avgWeeklySalaryPastYr.

aggregate outfile =* Mode=AddVariables 
/break=case 
/EmpLevelHighPastYrPAF = max(EmploymentLevelPastYr).

String EmpTypeHighPastYrPAF (a40).
if EmpLevelHighPastYrPAF =0 EmpTypeHighPastYrPAF="Unemployed".
if EmpLevelHighPastYrPAF =.5 EmpTypeHighPastYrPAF="Employed but No Hours Recorded".
if EmpLevelHighPastYrPAF =1 EmpTypeHighPastYrPAF="Volunteer Experience".
if EmpLevelHighPastYrPAF =2 EmpTypeHighPastYrPAF="Other Gainful Employ Activity".
if EmpLevelHighPastYrPAF =3 EmpTypeHighPastYrPAF="Paid In-House/Work Experience".
if EmpLevelHighPastYrPAF =4 EmpTypeHighPastYrPAF="Transitional/Enclave".
if EmpLevelHighPastYrPAF =5 EmpTypeHighPastYrPAF="Supported".
if EmpLevelHighPastYrPAF =6 EmpTypeHighPastYrPAF="Competitive".


string RecoveryGoalsEmployment(a3).

if EmploymentRecoveryGoals = "True" RecoveryGoalsEmployment="Yes".
if EmploymentRecoveryGoals = "False" RecoveryGoalsEmployment="No".


*****************INCOME.
 Rename Variables NOTE_FINANCIALSUPPORTCURRENT1 =WagesCur.
 Rename Variables NOTE_FINANCIALSUPPORTCURRENT2 =SpouseWagesCur.
 Rename Variables NOTE_FINANCIALSUPPORTCURRENT3 =SavingsCur.
 Rename Variables NOTE_FINANCIALSUPPORTCURRENT4 =FamFriendCur.
 Rename Variables NOTE_FINANCIALSUPPORTCURRENT5 =SSIRetireCur.
 Rename Variables NOTE_FINANCIALSUPPORTCURRENT6 =VetBenCur.
 Rename Variables NOTE_FINANCIALSUPPORTCURRENT7 =LoanCur.
 Rename Variables NOTE_FINANCIALSUPPORTCURRENT8 =HousSubsidyCur.
 Rename Variables NOTE_FINANCIALSUPPORTCURRENT9 =GACur.
 Rename Variables NOTE_FINANCIALSUPPORTCURRENT10 =FoodStCur.
 Rename Variables NOTE_FINANCIALSUPPORTCURRENT11 =TANFCur.
 Rename Variables NOTE_FINANCIALSUPPORTCURRENT12 =SSICur.
 Rename Variables NOTE_FINANCIALSUPPORTCURRENT13 =SSDICur.
 Rename Variables NOTE_FINANCIALSUPPORTCURRENT14 =SDICur.
 Rename Variables NOTE_FINANCIALSUPPORTCURRENT15 =TribalBenCur.
 Rename Variables NOTE_FINANCIALSUPPORTCURRENT16 =OtherCur.


 Rename Variables NOTE_FINANCIALSUPPORTPASTTWELVE1 =WagesPast.
  Rename Variables NOTE_FINANCIALSUPPORTPASTTWELVE2 =SpouseWagesPast.
 Rename Variables NOTE_FINANCIALSUPPORTPASTTWELVE3 =SavingsPast.
 Rename Variables NOTE_FINANCIALSUPPORTPASTTWELVE4 =FamFriendPast.
 Rename Variables NOTE_FINANCIALSUPPORTPASTTWELVE5 =SSIRetirePast.
 Rename Variables NOTE_FINANCIALSUPPORTPASTTWELVE6 =VetBenPast.
 Rename Variables NOTE_FINANCIALSUPPORTPASTTWELVE7 =LoanPast.
 Rename Variables NOTE_FINANCIALSUPPORTPASTTWELVE8 =HousSubsidyPast.
 Rename Variables NOTE_FINANCIALSUPPORTPASTTWELVE9 =GAPast.
Rename Variables NOTE_FINANCIALSUPPORTPASTTWELVE10 =FoodStPast.
 Rename Variables NOTE_FINANCIALSUPPORTPASTTWELVE11 =TANFPast.
 Rename Variables NOTE_FINANCIALSUPPORTPASTTWELVE12 =SSIPast.
 Rename Variables NOTE_FINANCIALSUPPORTPASTTWELVE13 =SSDIPast.
 Rename Variables NOTE_FINANCIALSUPPORTPASTTWELVE14 =SDIPast.
 Rename Variables NOTE_FINANCIALSUPPORTPASTTWELVE15 =TribalBenPast.
 Rename Variables NOTE_FINANCIALSUPPORTPASTTWELVE16 =OtherPast.
Rename Variables NOTE_GRADESCURR=GradesCurr.
Rename Variables NOTE_GRADESPAST12 =GradesPast12.

 Rename Variables NOTE_GHI =GHI.

 Rename Variables NOTE_IADLHANDYMAN =HandymanWork.
 Rename Variables NOTE_IADLHOUSEWORK =Housework.
 Rename Variables NOTE_IADLLAUNDRY =Laundry.
 Rename Variables NOTE_IADLMEALS =MealPreparation.
 Rename Variables NOTE_IADLMEDICATION =MedicationSelf.
 Rename Variables NOTE_IADLMONEY =MoneyMangage.
 Rename Variables NOTE_IADLSHOPPING =ShoppingFood.
 Rename Variables NOTE_IADLTELEPHONE =TelephoneUse.
 Rename Variables NOTE_IADLWALKING =GoBeyondWalkDist.
 Rename Variables NOTE_MENRELATED =EmergencyMental.


*note below NOTE_MHSA there beginning w 7/30 refresh-- 1st Camille refresh.
 *Rename Variables NOTE_MHSA =MHSA.
 Rename Variables NOTE_MHSAHP =MHSAHP.
 *  Rename Variables NOTE_ANOTHERREASON =SpecialEdOther.



IF NOTE_DYNRADIOBUTTON104 = "True" PayeeCurr="True".
IF NOTE_DYNRADIOBUTTON105 = "True" PayeeCurr="False".
IF NOTE_DYNRADIOBUTTON106 = "True" PayeePast12="True".
IF NOTE_DYNRADIOBUTTON107 = "True" PayeePast12="False".
IF NOTE_DYNRADIOBUTTON108 = "True" PayeePrior12="True".
IF NOTE_DYNRADIOBUTTON109 = "True" PayeePrior12="False".
IF NOTE_DYNRADIOBUTTON110 = "True" PhysicianPast12="True".
IF NOTE_DYNRADIOBUTTON111 = "True" PhysicianPast12="False".
IF NOTE_DYNRADIOBUTTON13 = "True" educationrecoverygoal="True".
IF NOTE_DYNRADIOBUTTON14 = "True" educationrecoverygoal="False".
IF NOTE_DYNRADIOBUTTON15 = "True" PhysicianCurr="True".
 * IF NOTE_DYNRADIOBUTTON150 = "True" DependentCourtCurr="True".
 * IF NOTE_DYNRADIOBUTTON151 = "True" DependentCourtCurr="False".
 * IF NOTE_DYNRADIOBUTTON152 = "True" DependentCourtPast12="True".
 * IF NOTE_DYNRADIOBUTTON153 = "True" DependentCourtPast12="False".
 * IF NOTE_DYNRADIOBUTTON154 = "True" DependentCourtPrior="True".
 * IF NOTE_DYNRADIOBUTTON155 = "True" DependentCourtPrior="False".
IF NOTE_DYNRADIOBUTTON16 = "True" PhysicianCurr="False".
IF NOTE_DYNRADIOBUTTON17 = "True" CoOccurringEver="True".
IF NOTE_DYNRADIOBUTTON18 = "True" CoOccurringEver="False".
IF NOTE_DYNRADIOBUTTON19 = "True" ActiveProblem="True".
IF NOTE_DYNRADIOBUTTON20 = "True" ActiveProblem="False".
IF NOTE_DYNRADIOBUTTON21 = "True" AbuseServices="True".
IF NOTE_DYNRADIOBUTTON22 = "True" AbuseServices="False".
 * IF NOTE_DYNRADIOBUTTON1 = "True" SpecialEdSED="True".
 * IF NOTE_DYNRADIOBUTTON54 = "True" SpecialEdSED="False".
 * IF NOTE_DYNRADIOBUTTON113 = "True" SpecialEdOther="False".
 * IF NOTE_DYNRADIOBUTTON55 = "True" SpecialEdOther="True".
IF NOTE_DYNRADIOBUTTON82 = "True" EmploymentRecoveryGoals="False".
IF NOTE_DYNRADIOBUTTON83 = "True" EmploymentRecoveryGoals="True".
IF NOTE_DYNRADIOBUTTON84 = "True" ArrestPrior12="True". 
IF NOTE_DYNRADIOBUTTON85 = "True" ArrestPrior12="False".
IF NOTE_DYNRADIOBUTTON86 = "True" ProbationCurr="True".
IF NOTE_DYNRADIOBUTTON87 = "True" ProbationCurr="False".
IF NOTE_DYNRADIOBUTTON88 = "True" ProbationPast12="True".
IF NOTE_DYNRADIOBUTTON89 = "True" ProbationPast12="False".
IF NOTE_DYNRADIOBUTTON90 = "True" ProbationPrior12="True".
IF NOTE_DYNRADIOBUTTON91 = "True" ProbationPrior12="False".
IF NOTE_DYNRADIOBUTTON92 = "True" ParoleCurr="True".
IF NOTE_DYNRADIOBUTTON93 = "True" ParoleCurr="False".
IF NOTE_DYNRADIOBUTTON94 = "True" ParolePast12="True".
IF NOTE_DYNRADIOBUTTON95 = "True" ParolePast12="False".
IF NOTE_DYNRADIOBUTTON96 = "True" ParolePrior12="True".
IF NOTE_DYNRADIOBUTTON97 = "True" ParolePrior12="False".
IF NOTE_DYNRADIOBUTTON98 = "True" ConservCurr="True".
IF NOTE_DYNRADIOBUTTON99 = "True" ConservCurr="False".
IF NOTE_DYNRADIOBUTTON100 = "True" ConservPast12="True".
IF NOTE_DYNRADIOBUTTON101 = "True" ConservPast12="False".
IF NOTE_DYNRADIOBUTTON102 = "True" ConservPrior12="True".
IF NOTE_DYNRADIOBUTTON103 = "True" ConservPrior12="False".


Save outfile = '//covenas/decisionsupport/Meinzer\temp/PAFwork.SAV'.
get file = '//covenas/decisionsupport/Meinzer\temp/PAFwork.SAV'.
**********Adult and OlderAdult.

*GET FILE = '//covenas/decisionsupport/Meinzer/PAFKETQTR\PAFwork.SAV'.

Select iF NoteTitle = "Adult Partnership Assessment Form" OR NoteTitle = "Older Adult Partnership Assessment Form".

Rename Variables NOTE_FINANCIALSUPPORTCURRENT17 =NoneC.
Rename Variables NOTE_FINANCIALSUPPORTPASTTWELVE17 =NoneP.


string PAFCurWage(a400).
string PAFPastWage(a400).



do if WagesCur="True".
do if PAFCurWage=' '.
compute PAFCurWage = "Partner's Wages".
end if.
End if.
do if SpouseWagesCur="True".
do if PAFCurWage=' '.
compute PAFCurWage =  'Partners Spouse/Significant Other Wages'.
else.
compute PAFCurWage=Concat(ltrimg(rtrim(PAFCurWage)),', ','Partners Spouse/Significant Other Wages').
end if.
End if.
do if SavingsCur="True".
do if PAFCurWage=' '.
compute PAFCurWage = 'Savings'.
else.
compute PAFCurWage=Concat(ltrimg(rtrim(PAFCurWage)),', ','Savings').
end if.
End if.
do if FamFriendCur="True".
do if PAFCurWage=' '.
compute PAFCurWage = 'Other Family Member/Friend'.
else.
compute PAFCurWage=Concat(ltrimg(rtrim(PAFCurWage)),', ','Other Family Member/Friend').
end if.
End if.
do if SSIRetireCur="True".
do if PAFCurWage=' '.
compute PAFCurWage = 'Retirement/Social Security Income'.
else.
compute PAFCurWage=Concat(ltrimg(rtrim(PAFCurWage)),', ','Retirement/Social Security Income').
end if.
End if.
do if VetbenCur="True".
do if PAFCurWage=' '.
compute PAFCurWage = 'Veterans Assistance Benefits'.
else.
compute PAFCurWage=Concat(ltrimg(rtrim(PAFCurWage)),', ','Veterans Assistance Benefits').
end if.
End if.
do if LoanCur="True".
do if PAFCurWage=' '.
compute PAFCurWage = 'Loan/Credit'.
else.
compute PAFCurWage=Concat(ltrimg(rtrim(PAFCurWage)),', ','Loan/Credit').
end if.
End if.
do if HousSubsidyCur="True".
do if PAFCurWage=' '.
compute PAFCurWage = 'Housing Subsidy'.
else.
compute PAFCurWage=Concat(ltrimg(rtrim(PAFCurWage)),', ','Housing Subsidy').
end if.
End if.
do if GACur="True".
do if PAFCurWage=' '.
compute PAFCurWage = 'General Relief/General Assistance'.
else.
compute PAFCurWage=Concat(ltrimg(rtrim(PAFCurWage)),', ','General Relief/General Assistance').
end if.
End if.
do if FoodStCur="True".
do if PAFCurWage=' '.
compute PAFCurWage = 'Food Stamps'.
else.
compute PAFCurWage=Concat(ltrimg(rtrim(PAFCurWage)),', ','Food Stamps').
end if.
End if.
do if TANFCur="True".
do if PAFCurWage=' '.
compute PAFCurWage = 'Temporary Assistance for Needy Families (TANF)'.
else.
compute PAFCurWage=Concat(ltrimg(rtrim(PAFCurWage)),', ','Temporary Assistance for Needy Families (TANF)').
end if.
End if.
do if SSICur="True".
do if PAFCurWage=' '.
compute PAFCurWage = 'Supplemental Security Income/State Supplementary Payment Program (SSI/SSP)'.
else.
compute PAFCurWage=Concat(ltrimg(rtrim(PAFCurWage)),', ','Supplemental Security Income/State Supplementary Payment Program (SSI/SSP)').
end if.
End if.
do if SSDICur="True".
do if PAFCurWage=' '.
compute PAFCurWage = 'Social Security Disability Insurance (SSDI)'.
else.
compute PAFCurWage=Concat(ltrimg(rtrim(PAFCurWage)),', ','Social Security Disability Insurance (SSDI)').
end if.
End if.
do if SDICur="True".
do if PAFCurWage=' '.
compute PAFCurWage = 'State Disability Insurance (SDI)'.
else.
compute PAFCurWage=Concat(ltrimg(rtrim(PAFCurWage)),', ','State Disability Insurance (SDI)').
end if.
End if.
do if TribalBenCur="True".
do if PAFCurWage=' '.
compute PAFCurWage = 'American Indian Tribal Benefits (per Capita, revenue sharing, trust disbursements)'.
else.
compute PAFCurWage=Concat(ltrimg(rtrim(PAFCurWage)),', ','American Indian Tribal Benefits (per Capita, revenue sharing, trust disbursements)').
end if.
End if.
do if OtherCur="True".
do if PAFCurWage=' '.
compute PAFCurWage = 'Other'.
else.
compute PAFCurWage=Concat(ltrimg(rtrim(PAFCurWage)),', ','Other').
end if.
End if.
do if nonec="True".
do if PAFCurWage=' '.
compute PAFCurWage = 'No Financial Support'.
else.
compute PAFCurWage=Concat(ltrimg(rtrim(PAFCurWage)),', ','No Financial Support').
end if.
End if.

do if WagesPast="True".
do if PAFPastWage=' '.
compute PAFPastWage = 'Partners Wages'.
else.
compute PAFPASTWage=Concat(ltrimg(rtrim(PAFPastWage)),', ','Partners Wages').
end if.
End if.
do if SpouseWagesPast="True".
do if PAFPastWage=' '.
compute PAFPastWage = 'Partners Spouse/Significant Other Wages'.
else.
compute PAFPASTWage=Concat(ltrimg(rtrim(PAFPastWage)),', ','Partners Spouse/Significant Other Wages').
end if.
End if.
do if SavingsPast="True".
do if PAFPastWage=' '.
compute PAFPastWage = 'Savings'.
else.
compute PAFPASTWage=Concat(ltrimg(rtrim(PAFPastWage)),', ','Savings').
end if.
End if.
do if FamFriendPast="True".
do if PAFPastWage=' '.
compute PAFPastWage = 'Other Family Member/Friend'.
else.
compute PAFPASTWage=Concat(ltrimg(rtrim(PAFPastWage)),', ','Other Family Member/Friend').
end if.
End if.
do if SSIRetirePast="True".
do if PAFPastWage=' '.
compute PAFPastWage = 'Retirement/Social Security Income'.
else.
compute PAFPASTWage=Concat(ltrimg(rtrim(PAFPastWage)),', ','Retirement/Social Security Income').
end if.
End if.
do if VetbenPast="True".
do if PAFPastWage=' '.
compute PAFPastWage = 'Veterans Assistance Benefits'.
else.
compute PAFPASTWage=Concat(ltrimg(rtrim(PAFPastWage)),', ','Veterans Assistance Benefits').
end if.
End if.
do if LoanPast="True".
do if PAFPastWage=' '.
compute PAFPastWage = 'Loan/Credit'.
else.
compute PAFPASTWage=Concat(ltrimg(rtrim(PAFPastWage)),', ','Loan/Credit').
end if.
End if.
do if HousSubsidyPast="True".
do if PAFPastWage=' '.
compute PAFPastWage = 'Housing Subsidy'.
else.
compute PAFPASTWage=Concat(ltrimg(rtrim(PAFPastWage)),', ','Housing Subsidy').
end if.
End if.
do if GAPast="True".
do if PAFPastWage=' '.
compute PAFPastWage = 'General Relief/General Assistance'.
else.
compute PAFPASTWage=Concat(ltrimg(rtrim(PAFPastWage)),', ','General Relief/General Assistance').
end if.
End if.
do if FoodStPast="True".
do if PAFPastWage=' '.
compute PAFPastWage = 'Food Stamps'.
else.
compute PAFPASTWage=Concat(ltrimg(rtrim(PAFPastWage)),', ','Food Stamps').
end if.
End if.
do if TANFPast="True".
do if PAFPastWage=' '.
compute PAFPastWage = 'Temporary Assistance for Needy Families (TANF)'.
else.
compute PAFPASTWage=Concat(ltrimg(rtrim(PAFPastWage)),', ','Temporary Assistance for Needy Families (TANF)').
end if.
End if.
do if SSIPast="True".
do if PAFPastWage=' '.
compute PAFPastWage = 'Supplemental Security Income/State Supplementary Payment Program (SSI/SSP)'.
else.
compute PAFPASTWage=Concat(ltrimg(rtrim(PAFPastWage)),', ','Supplemental Security Income/State Supplementary Payment Program (SSI/SSP)').
end if.
End if.
do if SSDIPast="True".
do if PAFPastWage=' '.
compute PAFPastWage = 'Social Security Disability Insurance (SSDI)'.
else.
compute PAFPASTWage=Concat(ltrimg(rtrim(PAFPastWage)),', ','Social Security Disability Insurance (SSDI)').
end if.
End if.
do if SDIPast="True".
do if PAFPastWage=' '.
compute PAFPastWage = 'State Disability Insurance (SDI)'.
else.
compute PAFPASTWage=Concat(ltrimg(rtrim(PAFPastWage)),', ','State Disability Insurance (SDI)').
end if.
End if.
do if TribalBenPast="True".
do if PAFPastWage=' '.
compute PAFPastWage = 'American Indian Tribal Benefits (per Capita, revenue sharing, trust disbursements)'.
else.
compute PAFPASTWage=Concat(ltrimg(rtrim(PAFPastWage)),', ','American Indian Tribal Benefits (per Capita, revenue sharing, trust disbursements)').
end if.
End if.
do if OtherPast="True".
do if PAFPastWage=' '.
compute PAFPastWage = 'Other'.
else.
compute PAFPASTWage=Concat(ltrimg(rtrim(PAFPastWage)),', ','Other').
end if.
End if.
do if NoneP="True".
do if PAFPastWage=' '.
compute PAFPastWage = 'No Financial Support'.
else.
compute PAFPASTWage=Concat(ltrimg(rtrim(PAFPastWage)),', ','No Financial Support').
end if.
End if.

 Rename Variables NOTE_RESIDENTIALSETTINGPASTTWELVEDAYS1 =AloneD.
 Rename Variables NOTE_RESIDENTIALSETTINGPASTTWELVEDAYS10 =BoardCareD.
 Rename Variables NOTE_RESIDENTIALSETTINGPASTTWELVEDAYS11 =MedHospD.
 Rename Variables NOTE_RESIDENTIALSETTINGPASTTWELVEDAYS12 =PsychHospD.
 Rename Variables NOTE_RESIDENTIALSETTINGPASTTWELVEDAYS13 =StatePsychHospD.
 Rename Variables NOTE_RESIDENTIALSETTINGPASTTWELVEDAYS14 =LicResTreatmtD.
 Rename Variables NOTE_RESIDENTIALSETTINGPASTTWELVEDAYS15 =SkNursPhysD.


 Rename Variables NOTE_RESIDENTIALSETTINGPASTTWELVEDAYS16 =SkNursPsychD.
 Rename Variables NOTE_RESIDENTIALSETTINGPASTTWELVEDAYS17 =LTInstCareD.
 Rename Variables NOTE_RESIDENTIALSETTINGPASTTWELVEDAYS18 =JailD.
 Rename Variables NOTE_RESIDENTIALSETTINGPASTTWELVEDAYS19 =PrisonD.
 Rename Variables NOTE_RESIDENTIALSETTINGPASTTWELVEDAYS2 =ParentsD.
 Rename Variables NOTE_RESIDENTIALSETTINGPASTTWELVEDAYS20 =OtherD.
 Rename Variables NOTE_RESIDENTIALSETTINGPASTTWELVEDAYS21 =UnknownD.

 Rename Variables NOTE_RESIDENTIALSETTINGPASTTWELVEDAYS3 =FamilyD.
 Rename Variables NOTE_RESIDENTIALSETTINGPASTTWELVEDAYS4 =SROD.
 Rename Variables NOTE_RESIDENTIALSETTINGPASTTWELVEDAYS5 =EmergencyD.
 Rename Variables NOTE_RESIDENTIALSETTINGPASTTWELVEDAYS6 =HomelessD.
 Rename Variables NOTE_RESIDENTIALSETTINGPASTTWELVEDAYS7 =UnlicSupIndivD.
 Rename Variables NOTE_RESIDENTIALSETTINGPASTTWELVEDAYS8 =AssistLivingD.
 Rename Variables NOTE_RESIDENTIALSETTINGPASTTWELVEDAYS9 =CongregateD.
 Rename Variables NOTE_RESIDENTIALSETTINGPASTTWELVEOCCURENCES1 =AloneOcc.
 Rename Variables NOTE_RESIDENTIALSETTINGPASTTWELVEOCCURENCES10 =BoardCareOcc.
 Rename Variables NOTE_RESIDENTIALSETTINGPASTTWELVEOCCURENCES11 =MedHospOcc.
 Rename Variables NOTE_RESIDENTIALSETTINGPASTTWELVEOCCURENCES12 =PsychHospOcc.
 Rename Variables NOTE_RESIDENTIALSETTINGPASTTWELVEOCCURENCES13 =StatePsychHospOcc.
 Rename Variables NOTE_RESIDENTIALSETTINGPASTTWELVEOCCURENCES14 =LicResTreatmtOcc.
 Rename Variables NOTE_RESIDENTIALSETTINGPASTTWELVEOCCURENCES15 =SkNursPhysOcc.
 Rename Variables NOTE_RESIDENTIALSETTINGPASTTWELVEOCCURENCES16 =SkNursPsychOcc.
 Rename Variables NOTE_RESIDENTIALSETTINGPASTTWELVEOCCURENCES17 =LTInstCareOcc.
 Rename Variables NOTE_RESIDENTIALSETTINGPASTTWELVEOCCURENCES18 =JailOcc.
 Rename Variables NOTE_RESIDENTIALSETTINGPASTTWELVEOCCURENCES19 =PrisonOcc.
 Rename Variables NOTE_RESIDENTIALSETTINGPASTTWELVEOCCURENCES2 =ParentsOcc.
 Rename Variables NOTE_RESIDENTIALSETTINGPASTTWELVEOCCURENCES20 =OtherOcc.
 Rename Variables NOTE_RESIDENTIALSETTINGPASTTWELVEOCCURENCES21 =UnknownOcc.


 Rename Variables NOTE_RESIDENTIALSETTINGPASTTWELVEOCCURENCES3 =FamilyOcc.
 Rename Variables NOTE_RESIDENTIALSETTINGPASTTWELVEOCCURENCES4 =SROOcc.
 Rename Variables NOTE_RESIDENTIALSETTINGPASTTWELVEOCCURENCES5 =EmergencyOcc.
 Rename Variables NOTE_RESIDENTIALSETTINGPASTTWELVEOCCURENCES6 =HomelessOcc.
 Rename Variables NOTE_RESIDENTIALSETTINGPASTTWELVEOCCURENCES7 =UnlicSupIndivOcc.
 Rename Variables NOTE_RESIDENTIALSETTINGPASTTWELVEOCCURENCES8 =AssistLivingOcc.
 Rename Variables NOTE_RESIDENTIALSETTINGPASTTWELVEOCCURENCES9 =CongregateOcc.
 
Rename Variables NOTE_RESIDENTIALSETTINGPRIOR1 =AloneOccPrYr.
  Rename Variables NOTE_RESIDENTIALSETTINGPRIOR10 =BoardCareOccPrYrPrYr.
 Rename Variables NOTE_RESIDENTIALSETTINGPRIOR11 =MedHospOccPrYr.
 Rename Variables NOTE_RESIDENTIALSETTINGPRIOR12 =PsychHospOccPrYr.
 Rename Variables NOTE_RESIDENTIALSETTINGPRIOR13 =StatePsychHospOccPrYr.
 Rename Variables NOTE_RESIDENTIALSETTINGPRIOR14 =LicResTreatmtOccPrYr.
 Rename Variables NOTE_RESIDENTIALSETTINGPRIOR15 =SkNursPhysOccPrYr.
 Rename Variables NOTE_RESIDENTIALSETTINGPRIOR16 =SkNursPsychOccPrYr.
 Rename Variables NOTE_RESIDENTIALSETTINGPRIOR17 =LTInstCareOccPrYr.
 Rename Variables NOTE_RESIDENTIALSETTINGPRIOR18 =JailOccPrYr.
 Rename Variables NOTE_RESIDENTIALSETTINGPRIOR19 =PrisonOccPrYr.
 Rename Variables NOTE_RESIDENTIALSETTINGPRIOR2 =ParentsOccPrYr.
 Rename Variables NOTE_RESIDENTIALSETTINGPRIOR20 =OtherOccPrYr.
 Rename Variables NOTE_RESIDENTIALSETTINGPRIOR21 =UnknownOccPrYr.
 Rename Variables NOTE_RESIDENTIALSETTINGPRIOR3 =FamilyPrYr.
 Rename Variables NOTE_RESIDENTIALSETTINGPRIOR4 =SROPrYr.
 Rename Variables NOTE_RESIDENTIALSETTINGPRIOR5 =EmergencyPrYr.
 Rename Variables NOTE_RESIDENTIALSETTINGPRIOR6 =HomelessPrYr.
 Rename Variables NOTE_RESIDENTIALSETTINGPRIOR7 =UnlicSupIndivPrYr.
 Rename Variables NOTE_RESIDENTIALSETTINGPRIOR8 =AssistLivingPrYr.
 Rename Variables NOTE_RESIDENTIALSETTINGPRIOR9 =CongregatePrYr.

Rename Vars SkNursPhysD=SkNursPhysDX.
string SkNursPhysD(a3).
compute SkNursPhysD=SkNursPhysDx.

 * Rename Vars SkNursPsychOcc=SkNursPsychOccX.
 * string SkNursPsychOcc(a3).
 * compute SkNursPsychOcc=SkNursPsychOccx.

 * Rename Vars LTInstCareOcc=LTInstCareOccX.
 * string LTInstCareOcc(a3).
 * compute SkNursPsychOcc=LTInstCareOccX.

Rename Vars StatePsychHospOcc=StatePsychHospOccX.
string StatePsychHospOcc(a3).
compute StatePsychHospOcc=StatePsychHospOccX.

Rename Vars BoardCareOcc=BoardCareOccX.
string BoardCareOcc(a2).
compute BoardCareOcc=BoardCareOccX.

Rename Vars UnlicSupIndivOcc=UnlicSupIndivOccX.
string UnlicSupIndivOcc(a2).
compute UnlicSupIndivOcc=UnlicSupIndivOccX.
alter type otherocc(a1).
alter type ltinstcareocc(a3).
alter type sknurspsychocc(a2).
SAVE OUTFILE='//covenas/decisionsupport/Meinzer/temp/PAFWork_AdultsOA.SAV'.
get FILE='//covenas/decisionsupport/Meinzer/temp/PAFWork_AdultsOA.SAV'.
*TAY & CHILD RENAMES. 
*******************************************************************************************************************.
get file = '//covenas/decisionsupport/Meinzer/temp\PAFwork.SAV'.
Select iF NoteTitle = "TAY Partnership Assessment Form" OR NoteTitle = "Child Partnership Assessment Form".

 Rename Variables NOTE_FINANCIALSUPPORTCURRENT17 =CaregiverWagesC.
 Rename Variables NOTE_FINANCIALSUPPORTCURRENT18 =ChildSupportC.
 Rename Variables NOTE_FINANCIALSUPPORTCURRENT19 =NoneC.

Rename Variables NOTE_FINANCIALSUPPORTPASTTWELVE17 =CaregiverWagesP.
 Rename Variables NOTE_FINANCIALSUPPORTPASTTWELVE18 =ChildSupportP.
 Rename Variables NOTE_FINANCIALSUPPORTPASTTWELVE19 =NoneP.


Rename Variables NOTE_RESIDENTIALSETTINGPASTTWELVEDAYS1 =ParentsD.
 Rename Variables NOTE_RESIDENTIALSETTINGPASTTWELVEDAYS2 =FamilyD.
 Rename Variables NOTE_RESIDENTIALSETTINGPASTTWELVEDAYS3 =AloneD.
 Rename Variables NOTE_RESIDENTIALSETTINGPASTTWELVEDAYS4 =SROD.
 Rename Variables NOTE_RESIDENTIALSETTINGPASTTWELVEDAYS5 =FosterRelD.
 Rename Variables NOTE_RESIDENTIALSETTINGPASTTWELVEDAYS6 =FosterNonRelD.
 Rename Variables NOTE_RESIDENTIALSETTINGPASTTWELVEDAYS7 =EmergencyD.
 Rename Variables NOTE_RESIDENTIALSETTINGPASTTWELVEDAYS8 =HomelessD.
 Rename Variables NOTE_RESIDENTIALSETTINGPASTTWELVEDAYS9 =UnlicSupIndivD. 
 Rename Variables NOTE_RESIDENTIALSETTINGPASTTWELVEDAYS10 =CongregateD.
 Rename Variables NOTE_RESIDENTIALSETTINGPASTTWELVEDAYS11 =BoardCareD.
 Rename Variables NOTE_RESIDENTIALSETTINGPASTTWELVEDAYS12 =MedHospD.
 Rename Variables NOTE_RESIDENTIALSETTINGPASTTWELVEDAYS13 =PsychHospD.
 Rename Variables NOTE_RESIDENTIALSETTINGPASTTWELVEDAYS14 =StatePsychHospD.
 Rename Variables NOTE_RESIDENTIALSETTINGPASTTWELVEDAYS15 =GroupHome0to11D.
 Rename Variables NOTE_RESIDENTIALSETTINGPASTTWELVEDAYS16 =GroupHome12to14D.
 Rename Variables NOTE_RESIDENTIALSETTINGPASTTWELVEDAYS17 =CommTreatD.
 Rename Variables NOTE_RESIDENTIALSETTINGPASTTWELVEDAYS18 =LicResTreatmtD.
 Rename Variables NOTE_RESIDENTIALSETTINGPASTTWELVEDAYS19 =SkNursPhysD.
 Rename Variables NOTE_RESIDENTIALSETTINGPASTTWELVEDAYS20 =SkNursPsychD.
 Rename Variables NOTE_RESIDENTIALSETTINGPASTTWELVEDAYS21 =LTInstCareD.
 Rename Variables NOTE_RESIDENTIALSETTINGPASTTWELVEDAYS22 =JuviHallD.
 Rename Variables NOTE_RESIDENTIALSETTINGPASTTWELVEDAYS23 =JuviJusticeD.
 Rename Variables NOTE_RESIDENTIALSETTINGPASTTWELVEDAYS24 =JailD.
 Rename Variables NOTE_RESIDENTIALSETTINGPASTTWELVEDAYS25 =PrisonD.
 Rename Variables NOTE_RESIDENTIALSETTINGPASTTWELVEDAYS26 =OtherD.
 Rename Variables NOTE_RESIDENTIALSETTINGPASTTWELVEDAYS27 =UnknownD.

 Rename Variables NOTE_RESIDENTIALSETTINGPASTTWELVEOCCURENCES1 =ParentsOcc.
  Rename Variables NOTE_RESIDENTIALSETTINGPASTTWELVEOCCURENCES2 =FamilyOcc.
Rename Variables NOTE_RESIDENTIALSETTINGPASTTWELVEOCCURENCES3 =AloneOcc.
 Rename Variables NOTE_RESIDENTIALSETTINGPASTTWELVEOCCURENCES4 =SROOcc.
 Rename Variables NOTE_RESIDENTIALSETTINGPASTTWELVEOCCURENCES5 =FosterRelOcc.
 Rename Variables NOTE_RESIDENTIALSETTINGPASTTWELVEOCCURENCES6 =FosterNonRelOcc.
 Rename Variables NOTE_RESIDENTIALSETTINGPASTTWELVEOCCURENCES7 =EmergencyOcc.
 Rename Variables NOTE_RESIDENTIALSETTINGPASTTWELVEOCCURENCES8 =HomelessOcc.
 Rename Variables NOTE_RESIDENTIALSETTINGPASTTWELVEOCCURENCES9 =UnlicSupIndivOcc. 
Rename Variables NOTE_RESIDENTIALSETTINGPASTTWELVEOCCURENCES10 =CongregateOcc.
 Rename Variables NOTE_RESIDENTIALSETTINGPASTTWELVEOCCURENCES11 =BoardCareOcc.
 Rename Variables NOTE_RESIDENTIALSETTINGPASTTWELVEOCCURENCES12 =MedHospOcc.
 Rename Variables NOTE_RESIDENTIALSETTINGPASTTWELVEOCCURENCES13 =PsychHospOcc.
 Rename Variables NOTE_RESIDENTIALSETTINGPASTTWELVEOCCURENCES14 =StatePsychHospOcc.
 Rename Variables NOTE_RESIDENTIALSETTINGPASTTWELVEOCCURENCES15 =GroupHome0to11Occ.
 Rename Variables NOTE_RESIDENTIALSETTINGPASTTWELVEOCCURENCES16 =GroupHome12to14Occ.
 Rename Variables NOTE_RESIDENTIALSETTINGPASTTWELVEOCCURENCES17 =CommTreatOcc.
 Rename Variables NOTE_RESIDENTIALSETTINGPASTTWELVEOCCURENCES18 =LicResTreatmtOcc.
 Rename Variables NOTE_RESIDENTIALSETTINGPASTTWELVEOCCURENCES19 =SkNursPhysOcc.
 Rename Variables NOTE_RESIDENTIALSETTINGPASTTWELVEOCCURENCES20 =SkNursPsychOcc.
 Rename Variables NOTE_RESIDENTIALSETTINGPASTTWELVEOCCURENCES21 =LTInstCareOcc.
 Rename Variables NOTE_RESIDENTIALSETTINGPASTTWELVEOCCURENCES22 =JuviHallOcc.
 Rename Variables NOTE_RESIDENTIALSETTINGPASTTWELVEOCCURENCES23 =JuviJusticeOcc.
 Rename Variables NOTE_RESIDENTIALSETTINGPASTTWELVEOCCURENCES24 =JailOcc.
 Rename Variables NOTE_RESIDENTIALSETTINGPASTTWELVEOCCURENCES25 =PrisonOcc.
 Rename Variables NOTE_RESIDENTIALSETTINGPASTTWELVEOCCURENCES26 =OtherOcc.
 Rename Variables NOTE_RESIDENTIALSETTINGPASTTWELVEOCCURENCES27 =UnknownOcc.

 Rename Variables NOTE_RESIDENTIALSETTINGPRIOR1 =ParentsPrYr.
 Rename Variables NOTE_RESIDENTIALSETTINGPRIOR2 =FamilyPrYr.
 Rename Variables NOTE_RESIDENTIALSETTINGPRIOR3 =AlonePrYr.
 Rename Variables NOTE_RESIDENTIALSETTINGPRIOR4 =SROPrYr.
 Rename Variables NOTE_RESIDENTIALSETTINGPRIOR5 =FosterRelPrYr.
 Rename Variables NOTE_RESIDENTIALSETTINGPRIOR6 =FosterNonRelPrYr.
 Rename Variables NOTE_RESIDENTIALSETTINGPRIOR7 =EmergencyPrYr.
 Rename Variables NOTE_RESIDENTIALSETTINGPRIOR8 =HomelessPrYr.
 Rename Variables NOTE_RESIDENTIALSETTINGPRIOR9 =UnlicSupIndivPrYr. 
 Rename Variables NOTE_RESIDENTIALSETTINGPRIOR10 =CongregateOccPrYr.
 Rename Variables NOTE_RESIDENTIALSETTINGPRIOR11 =BoardCareOccPrYrPrYr.
 Rename Variables NOTE_RESIDENTIALSETTINGPRIOR12 =MedHospOccPrYr.
 Rename Variables NOTE_RESIDENTIALSETTINGPRIOR13 =PsychHospOccPrYr.
 Rename Variables NOTE_RESIDENTIALSETTINGPRIOR14 =StatePsychHospOccPrYr.
 Rename Variables NOTE_RESIDENTIALSETTINGPRIOR15 =GroupHome0to11OccPrYr.
 Rename Variables NOTE_RESIDENTIALSETTINGPRIOR16 =GroupHome12to14OccPrYr.
 Rename Variables NOTE_RESIDENTIALSETTINGPRIOR17 =CommTreatOccPrYr.
 Rename Variables NOTE_RESIDENTIALSETTINGPRIOR18 =LicResTreatmtOccPrYr.
 Rename Variables NOTE_RESIDENTIALSETTINGPRIOR19 =SkNursPhysOccPrYr.
 Rename Variables NOTE_RESIDENTIALSETTINGPRIOR20 =SkNursPsychOccPrYr.
 Rename Variables NOTE_RESIDENTIALSETTINGPRIOR21 =LTInstCareOccPrYr.
 Rename Variables NOTE_RESIDENTIALSETTINGPRIOR22 =JuviHallPrYr.
 Rename Variables NOTE_RESIDENTIALSETTINGPRIOR23 =JuviJusticePrYr.
 Rename Variables NOTE_RESIDENTIALSETTINGPRIOR24 =JailPrYr.
 Rename Variables NOTE_RESIDENTIALSETTINGPRIOR25 =PrisonPrYr.
 Rename Variables NOTE_RESIDENTIALSETTINGPRIOR26 =OtherOccPrYr.
 Rename Variables NOTE_RESIDENTIALSETTINGPRIOR27 =UnknownOccPrYr.
 

Rename Vars UnknownOcc=UnknownOccX.
string UnknownOcc(a3).
compute UnknownOcc=UnknownOccX.

 * Rename Vars OtherOcc=OtherOccX.
 * string OtherOcc(a3).
 * compute OtherOcc=OtherOccX.

Rename Vars PsychHospOcc=PsychHospOccX.
string PsychHospOcc(a2).
compute PsychHospOcc=PsychHospOccX.

Rename Vars HomelessOcc=HomelessOccX.
string HomelessOcc(a3).
compute HomelessOcc=HomelessOccX.

Rename Vars LicResTreatmtOcc=LicResTreatmtOccX.
string LicResTreatmtOcc(a3).
compute LicResTreatmtOcc=LicResTreatmtOccX.

Rename Vars JailOcc=JailOccX.
string JailOcc(a2).
compute JailOcc=JailOccX.

Rename Vars EmergencyOcc=EmergencyOccX.
string EmergencyOcc(a3).
compute EmergencyOcc=EmergencyOccX.

 * Rename Vars SkNursPhysOcc=SkNursPhysOccX.
 * string SkNursPhysOcc(a3).
 * compute SkNursPhysOcc=SkNursPhysOccX.


Rename Vars CongregateOcc=CongregateOccX.
string CongregateOcc(a2).
compute CongregateOcc=CongregateOccX.


SAVE OUTFILE='//covenas/decisionsupport/Meinzer/temp\PAFWork_TAYCHILD.SAV'.

****Recombine OA, Adult, and TAY.

ADD FILES
 /FILE='//covenas/decisionsupport/Meinzer/temp/PAFWork_AdultsOA.SAV'
 /FILE='//covenas/decisionsupport/Meinzer/temp\PAFWork_TAYCHILD.SAV'.




Rename Variables NOTE_RESIDENTIALSETTINGCURRENT=Housingtext.

compute housingtext=rtrim(ltrim(housingtext)).
if HOUSINGTEXT="In an apartment or house alone / with spouse / partner / minor children / other dependents / roommate - must hold lease or sh                           "  
	HOUSINGTEXT="In an apartment or house alone or with others - must hold lease or share in rent / mortgage".
if HOUSINGTEXT="In an apartment or house alone / with spouse / partner / minor children / other dependents / roommate - must hold lease or share in rent / mortgage"  
	HOUSINGTEXT="In an apartment or house alone or with others - must hold lease or share in rent / mortgage".
if HOUSINGTEXT="In an apartment or house alone / with spouse / partner / minor children / other dependents / roommate"  
	HOUSINGTEXT="In an apartment or house alone or with others - must hold lease or share in rent / mortgage".

RENAME VARIABLES HOUSINGTEXT=HOUSINGTEXT147.
STRING HOUSINGTEXT(A125).
COMPUTE HOUSINGTEXT = SUBSTR(HOUSINGTEXT147,1,125).
exe.
delete vars housingtext147.

sort cases by housingtext.
match files /table='//covenas/decisionsupport/meinzer/tables/housingtexttable.sav'  /file=* /by housingtext /drop statenum.
rename variables statestring=Current.
rename vars housingtext=RESIDENTIALSETTINGCURRENT.
exe.
rename vars notetitle=PafNoteTitle  note_text=PafNote_text.

Rename Variables NOTE_RESIDENTIALSETTINGYESTERDAY=Housingtext.

compute housingtext=rtrim(ltrim(housingtext)).
if HOUSINGTEXT="In an apartment or house alone / with spouse / partner / minor children / other dependents / roommate - must hold lease or sh                           "  
	HOUSINGTEXT="In an apartment or house alone or with others - must hold lease or share in rent / mortgage".
if HOUSINGTEXT="In an apartment or house alone / with spouse / partner / minor children / other dependents / roommate - must hold lease or share in rent / mortgage"  
	HOUSINGTEXT="In an apartment or house alone or with others - must hold lease or share in rent / mortgage".
if HOUSINGTEXT="In an apartment or house alone / with spouse / partner / minor children / other dependents / roommate"  
	HOUSINGTEXT="In an apartment or house alone or with others - must hold lease or share in rent / mortgage".

RENAME VARIABLES HOUSINGTEXT=HOUSINGTEXT147.
STRING HOUSINGTEXT(A125).
COMPUTE HOUSINGTEXT = SUBSTR(HOUSINGTEXT147,1,125).
exe.
delete vars housingtext147.

sort cases by housingtext.
match files /table='//covenas/decisionsupport/meinzer/tables/housingtexttable.sav'  /file=* /by housingtext /drop statenum.
rename variables statestring=Yesterday.


rename vars housingtext=RESIDENTIALSETTINGYESTERDAY.
exe.



sort cases by case ru.
compute Measure=1.
Save outfile='//covenas/decisionsupport/meinzer/temp/CGPAFWork_LONG.sav'.



****************         KET CG DATA PULL STARTS Here           ********************.


GET DATA
  /TYPE=ODBC
  /CONNECT='DSN=CGReporting;Description=mhs;UID=;Trusted_Connection=Yes;APP=IBM SPSS Products: '+
    'Statistics Common;WSID=HPMXL2221NXK;DATABASE=Reporting'
  /SQL='SELECT __row_id AS KETstamp, client_number, reporting_unit, CreateDate, Opening_Date, '+
    'ServiceID, "Note ID" AS Note_ID, "Note Title" AS NoteTitle, note_text, NOTE_DATEPROVICHANGE, '+    
    'NOTE_EMPSTATUSCODEHRWAGE4, NOTE_MHSAHPCHANGEDATE, NOTE_PROVIDERSITE, NOTE_EMERGENCYTYPE, '+
    'NOTE_DATESTATUSCHANGE, NOTE_GHI, NOTE_EMPSTATUSCODEAVGHRSWEEK5, '+
    'NOTE_EMPSTATUSCODEAVGHRSWEEK6, NOTE_DATEARRESTED, NOTE_DATEPAYEE, NOTE_EMPSTATUSCODEHRWAGE2, '+    
    'NOTE_EDUCATIONCODECURRENTLY3, NOTE_DATECONSERVA, NOTE_RESSETTINGTYPE, NOTE_CONSERVASTATUS, '+
    'NOTE_DATERESICHANGE, NOTE_PAYEESTATUS, NOTE_PAROLESTATUS, NOTE_EMPSTATUSCODEAVGHRSWEEK2, '+
    'NOTE_COMPLETEPROGRAM, NOTE_PROBATIONSTATUS, NOTE_ASSESSMENTDATE, '+
    'NOTE_EDUCATIONCODECURRENTLY2, NOTE_PARTNERSTATUS, NOTE_AB2034, NOTE_EMPLOYED, '+
    'NOTE_DATEEMPCHANGE, NOTE_EMPSTATUSCODEAVGHRSWEEK1, NOTE_MHSAHP, NOTE_EDUCATIONCODECURRENTLY4, '+
    ''+
    'NOTE_DISCONTREASON, NOTE_EMPSTATUSCODEHRWAGE3, NOTE_COORDINATORID, NOTE_DATECOORDCHANGE, '+
    'NOTE_RECOVERYGOALS, NOTE_EDUCATIONCODECURRENTLY5, NOTE_GHIDATE, NOTE_COUNTYPROGRAMID, '+
    'NOTE_DATEEMERGENCYCHANGE, NOTE_EDUGRADELEVELTYPE, NOTE_EMPSTATUSCODEAVGHRSWEEK3, '+
    'NOTE_DATEPROGMCHANGE, NOTE_AB2034DATE, NOTE_EMPSTATUSCODEHRWAGE1, '+
    'NOTE_EDUCATIONCODECURRENTLY1, NOTE_DATEGRADECOMPLETE, NOTE_DATEPAROLE, '+
    'NOTE_DATESETTINGCHANGE, NOTE_DATEPROBATION, NOTE_EMPSTATUSCODEHRWAGE6, '+
    'NOTE_EMPSTATUSCODEAVGHRSWEEK4, NOTE_EDUCATIONRECOVERYGOALS, NOTE_EDUCATIONCODECURRENTLY6, '+
    'NOTE_CGSTAFFNUMBER, NOTE_DATESUSPENSION, NOTE_DATEWICODE, NOTE_WICODESTATUS, '+
    'NOTE_DATEEXPULSION, NOTE_TAYPROGRAM, NOTE_TAYPROGRAMDATE FROM Reporting.dbo.[KET]'
  /ASSUMEDSTRWIDTH=255.
CACHE.
exe.
rename vars 
client_number =Case 
reporting_unit=RU opening_date=opdate.

sort cases by ru.
match files/table='//covenas/spssdata/ruTableRU2.sav' /file=* /by ru.
if ru2 ne " " Ru = RU2.
sort cases by ru.
match files/table='//covenas/spssdata/ruTableRU2.sav' /file=* /by ru.

sort cases by ru case opdate.
match files /table='//covenas/decisionsupport/epsCG.sav' /file=* /by ru case opdate /drop primdx refsrce primarytherapist lst_svc epflag.
sort cases by case opdate.
if lag(case)=case and  opdate ne lag(opdate) and datediff(opdate,lag(closdate),'years') ge 1 opdate=lag(opdate).


*save outfile = '//covenas/decisionsupport/CGKetPull.sav'.


 * GET
  FILE= '//covenas/decisionsupport/meinzer/projects/fsp/CGKetPull255.sav'.


********to get choices working.




String FSPName (a20).
if RU="018435" FSPName="FSP-3 STAY".
if RU="01EE1" FSPName="FSP-1 HOST".
if RU="01EG1"   FSPName="FSP-4 GH".
if RU="01EM1" FSPName="FSP-2 NCSHP".
if RU="81486"  FSPName="FSP-5 FACT".
if RU="88036" FSPName="FSP-6 TIP".
if RU="81487" FSPName="FSP-9 TRACT".
if RU="01FZ1" FSPName="FSP-7 CHOICES".
if RU="01028" FSPName="FSP-7 CHOICES".
if RU="0108T1" FSPName="FSP-7 CHOICES".
if RU="01221" FSPName="FSP-7 CHOICES".
if RU= "01911" FSPName="FSP-7 CHOICES".
if RU="8133T1" FSPName="FSP-7 CHOICES".
if RU="01333" FSPName="FSP-7 CHOICES".
if RU="01EE2" FSPName="FSP-7 CHOICES".

*new below.
if RU="01521" FSPName="FSP-7 CHOICES".
if RU="0152M1" FSPName="FSP-7 CHOICES".
if RU="0112T1" FSPName="FSP-7 CHOICES".
if RU="0112T2" FSPName="FSP-7 CHOICES".
if RU="0112M1" FSPName="FSP-7 CHOICES".
if RU="0170T1" FSPName="FSP-7 CHOICES".
if RU="0170T2" FSPName="FSP-7 CHOICES".
if RU="01113" FSPName="FSP-7 CHOICES".


rename variables 
	ServiceID=ServiceIDKET.

rename vars NOTE_DISCONTREASON=ReasonDiscontinuedPartnership.


Rename Variables NOTE_DATEARRESTED = DATEARRESTED.
Rename Variables NOTE_DATECONSERVA = DATECONSERVA.
Rename Variables NOTE_DATECOORDCHANGE = DATECOORDCHANGE.
Rename Variables NOTE_DATEEMERGENCYCHANGE = DATEEMERGENCYCHANGE.

Rename Variables NOTE_DATEEXPULSION = DATEEXPULSION.
Rename Variables NOTE_DATEGRADECOMPLETE = DATEGRADECOMPLETE.
Rename Variables NOTE_DATEPAROLE = DATEPAROLE.


Rename Variables NOTE_DATEPROGMCHANGE = DATEPROGMCHANGE.
Rename Variables NOTE_DATEPROVICHANGE = DATEPROVICHANGE.

*Rename Variables NOTE_DATESETTINGCHANGE = DATEEDUSETTINGCHANGE.
Rename Variables NOTE_DATESTATUSCHANGE = DATESTATUSCHANGE.
Rename Variables NOTE_DATESUSPENSION = DATESUSPENSION.
Rename Variables NOTE_DATEWICODE = DATEWICODE.
Rename Variables NOTE_GHIDATE = GHIDATE.
Rename Variables NOTE_MHSAHPCHANGEDATE = MHSAHPCHANGEDATE.
Rename Variables NOTE_TAYPROGRAMDATE = TAYPROGRAMDATE.

*NEW FINANCIAL.
rename vars NOTE_PAYEESTATUS=PayeeStatusKET.	
Rename Variables NOTE_DATEPAYEE = DATEPAYEE.

*NEW PROBATION.
rename vars NOTE_PROBATIONSTATUS=KETProbationStatus.
Rename Variables NOTE_DATEPROBATION = DATEPROBATION.	

*NEW EDUCATION.

Rename Variables NOTE_DATESETTINGCHANGE = EdSettingChangeDateKET.
rename vars NOTE_EDUCATIONCODECURRENTLY1=EdNotInSchoolCurrKET.
rename vars NOTE_EDUCATIONCODECURRENTLY2=EdHighSchoolORAdultEdCurrKET.
rename vars NOTE_EDUCATIONCODECURRENTLY3=EdTechORVocCurrKET.
rename vars NOTE_EDUCATIONCODECURRENTLY4=EdCommCollegeOR4yrCurrKET.
rename vars NOTE_EDUCATIONCODECURRENTLY5=EdGradSchoolCurrKET.
rename vars NOTE_EDUCATIONCODECURRENTLY6=EdOtherSchoolCurrKET.

rename vars NOTE_EDUGRADELEVELTYPE=EdLevelChangeKET.

compute EducChange=1.
if EdLevelChangeKET= "No change" EducChange=0.
exe.

string RecoveryGoalsEducation(a3).

if NOTE_EDUCATIONRECOVERYGOALS="True" RecoveryGoalsEducation="Yes".
if NOTE_EDUCATIONRECOVERYGOALS="False" RecoveryGoalsEducation="No".


string gradetext(a64).
compute gradetext = edLevelChangeKET.

sort cases by gradetext.
match files /table = '//covenas/decisionsupport/meinzer/tables/gradetext.sav' /file=* /by gradetext.
*freq grade.


******** Employment.

rename vars NOTE_DATEEMPCHANGE=DateEmpChangeKET.

rename variables 
	note_EmpStatusCodeAvgHrsWeek1=EmpCompetHrKET
	note_EmpStatusCodeAvgHrsWeek2=EmpSuptHrKET
	note_EmpStatusCodeAvgHrsWeek3=EmpTransHrKET
	note_EmpStatusCodeAvgHrsWeek4=EmpPdInHseHrKET
	note_EmpStatusCodeAvgHrsWeek5=EmpVolHrKET
	note_EmpStatusCodeAvgHrsWeek6=EmpOtherHrKET.

rename variables 
	note_EmpStatusCodeHrWage1=EmpCompetWgKET
	note_EmpStatusCodeHrWage2=EmpSuptWgKET
	note_EmpStatusCodeHrWage3=EmpTransWgKET
	note_EmpStatusCodeHrWage4=EmpPdInHseWgKET
	note_EmpStatusCodeHrWage6=EmpOtherWgKET.

string EmpRecoveryGoalKET(a3).
If note_RecoveryGoals = "Yes" EmpRecoveryGoalKET ="Yes".
If note_RecoveryGoals = "No" or note_RecoveryGoals ='False' EmpRecoveryGoalKET ="No".
exe.
aggregate outfile =* mode=addVariables
/break = case 
/EmploymentRecoveryGoalKET=max(EmpRecoveryGoalKET).
exe.
delete vars EmpRecoveryGoalKET.
EXECUTE.

*freq Note_employed.
if NOTE_EMPLOYED ="True"  UnemployedKET=1.
if NOTE_EMPLOYED="False"   UnemployedKET=0.

string EmpTypeKET(a40).
if UnemployedKET=1 EmpLevelKET=0.
if EmpLevelKET=0 EmpTypeKET="Unemployed".

if number(EmpVolHrKET, f1) gt 0 EmpLevelKET=1. 
if EmpLevelKET=1  EmpTypeKET="Volunteer Experience".

if number(EmpOtherHrKET, f1) gt 0 EmpLevelKET=2. 
if EmpLevelKET=2 EmpTypeKET="Other Gainful Employ Activity".

if number(EmpPdInHseHrKET, f1) gt 0 EmpLevelKET=3.
if EmpLevelKET=3 EmpTypeKET="Paid In-House/Work Experience".

if number(EmpTransHrKET, f1) gt 0 EmpLevelKET=4.
if EmpLevelKET=4 EmpTypeKET="Transitional/Enclave".

if number(EmpSuptHrKET, f1) gt 0 EmpLevelKET=5.
if EmpLevelKET=5 EmpTypeKET="Supported".

if number(EmpCompetHrKET, f1) gt 0 EmpLevelKET=6.
if EmpLevelKET=6 EmpTypeKET="Competitive".


Compute CompSalaryKET=number(EmpCompetHrKET , f4)*Number(EmpCompetWgKET , f4).
Compute SuppSalaryKET=number(EmpSuptHrKET, f4)*number(EmpSuptWgKET, f4).
Compute TransSalaryKET=number(EmpTransHrKET, f4)*number(EmpTransWgKET, f4).
COmpute InHouseSalaryKET=number(EmpPdInHseHrKET, f4)*number(EmpPdInHseWgKET, f4).
Compute OtherSalaryKET=number(EmpOtherHrKET, f4)*number(EmpOtherWgKET, f4).

Compute AvgSalaryKET=sum(CompSalaryKET, SuppSalaryKET, TransSalaryKET, InHouseSalaryKET, OtherSalaryKET).
*check all dates.
*format to 
exe.
aggregate outfile =* mode=addVariables /break = case /mostRecentEmpChangeKET=max(DateEmpChangeKET).


if DateEmpChangeKET = mostRecentEmpChangeKET CurrentEmpLevelKET= EmpLevelKET.
if DateEmpChangeKET = mostRecentEmpChangeKET CurrentAvgSalaryKET= AvgSalaryKET.
exe.
aggregate outfile =* mode=addVariables overwrite=yes /break = case  /CurrentEmpLevelKET=max(CurrentEmpLevelKET)
/CurrentAvgSalaryKET=max(CurrentAvgSalaryKET).
exe.
String CurrentEmpTypeKET (a40).
if CurrentEmpLevelKET=0 CurrentEmpTypeKET ="Unemployed".
if CurrentEmpLevelKET=1 CurrentEmpTypeKET ="Volunteer Experience".
if CurrentEmpLevelKET=2 CurrentEmpTypeKET ="Other Gainful Employ Activity".
if CurrentEmpLevelKET=3 CurrentEmpTypeKET ="Paid In-House/Work Experience".
if CurrentEmpLevelKET=4 CurrentEmpTypeKET ="Transitional/Enclave".
if CurrentEmpLevelKET=5 CurrentEmpTypeKET ="Supported".
if CurrentEmpLevelKET=6 CurrentEmpTypeKET ="Competitive".

exe.
aggregate outfile =* mode=addVariables 
/break = case 
/HighestEmpAchievedKET=max(EmpLevelKET)
/HighestSalaryAchievedKET=max(AvgSalaryKET).
exe.
String HighestEmpTypeAchievedKET (a40).
if HighestEmpAchievedKET=0 HighestEmpTypeAchievedKET ="Unemployed".
if HighestEmpAchievedKET=1 HighestEmpTypeAchievedKET ="Volunteer Experience".
if HighestEmpAchievedKET=2 HighestEmpTypeAchievedKET ="Other Gainful Employ Activity".
if HighestEmpAchievedKET=3 HighestEmpTypeAchievedKET ="Paid In-House/Work Experience".
if HighestEmpAchievedKET=4 HighestEmpTypeAchievedKET ="Transitional/Enclave".
if HighestEmpAchievedKET=5 HighestEmpTypeAchievedKET ="Supported".
if HighestEmpAchievedKET=6 HighestEmpTypeAchievedKET ="Competitive".


***HOUSING.
rename vars
note_ResSettingType=HousingText
note_DateResiChange=HousingChangeDateKET.



compute residentialchange=1.
if HousingText="No change" ResidenceChange=0.

compute housingtext=rtrim(ltrim(housingtext)).
if HOUSINGTEXT="In an apartment or house alone / with spouse / partner / minor children / other dependents / roommate - must hold lease or sh                           "  
	HOUSINGTEXT="In an apartment or house alone or with others - must hold lease or share in rent / mortgage".
if HOUSINGTEXT="In an apartment or house alone / with spouse / partner / minor children / other dependents / roommate - must hold lease or share in rent / mortgage"  
	HOUSINGTEXT="In an apartment or house alone or with others - must hold lease or share in rent / mortgage".
if HOUSINGTEXT="In an apartment or house alone / with spouse / partner / minor children / other dependents / roommate"  
	HOUSINGTEXT="In an apartment or house alone or with others - must hold lease or share in rent / mortgage".

RENAME VARIABLES HOUSINGTEXT=HOUSINGTEXT147.
STRING HOUSINGTEXT(A125).
COMPUTE HOUSINGTEXT = SUBSTR(HOUSINGTEXT147,1,125).
*FREQ HOUSINGTEXT.
EXECUTE.
sort cases by housingtext.
match files /table='//covenas/decisionsupport/meinzer/tables/housingtexttable.sav'  /file=* /by housingtext /drop statenum.
rename variables statestring=Current.
EXECUTE.
delete vars housingtext147.
rename vars housingtext=ResSettingChangeKET.
rename vars notetitle=KETNoteTitle  note_text=KETNote_text.
compute measure =2.
Compute KETAssessmentDate = num(note_AssessmentDate,adate10) .
formats KETAssessmentDate(adate10).

rename variables DATEGRADECOMPLETE = DATEGRADECOMPLETEx.
rename variables DATESUSPENSION = DATESUSPENSIONx.
rename variables DATEEXPULSION = DATEEXPULSIONx.
rename variables DATEARRESTED = DATEARRESTEDx.
rename variables DATEPROBATION = DATEPROBATIONx.
rename variables DATEPAROLE = DATEPAROLEx.
rename variables DATECONSERVA = DATECONSERVAx.
rename variables DATEPAYEE = DATEPAYEEx.
rename variables DATEEMERGENCYCHANGE = DATEEMERGENCYCHANGEx.
rename variables DATEPROVICHANGE = DATEPROVICHANGEx.
rename variables DATEPROGMCHANGE = DATEPROGMCHANGEx.

Compute DateKETStatusChange = num(DATESTATUSCHANGE,adate10) .

Compute AB2034ChangeDate = num(NOTE_AB2034DATE,adate10) .
Compute GHIChangeDate = num(GHIDATE,adate10) .
Compute MHSAChangeDate = num(MHSAHPCHANGEDATE,adate10) .
Compute DateResidentialChange = num(HousingChangeDateKET,adate10) .
Compute DateSettingChange = num(EdSettingChangeDateKET,adate10) .
Compute DateEmpChange = num(DateEmpChangeKET,adate10) .
Compute DateDepen = num(DATEWICODE,adate10) .

compute DateGradeComplete = num(DATEGRADECOMPLETEx, adate10).
compute DateSuspension = num(DATESUSPENSIONx, adate10).
compute DateExpulsion = num(DATEEXPULSIONx, adate10).
compute DateArrested = num(DATEARRESTEDx, adate10).
compute DateProbation = num(DATEPROBATIONx, adate10).
compute DateParole = num(DATEPAROLEx, adate10).
compute DateConserva = num(DATECONSERVAx, adate10).
compute DatePayee = num(DATEPAYEEx, adate10).
compute DateEmergencyChange = num(DATEEMERGENCYCHANGEx, adate10).
compute DateProviChange = num(DATEPROVICHANGEx, adate11).
compute DateProgmChange = num(DATEPROGMCHANGEx, adate12).


formats DateKETStatusChange(adate10).

formats AB2034ChangeDate(adate10).
formats GHIChangeDate(adate10).
formats MHSAChangeDate(adate10).
formats DateResidentialChange(adate10).
formats DateSettingChange(adate10).
formats DateEmpChange(adate10).
formats DateDepen(adate10).

formats DateGradeComplete(adate10).
formats DateSuspension(adate10).
formats DateExpulsion(adate10).
formats DateArrested(adate10).
formats DateProbation(adate10).
formats DateParole(adate10).
formats DateConserva(adate10).
formats DatePayee(adate10).
formats DateEmergencyChange(adate10).
formats DateProviChange(adate11).
formats DateProgmChange(adate12).
compute KetHousingDate = num(HousingChangeDateKET,adate12).
formats kethousingdate(date10).
SAVE OUTFILE='//covenas/decisionsupport/meinzer/temp/CGKETWork.sav'.
 * get FILE='//covenas/decisionsupport/meinzer/temp/CGKETWork.sav'.
******end KET*****.



******** QTR CG PULL ***************.


GET DATA
  /TYPE=ODBC
  /CONNECT='DSN=CGReporting;Description=mhs;UID=;Trusted_Connection=Yes;APP=IBM SPSS Products: '+
    'Statistics Common;WSID=HPMXL2221NXK;DATABASE=Reporting'
  /SQL='SELECT __row_id AS QtrStamp, client_number, reporting_unit, CreateDate, Opening_Date, '+
    'ServiceID, "Note ID" AS Note_ID, "Note Title" AS NoteTitle, note_text, NOTE_DYNCHECKBOX10, '+
    'NOTE_DYNCHECKBOX13, NOTE_DYNCHECKBOX12, NOTE_DYNCHECKBOX6, NOTE_DYNCHECKBOX3, '+
    'NOTE_DYNTEXTBOX5, NOTE_DYNCHECKBOX2, NOTE_DYNCHECKBOX9, NOTE_SARS, NOTE_DYNCHECKBOX8, '+
    'NOTE_FINANCIALSUPPORTNONE, NOTE_ASSESSMENTDATE, NOTE_DYNTEXTBOX2, NOTE_DYNTEXTBOX3, '+
    'NOTE_DYNCHECKBOX14, NOTE_DYNTEXTBOX4, NOTE_SACO, NOTE_DYNCHECKBOX4, NOTE_HEALTHPCP, '+
    'NOTE_DYNCHECKBOX18, NOTE_DYNCHECKBOX15, NOTE_DYNCHECKBOX7, NOTE_DYNCHECKBOX17, '+
    'NOTE_DYNCHECKBOX16, NOTE_DYNCHECKBOX11, NOTE_CBAMERICANINDIAN, NOTE_CBLOADCREDIT, '+
    'NOTE_TXTQUARTERLYLIST, NOTE_TXTERRORCOMPLETIONFUTUREDATE, NOTE_CBVETERANASSISTANCE, '+
    'NOTE_TXTPARTNERBIRTHDATE, NOTE_TXTERRORCOMPLETIONDATE, NOTE_TXTERRORINVALIDDATE, '+
    'NOTE_CBGENERALRELIEF, NOTE_CBSAVINGS, NOTE_TXTAGE, NOTE_CBFOODSTAMPS, '+
    'NOTE_CBTEMPORARYASSISTANCE, NOTE_CBPARTNERWAGES, NOTE_TXTTOTALERROR, NOTE_CBSOCIALSECURITY, '+
    'NOTE_CBOTHER, NOTE_CBRETIREMENT, NOTE_CBSTATEDISABILITY, NOTE_CBOTHERFAMILYMEMBER, '+
    'NOTE_TXTERRORAGE, NOTE_CBPARTNERSPOUSE, NOTE_CBSUPPLEMENTALSECURITY, NOTE_TXTPAFDATE, '+
    'NOTE_CBHOUSINGSUBSIDY, NOTE_IADLSHOPPING, NOTE_ADLDRESSING, NOTE_IADLMEDICATION, '+
    'NOTE_IADLTELEPHONE, NOTE_ADLFEEDING, NOTE_ADLTRANSFER, NOTE_IADLLAUNDRY, NOTE_IADLHOUSEWORK, '+    
    'NOTE_ADLBATHING, NOTE_ADLCONTINENCE, NOTE_IADLHANDYMAN, NOTE_IADLMEALS, NOTE_IADLWALKING, '+
    'NOTE_ADLTOILETING, NOTE_IADLMONEY, NOTE_ADLCONFINE, NOTE_ADLWALKING, NOTE_CGSTAFFNUMBER, '+
    'NOTE_DYNTEXTBOX6, NOTE_EDUCATIONED, NOTE_DYNCHECKBOX5, NOTE_EDUCATIONOR, '+
    'NOTE_EDUCATIONGRADES, NOTE_EDUCATIONAL, NOTE_DYNCHECKBOX1, '+
    'NOTE_CBTEMPORARYASSISTANCEFORNEEDYFAMILIES, NOTE_CBYOUTHSSPOUSE, '+
    'NOTE_CBSTATEDISABILITYINSURANCE, NOTE_CBCAREGIVERWAGES, '+
    'NOTE_CBRETIREMENTSOCIALSECURITYINCOME, NOTE_CBVETERANSASSISTANCEBENEFITS, '+
    'NOTE_CBAMERICANINDIANTRIBALBENEFITS, NOTE_CBOTHERFAMILYMEMBERFRIEND, '+
    'NOTE_CBGENERAKASSISTANCE, NOTE_CBYOUTHWAGES, NOTE_CBCHILDSUPPORT, '+
    'NOTE_CBSOCIALSECURITYDESABILITYINSURANCE, NOTE_CBSUPPLEMENTALSECURITYINCOME, '+
    'NOTE_CBLOANCREDIT, NOTE_TXTASSESSMENTDATE, NOTE_DYNTEXTBOX10, NOTE_DYNTEXTBOX11, '+
    'NOTE_DYNTEXTBOX12, NOTE_DYNTEXTBOX13, NOTE_DYNTEXTBOX14, NOTE_DYNTEXTBOX15, '+
    'NOTE_DYNTEXTBOX16, NOTE_SAACTIVE, NOTE_DYNTEXTBOX18, NOTE_DYNTEXTBOX7, NOTE_DYNTEXTBOX9, '+
    'NOTE_DYNTEXTBOX8, NOTE_DYNTEXTBOX17 FROM Reporting.dbo.[QA]'
  /ASSUMEDSTRWIDTH=255.
CACHE.
EXECUTE.

*get file = '//covenas/spssdata/temp\CGQtrPull.sav'.

rename vars 
client_number =Case 
reporting_unit=RU opening_date=opdate.

sort cases by ru.
match files/table='//covenas/spssdata/ruTableRU2.sav' /file=* /by ru.
if ru2 ne " " Ru = RU2.
sort cases by ru.
match files/table='//covenas/spssdata/ruTableRU2.sav' /file=* /by ru.

sort cases by ru case opdate.
match files /table='//covenas/decisionsupport/epsCG.sav' /file=* /by ru case opdate /drop primdx refsrce primarytherapist lst_svc epflag.
sort cases by case opdate.
if lag(case)=case and  opdate ne lag(opdate) and datediff(opdate,lag(closdate),'years') ge 1 opdate=lag(opdate).

String FSPName (a20).
if RU="018435" FSPName="FSP-3 STAY".
if RU="01EE1" FSPName="FSP-1 HOST".
if RU="01EG1"   FSPName="FSP-4 GH".
if RU="01EM1" FSPName="FSP-2 NCSHP".
if RU="81486"  FSPName="FSP-5 FACT".
if RU="88036" FSPName="FSP-6 TIP".
if RU="81487" FSPName="FSP-9 TRACT".
if RU="01FZ1" FSPName="FSP-7 CHOICES".
if RU="01028" FSPName="FSP-7 CHOICES".
if RU="0108T1" FSPName="FSP-7 CHOICES".
if RU="01221" FSPName="FSP-7 CHOICES".
if RU= "01911" FSPName="FSP-7 CHOICES".
if RU="8133T1" FSPName="FSP-7 CHOICES".
if RU="01333" FSPName="FSP-7 CHOICES".
if RU="01EE2" FSPName="FSP-7 CHOICES".
*new below.
if RU="01521" FSPName="FSP-7 CHOICES".
if RU="0152M1" FSPName="FSP-7 CHOICES".
if RU="0112T1" FSPName="FSP-7 CHOICES".
if RU="0112T2" FSPName="FSP-7 CHOICES".
if RU="0112M1" FSPName="FSP-7 CHOICES".
if RU="0170T1" FSPName="FSP-7 CHOICES".
if RU="0170T2" FSPName="FSP-7 CHOICES".
if RU="01113" FSPName="FSP-7 CHOICES".


rename variables ServiceID=ServiceIDQTR.


Compute QTRAssessmentDate=num(note_AssessmentDate,adate10) .	
formats QTRAssessmentDate(adate10).
rename variables NOTE_DYNCHECKBOX1 = QtrCaregiverWages.
rename variables NOTE_DYNCHECKBOX2 = QtrWages.
rename variables NOTE_DYNCHECKBOX3 = QtrSpouseWages.
rename variables NOTE_DYNCHECKBOX4 = QtrSavings.
rename variables NOTE_DYNCHECKBOX5 = QtrChildSupport.
rename variables NOTE_DYNCHECKBOX6 = QtrFamFriend.
rename variables NOTE_DYNCHECKBOX7 = QtrSSIRetire.
rename variables NOTE_DYNCHECKBOX8 = QtrVetBen.
rename variables NOTE_DYNCHECKBOX9 = QtrLoan.
rename variables NOTE_DYNCHECKBOX10 = QtrHousSubsidy.
rename variables NOTE_DYNCHECKBOX11 = QtrGA.
rename variables NOTE_DYNCHECKBOX12 = QtrFoodSt.
rename variables NOTE_DYNCHECKBOX13 = QtrTANF.
rename variables NOTE_DYNCHECKBOX14 = QtrSSISSP.
rename variables NOTE_DYNCHECKBOX15 = QtrSSDI.
rename variables NOTE_DYNCHECKBOX16 = QtrSDI.
rename variables NOTE_DYNCHECKBOX17 = QtrTribalBen.
rename variables NOTE_DYNCHECKBOX18 = QtrOther.
rename variables NOTE_DYNTEXTBOX2 = QtrCourtDep.
rename variables NOTE_DYNTEXTBOX3 = QtrFosterCare.
rename variables NOTE_DYNTEXTBOX4 = QtrReunified.
rename variables NOTE_DYNTEXTBOX5 = QtrAdopted.
rename variables NOTE_EDUCATIONAL = QtrAttendance.
rename variables NOTE_EDUCATIONED = QtrEducSED.
rename variables NOTE_EDUCATIONGRADES = QtrGrades.
rename variables NOTE_EDUCATIONOR = QtrEducOR.
rename variables NOTE_FINANCIALSUPPORTNONE = QtrNone.
rename variables NOTE_HEALTHPCP = QtrHealthPCP.

*sort cases by RU case QtrAssessDate .


string QTRCurWage(a400).

do if QtrWages="True".
do if QTRCURWage=' '.
compute QTRCURWage = 'Partners Wages'.
else.
compute QTRCURWage=Concat(ltrimg(rtrim(QTRCURWage)),', ','Partners Wages').
end if.
End if.
do if QtrSpouseWages="True".
do if QTRCurWage=' '.
compute QTRCurWage = 'Partners Spouse/Significant Other Wages'.
else.
compute QTRCurWage=Concat(ltrimg(rtrim(QTRCurWage)),', ','Partners Spouse/Significant Other Wages').
end if.
End if.
do if QtrSavings="True".
do if QTRCurWage=' '.
compute QTRCurWage = 'Savings'.
else.
compute QTRCurWage=Concat(ltrimg(rtrim(QTRCurWage)),', ','Savings').
end if.
End if.
do if QtrFamFriend="True".
do if QTRCurWage=' '.
compute QTRCurWage = 'Other Family Member/Friend'.
else.
compute QTRCurWage=Concat(ltrimg(rtrim(QTRCurWage)),', ','Other Family Member/Friend').
end if.
End if.
do if QtrSSIRetire="True".
do if QTRCurWage=' '.
compute QTRCurWage = 'Retirement/Social Security Income'.
else.
compute QTRCurWage=Concat(ltrimg(rtrim(QTRCurWage)),', ','Retirement/Social Security Income').
end if.
End if.
do if QtrVetBen="True".
do if QTRCurWage=' '.
compute QTRCurWage = 'Veterans Assistance Benefits'.
else.
compute QTRCurWage=Concat(ltrimg(rtrim(QTRCurWage)),', ','Veterans Assistance Benefits').
end if.
End if.
do if QtrLoan="True".
do if QTRCurWage=' '.
compute QTRCurWage = 'Loan/Credit'.
else.
compute QTRCurWage=Concat(ltrimg(rtrim(QTRCurWage)),', ','Loan/Credit').
end if.
End if.
do if QtrHousSubsidy="True".
do if QTRCurWage=' '.
compute QTRCurWage = 'Housing Subsidy'.
else.
compute QTRCurWage=Concat(ltrimg(rtrim(QTRCurWage)),', ','Housing Subsidy').
end if.
End if.
do if QtrGA="True".
do if QTRCurWage=' '.
compute QTRCurWage = 'General Relief/General Assistance'.
else.
compute QTRCurWage=Concat(ltrimg(rtrim(QTRCurWage)),', ','General Relief/General Assistance').
end if.
End if.
do if QtrFoodSt="True".
do if QTRCurWage=' '.
compute QTRCurWage = 'Food Stamps'.
else.
compute QTRCurWage=Concat(ltrimg(rtrim(QTRCurWage)),', ','Food Stamps').
end if.
End if.
do if QtrTANF="True".
do if QTRCurWage=' '.
compute QTRCurWage = 'Temporary Assistance for Needy Families (TANF)'.
else.
compute QTRCurWage=Concat(ltrimg(rtrim(QTRCurWage)),', ','Temporary Assistance for Needy Families (TANF)').
end if.
End if.
do if QtrSSISSP="True".
do if QTRCurWage=' '.
compute QTRCurWage = 'Supplemental Security Income/State Supplementary Payment Program (SSI/SSP)'.
else.
compute QTRCurWage=Concat(ltrimg(rtrim(QTRCurWage)),', ','Supplemental Security Income/State Supplementary Payment Program (SSI/SSP)').
end if.
End if.
do if QtrSSDI="True".
do if QTRCurWage=' '.
compute QTRCurWage = 'Social Security Disability Insurance (SSDI)'.
else.
compute QTRCurWage=Concat(ltrimg(rtrim(QTRCurWage)),', ','Social Security Disability Insurance (SSDI)').
end if.
End if.
do if QtrSDI="True".
do if QTRCurWage=' '.
compute QTRCurWage = 'State Disability Insurance (SDI)'.
else.
compute QTRCurWage=Concat(ltrimg(rtrim(QTRCurWage)),', ','State Disability Insurance (SDI)').
end if.
End if.
do if QtrTribalBen="True".
do if QTRCurWage=' '.
compute QTRCurWage = 'American Indian Tribal Benefits (per Capita, revenue sharing, trust disbursements)'.
else.
compute QTRCurWage=Concat(ltrimg(rtrim(QTRCurWage)),', ','American Indian Tribal Benefits (per Capita, revenue sharing, trust disbursements)').
end if.
End if.
do if QtrOther="True".
do if QTRCurWage=' '.
compute QTRCurWage = 'Other'.
else.
compute QTRCurWage=Concat(ltrimg(rtrim(QTRCurWage)),', ','Other').
end if.
End if.
do if QtrNone="True".
do if QTRCurWage=' '.
compute QTRCurWage = 'No Financial Support'.
else.
compute QTRCurWage=Concat(ltrimg(rtrim(QTRCurWage)),', ','No Financial Support').
end if.
End if.
rename vars notetitle=QTRNoteTitle  note_text=QTRNote_text.
compute Measure = 3.
SAVE OUTFILE='//covenas/decisionsupport/meinzer/temp/CGQTR.SAV'.



