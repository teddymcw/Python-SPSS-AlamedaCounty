
 * save translate /TYPE=ODBC /CONNECT='DSN=FSP_Kate;DBQ=//covenas/decisionsupport/MEINZER\PROJECTS\FSP\Deliv. 7.2 DCR_Client-Level'+
 '-Report_Access2010_Encrypted_2012-1216.accdb'
 /table = 'NewTable' /MAP /REPLACE.
 * CACHE.


**append,replace(create),update.

 * GET DATA /TYPE=ODBC /CONNECT=
 'DSN=FSP_Kate;DBQ=//covenas/decisionsupport/MEINZER\PROJECTS\FSP\Deliv. 7.2 DCR_Client-Level'+
 '-Report_Access2010_Encrypted_2012-1216.accdb;'
  'DriverId=25;FIL=MS Access;MaxBufferSize=2048;PageTimeout=5;'
 /SQL = 'SELECT   * FROM  NewTable'
 /ASSUMEDSTRWIDTH=255
 .
 * CACHE.


*State DCR.

get file='//covenas/decisionsupport/meinzer/temp/CGPAFWork_LONG.sav'.

string globalid AssessmentGUID(a36).
compute globalid=concat(ltrim(string(case,f11)),string(opdate,date11)).
compute AssessmentGUID =concat(ltrim(string(case,f11)),string(AssessmentDate,date11)).
insert file='//covenas/decisionsupport/meinzer/modules/trueconvert.sps'.

formats case(n9).
string CSINumber(a9).
compute CSINumber = ltrim(string(Case,n9)).

if substr(MoneyMangage, 1,40) = 'Without help' MoneyMangage='1'.
if substr(MoneyMangage, 1,40) = 'With some help' MoneyMangage='2'.
if substr(MoneyMangage, 1,40) = 'Completely unable to do' MoneyMangage='3'.

if substr(MedicationSelf, 1,40) = 'Without help' MedicationSelf='1'.
if substr(MedicationSelf, 1,40) = 'With some help' MedicationSelf='2'.
if substr(MedicationSelf, 1,40) = 'Completely unable to do' MedicationSelf='3'.

if substr(LAUNDRY, 1,40) = 'Without help' LAUNDRY='1'.
if substr(LAUNDRY, 1,40) = 'With some help' LAUNDRY='2'.
if substr(LAUNDRY, 1,40) = 'Completely unable to do' LAUNDRY='3'.

if substr(HandymanWork, 1,40) = 'Without help' HandymanWork='1'.
if substr(HandymanWork, 1,40) = 'With some help' HandymanWork='2'.
if substr(HandymanWork, 1,40) = 'Completely unable to do' HandymanWork='3'.

if substr(Housework, 1,40) = 'Without help' Housework='1'.
if substr(Housework, 1,40) = 'With some help' Housework='2'.
if substr(Housework, 1,40) = 'Completely unable to do' Housework='3'.

if substr(MealPreparation, 1,40) = 'Without help' MealPreparation='1'.
if substr(MealPreparation, 1,40) = 'With some help' MealPreparation='2'.
if substr(MealPreparation, 1,40) = 'Completely unable to do' MealPreparation='3'.

if substr(ShoppingFood, 1,40) = 'Without help' ShoppingFood='1'.
if substr(ShoppingFood, 1,40) = 'With some help' ShoppingFood='2'.
if substr(ShoppingFood, 1,40) = 'Completely unable to do' ShoppingFood='3'.

if substr(GoBeyondWalkDist, 1,40) = 'Without help' GoBeyondWalkDist='1'.
if substr(GoBeyondWalkDist, 1,40) = 'With some help' GoBeyondWalkDist='2'.
if substr(GoBeyondWalkDist, 1,40) = 'Completely unable to do' GoBeyondWalkDist='3'.

if substr(TelephoneUse, 1,40) = 'Without help' TelephoneUse='1'.
if substr(TelephoneUse, 1,40) = 'With some help' TelephoneUse='2'.
if substr(TelephoneUse, 1,40) = 'Completely unable to do' TelephoneUse='3'.

if substr(ConfinementHouse, 1,40) = 'Has been outside of residence on 3 or mo' ConfinementHouse='1'.
if substr(ConfinementHouse, 1,40) = 'Has been outside of residence on only 1' ConfinementHouse='2'.
if substr(ConfinementHouse, 1,40) = 'Has not been outside of residence in pas' ConfinementHouse='3'.

if substr(WALKING, 1,40) = 'Walks on level without assistance' WALKING='1'.
if substr(WALKING, 1,40) = 'Walks without assistance but uses single' WALKING='2'.
if substr(WALKING, 1,40) = 'Walks without assistance but uses two po' WALKING='3'.
if substr(WALKING, 1,40) = 'Walks with assistance' WALKING='4'.
if substr(WALKING, 1,40) = 'Uses wheelchair only' WALKING='5'.
if substr(WALKING, 1,40) = 'Not walking or using wheelchair' WALKING='6'.

if substr(feeding, 1,40) = 'Feeds self without assistance' feeding='1'.
if substr(feeding, 1,40) = 'Feeds self except for getting assistance' feeding='2'.
if substr(feeding, 1,40) = 'Receives assistance in feeding or is fed' feeding='3'.

if substr(TRANSFER, 1,40) = 'Moves in and out of bed as well as in an' TRANSFER='1'.
if substr(TRANSFER, 1,40) = 'Moves in and out of bed or chair with as' TRANSFER='2'.
if substr(TRANSFER, 1,40) = "Doesn't get out of bed" TRANSFER='3'.

if substr(Toileting, 1,40) =  "Doesn't go to room termed 'toilet' for t" Toileting='3'.
if substr(Toileting, 1,40) =  "Goes to 'toilet room,' cleans self, and" Toileting='1'.
if substr(Toileting, 1,40) =  "Receives assistance in going to the 'toi" Toileting='2'.

if substr(dressing, 1,40) = 'Gets clothes and gets completely dressed' dressing='1'.
if substr(dressing, 1,40) = 'Gets clothes and gets dressed without as' dressing='2'.
if substr(dressing, 1,40) = 'Receives assistance in getting clothes o' dressing='3'.

if substr(GradesPast12, 1,40) = 'Very Good' GradesPast12='1'.
if substr(GradesPast12, 1,40) = 'Good' GradesPast12='2'.
if substr(GradesPast12, 1,40) = 'Average' GradesPast12='3'.
if substr(GradesPast12, 1,40) = 'Below Average' GradesPast12='4'.
if substr(GradesPast12, 1,40) = 'Poor' GradesPast12='5'.

if substr(GradesCurr, 1,40) = 'Very Good' GradesCurr='1'.
if substr(GradesCurr, 1,40) = 'Good' GradesCurr='2'.
if substr(GradesCurr, 1,40) = 'Average' GradesCurr='3'.
if substr(GradesCurr, 1,40) = 'Below Average' GradesCurr='4'.
if substr(GradesCurr, 1,40) = 'Poor' GradesCurr='5'.

if substr(Attendancecurr, 1,40) = 'Always attends school (never truant)' Attendancecurr='1'.
if substr(Attendancecurr, 1,40) = 'Attends school most of the time' Attendancecurr='2'.
if substr(Attendancecurr, 1,40) = 'Sometimes attends school' Attendancecurr='3'.
if substr(Attendancecurr, 1,40) = 'Infrequently attends school' Attendancecurr='4'.
if substr(Attendancecurr, 1,40) = 'Never attends school' Attendancecurr='5'.

if substr(AttendancePast12, 1,40) = 'Always attends school (never truant)' AttendancePast12='1'.
if substr(AttendancePast12, 1,40) = 'Attends school most of the time' AttendancePast12='2'.
if substr(AttendancePast12, 1,40) = 'Sometimes attends school' AttendancePast12='3'.
if substr(AttendancePast12, 1,40) = 'Infrequently attends school' AttendancePast12='4'.
if substr(AttendancePast12, 1,40) = 'Never attends school' AttendancePast12='5'.

if substr(bathing, 1,40) = "Receives no assistance gets in and out" Bathing="1".
if substr(bathing, 1,40) = "Receives assistance in bathing more than" Bathing="2".
if substr(bathing, 1,40) = "Receives assistance in bathing only one" Bathing="3".

if substr(CONTINENCE, 1,40) = "Controls urination and bowel movement co" CONTINENCE="1".
if substr(CONTINENCE, 1,40) = "Has occasional 'accidents'" CONTINENCE="2".
if substr(CONTINENCE, 1,40) = "Supervision helps keep urine or bowel co" CONTINENCE="3".

if substr(referredby, 1,4)="Self" referredby="01".
if substr(referredby, 1,4)="Sign" referredby="03".
if substr(referredby, 1,4)="Scho" referredby="05".
if substr(referredby, 1,4)="Emer" referredby="07".
if substr(referredby, 1,4)="Soci" referredby="09".
if substr(referredby, 1,4)="Fait" referredby="11".
if substr(referredby, 1,4)="Home" referredby="13".
if substr(referredby, 1,4)="Juve" referredby="15".
if substr(referredby, 1,4)="Acut" referredby="17".
if substr(referredby, 1,4)="Fami" referredby="02".
if substr(referredby, 1,4)="Frie" referredby="04".
if substr(referredby, 1,4)="Prim" referredby="06".
if substr(referredby, 1,4)="Ment" referredby="08".
if substr(referredby, 1,4)="Subs" referredby="10".
if substr(referredby, 1,8)="Other Co" referredby="12".
if substr(referredby, 1,4)="Stre" referredby="14".
if substr(referredby, 1,4)="Jail" referredby="16".
if substr(referredby, 1,8)="Other re" referredby="18".

sort cases by case .
match files /table='//covenas/spssdata/clinfo.sav' /file=* /by case /drop  bornname  language disab educ created cin marital minors ssn.

compute name=concat(rtrim(SUBSTR(name,1,index(name,"  "))),", ",ltrim(SUBSTR(name,index(name,"  "),28))).

sort cases by ru.
match files /table='//covenas/decisionsupport/rutable.sav' /file=* /by ru /drop svcmode DayTx kidsru psmask2 school cds_Code agency county ab3632RU CESDC Level3Classic OAru Level2
TAYru MHSA svcType svcType3 EPSDTGroup  start_dt end_dt program Residential OutCty CalWorks SafePassages RUCITY frc.

if ru2 ne "  " RU=ru2.

string ProgramDesc(a255).
compute ProgramDesc  = concat(RU," ",rtrim(provname)).

Sort cases by ethnic.
Match Files /Table='//covenas/decisionsupport/ethnicity.sav' /File=* /by ethnic.
If hispanic="G" or hispanic="M" or hispanic="N" or hispanic="S" or hispanic="5" or hispanic="2" Ethnicity="Latino".
If hispanic="G" or hispanic="M" or hispanic="N" or hispanic="S" or hispanic="5" or hispanic="2" RaceEthnicityCode="2".
If Ethnicity=" " or Ethnicity="Other" or Ethnicity="Unknown" Ethnicity="Other/Unknown".
match files/file=* /drop EthnicDetail PacificIslander ethnic ethnicity.
RECODE hispanic ('1'='N') ('U'='U') (MISSING='U') (ELSE='Y').

if RecoveryGoalsEducation = "Yes" RecoveryGoalsEducation ="1".
if RecoveryGoalsEducation = "No" RecoveryGoalsEducation ="0".

aggregate outfile=* mode=addvariables overwrite=yes
   /break case
   /partnershipdate=min(AssessmentDate).






save OUTFILE='//covenas/decisionsupport/meinzer/temp/CGPAFWork_LONGforSTATE.sav'.

string Ethnicity(a1).	
compute Ethnicity = Hispanic.

rename variables ReferredBy = ReferredByx.
rename variables AB2034 = AB2034x.
rename variables GHI = GHIx.
rename variables name = namex.

Compute DatePartnershipStatusChange= $sysmis.

Compute DateOfBirth = bday .
Compute CSIDateOfBirth= bday .

 * Compute PartnershipDate= $sysmis.
Compute PartnershipStatus= $sysmis.
Compute PAFStatus= $sysmis.
Compute AssessmentSource= $sysmis.
Compute Age_Group= $sysmis.
compute ReferredBy = num(ReferredByx,f2).
compute JuvenileHallSLASHCamp_PastTwelveOccurences = num(JuviHallOcc,f3.0).
compute IndividualPlacement_PastTwelveOccurences = num(UnlicSupIndivOcc,f3.0).
compute MedicalHospital_PastTwelveDays = num(MedHospD,f3.0).
compute PsychiatricHospital_PastTwelveDays = num(PsychHospD,f3.0).
compute StatePsychiatric_PastTwelveDays = num(StatePsychHospD,f3.0).
compute GroupHome0DASH11_PastTwelveDays = num(GroupHome0to11D,f3.0).
compute GroupHome12DASH14_PastTwelveDays = num(GroupHome12to14D,f3.0).
compute CommunityCare_PastTwelveDays = num(BoardCareD,f3.0).
compute CommunityTreatment_PastTwelveDays = num(CommTreatD,f3.0).
compute ResidentialTreatment_PastTwelveDays = num(LicResTreatmtD,f3.0).
compute NursingPhysical_PastTwelveDays = num(SkNursPhysD,f3.0).
compute WithParents_PastTwelveDays = num(ParentsD,f3.0).
compute NursingPsychiatric_PastTwelveDays = num(SkNursPsychD,f3.0).
compute LongDASHTermCare_PastTwelveDays = num(LTInstCareD,f3.0).
compute JuvenileHallSLASHCamp_PastTwelveDays = num(JuviHallD,f3.0).
compute DJJ_PastTwelveDays = num(JuviJusticeD,f3.0).
compute Jail_PastTwelveDays = num(JailD,f3.0).
compute Prison_PastTwelveDays = num(PrisonD,f3.0).
compute OtherSetting_PastTwelveDays = num(OtherD,f3.0).
compute UnknownSetting_PastTwelveDays = num(UnknownD,f3.0).
compute WithOtherFamily_PastTwelveDays = num(FamilyD,f3.0).
compute ApartmentAlone_PastTwelveDays = num(AloneD,f3.0).
compute SingleRoomOccupancy_PastTwelveDays = num(SROD,f3.0).
compute FosterHomeRelative_PastTwelveDays = num(FosterRelD,f3.0).
compute EmergencyShelter_PastTwelveDays = num(EmergencyD,f3.0).
compute FosterHomeNonDASHrelative_PastTwelveDays = num(FosterNonRelD,f3.0).
compute Homeless_PastTwelveDays = num(HomelessD,f3.0).
compute AssistedLiving_PastTwelveDays = num(AssistLivingD,f3.0).
compute IndividualPlacement_PastTwelveDays = num(UnlicSupIndivD,f3.0).
compute CongregatePlacement_PastTwelveDays = num(CongregateD,f3.0).
compute WithParents_PastTwelveOccurences = num(ParentsOcc,f3.0).
compute MedicalHospital_PastTwelveOccurences = num(MedHospOcc,f3.0).
compute PsychiatricHospital_PastTwelveOccurences = num(PsychHospOcc,f3.0).
compute StatePsychiatric_PastTwelveOccurences = num(StatePsychHospOcc,f3.0).
compute GroupHome0DASH11_PastTwelveOccurences = num(GroupHome0to11Occ,f3.0).
compute NursingPhysical_PastTwelveOccurences = num(SkNursPhysOcc,f3.0).
compute NursingPsychiatric_PastTwelveOccurences = num(SkNursPsychOcc,f3.0).
compute GroupHome12DASH14_PastTwelveOccurences = num(GroupHome12to14Occ,f3.0).
compute CommunityCare_PastTwelveOccurences = num(BoardCareOcc,f3.0).
compute CommunityTreatment_PastTwelveOccurences = num(CommTreatOcc,f3.0).
compute LongDASHTermCare_PastTwelveOccurences = num(LTInstCareOcc,f3.0).
compute ResidentialTreatment_PastTwelveOccurences = num(LicResTreatmtOcc,f3.0).
compute Jail_PastTwelveOccurences = num(JailOcc,f3.0).
compute Prison_PastTwelveOccurences = num(PrisonOcc,f3.0).
compute OtherSetting_PastTwelveOccurences = num(OtherOcc,f3.0).
compute UnknownSetting_PastTwelveOccurences = num(UnknownOcc,f3.0).
compute DJJ_PastTwelveOccurences = num(JuviJusticeOcc,f3.0).
compute WithOtherFamily_PastTwelveOccurences = num(FamilyOcc,f3.0).
compute ApartmentAlone_PastTwelveOccurences = num(AloneOcc,f3.0).
compute SingleRoomOccupancy_PastTwelveOccurences = num(SROOcc,f3.0).
compute FosterHomeRelative_PastTwelveOccurences = num(FosterRelOcc,f3.0).
compute EmergencyShelter_PastTwelveOccurences = num(EmergencyOcc,f3.0).
compute FosterHomeNonDASHrelative_PastTwelveOccurences = num(FosterNonRelOcc,f3.0).
compute Homeless_PastTwelveOccurences = num(HomelessOcc,f3.0).
compute AssistedLiving_PastTwelveOccurences = num(AssistLivingOcc,f3.0).
compute CongregatePlacement_PastTwelveOccurences = num(CongregateOcc,f3.0).
string Gender(a1).
string Ethnicty_A(a1).
string Ethnicty_B(a1).

string Race1(a1).
string Race2(a1).
string Race3(a1).
string Race4(a1).
string Race5(a1).
string AB2034(a1).
string GHI(a1).
string MHSA(a1).
string WithParents_PriorTwelve(a1).
string CongregatePlacement_PriorTwelve(a1).
string MedicalHospital_PriorTwelve(a1).
string PsychiatricHospital_PriorTwelve(a1).
string StatePsychiatric_PriorTwelve(a1).
string GroupHome0DASH11_PriorTwelve(a1).
string GroupHome12DASH14_PriorTwelve(a1).
string CommunityCare_PriorTwelve(a1).
string CommunityTreatment_PriorTwelve(a1).
string NursingPhysical_PriorTwelve(a1).
string NursingPsychiatric_PriorTwelve(a1).
string LongDASHTermCare_PriorTwelve(a1).
string JuvenileHallSLASHCamp_PriorTwelve(a1).
string DJJ_PriorTwelve(a1).
string Jail_PriorTwelve(a1).
string Prison_PriorTwelve(a1).
string UnknownSetting_PriorTwelve(a1).
string WithOtherFamily_PriorTwelve(a1).
string SingleRoomOccupancy_PriorTwelve(a1).
string FosterHomeRelative_PriorTwelve(a1).
string EmergencyShelter_PriorTwelve(a1).
string Homeless_PriorTwelve(a1).
string FosterHomeNonDASHrelative_PriorTwelve(a1).
string AssistedLiving_PriorTwelve(a1).
string IndividualPlacement_PriorTwelve(a1).
string ResidentialTreatment_PriorTwelve(a1).
string OtherSetting_PriorTwelve(a1).
string CountyID(a2).
string AssessmentType(a3).
string ApartmentAlone_PriorTwelve(a3).

string AssessmentID(a5).

string ProviderSiteID(a10).

string Name(a25).
string CoordinatorID(a25).




formats DatePartnershipStatusChange(adate10).
formats CreateDate(adate10).
formats DateOfBirth(adate10).
formats CSIDateOfBirth(adate10).
formats AssessmentDate(adate10).
formats PartnershipDate(adate10).
formats PartnershipStatus(f1).
formats PAFStatus(f1).
formats AssessmentSource(f1).
formats Age_Group(f2).
formats ReferredBy(f2).
formats JuvenileHallSLASHCamp_PastTwelveOccurences(f3).
formats IndividualPlacement_PastTwelveOccurences(f3).
formats MedicalHospital_PastTwelveDays(f3).
formats PsychiatricHospital_PastTwelveDays(f3).
formats StatePsychiatric_PastTwelveDays(f3).
formats GroupHome0DASH11_PastTwelveDays(f3).
formats GroupHome12DASH14_PastTwelveDays(f3).
formats CommunityCare_PastTwelveDays(f3).
formats CommunityTreatment_PastTwelveDays(f3).
formats ResidentialTreatment_PastTwelveDays(f3).
formats NursingPhysical_PastTwelveDays(f3).
formats WithParents_PastTwelveDays(f3).
formats NursingPsychiatric_PastTwelveDays(f3).
formats LongDASHTermCare_PastTwelveDays(f3).
formats JuvenileHallSLASHCamp_PastTwelveDays(f3).
formats DJJ_PastTwelveDays(f3).
formats Jail_PastTwelveDays(f3).
formats Prison_PastTwelveDays(f3).
formats OtherSetting_PastTwelveDays(f3).
formats UnknownSetting_PastTwelveDays(f3).
formats WithOtherFamily_PastTwelveDays(f3).
formats ApartmentAlone_PastTwelveDays(f3).
formats SingleRoomOccupancy_PastTwelveDays(f3).
formats FosterHomeRelative_PastTwelveDays(f3).
formats EmergencyShelter_PastTwelveDays(f3).
formats FosterHomeNonDASHrelative_PastTwelveDays(f3).
formats Homeless_PastTwelveDays(f3).
formats AssistedLiving_PastTwelveDays(f3).
formats IndividualPlacement_PastTwelveDays(f3).
formats CongregatePlacement_PastTwelveDays(f3).
formats WithParents_PastTwelveOccurences(f3).
formats MedicalHospital_PastTwelveOccurences(f3).
formats PsychiatricHospital_PastTwelveOccurences(f3).
formats StatePsychiatric_PastTwelveOccurences(f3).
formats GroupHome0DASH11_PastTwelveOccurences(f3).
formats NursingPhysical_PastTwelveOccurences(f3).
formats NursingPsychiatric_PastTwelveOccurences(f3).
formats GroupHome12DASH14_PastTwelveOccurences(f3).
formats CommunityCare_PastTwelveOccurences(f3).
formats CommunityTreatment_PastTwelveOccurences(f3).
formats LongDASHTermCare_PastTwelveOccurences(f3).
formats ResidentialTreatment_PastTwelveOccurences(f3).
formats Jail_PastTwelveOccurences(f3).
formats Prison_PastTwelveOccurences(f3).
formats OtherSetting_PastTwelveOccurences(f3).
formats UnknownSetting_PastTwelveOccurences(f3).
formats DJJ_PastTwelveOccurences(f3).
formats WithOtherFamily_PastTwelveOccurences(f3).
formats ApartmentAlone_PastTwelveOccurences(f3).
formats SingleRoomOccupancy_PastTwelveOccurences(f3).
formats FosterHomeRelative_PastTwelveOccurences(f3).
formats EmergencyShelter_PastTwelveOccurences(f3).
formats FosterHomeNonDASHrelative_PastTwelveOccurences(f3).
formats Homeless_PastTwelveOccurences(f3).
formats AssistedLiving_PastTwelveOccurences(f3).
formats CongregatePlacement_PastTwelveOccurences(f3).
compute Gender = sex.
compute Ethnicty_A = RaceEthnicityCode.
compute Ethnicty_B = " ".

compute Race1 = " ".
compute Race2 = " ".
compute Race3 = " ".
compute Race4 = " ".
compute Race5 = " ".
compute AB2034 = AB2034x.
compute GHI = GHIx.
compute MHSA = NOTE_MHSA.
compute WithParents_PriorTwelve = ParentsOccPrYr.
compute CongregatePlacement_PriorTwelve = CongregateOccPrYr.
compute MedicalHospital_PriorTwelve = MedHospOccPrYr.
compute PsychiatricHospital_PriorTwelve = PsychHospOccPrYr.
compute StatePsychiatric_PriorTwelve = StatePsychHospOccPrYr.
compute GroupHome0DASH11_PriorTwelve = GroupHome0to11OccPrYr.
compute GroupHome12DASH14_PriorTwelve = GroupHome12to14OccPrYr.
compute CommunityCare_PriorTwelve = BoardCareOccPrYrPrYr.
compute CommunityTreatment_PriorTwelve = CommTreatOccPrYr.
compute NursingPhysical_PriorTwelve = SkNursPhysOccPrYr.
compute NursingPsychiatric_PriorTwelve = SkNursPsychOccPrYr.
compute LongDASHTermCare_PriorTwelve = LTInstCareOccPrYr.
compute JuvenileHallSLASHCamp_PriorTwelve = JuviHallPrYr.
compute DJJ_PriorTwelve = JuviJusticePrYr.
compute Jail_PriorTwelve = JailPrYr.
compute Prison_PriorTwelve = PrisonPrYr.
compute UnknownSetting_PriorTwelve = UnknownOccPrYr.
compute WithOtherFamily_PriorTwelve = FamilyPrYr.
compute SingleRoomOccupancy_PriorTwelve = SROPrYr.
compute FosterHomeRelative_PriorTwelve = FosterRelPrYr.
compute EmergencyShelter_PriorTwelve = EmergencyPrYr.
compute Homeless_PriorTwelve = HomelessPrYr.
compute FosterHomeNonDASHrelative_PriorTwelve = FosterNonRelPrYr.
compute AssistedLiving_PriorTwelve = AssistLivingPrYr.
compute IndividualPlacement_PriorTwelve = UnlicSupIndivPrYr.
compute ResidentialTreatment_PriorTwelve = LicResTreatmtOccPrYr.
compute OtherSetting_PriorTwelve = OtherOccPrYr.
compute CountyID = '01'.

compute AssessmentType = " ".
compute ApartmentAlone_PriorTwelve = AlonePrYr.

compute AssessmentID = " ".


compute ProviderSiteID = PROVIDERSITE.

compute Name = namex.
compute CoordinatorID = NOTE_COORDINATORID.

recode Ethnicty_A(''='9').

VARIABLE ALIGNMENT Ethnicty_A(RIGHT).
EXECUTE.
string CountyFSPID(a15).
if substr(ru,6,1)=" "  countyfspid=concat("0000000000",ru).
if substr(ru,6,1) ne " "  countyfspid=concat("000000000",ru).
VARIABLE ALIGNMENT CountyFSPID(RIGHT).
EXECUTE.

save outfile='//covenas/decisionsupport/temp/pafcheckSelect.sav' /keep ru case opdate DatePartnershipStatusChange Ethnicity
CreateDate
DateOfBirth
CSIDateOfBirth
AssessmentDate
PartnershipDate
PartnershipStatus
PAFStatus
AssessmentSource
Age_Group
ReferredBy
JuvenileHallSLASHCamp_PastTwelveOccurences
IndividualPlacement_PastTwelveOccurences
MedicalHospital_PastTwelveDays
PsychiatricHospital_PastTwelveDays
StatePsychiatric_PastTwelveDays
GroupHome0DASH11_PastTwelveDays
GroupHome12DASH14_PastTwelveDays
CommunityCare_PastTwelveDays
CommunityTreatment_PastTwelveDays
ResidentialTreatment_PastTwelveDays
NursingPhysical_PastTwelveDays
WithParents_PastTwelveDays
NursingPsychiatric_PastTwelveDays
LongDASHTermCare_PastTwelveDays
JuvenileHallSLASHCamp_PastTwelveDays
DJJ_PastTwelveDays
Jail_PastTwelveDays
Prison_PastTwelveDays
OtherSetting_PastTwelveDays
UnknownSetting_PastTwelveDays
WithOtherFamily_PastTwelveDays
ApartmentAlone_PastTwelveDays
SingleRoomOccupancy_PastTwelveDays
FosterHomeRelative_PastTwelveDays
EmergencyShelter_PastTwelveDays
FosterHomeNonDASHrelative_PastTwelveDays
Homeless_PastTwelveDays
AssistedLiving_PastTwelveDays
IndividualPlacement_PastTwelveDays
CongregatePlacement_PastTwelveDays
WithParents_PastTwelveOccurences
MedicalHospital_PastTwelveOccurences
PsychiatricHospital_PastTwelveOccurences
StatePsychiatric_PastTwelveOccurences
GroupHome0DASH11_PastTwelveOccurences
NursingPhysical_PastTwelveOccurences
NursingPsychiatric_PastTwelveOccurences
GroupHome12DASH14_PastTwelveOccurences
CommunityCare_PastTwelveOccurences
CommunityTreatment_PastTwelveOccurences
LongDASHTermCare_PastTwelveOccurences
ResidentialTreatment_PastTwelveOccurences
Jail_PastTwelveOccurences
Prison_PastTwelveOccurences
OtherSetting_PastTwelveOccurences
UnknownSetting_PastTwelveOccurences
DJJ_PastTwelveOccurences
WithOtherFamily_PastTwelveOccurences
ApartmentAlone_PastTwelveOccurences
SingleRoomOccupancy_PastTwelveOccurences
FosterHomeRelative_PastTwelveOccurences
EmergencyShelter_PastTwelveOccurences
FosterHomeNonDASHrelative_PastTwelveOccurences
Homeless_PastTwelveOccurences
AssistedLiving_PastTwelveOccurences
CongregatePlacement_PastTwelveOccurences
Gender
Ethnicty_A
Ethnicty_B
Race1
Race2
Race3
Race4
Race5
AB2034
GHI
MHSA
WithParents_PriorTwelve
CongregatePlacement_PriorTwelve
MedicalHospital_PriorTwelve
PsychiatricHospital_PriorTwelve
StatePsychiatric_PriorTwelve
GroupHome0DASH11_PriorTwelve
GroupHome12DASH14_PriorTwelve
CommunityCare_PriorTwelve
CommunityTreatment_PriorTwelve
NursingPhysical_PriorTwelve
NursingPsychiatric_PriorTwelve
LongDASHTermCare_PriorTwelve
JuvenileHallSLASHCamp_PriorTwelve
DJJ_PriorTwelve
Jail_PriorTwelve
Prison_PriorTwelve
UnknownSetting_PriorTwelve
WithOtherFamily_PriorTwelve
SingleRoomOccupancy_PriorTwelve
FosterHomeRelative_PriorTwelve
EmergencyShelter_PriorTwelve
Homeless_PriorTwelve
FosterHomeNonDASHrelative_PriorTwelve
AssistedLiving_PriorTwelve
IndividualPlacement_PriorTwelve
ResidentialTreatment_PriorTwelve
OtherSetting_PriorTwelve
CountyID
Current
Yesterday
AssessmentType
ApartmentAlone_PriorTwelve
AssessmentID
AssessmentGUID
CSINumber
ProviderSiteID
CountyFSPID
Name
CoordinatorID
GlobalID
ProgramDesc.

get file='//covenas/decisionsupport/temp/pafcheckSelect.sav' .

 * SAVE TRANSLATE /TYPE=ODBC
  /CONNECT='DSN=FSP_Kate;DBQ=//covenas/decisionsupport/meinzer\projects\fsp\deliv. 7.2 '+
    'dcr_client-level-report_access2010_encrypted_2012-1216.accdb;DriverId=25;FIL=MS '+
    'Access;MaxBufferSize=2048;PageTimeout=5;'
  /ENCRYPTED
  /MISSING=IGNORE
  /TABLE='SPSS_TEMP'
  /KEEP=CountyID, CSINumber, GlobalID, CountyFSPID, Name, PartnershipDate, AssessmentDate, 
    DateOfBirth, CSIDateOfBirth, Gender, Ethnicty_A, Ethnicty_B, Ethnicity, Race1, Race2, Race3, Race4, 
    Race5, ReferredBy, ProviderSiteID, ProgramDesc, CoordinatorID, PartnershipStatus, PAFStatus, 
    DatePartnershipStatusChange, AB2034, GHI, MHSA, Current, Yesterday, 
    WithParents_PastTwelveOccurences, WithParents_PastTwelveDays, WithParents_PriorTwelve, 
    WithOtherFamily_PastTwelveOccurences, WithOtherFamily_PastTwelveDays, WithOtherFamily_PriorTwelve, 
    ApartmentAlone_PastTwelveOccurences, ApartmentAlone_PastTwelveDays, ApartmentAlone_PriorTwelve, 
    SingleRoomOccupancy_PastTwelveOccurences, SingleRoomOccupancy_PastTwelveDays, 
    SingleRoomOccupancy_PriorTwelve, FosterHomeRelative_PastTwelveOccurences, 
    FosterHomeRelative_PastTwelveDays, FosterHomeRelative_PriorTwelve, 
    FosterHomeNonDASHrelative_PastTwelveOccurences, FosterHomeNonDASHrelative_PastTwelveDays, 
    FosterHomeNonDASHrelative_PriorTwelve, EmergencyShelter_PastTwelveOccurences, 
    EmergencyShelter_PastTwelveDays, EmergencyShelter_PriorTwelve, Homeless_PastTwelveOccurences, 
    Homeless_PastTwelveDays, Homeless_PriorTwelve, IndividualPlacement_PastTwelveOccurences, 
    IndividualPlacement_PriorTwelve, IndividualPlacement_PastTwelveDays, 
    AssistedLiving_PastTwelveOccurences, AssistedLiving_PastTwelveDays, AssistedLiving_PriorTwelve, 
    CongregatePlacement_PastTwelveOccurences, CongregatePlacement_PastTwelveDays, 
    CongregatePlacement_PriorTwelve, CommunityCare_PastTwelveOccurences, CommunityCare_PastTwelveDays, 
    CommunityCare_PriorTwelve, MedicalHospital_PastTwelveOccurences, MedicalHospital_PastTwelveDays, 
    MedicalHospital_PriorTwelve, PsychiatricHospital_PastTwelveOccurences, 
    PsychiatricHospital_PastTwelveDays, PsychiatricHospital_PriorTwelve, 
    StatePsychiatric_PastTwelveOccurences, StatePsychiatric_PastTwelveDays, 
    StatePsychiatric_PriorTwelve, GroupHome0DASH11_PastTwelveOccurences, 
    GroupHome0DASH11_PastTwelveDays, GroupHome0DASH11_PriorTwelve, 
    GroupHome12DASH14_PastTwelveOccurences, GroupHome12DASH14_PastTwelveDays, 
    GroupHome12DASH14_PriorTwelve, CommunityTreatment_PastTwelveOccurences, 
    CommunityTreatment_PastTwelveDays, CommunityTreatment_PriorTwelve, 
    ResidentialTreatment_PastTwelveOccurences, ResidentialTreatment_PastTwelveDays, 
    ResidentialTreatment_PriorTwelve, NursingPhysical_PastTwelveOccurences, 
    NursingPhysical_PastTwelveDays, NursingPhysical_PriorTwelve, 
    NursingPsychiatric_PastTwelveOccurences, NursingPsychiatric_PastTwelveDays, 
    NursingPsychiatric_PriorTwelve, LongDASHTermCare_PastTwelveOccurences, 
    LongDASHTermCare_PastTwelveDays, LongDASHTermCare_PriorTwelve, 
    JuvenileHallSLASHCamp_PastTwelveOccurences, JuvenileHallSLASHCamp_PastTwelveDays, 
    JuvenileHallSLASHCamp_PriorTwelve, DJJ_PastTwelveOccurences, DJJ_PastTwelveDays, DJJ_PriorTwelve, 
    Jail_PastTwelveOccurences, Jail_PastTwelveDays, Jail_PriorTwelve, Prison_PastTwelveOccurences, 
    Prison_PastTwelveDays, Prison_PriorTwelve, OtherSetting_PastTwelveOccurences, 
    OtherSetting_PastTwelveDays, OtherSetting_PriorTwelve, UnknownSetting_PastTwelveOccurences, 
    UnknownSetting_PastTwelveDays, UnknownSetting_PriorTwelve, AssessmentID, AssessmentType, Age_Group, 
    AssessmentSource, CreateDate
  /SQL='INSERT INTO DCR_PAFRes (CountyID, CSINumber, GlobalID, CountyFSPID, Name, '+
    'PartnershipDate, AssessmentDate, DateOfBirth, CSIDateOfBirth, Gender, Ethnicty_A, Ethnicty_B, '+
    'Ethnicity, Race1, Race2, Race3, Race4, Race5, ReferredBy, ProviderSiteID, ProgramDesc, '+
    'CoordinatorID, PartnershipStatus, PAFStatus, DatePartnershipStatusChange, AB2034, GHI, MHSA, '+
    '`Current`, Yesterday, WithParents_PastTwelveOccurences, WithParents_PastTwelveDays, '+
    'WithParents_PriorTwelve, WithOtherFamily_PastTwelveOccurences, '+
    'WithOtherFamily_PastTwelveDays, WithOtherFamily_PriorTwelve, '+
    'ApartmentAlone_PastTwelveOccurences, ApartmentAlone_PastTwelveDays, '+
    'ApartmentAlone_PriorTwelve, SingleRoomOccupancy_PastTwelveOccurences, '+
    'SingleRoomOccupancy_PastTwelveDays, SingleRoomOccupancy_PriorTwelve, '+
    'FosterHomeRelative_PastTwelveOccurences, FosterHomeRelative_PastTwelveDays, '+
    'FosterHomeRelative_PriorTwelve, `FosterHomeNon-relative_PastTwelveOccurences`, '+
    '`FosterHomeNon-relative_PastTwelveDays`, `FosterHomeNon-relative_PriorTwelve`, '+
    'EmergencyShelter_PastTwelveOccurences, EmergencyShelter_PastTwelveDays, '+
    'EmergencyShelter_PriorTwelve, Homeless_PastTwelveOccurences, Homeless_PastTwelveDays, '+
    'Homeless_PriorTwelve, IndividualPlacement_PastTwelveOccurences, '+
    'IndividualPlacement_PastTwelveDays, IndividualPlacement_PriorTwelve, '+
    'AssistedLiving_PastTwelveOccurences, AssistedLiving_PastTwelveDays, '+
    'AssistedLiving_PriorTwelve, CongregatePlacement_PastTwelveOccurences, '+
    'CongregatePlacement_PastTwelveDays, CongregatePlacement_PriorTwelve, '+
    'CommunityCare_PastTwelveOccurences, CommunityCare_PastTwelveDays, CommunityCare_PriorTwelve, '+
    'MedicalHospital_PastTwelveOccurences, MedicalHospital_PastTwelveDays, '+
    'MedicalHospital_PriorTwelve, PsychiatricHospital_PastTwelveOccurences, '+
    'PsychiatricHospital_PastTwelveDays, PsychiatricHospital_PriorTwelve, '+
    'StatePsychiatric_PastTwelveOccurences, StatePsychiatric_PastTwelveDays, '+
    'StatePsychiatric_PriorTwelve, `GroupHome0-11_PastTwelveOccurences`, '+
    '`GroupHome0-11_PastTwelveDays`, `GroupHome0-11_PriorTwelve`, '+
    '`GroupHome12-14_PastTwelveOccurences`, `GroupHome12-14_PastTwelveDays`, '+
    '`GroupHome12-14_PriorTwelve`, CommunityTreatment_PastTwelveOccurences, '+
    'CommunityTreatment_PastTwelveDays, CommunityTreatment_PriorTwelve, '+
    'ResidentialTreatment_PastTwelveOccurences, ResidentialTreatment_PastTwelveDays, '+
    'ResidentialTreatment_PriorTwelve, NursingPhysical_PastTwelveOccurences, '+
    'NursingPhysical_PastTwelveDays, NursingPhysical_PriorTwelve, '+
    'NursingPsychiatric_PastTwelveOccurences, NursingPsychiatric_PastTwelveDays, '+
    'NursingPsychiatric_PriorTwelve, `Long-TermCare_PastTwelveOccurences`, '+
    '`Long-TermCare_PastTwelveDays`, `Long-TermCare_PriorTwelve`, '+
    '`JuvenileHall/Camp_PastTwelveOccurences`, `JuvenileHall/Camp_PastTwelveDays`, '+
    '`JuvenileHall/Camp_PriorTwelve`, DJJ_PastTwelveOccurences, DJJ_PastTwelveDays, '+
    'DJJ_PriorTwelve, Jail_PastTwelveOccurences, Jail_PastTwelveDays, Jail_PriorTwelve, '+
    'Prison_PastTwelveOccurences, Prison_PastTwelveDays, Prison_PriorTwelve, '+
    'OtherSetting_PastTwelveOccurences, OtherSetting_PastTwelveDays, OtherSetting_PriorTwelve, '+
    'UnknownSetting_PastTwelveOccurences, UnknownSetting_PastTwelveDays, '+
    'UnknownSetting_PriorTwelve, AssessmentID, AssessmentType, Age_Group, AssessmentSource, '+
    'CreateDate) SELECT CountyID, CSINumber, GlobalID, CountyFSPID, Name, PartnershipDate, '+
    'AssessmentDate, DateOfBirth, CSIDateOfBirth, Gender, Ethnicty_A, Ethnicty_B, Ethnicity, '+
    'Race1, Race2, Race3, Race4, Race5, ReferredBy, ProviderSiteID, ProgramDesc, CoordinatorID, '+
    'PartnershipStatus, PAFStatus, DatePartnershipStatusChange, AB2034, GHI, MHSA, `Current`, '+
    'Yesterday, WithParents_PastTwelveOccurences, WithParents_PastTwelveDays, '+
    'WithParents_PriorTwelve, WithOtherFamily_PastTwelveOccurences, '+
    'WithOtherFamily_PastTwelveDays, WithOtherFamily_PriorTwelve, '+
    'ApartmentAlone_PastTwelveOccurences, ApartmentAlone_PastTwelveDays, '+
    'ApartmentAlone_PriorTwelve, SingleRoomOccupancy_PastTwelveOccurences, '+
    'SingleRoomOccupancy_PastTwelveDays, SingleRoomOccupancy_PriorTwelve, '+
    'FosterHomeRelative_PastTwelveOccurences, FosterHomeRelative_PastTwelveDays, '+
    'FosterHomeRelative_PriorTwelve, FosterHomeNonDASHrelative_PastTwelveOccurences, '+
    'FosterHomeNonDASHrelative_PastTwelveDays, FosterHomeNonDASHrelative_PriorTwelve, '+
    'EmergencyShelter_PastTwelveOccurences, EmergencyShelter_PastTwelveDays, '+
    'EmergencyShelter_PriorTwelve, Homeless_PastTwelveOccurences, Homeless_PastTwelveDays, '+
    'Homeless_PriorTwelve, IndividualPlacement_PastTwelveOccurences, '+
    'IndividualPlacement_PriorTwelve, IndividualPlacement_PastTwelveDays, '+
    'AssistedLiving_PastTwelveOccurences, AssistedLiving_PastTwelveDays, '+
    'AssistedLiving_PriorTwelve, CongregatePlacement_PastTwelveOccurences, '+
    'CongregatePlacement_PastTwelveDays, CongregatePlacement_PriorTwelve, '+
    'CommunityCare_PastTwelveOccurences, CommunityCare_PastTwelveDays, CommunityCare_PriorTwelve, '+
    'MedicalHospital_PastTwelveOccurences, MedicalHospital_PastTwelveDays, '+
    'MedicalHospital_PriorTwelve, PsychiatricHospital_PastTwelveOccurences, '+
    'PsychiatricHospital_PastTwelveDays, PsychiatricHospital_PriorTwelve, '+
    'StatePsychiatric_PastTwelveOccurences, StatePsychiatric_PastTwelveDays, '+
    'StatePsychiatric_PriorTwelve, GroupHome0DASH11_PastTwelveOccurences, '+
    'GroupHome0DASH11_PastTwelveDays, GroupHome0DASH11_PriorTwelve, '+
    'GroupHome12DASH14_PastTwelveOccurences, GroupHome12DASH14_PastTwelveDays, '+
    'GroupHome12DASH14_PriorTwelve, CommunityTreatment_PastTwelveOccurences, '+
    'CommunityTreatment_PastTwelveDays, CommunityTreatment_PriorTwelve, '+
    'ResidentialTreatment_PastTwelveOccurences, ResidentialTreatment_PastTwelveDays, '+
    'ResidentialTreatment_PriorTwelve, NursingPhysical_PastTwelveOccurences, '+
    'NursingPhysical_PastTwelveDays, NursingPhysical_PriorTwelve, '+
    'NursingPsychiatric_PastTwelveOccurences, NursingPsychiatric_PastTwelveDays, '+
    'NursingPsychiatric_PriorTwelve, LongDASHTermCare_PastTwelveOccurences, '+
    'LongDASHTermCare_PastTwelveDays, LongDASHTermCare_PriorTwelve, '+
    'JuvenileHallSLASHCamp_PastTwelveOccurences, JuvenileHallSLASHCamp_PastTwelveDays, '+
    'JuvenileHallSLASHCamp_PriorTwelve, DJJ_PastTwelveOccurences, DJJ_PastTwelveDays, '+
    'DJJ_PriorTwelve, Jail_PastTwelveOccurences, Jail_PastTwelveDays, Jail_PriorTwelve, '+
    'Prison_PastTwelveOccurences, Prison_PastTwelveDays, Prison_PriorTwelve, '+
    'OtherSetting_PastTwelveOccurences, OtherSetting_PastTwelveDays, OtherSetting_PriorTwelve, '+
    'UnknownSetting_PastTwelveOccurences, UnknownSetting_PastTwelveDays, '+
    'UnknownSetting_PriorTwelve, AssessmentID, AssessmentType, Age_Group, AssessmentSource, '+
    'CreateDate FROM SPSS_TEMP'
  /SQL='DROP TABLE SPSS_TEMP'.

 * save translate /TYPE=ODBC /CONNECT='DSN=FSP_Kate;DBQ=//covenas/decisionsupport/MEINZER\PROJECTS\FSP\Deliv. 7.2 DCR_Client-Level'+
 '-Report_Access2010_Encrypted_2012-1216.accdb'
 /table = 'DCR_PAFRes_AlamedaCounty' /MAP /REPLACE.
 * CACHE.



 * SAVE TRANSLATE OUTFILE='//covenas/decisionsupport/Coelho\FSP\DCR\Checks\PafRESSelect.xlsx'
  /TYPE=XLS
  /VERSION=12
  /MAP
  /REPLACE
  /FIELDNAMES
  /CELLS=VALUES.

 * SAVE TRANSLATE OUTFILE='//covenas/decisionsupport/Coelho\FSP\DCR\Checks\PafRESSelect.csv'
  /TYPE=CSV
  /ENCODING='Locale'
  /MAP
  /REPLACE
  /FIELDNAMES
  /CELLS=VALUES.
 
 * save translate /TYPE=ODBC /CONNECT='DSN=FSP_Kate;DBQ=//covenas/decisionsupport/MEINZER\PROJECTS\FSP\Deliv. 7.2 DCR_Client-Level'+
 '-Report_Access2010_Encrypted_2012-1216.accdb'
 /table = 'NewTable' /MAP /REPLACE.
 * CACHE.


**append,replace(create),update.

 * GET DATA /TYPE=ODBC /CONNECT=
 'DSN=FSP_Kate;DBQ=//covenas/decisionsupport/MEINZER\PROJECTS\FSP\Deliv. 7.2 DCR_Client-Level'+
 '-Report_Access2010_Encrypted_2012-1216.accdb;'
  'DriverId=25;FIL=MS Access;MaxBufferSize=2048;PageTimeout=5;'
 /SQL = 'SELECT   * FROM  NewTable'
 /ASSUMEDSTRWIDTH=255
 .
 * CACHE.


get file ='//covenas/decisionsupport/meinzer/temp/CGPAFWork_LONGforSTATE.sav'.



sort cases by case .
match files /table='//covenas/spssdata/clinfo.sav' /file=* /by case /drop  bornname  language disab educ created cin marital minors ssn.
Sort cases by ethnic.
Match Files /Table='//covenas/decisionsupport/ethnicity.sav' /File=* /by ethnic.
If hispanic="G" or hispanic="M" or hispanic="N" or hispanic="S" or hispanic="5" or hispanic="2" Ethnicity="Latino".
If hispanic="G" or hispanic="M" or hispanic="N" or hispanic="S" or hispanic="5" or hispanic="2" RaceEthnicityCode="2".
If Ethnicity=" " or Ethnicity="Other" or Ethnicity="Unknown" Ethnicity="Other/Unknown".
match files/file=* /drop EthnicDetail PacificIslander ethnic ethnicity.


RECODE hispanic ('1'='N') ('U'='U') (MISSING='U') (ELSE='Y').
string Ethnicity(a1).	
compute Ethnicity = Hispanic.
formats case(n9).
rename variables name = namex.
rename variables ReferredBy = ReferredByx.
rename variables AB2034 = AB2034x.
rename variables GHI = GHIx.
rename variables AttendancePast12 = AttendancePast12x.
rename variables AttendanceCurr = AttendanceCurrx.
rename variables GradesCurr = GradesCurrx.
rename variables GradesPast12 = GradesPast12x.
rename variables SuspensionPast12 = SuspensionPast12x.
rename variables ArrestPast12 = ArrestPast12x.
rename variables ArrestPrior12 = ArrestPrior12x.
rename variables ParolePast12 = ParolePast12x.
rename variables ParolePrior12 = ParolePrior12x.
rename variables ConservPast12 = ConservPast12x.
rename variables ConservPrior12 = ConservPrior12x.
rename variables PayeePast12 = PayeePast12x.
rename variables PayeePrior12 = PayeePrior12x.
rename variables PhyRelated = PhyRelatedx.
rename variables PhysicianCurr = PhysicianCurrx.
rename variables PhysicianPast12 = PhysicianPast12x.
rename variables ActiveProblem = ActiveProblemx.
rename variables AbuseServices = AbuseServicesx.
rename variables Bathing = Bathingx.
rename variables Dressing = Dressingx.
rename variables Toileting = Toiletingx.
rename variables Transfer = Transferx.
rename variables Continence = Continencex.
rename variables Feeding = Feedingx.
rename variables Walking = Walkingx.
rename variables Housework = Houseworkx.
rename variables Laundry = Laundryx.

string CountyID(a5).


string Name(a25).
Compute PartnershipDate= $sysmis.

Compute DateOfBirth = bday .
Compute CSIDateOfBirth = bday .
string Gender(a1).
string Ethnicty_A(a1).
string Ethnicty_B(a1).

string Race1(a1).
string Race2(a1).
string Race3(a1).
string Race4(a1).
string Race5(a1).
compute ReferredBy = num(ReferredByx,f2).
string ProviderSiteID(a10).

string CoordinatorID(a25).
Compute PartnershipStatus= $sysmis.
Compute PAFStatus= $sysmis.
Compute DatePartnershipStatusChange= $sysmis.
string AB2034(a1).
string GHI(a1).
string MHSA(a1).
string HighestGrade(a2).
string EmotionalDisturbance(a1).
string AnotherReason(a1).
string AttendancePast12(a1).
string AttendanceCurr(a1).
string GradesCurr(a1).
string GradesPast12(a1).
Compute SuspensionPast12 = num(SuspensionPast12x,f2).
Compute ExpulsionPast12 = num(NOTE_EXPULSIONPAST12,f6).
Compute NotinschoolPast12 = num(NotSchlWk,f6).
string NotinschoolCurr(a1).
Compute HighSchoolPast12 = num(HSAdEdWk,f6).
string HighSchoolCurr(a1).
Compute TechnicalPast12 = num(TechVocWk,f6).
string TechnicalCurr(a1).
Compute CommunityCollegePast12 = num(CollegeWk,f6).
string CommunityCollegeCurr(a1).
Compute GraduatePast12 = num(GradSchWk,f6).
string GraduateCurr(a1).
Compute OtherEducationPast12 = num(OtherEdWk,f6).
string OtherEducationCurr(a1).
string EdRecoveryGoals(a1).
Compute Past12_Competitive = num(NOTE_EMPLOYMENTSTATUSPAST12NUMWEEKS1,f6).
Compute Past12_CompetitiveAvgHrWeek = num(EmpCompetHrPastYr,f6).
Compute Past12_CompetitiveAvgHrWage = num(EmpCompetWgPastYr,f6).
Compute Past12_Supported = num(NOTE_EMPLOYMENTSTATUSPAST12NUMWEEKS2,f6).
Compute Past12_SupportedAvgHrWeek = num(EmpSuptHrPastYr,f6).
Compute Past12_SupportedAvgHrWage = num(EmpSuptWgPastYr,f6).
Compute Past12_Transitional = num(NOTE_EMPLOYMENTSTATUSPAST12NUMWEEKS3,f6).
Compute Past12_TransitionalAvgHrWeek = num(EmpTransHrPastYr,f6).
Compute Past12_TransitionalAvgHrWage = num(EmpTransWgPastYr,f6).
Compute Past12_InDASHHouse = num(NOTE_EMPLOYMENTSTATUSPAST12NUMWEEKS4,f6).
Compute Past12_InDASHHouseAvgHrWeek = num(EmpPdInHseHrPastYr,f6).
Compute Past12_InDASHHouseAvgHrWage = num(EmpPdInHseWgPastYr,f6).
Compute Past12_NonDASHpaid = num(NOTE_EMPLOYMENTSTATUSPAST12NUMWEEKS5,f6).
Compute Past12_NonDASHpaidAvgHrWeek = num(EmpVolHrPastYr,f6).
Compute Past12_OtherEmployment = num(NOTE_EMPLOYMENTSTATUSPAST12NUMWEEKS6,f6).
Compute Past12_OtherEmploymentAvgHrWeek = num(EmpOtherHrPastYr,f6).
Compute Past12_OtherEmploymentAvgHrWage = num(EmpOtherWgPastYr,f6).
Compute Past12_Unemployed = num(EmpUnempWksPastYr,f6).
Compute Current_CompetitiveAvgHrWeek = num(EmpCompetHr,f6).
Compute Current_CompetitiveAvgHrWage = num(EmpCompetWg,f6).
Compute Current_SupportedAvgHrWeek = num(EmpSuptHr,f6).
Compute Current_SupportedAvgHrWage = num(EmpSuptWg,f6).
Compute Current_TransitionalAvgHrWeek = num(EmpTransHr,f6).
Compute Current_TransitionalAvgHrWage = num(EmpTransWg,f6).
Compute Current_InDASHHouseAvgHrWeek = num(EmpPdInHseHr,f6).
Compute Current_InDASHHouseAvgHrWage = num(EmpPdInHseWg,f6).
Compute Current_NonDASHpaidAvgHrWeek = num(EmpVolHr,f6).
Compute Current_OtherEmploymentAvgHrWeek = num(EmpOtherHr,f6).
Compute Current_OtherEmploymentAvgHrWage = num(EmpOtherWg,f6).
string Current_Unemployed(a1).
string EmpRecoveryGoals(a1).
string Caregivers_Past12(a1).
string Caregivers_Curr(a1).
string Wages_Past12(a1).
string Wages_Curr(a1).
string Spouse_Past12(a1).
string Spouse_Curr(a1).
string Savings_Past12(a1).
string Savings_Curr(a1).
string ChildSupport_Past12(a1).
string ChildSupport_Curr(a1).
string OtherFamily_Past12(a1).
string OtherFamily_Curr(a1).
string Retirement_Past12(a1).
string Retirement_Curr(a1).
string Veterans_Past12(a1).
string Veterans_Curr(a1).
string Loan_Past12(a1).
string Loan_Curr(a1).
string Housing_Past12(a1).
string Housing_Curr(a1).
string General_Past12(a1).
string General_Curr(a1).
string FoodStamps_Past12(a1).
string FoodStamps_Curr(a1).
string TANF_Past12(a1).
string TANF_Curr(a1).
string SSI_Past12(a1).
string SSI_Curr(a1).
string SSDI_Past12(a1).
string SSDI_Curr(a1).
string SDI_Past12(a1).
string SDI_Curr(a1).
string TribalBenefits_Past12(a1).
string TribalBenefits_Curr(a1).
string OtherSupport_Past12(a1).
string OtherSupport_Curr(a1).
string NoSupport_Past12(a1).
string NoSupport_Curr(a1).
Compute ArrestPast12 = num(ArrestPast12x,f2).
string ArrestPrior12(a1).
string ProbationStatus(a1).
string ProbPast12(a1).
string ProbPrior12(a1).
string ParoleStatus(a1).
string ParolePast12(a1).
string ParolePrior12(a1).
string ConservaStatus(a1).
string ConservPast12(a1).
string ConservPrior12(a1).
string PayeeStatus(a1).
string PayeePast12(a1).
string PayeePrior12(a1).
string WICodeStatus(a1).
string DepenPast12(a1).
string DepenPrior12(a1).
Compute DepenYear = num(DependentCourtYear,f6).
 * Compute Dependent = num(DependentCourtCurr,f6).
Compute Foster = num(KidsFoster,f6).
Compute Reunified = num(KidsReunif,f6).
Compute Adopted = num(KidsAdopt,f6).
Compute PhyRelated = num(PhyRelatedx,f2).
Compute MenRelated = num(EmergencyMental,f6).
string PhysicianCurr(a1).
string PhysicianPast12(a1).
string MentalIllness(a1).
string ActiveProblem(a1).
string AbuseServices(a1).
string Bathing(a1).
string Dressing(a1).
string Toileting(a1).
string Transfer(a1).
string Continence(a1).
string Feeding(a1).
string Walking(a1).
string HouseConfinement(a1).
string Telephone(a1).
string WalkingDistance(a1).
string Groceries(a1).
string Meals(a1).
string Housework(a1).
string Handyman(a1).
string Laundry(a1).
string Medication(a1).
string Money(a1).
string AssessmentID(a5).
string AssessmentType(a3).
Compute Age_Group= $sysmis.
Compute AssessmentSource= $sysmis.

string KETCntyUse1(a15).
string KETCntyUse2(a15).
string KETCntyUse3(a15).
string QtrlyCntyUse1(a15).
string QtrlyCntyUse2(a15).
string QtrlyCntyUse3(a15).

compute CountyID = "01".
compute CSINumber = ltrim(string(Case,n9)).


compute Name = namex.
formats PartnershipDate(adate10).
formats AssessmentDate(adate10).
formats DateOfBirth(adate10).
formats CSIDateOfBirth(adate10).
compute Gender = sex.
compute Ethnicty_A = RaceEthnicityCode.
compute Ethnicty_B = " ".

compute Race1 = " ".
compute Race2 = " ".
compute Race3 = " ".
compute Race4 = " ".
compute Race5 = " ".
formats ReferredBy(f2).
compute ProviderSiteID = PROVIDERSITE.

compute CoordinatorID = NOTE_COORDINATORID.
formats PartnershipStatus(f1).
formats PAFStatus(f1).
formats DatePartnershipStatusChange(adate10).
compute AB2034 = AB2034x.
compute GHI = GHIx.
compute MHSA = NOTE_MHSA.
compute HighestGrade = grade.
 * compute EmotionalDisturbance = specialEDSED.
compute AnotherReason = NOTE_DYNRADIOBUTTON55.
compute AttendancePast12 = AttendancePast12x.
compute AttendanceCurr = AttendanceCurrx.
compute GradesCurr = GradesCurrx.
compute GradesPast12 = GradesPast12x.
formats SuspensionPast12(f2.0).
formats ExpulsionPast12(f2.0).
formats NotinschoolPast12(f2.0).
compute NotinschoolCurr = NotSchlC.
formats HighSchoolPast12(f2.0).
compute HighSchoolCurr = HSAdEdC.
formats TechnicalPast12(f2.0).
compute TechnicalCurr = TechVocC.
formats CommunityCollegePast12(f2.0).
compute CommunityCollegeCurr = CollegeC.
formats GraduatePast12(f1.0).
compute GraduateCurr = GradSchC.
formats OtherEducationPast12(f2.0).
compute OtherEducationCurr = OtherEdC.
compute EdRecoveryGoals = educationrecoverygoal.
formats Past12_Competitive(f2.0).
formats Past12_CompetitiveAvgHrWeek(f2.0).
formats Past12_CompetitiveAvgHrWage(dollar6.0).
formats Past12_Supported(f2.0).
formats Past12_SupportedAvgHrWeek(f2.0).
formats Past12_SupportedAvgHrWage(dollar6.0).
formats Past12_Transitional(f2.0).
formats Past12_TransitionalAvgHrWeek(f2.0).
formats Past12_TransitionalAvgHrWage(dollar6.0).
formats Past12_InDASHHouse(f2.0).
formats Past12_InDASHHouseAvgHrWeek(f2.0).
formats Past12_InDASHHouseAvgHrWage(dollar6.0).
formats Past12_NonDASHpaid(f2.0).
formats Past12_NonDASHpaidAvgHrWeek(f2.0).
formats Past12_OtherEmployment(f2.0).
formats Past12_OtherEmploymentAvgHrWeek(f2.0).
formats Past12_OtherEmploymentAvgHrWage(dollar6.0).
formats Past12_Unemployed(f2.0).
formats Current_CompetitiveAvgHrWeek(f2.0).
formats Current_CompetitiveAvgHrWage(dollar6.0).
formats Current_SupportedAvgHrWeek(f2.0).
formats Current_SupportedAvgHrWage(dollar6.0).
formats Current_TransitionalAvgHrWeek(f2.0).
formats Current_TransitionalAvgHrWage(dollar6.0).
formats Current_InDASHHouseAvgHrWeek(f2.0).
formats Current_InDASHHouseAvgHrWage(dollar6.0).
formats Current_NonDASHpaidAvgHrWeek(f2.0).
formats Current_OtherEmploymentAvgHrWeek(f2.0).
formats Current_OtherEmploymentAvgHrWage(dollar6.0).
compute Current_Unemployed = ltrim(string(Unemployed,f11)).
compute EmpRecoveryGoals = EmploymentRecoveryGoals.
compute Caregivers_Past12 = CaregiverWagesP.
compute Caregivers_Curr = CaregiverWagesC.
compute Wages_Past12 = WagesPast.
compute Wages_Curr = WagesCur.
compute Spouse_Past12 = SpouseWagesPast.
compute Spouse_Curr = SpouseWagesCur.
compute Savings_Past12 = SavingsPast.
compute Savings_Curr = SavingsCur.
compute ChildSupport_Past12 = ChildSupportP.
compute ChildSupport_Curr = ChildSupportC.
compute OtherFamily_Past12 = FamFriendPast.
compute OtherFamily_Curr = FamFriendCur.
compute Retirement_Past12 = SSIRetirePast.
compute Retirement_Curr = SSIRetireCur.
compute Veterans_Past12 = VetBenPast.
compute Veterans_Curr = VetBenCur.
compute Loan_Past12 = LoanPast.
compute Loan_Curr = LoanCur.
compute Housing_Past12 = HousSubsidyPast.
compute Housing_Curr = HousSubsidyCur.
compute General_Past12 = GAPast.
compute General_Curr = GACur.
compute FoodStamps_Past12 = FoodStPast.
compute FoodStamps_Curr = FoodStCur.
compute TANF_Past12 = TANFPast.
compute TANF_Curr = TANFCur.
compute SSI_Past12 = SSIPast.
compute SSI_Curr = SSICur.
compute SSDI_Past12 = SSDIPast.
compute SSDI_Curr = SSDICur.
compute SDI_Past12 = SDIPast.
compute SDI_Curr = SDICur.
compute TribalBenefits_Past12 = TribalBenPast.
compute TribalBenefits_Curr = TribalBenCur.
compute OtherSupport_Past12 = OtherPast.
compute OtherSupport_Curr = OtherCur.
compute NoSupport_Past12 = NoneP.
compute NoSupport_Curr = NoneC.
formats ArrestPast12(f2.0).
compute ArrestPrior12 = ArrestPrior12x.
compute ProbationStatus = ProbationCurr.
compute ProbPast12 = ProbationPast12.
compute ProbPrior12 = ProbationPrior12.
compute ParoleStatus = ParoleCurr.
compute ParolePast12 = ParolePast12x.
compute ParolePrior12 = ParolePrior12x.
compute ConservaStatus = ConservCurr.
compute ConservPast12 = ConservPast12x.
compute ConservPrior12 = ConservPrior12x.
compute PayeeStatus = PayeeCurr.
compute PayeePast12 = PayeePast12x.
compute PayeePrior12 = PayeePrior12x.
compute WICodeStatus = WICodeStatus.
 * compute DepenPast12 = DependentCourtPast12.
 * compute DepenPrior12 = DependentCourtPrior.
formats DepenYear(f4.0).
 * formats Dependent(f2.0).
formats Foster(f2.0).
formats Reunified(f2.0).
formats Adopted(f2.0).
formats PhyRelated(f2.0).
formats MenRelated(f2.0).
compute PhysicianCurr = PhysicianCurrx.
compute PhysicianPast12 = PhysicianPast12x.
compute MentalIllness = NOTE_DYNRADIOBUTTON17 .
compute ActiveProblem = ActiveProblemx.
compute AbuseServices = AbuseServicesx.
compute Bathing = Bathingx.
compute Dressing = Dressingx.
compute Toileting = Toiletingx.
compute Transfer = Transferx.
compute Continence = Continencex.
compute Feeding = Feedingx.
compute Walking = Walkingx.
compute HouseConfinement = ConfinementHouse.
compute Telephone = TelephoneUse.
compute WalkingDistance = GoBeyondWalkDist.
compute Groceries = ShoppingFood.
compute Meals = MealPreparation.
compute Housework = Houseworkx.
compute Handyman = HandymanWork.
compute Laundry = Laundryx.
compute Medication = MedicationSelf.
compute Money = MoneyMangage.
compute AssessmentID = " ".
compute AssessmentType = " ".
formats Age_Group(f2).
formats AssessmentSource(f1).

compute KETCntyUse1 = " ".
compute KETCntyUse2 = " ".
compute KETCntyUse3 = " ".
compute QtrlyCntyUse1 = " ".
compute QtrlyCntyUse2 = " ".
compute QtrlyCntyUse3 = " ".
recode Ethnicty_A(''='9').
exe.
VARIABLE ALIGNMENT Ethnicty_A(RIGHT).
EXECUTE.
string CountyFSPID(a15).
if substr(ru,6,1)=" "  countyfspid=concat("0000000000",ru).
if substr(ru,6,1) ne " "  countyfspid=concat("000000000",ru).
VARIABLE ALIGNMENT CountyFSPID(RIGHT).
EXECUTE.

aggregate outfile=* mode=addvariables overwrite=yes
   /break case
   /partnershipdate=min(AssessmentDate).

save outfile='//covenas/decisionsupport/temp/pafNonResSelect.sav' /keep ru case opdate CountyID Ethnicity
CSINumber
GlobalID
CountyFSPID
Name
PartnershipDate
AssessmentDate
DateOfBirth
CSIDateOfBirth
Gender
Ethnicty_A
Ethnicty_B
Race1
Race2
Race3
Race4
Race5
ReferredBy
ProviderSiteID
ProgramDesc
CoordinatorID
PartnershipStatus
PAFStatus
DatePartnershipStatusChange
AB2034
GHI
MHSA
HighestGrade
EmotionalDisturbance
AnotherReason
AttendancePast12
AttendanceCurr
GradesCurr
GradesPast12
SuspensionPast12
ExpulsionPast12
NotinschoolPast12
NotinschoolCurr
HighSchoolPast12
HighSchoolCurr
TechnicalPast12
TechnicalCurr
CommunityCollegePast12
CommunityCollegeCurr
GraduatePast12
GraduateCurr
OtherEducationPast12
OtherEducationCurr
EdRecoveryGoals
Past12_Competitive
Past12_CompetitiveAvgHrWeek
Past12_CompetitiveAvgHrWage
Past12_Supported
Past12_SupportedAvgHrWeek
Past12_SupportedAvgHrWage
Past12_Transitional
Past12_TransitionalAvgHrWeek
Past12_TransitionalAvgHrWage
Past12_InDASHHouse
Past12_InDASHHouseAvgHrWeek
Past12_InDASHHouseAvgHrWage
Past12_NonDASHpaid
Past12_NonDASHpaidAvgHrWeek
Past12_OtherEmployment
Past12_OtherEmploymentAvgHrWeek
Past12_OtherEmploymentAvgHrWage
Past12_Unemployed
Current_CompetitiveAvgHrWeek
Current_CompetitiveAvgHrWage
Current_SupportedAvgHrWeek
Current_SupportedAvgHrWage
Current_TransitionalAvgHrWeek
Current_TransitionalAvgHrWage
Current_InDASHHouseAvgHrWeek
Current_InDASHHouseAvgHrWage
Current_NonDASHpaidAvgHrWeek
Current_OtherEmploymentAvgHrWeek
Current_OtherEmploymentAvgHrWage
Current_Unemployed
EmpRecoveryGoals
Caregivers_Past12
Caregivers_Curr
Wages_Past12
Wages_Curr
Spouse_Past12
Spouse_Curr
Savings_Past12
Savings_Curr
ChildSupport_Past12
ChildSupport_Curr
OtherFamily_Past12
OtherFamily_Curr
Retirement_Past12
Retirement_Curr
Veterans_Past12
Veterans_Curr
Loan_Past12
Loan_Curr
Housing_Past12
Housing_Curr
General_Past12
General_Curr
FoodStamps_Past12
FoodStamps_Curr
TANF_Past12
TANF_Curr
SSI_Past12
SSI_Curr
SSDI_Past12
SSDI_Curr
SDI_Past12
SDI_Curr
TribalBenefits_Past12
TribalBenefits_Curr
OtherSupport_Past12
OtherSupport_Curr
NoSupport_Past12
NoSupport_Curr
ArrestPast12
ArrestPrior12
ProbationStatus
ProbPast12
ProbPrior12
ParoleStatus
ParolePast12
ParolePrior12
ConservaStatus
ConservPast12
ConservPrior12
PayeeStatus
PayeePast12
PayeePrior12
WICodeStatus
DepenPast12
DepenPrior12
DepenYear
Foster
Reunified
Adopted
PhyRelated
MenRelated
PhysicianCurr
PhysicianPast12
MentalIllness
ActiveProblem
AbuseServices
Bathing
Dressing
Toileting
Transfer
Continence
Feeding
Walking
HouseConfinement
Telephone
WalkingDistance
Groceries
Meals
Housework
Handyman
Laundry
Medication
Money
AssessmentID
AssessmentGUID
AssessmentType
Age_Group
AssessmentSource
CreateDate
KETCntyUse1
KETCntyUse2
KETCntyUse3
QtrlyCntyUse1
QtrlyCntyUse2
QtrlyCntyUse3.


get FILE='//covenas/decisionsupport/meinzer/temp/CGKETWork.sav'.

string globalid AssessmentGUID(a36).
compute globalid=concat(ltrim(string(case,f11)),string(opdate,date11)).
compute AssessmentGUID =concat(ltrim(string(case,f11)),string(KETAssessmentDate,date11)).

if NOTE_PARTNERSTATUS='Reestablishment' partnershipstatus=3.
if NOTE_PARTNERSTATUS='Discontinuation' partnershipstatus=0.
if missing(partnershipstatus) partnershipstatus=1.
Compute DatePartnershipStatusChange = num(DATESTATUSCHANGE,adate10) .
 * Compute DatePartnershipStatusChange = $sysmis .

if Note_emergencytype = "No Answer" Note_emergencytype = "0".
if Note_emergencytype ="Physical Health Related" Note_emergencytype = "1".
if Note_emergencytype = "Mental Health / Substance Abuse Related" Note_emergencytype="2".
if NOTE_CONSERVASTATUS = "Removed" NOTE_CONSERVASTATUS = "0".
if NOTE_CONSERVASTATUS = "Placed" NOTE_CONSERVASTATUS = "1".
if PayeeStatusKET = "Removed" PayeeStatusKET = "0".
if PayeeStatusKET = "Placed" PayeeStatusKET = "1".
if NOTE_PAROLESTATUS = "Removed" NOTE_PAROLESTATUS = "0".
if NOTE_PAROLESTATUS = "Placed" NOTE_PAROLESTATUS = "1".
if KETProbationStatus = "Removed" KETProbationStatus = "0".
if KETProbationStatus = "Placed" KETProbationStatus = "1".
if NOTE_mhsahp = "Yes" NOTE_mhsahp ="1".
if NOTE_mhsahp = "No" NOTE_mhsahp ="0".
if NOTE_AB2034 = "Yes" NOTE_AB2034 ="1".
if NOTE_AB2034 = "No" NOTE_AB2034 ="0".
if EmploymentRecoveryGoalKET = "Yes" EmploymentRecoveryGoalKET ="1".
if EmploymentRecoveryGoalKET = "No" EmploymentRecoveryGoalKET ="0".
if RecoveryGoalsEducation = "Yes" RecoveryGoalsEducation ="1".
if RecoveryGoalsEducation = "No" RecoveryGoalsEducation ="0".
if NOTE_COMPLETEPROGRAM = "Yes" NOTE_COMPLETEPROGRAM ="1".
if NOTE_COMPLETEPROGRAM = "No" NOTE_COMPLETEPROGRAM ="0".

if substr(ReasonDiscontinuedPartnership, 1,70) = 'After repeated attempts to contact child/youth, s/he cannot be located' ReasonDiscontinuedPartnership= '4'.
if substr(ReasonDiscontinuedPartnership, 1,70) = 'Community services/program interrupted - Partner will be serving jail' ReasonDiscontinuedPartnership= '6'.
if substr(ReasonDiscontinuedPartnership, 1,70) = 'Community services/program interrupted - Partner will be serving priso' ReasonDiscontinuedPartnership= '11'.
if substr(ReasonDiscontinuedPartnership, 1,70) = "Community services/program interrupted - Partner's circumstances refle" ReasonDiscontinuedPartnership= "5".
if substr(ReasonDiscontinuedPartnership, 1,70) = "Community services/program interrupted - Youth's circumstances reflect" ReasonDiscontinuedPartnership= "5".
if substr(ReasonDiscontinuedPartnership, 1,70) = 'JAIL' ReasonDiscontinuedPartnership= '6'.
if substr(ReasonDiscontinuedPartnership, 1,70) = 'Partner decided to discontinue Full Service Partnership participation' ReasonDiscontinuedPartnership= '2'.
if substr(ReasonDiscontinuedPartnership, 1,70) = 'Partner has successfully met his/her goals such that discontinuation o' ReasonDiscontinuedPartnership= '7'.
if substr(ReasonDiscontinuedPartnership, 1,70) = 'Partner is deceased.' ReasonDiscontinuedPartnership= '8'.
if substr(ReasonDiscontinuedPartnership, 1,70) = 'Partner moved to another county/service area.' ReasonDiscontinuedPartnership= '3'.
if substr(ReasonDiscontinuedPartnership, 1,70) = 'PRISON' ReasonDiscontinuedPartnership= '11'.
if substr(ReasonDiscontinuedPartnership, 1,70) = 'Target population criteria are not met.' ReasonDiscontinuedPartnership= '1'.
if substr(ReasonDiscontinuedPartnership, 1,70) = 'Youth decided to discontinue Full Service Partnership participation af' ReasonDiscontinuedPartnership= '2'.
if substr(ReasonDiscontinuedPartnership, 1,70) = 'Youth has successfully met his/her goals such that discontinuation of' ReasonDiscontinuedPartnership= '7'.
if substr(ReasonDiscontinuedPartnership, 1,70) = 'Youth moved to another county/service area.' ReasonDiscontinuedPartnership= '3'.

sort cases by case .
match files /table='//covenas/spssdata/clinfo.sav' /file=* /by case /drop  bornname  language disab educ created cin marital minors ssn.

compute name=concat(rtrim(SUBSTR(name,1,index(name,"  "))),", ",ltrim(SUBSTR(name,index(name,"  "),28))).

sort cases by ru.
match files /table='//covenas/decisionsupport/rutable.sav' /file=* /by ru /drop svcmode DayTx kidsru psmask2 school cds_Code agency county ab3632RU CESDC Level3Classic OAru Level2
TAYru MHSA svcType svcType3 EPSDTGroup  start_dt end_dt program Residential OutCty CalWorks SafePassages RUCITY frc.

IF RU2 ne "" RU =RU2.

string ProgramDesc(a255).
compute ProgramDesc  = concat(RU," ",rtrim(provname)).

Sort cases by ethnic.
Match Files /Table='//covenas/decisionsupport/ethnicity.sav' /File=* /by ethnic.
If hispanic="G" or hispanic="M" or hispanic="N" or hispanic="S" or hispanic="5" or hispanic="2" Ethnicity="Latino".
If hispanic="G" or hispanic="M" or hispanic="N" or hispanic="S" or hispanic="5" or hispanic="2" RaceEthnicityCode="2".
If Ethnicity=" " or Ethnicity="Other" or Ethnicity="Unknown" Ethnicity="Other/Unknown".
match files/file=* /drop EthnicDetail PacificIslander ethnic ethnicity.
recode hispanic ('1'='N') ('U'='U') (MISSING='U') (ELSE='Y').

insert file='//covenas/decisionsupport/meinzer/modules/trueconvert.sps'.

rename variables name = namex.
rename variables ketassessmentdate= AssessmentDate.

formats case(n9).

string Ethnicity(a1).	
compute Ethnicity = Hispanic.

string CountyID(a2).
string CSINumber(a9).


string Gender(a1).
string Ethnicty_A(a1).
string Ethnicty_B(a1).
string Race1(a1).
string Race2(a1).
string Race3(a1).
string Race4(a1).
string Race5(a1).
string ProviderSiteID(a10).
string CoordinatorID(a25).
string KETStatus(a1).

if NOTE_PARTNERSTATUS='Reestablishment' KETStatus='1'.
if NOTE_PARTNERSTATUS='Discontinuation' KETStatus='0'.

string DiscontReason(a2).
string AB2034(a1).
string MHSA(a1).
string HighestGrade(a2).
string NotinschoolCurr(a1).
string HighSchoolCurr(a1).
string TechnicalCurr(a1).
string CommunityCollegeCurr(a1).
string GraduateCurr(a1).
string OtherEducationCurr(a1).
string CompletePgm(a1).
string EdRecoveryGoals(a1).
string Current_Unemployed(a1).
string EmpRecoveryGoals(a1).
string ProbationStatus(a1).
string ParoleStatus(a1).
string ConservaStatus(a10).
string PayeeStatus(a1).
string WICodeStatus(a1).
string EmergencyType(a1).
string AssessmentID(a5).
string AssessmentType(a3).
string KETCntyUse1(a15).
string KETCntyUse2(a15).
string KETCntyUse3(a15).
string Name(a25).
string GHI(a1).

Compute PartnershipDate= $sysmis.
Compute DateOfBirth = bday .
Compute CSIDateOfBirth = bday .
Compute DatePSCIDChange = $sysmis .
Compute DateKETStatusChange = num(DATESTATUSCHANGE,adate10) .
 * Compute DatePartnershipStatusChange = $sysmis .
Compute AB2034ChangeDate = num(NOTE_AB2034DATE,adate10) .
Compute GHIChangeDate = num(GHIDATE,adate10) .
Compute MHSAChangeDate = num(MHSAHPCHANGEDATE,adate10) .
Compute DateResidentialChange = num(HousingChangeDateKET,adate10) .
Compute DateSettingChange = num(EdSettingChangeDateKET,adate10) .
Compute DateEmpChange = num(DateEmpChangeKET,adate10) .
Compute DateDepen = num(DATEWICODE,adate10) .

Compute DateKETCntyUse1 = $sysmis .
Compute DateKETCntyUse2 = $sysmis .
Compute DateKETCntyUse3 = $sysmis .
 * compute DateGradeComplete = num(DATEGRADECOMPLETEx, f10).
 * compute DateSuspension = num(DATESUSPENSIONx, f10).
 * compute DateExpulsion = num(DATEEXPULSIONx, f10).
 * compute DateArrested = num(DATEARRESTEDx, f10).
 * compute DateProbation = num(DATEPROBATIONx, f10).
 * compute DateParole = num(DATEPAROLEx, f10).
 * compute DateConserva = num(DATECONSERVAx, f10).
 * compute DatePayee = num(DATEPAYEEx, f10).
 * compute DateEmergencyChange = num(DATEEMERGENCYCHANGEx, f10).
 * compute DateProviChange = num(DATEPROVICHANGEx, f11).
 * compute DateProgmChange = num(DATEPROGMCHANGEx, f12).
 * Compute PartnerShipStatus = $sysmis .
Compute Current_CompetitiveAvgHrWeek = num(EmpCompetHrKET,f6).
Compute Current_CompetitiveAvgHrWage = num(EmpCompetWgKET,f6).
Compute Current_SupportedAvgHrWeek = num(EmpSuptHrKET,f6).
Compute Current_SupportedAvgHrWage = num(EmpSuptWgKET,f6).
Compute Current_TransitionalAvgHrWeek = num(EmpTransHrKET,f6).
Compute Current_TransitionalAvgHrWage = num(EmpTransWgKET,f6).
Compute Current_InDASHHouseAvgHrWeek = num(EmpPdInHseHrKET,f6).
Compute Current_InDASHHouseAvgHrWage = num(EmpPdInHseWgKET,f6).
Compute Current_NonDASHpaidAvgHrWeek = num(EmpVolHrKET,f6).
Compute Current_OtherEmploymentAvgHrWeek = num(EmpOtherHrKET,f6).
Compute Current_OtherEmploymentAvgHrWage = num(EmpOtherWgKET,f6).
Compute Age_Group= $sysmis.
Compute AssessmentSource= $sysmis.

compute CountyID = '01'.
compute CSINumber = ltrim(string(Case,n9)).


compute Gender = sex.
compute Ethnicty_A = RaceEthnicityCode.
compute Ethnicty_B = " ".
compute Race1 = " ".
compute Race2 = " ".
compute Race3 = " ".
compute Race4 = " ".
compute Race5 = " ".
compute ProviderSiteID = NOTE_PROVIDERSITE.
compute CoordinatorID = NOTE_COORDINATORID.
*compute KETStatus = " ".
compute DiscontReason = ReasonDiscontinuedPartnership.
compute AB2034 = NOTE_AB2034.
compute MHSA = note_MHSAHP.
compute HighestGrade = grade.
compute NotinschoolCurr = EdNotInSchoolCurrKET.
compute HighSchoolCurr = EdHighSchoolORAdultEdCurrKET.
compute TechnicalCurr = EdTechORVocCurrKET.
compute CommunityCollegeCurr = EdCommCollegeOR4yrCurrKET.
compute GraduateCurr = EdGradSchoolCurrKET.
compute OtherEducationCurr = EdOtherSchoolCurrKET.
compute CompletePgm = NOTE_COMPLETEPROGRAM.
compute EdRecoveryGoals = RecoveryGoalsEducation.
compute Current_Unemployed = ltrim(string(UnemployedKET,f11)).
compute EmpRecoveryGoals = EmploymentRecoveryGoalKET.
compute ProbationStatus = KETProbationStatus.
compute ParoleStatus = NOTE_PAROLESTATUS.
compute ConservaStatus = NOTE_CONSERVASTATUS.
compute PayeeStatus = PayeeStatusKET.
compute WICodeStatus = NOTE_WICODESTATUS.
compute EmergencyType = NOTE_EMERGENCYTYPE.
compute AssessmentID = " ".
compute AssessmentType = " ".
compute KETCntyUse1 = " ".
compute KETCntyUse2 = " ".
compute KETCntyUse3 = " ".
compute Name = namex.
compute GHI = GHI.
formats PartnershipDate(adate10).
formats DateOfBirth(adate10).
formats CSIDateOfBirth(adate10).
formats DatePSCIDChange(adate10).
formats DateKETStatusChange(adate10).
formats DatePartnershipStatusChange(adate10).
formats AB2034ChangeDate(adate10).
formats GHIChangeDate(adate10).
formats MHSAChangeDate(adate10).
formats DateResidentialChange(adate10).
formats DateSettingChange(adate10).
formats DateEmpChange(adate10).
formats DateDepen(adate10).
formats CreateDate(adate10).
formats DateKETCntyUse1(adate10).
formats DateKETCntyUse2(adate10).
formats DateKETCntyUse3(adate10).
formats DateGradeComplete(adate10).
formats DateSuspension(adate10).
formats DateExpulsion(adate10).
formats DateArrested(adate10).
formats DateProbation(adate10).
formats DateParole(adate10).
formats DateConserva(adate10).
formats DatePayee(adate10).
formats DateEmergencyChange(adate10).
formats DateProviChange(adate10).
formats DateProgmChange(adate10).
formats PartnerShipStatus(f1).
formats Current_CompetitiveAvgHrWeek(f2.0).
formats Current_CompetitiveAvgHrWage(f6.0).
formats Current_SupportedAvgHrWeek(f2.0).
formats Current_SupportedAvgHrWage(f6.0).
formats Current_TransitionalAvgHrWeek(f2.0).
formats Current_TransitionalAvgHrWage(f6.0).
formats Current_InDASHHouseAvgHrWeek(f2.0).
formats Current_InDASHHouseAvgHrWage(f6.0).
formats Current_NonDASHpaidAvgHrWeek(f2.0).
formats Current_OtherEmploymentAvgHrWeek(f2.0).
formats Current_OtherEmploymentAvgHrWage(f6.0).
formats Age_Group(f2).
formats AssessmentSource(f1).
formats assessmentdate(adate10).
exe.
recode Ethnicty_A(''='9').
exe.
VARIABLE ALIGNMENT Ethnicty_A(RIGHT).
EXECUTE.
string CountyFSPID(a15).
if substr(ru,6,1)=" "  countyfspid=concat("0000000000",ru).
if substr(ru,6,1) ne " "  countyfspid=concat("000000000",ru).
VARIABLE ALIGNMENT CountyFSPID(RIGHT).
EXECUTE.


save outfile ='//covenas/decisionsupport/temp/KETselect.sav'.
 *  /keep ru case opdate AssessmentGUID Ethnicity
CountyID
CSINumber
GlobalID
CountyFSPID
Gender
Ethnicty_A
Ethnicty_B
Race1
Race2
Race3
Race4
Race5
ProviderSiteID
ProgramDesc
CoordinatorID
KETStatus
DiscontReason
AB2034
MHSA
HighestGrade
NotinschoolCurr
HighSchoolCurr
TechnicalCurr
CommunityCollegeCurr
GraduateCurr
OtherEducationCurr
CompletePgm
EdRecoveryGoals
Current_Unemployed
EmpRecoveryGoals
ProbationStatus
ParoleStatus
ConservaStatus
PayeeStatus
WICodeStatus
EmergencyType
AssessmentID
AssessmentGUID
AssessmentType
KETCntyUse1
KETCntyUse2
KETCntyUse3
Name
GHI
Current
PartnershipDate
AssessmentDate
DateOfBirth
CSIDateOfBirth
DatePSCIDChange
DateKETStatusChange
DatePartnershipStatusChange
AB2034ChangeDate
GHIChangeDate
MHSAChangeDate
DateResidentialChange
DateSettingChange
DateEmpChange
DateDepen
CreateDate
DateKETCntyUse1
DateKETCntyUse2
DateKETCntyUse3
DateGradeComplete
DateSuspension
DateExpulsion
DateArrested
DateProbation
DateParole
DateConserva
DatePayee
DateEmergencyChange
DateProviChange
DateProgmChange
PartnerShipStatus
Current_CompetitiveAvgHrWeek
Current_CompetitiveAvgHrWage
Current_SupportedAvgHrWeek
Current_SupportedAvgHrWage
Current_TransitionalAvgHrWeek
Current_TransitionalAvgHrWage
Current_InDASHHouseAvgHrWeek
Current_InDASHHouseAvgHrWage
Current_NonDASHpaidAvgHrWeek
Current_OtherEmploymentAvgHrWeek
Current_OtherEmploymentAvgHrWage
Age_Group
AssessmentSource.

 * get file ='//covenas/decisionsupport/temp/KETselect.sav'.

 * save translate /TYPE=ODBC /CONNECT='DSN=FSP_Kate;DBQ=//covenas/decisionsupport/MEINZER\PROJECTS\FSP\Deliv. 7.2 DCR_Client-Level'+
 '-Report_Access2010_Encrypted_2012-1216.accdb'
 /table = 'DCR_KET_AlamedaCounty' /MAP /REPLACE.
 * CACHE.

 * SAVE TRANSLATE OUTFILE='//covenas/decisionsupport/Coelho\FSP\DCR\Checks\KETSelect.xlsx'
  /TYPE=XLS
  /VERSION=12
  /MAP
  /REPLACE
  /FIELDNAMES
  /CELLS=VALUES.
 * SAVE TRANSLATE OUTFILE='//covenas/decisionsupport/Coelho\FSP\DCR\Checks\KETSelect.csv'
  /TYPE=CSV
  /ENCODING='Locale'
  /MAP
  /REPLACE
  /FIELDNAMES
  /CELLS=VALUES.


get FILE='//covenas/decisionsupport/meinzer/temp/CGQTR.SAV'.

string globalid AssessmentGUID(a36).
compute globalid=concat(ltrim(string(case,f11)),string(opdate,date11)).
compute AssessmentGUID =concat(ltrim(string(case,f11)),string(QTRAssessmentDate,date11)).

if substr(NOTE_IADLMONEY, 1,40) = 'Without help' NOTE_IADLMONEY='1'.
if substr(NOTE_IADLMONEY, 1,40) = 'With some help' NOTE_IADLMONEY='2'.
if substr(NOTE_IADLMONEY, 1,40) = 'Completely unable to do' NOTE_IADLMONEY='3'.

if substr(NOTE_IADLMEDICATION, 1,40) = 'Without help' NOTE_IADLMEDICATION='1'.
if substr(NOTE_IADLMEDICATION, 1,40) = 'With some help' NOTE_IADLMEDICATION='2'.
if substr(NOTE_IADLMEDICATION, 1,40) = 'Completely unable to do' NOTE_IADLMEDICATION='3'.

if substr(NOTE_IADLLAUNDRY, 1,40) = 'Without help' NOTE_IADLLAUNDRY='1'.
if substr(NOTE_IADLLAUNDRY, 1,40) = 'With some help' NOTE_IADLLAUNDRY='2'.
if substr(NOTE_IADLLAUNDRY, 1,40) = 'Completely unable to do' NOTE_IADLLAUNDRY='3'.

if substr(NOTE_IADLHANDYMAN, 1,40) = 'Without help' NOTE_IADLHANDYMAN='1'.
if substr(NOTE_IADLHANDYMAN, 1,40) = 'With some help' NOTE_IADLHANDYMAN='2'.
if substr(NOTE_IADLHANDYMAN, 1,40) = 'Completely unable to do' NOTE_IADLHANDYMAN='3'.

if substr(NOTE_IADLHOUSEWORK, 1,40) = 'Without help' NOTE_IADLHOUSEWORK='1'.
if substr(NOTE_IADLHOUSEWORK, 1,40) = 'With some help' NOTE_IADLHOUSEWORK='2'.
if substr(NOTE_IADLHOUSEWORK, 1,40) = 'Completely unable to do' NOTE_IADLHOUSEWORK='3'.

if substr(NOTE_IADLMEALS, 1,40) = 'Without help' NOTE_IADLMEALS='1'.
if substr(NOTE_IADLMEALS, 1,40) = 'With some help' NOTE_IADLMEALS='2'.
if substr(NOTE_IADLMEALS, 1,40) = 'Completely unable to do' NOTE_IADLMEALS='3'.


if substr(NOTE_IADLSHOPPING, 1,40) = 'Without help' NOTE_IADLSHOPPING='1'.
if substr(NOTE_IADLSHOPPING, 1,40) = 'With some help' NOTE_IADLSHOPPING='2'.
if substr(NOTE_IADLSHOPPING, 1,40) = 'Completely unable to do' NOTE_IADLSHOPPING='3'.

if substr(NOTE_IADLWALKING, 1,40) = 'Without help' NOTE_IADLWALKING='1'.
if substr(NOTE_IADLWALKING, 1,40) = 'With some help' NOTE_IADLWALKING='2'.
if substr(NOTE_IADLWALKING, 1,40) = 'Completely unable to do' NOTE_IADLWALKING='3'.

if substr(NOTE_IADLTELEPHONE, 1,40) = 'Without help' NOTE_IADLTELEPHONE='1'.
if substr(NOTE_IADLTELEPHONE, 1,40) = 'With some help' NOTE_IADLTELEPHONE='2'.
if substr(NOTE_IADLTELEPHONE, 1,40) = 'Completely unable to do' NOTE_IADLTELEPHONE='3'.

if substr(NOTE_ADLCONFINE, 1,40) = 'Has been outside of residence on 3 or mo' NOTE_ADLCONFINE='1'.
if substr(NOTE_ADLCONFINE, 1,40) = 'Has been outside of residence on only 1' NOTE_ADLCONFINE='2'.
if substr(NOTE_ADLCONFINE, 1,40) = 'Has not been outside of residence in pas' NOTE_ADLCONFINE='3'.

if substr(NOTE_ADLWALKING, 1,40) = 'Walks on level without assistance' NOTE_ADLWALKING='1'.
if substr(NOTE_ADLWALKING, 1,40) = 'Walks without assistance but uses single' NOTE_ADLWALKING='2'.
if substr(NOTE_ADLWALKING, 1,40) = 'Walks without assistance but uses two po' NOTE_ADLWALKING='3'.
if substr(NOTE_ADLWALKING, 1,40) = 'Walks with assistance' NOTE_ADLWALKING='4'.
if substr(NOTE_ADLWALKING, 1,40) = 'Uses wheelchair only' NOTE_ADLWALKING='5'.
if substr(NOTE_ADLWALKING, 1,40) = 'Not walking or using wheelchair' NOTE_ADLWALKING='6'.

if substr(note_adlfeeding, 1,40) = 'Feeds self without assistance' note_adlfeeding='1'.
if substr(note_adlfeeding, 1,40) = 'Feeds self except for getting assistance' note_adlfeeding='2'.
if substr(note_adlfeeding, 1,40) = 'Receives assistance in feeding or is fed' note_adlfeeding='3'.

if substr(NOTE_ADLCONTINENCE, 1,40) = "Controls urination and bowel movement co" NOTE_ADLCONTINENCE="1".
if substr(NOTE_ADLCONTINENCE, 1,40) = "Has occasional 'accidents'" NOTE_ADLCONTINENCE="2".
if substr(NOTE_ADLCONTINENCE, 1,40) = "Supervision helps keep urine or bowel co" NOTE_ADLCONTINENCE="3".

if substr(NOTE_ADLTRANSFER, 1,40) = 'Moves in and out of bed as well as in an' NOTE_ADLTRANSFER='1'.
if substr(NOTE_ADLTRANSFER, 1,40) = 'Moves in and out of bed or chair with as' NOTE_ADLTRANSFER='2'.
if substr(NOTE_ADLTRANSFER, 1,40) = "Doesn't get out of bed" NOTE_ADLTRANSFER='3'.

if substr(note_adltoileting, 1,40) =  "Doesn't go to room termed 'toilet' for t" note_adltoileting='3'.
if substr(note_adltoileting, 1,40) =  "Goes to 'toilet room,' cleans self, and" note_adltoileting='1'.
if substr(note_adltoileting, 1,40) =  "Receives assistance in going to the 'toi" note_adltoileting='2'.

if substr(note_adldressing, 1,40) = 'Gets clothes and gets completely dressed' note_adldressing='1'.
if substr(note_adldressing, 1,40) = 'Gets clothes and gets dressed without as' note_adldressing='2'.
if substr(note_adldressing, 1,40) = 'Receives assistance in getting clothes o' note_adldressing='3'.

if substr(note_adlbathing, 1,40) = 'Receives no assistance (gets in and out' note_adlbathing='1'.
if substr(note_adlbathing, 1,40) = 'Receives assistance in bathing only one' note_adlbathing='2'.
if substr(note_adlbathing, 1,40) = 'Receives assistance in bathing more than' note_adlbathing='3'.

if substr(QTRAttendance, 1,40) = 'Always attends school (never truant)' QTRAttendance='1'.
if substr(QTRAttendance, 1,40) = 'Attends school most of the time' QTRAttendance='2'.
if substr(QTRAttendance, 1,40) = 'Sometimes attends school' QTRAttendance='3'.
if substr(QTRAttendance, 1,40) = 'Infrequently attends school' QTRAttendance='4'.
if substr(QTRAttendance, 1,40) = 'Never attends school' QTRAttendance='5'.

*qtrGrades already converted? attendancecurr.

insert file='//covenas/decisionsupport/meinzer/modules/trueconvert.sps'.

sort cases by case .
match files /table='//covenas/spssdata/clinfo.sav' /file=* /by case /drop  bornname  language disab educ created cin marital minors ssn.

compute name=concat(rtrim(SUBSTR(name,1,index(name,"  "))),", ",ltrim(SUBSTR(name,index(name,"  "),28))).

sort cases by ru.
match files /table='//covenas/decisionsupport/rutable.sav' /file=* /by ru /drop svcmode DayTx kidsru psmask2 school cds_Code agency county ab3632RU CESDC Level3Classic OAru Level2
TAYru MHSA svcType svcType3 EPSDTGroup  start_dt end_dt program Residential OutCty CalWorks SafePassages RUCITY frc.

IF RU2 ne "" RU =RU2.

string ProgramDesc(a255).
compute ProgramDesc  = concat(RU," ",rtrim(provname)).

Sort cases by ethnic.
Match Files /Table='//covenas/decisionsupport/ethnicity.sav' /File=* /by ethnic.
If hispanic="G" or hispanic="M" or hispanic="N" or hispanic="S" or hispanic="5" or hispanic="2" Ethnicity="Latino".
If hispanic="G" or hispanic="M" or hispanic="N" or hispanic="S" or hispanic="5" or hispanic="2" RaceEthnicityCode="2".
If Ethnicity=" " or Ethnicity="Other" or Ethnicity="Unknown" Ethnicity="Other/Unknown".
match files/file=* /drop EthnicDetail PacificIslander ethnic ethnicity.
RECODE hispanic ('1'='N') ('U'='U') (MISSING='U') (ELSE='Y').

formats case(n9).

string Ethnicity(a1).	
compute Ethnicity = Hispanic.

rename variables name = namex.


string CountyID(a2).
string CSINumber(a9).


string Name(a25).
Compute PartnershipDate= $sysmis.
Compute DateOfBirth = bday .
Compute CSIDateOfBirth = bday .
string Gender(a1).
string Ethnicty_A(a1).
string Ethnicty_B(a1).
string Race1(a1).
string Race2(a1).
string Race3(a1).
string Race4(a1).
string Race5(a1).
Compute DatePartnershipStatusChange= $sysmis.
Compute PartnerShipStatus= $sysmis.
string EmotionalDisturbance(a1).
string AnotherReason(a1).
string AttendanceCurr(a1).
string GradesCurr(a1).
string Caregivers_Curr(a1).
string Wages_Curr(a1).
string Spouse_Curr(a1).
string Savings_Curr(a1).
string ChildSupport_Curr(a1).
string OtherFamily_Curr(a1).
string Retirement_Curr(a1).
string Veterans_Curr(a1).
string Loan_Curr(a1).
string Housing_Curr(a1).
string General_Curr(a1).
string FoodStamps_Curr(a1).
string TANF_Curr(a1).
string SSI_Curr(a1).
string SSDI_Curr(a1).
string SDI_Curr(a1).
string TribalBenefits_Curr(a1).
string OtherSupport_Curr(a1).
string NoSupport_Curr(a1).
Compute Dependent = num(QtrCourtDep,f6).
Compute Foster = num(QtrFosterCare,f6).
Compute Reunified = num(QtrReunified,f6).
Compute Adopted = num(QtrAdopted,f6).
string PhysicianCurr(a1).
string ActiveProblem(a1).
string AbuseServices(a1).
string Bathing(a1).
string Dressing(a1).
string Toileting(a1).
string Transfer(a1).
string Continence(a1).
string Feeding(a1).
string Walking(a1).
string HouseConfinement(a1).
string Telephone(a1).
string WalkingDistance(a1).
string Groceries(a1).
string Meals(a1).
string Housework(a1).
string Handyman(a1).
string Laundry(a1).
string Medication(a1).
string Money(a1).
string AssessmentID(a5).
string AssessmentType(a3).
Compute Age_Group= $sysmis.
Compute AssessmentSource= $sysmis.
string QtrlyCntyUse1(a15).
string QtrlyCntyUse2(a15).
string QtrlyCntyUse3(a15).


compute CountyID = '01'.
compute CSINumber = ltrim(string(Case,n9)).


compute Name = namex.
formats PartnershipDate(adate10).
rename variables QTRAssessmentDate= AssessmentDate.
formats AssessmentDate(adate10).
formats DateOfBirth(adate10).
formats CSIDateOfBirth(adate10).
compute Gender = sex.
compute Ethnicty_A = RaceEthnicityCode.
compute Ethnicty_B = " ".

compute Race1 = " ".
compute Race2 = " ".
compute Race3 = " ".
compute Race4 = " ".
compute Race5 = " ".
formats DatePartnershipStatusChange(adate10).
formats PartnerShipStatus(f1).
compute EmotionalDisturbance = QtrEducSED.
compute AnotherReason = QtrEducOR.
compute AttendanceCurr = QtrAttendance.
compute GradesCurr = QtrGrades.
compute Caregivers_Curr = QtrCaregiverWages.
compute Wages_Curr = QtrWages.
compute Spouse_Curr = QtrSpouseWages.
compute Savings_Curr = QtrSavings.
compute ChildSupport_Curr = QtrChildSupport.
compute OtherFamily_Curr = QtrFamFriend.
compute Retirement_Curr = QtrSSIRetire.
compute Veterans_Curr = QtrVetBen.
compute Loan_Curr = QtrLoan.
compute Housing_Curr =  QtrHousSubsidy.
compute General_Curr = QtrGA.
compute FoodStamps_Curr = QtrFoodSt.
compute TANF_Curr = QtrTANF.
compute SSI_Curr =  QtrSSISSP.
compute SSDI_Curr = QtrSSDI.
compute SDI_Curr = QtrSDI.
compute TribalBenefits_Curr = QtrTribalBen.
compute OtherSupport_Curr = QtrOther.
compute NoSupport_Curr = QtrNone.
formats Dependent(f2.0).
formats Foster(f2.0).
formats Reunified(f2.0).
formats Adopted(f2.0).
compute PhysicianCurr = QtrHealthPCP.
compute ActiveProblem = NOTE_SACO.
compute AbuseServices = Note_SARS.
compute Bathing = NOTE_ADLBATHING.
compute Dressing = NOTE_ADLDRESSING.
compute Toileting = NOTE_ADLTOILETING.
compute Transfer = NOTE_ADLTRANSFER.
compute Continence = NOTE_ADLCONTINENCE.
compute Feeding = NOTE_ADLFEEDING.
compute Walking = NOTE_ADLWALKING.
compute HouseConfinement = NOTE_ADLCONFINE.
compute Telephone = NOTE_IADLTELEPHONE.
compute WalkingDistance = NOTE_IADLWALKING.
compute Groceries = NOTE_IADLSHOPPING.
compute Meals = NOTE_IADLMEALS.
compute Housework = NOTE_IADLHOUSEWORK.
compute Handyman = NOTE_IADLHANDYMAN.
compute Laundry = NOTE_IADLLAUNDRY.
compute Medication = NOTE_IADLMEDICATION.
compute Money = NOTE_IADLMONEY.
compute AssessmentID = " ".
compute AssessmentType = " ".
formats Age_Group(f2).
formats AssessmentSource(f1).

compute QtrlyCntyUse1 = " ".
compute QtrlyCntyUse2 = " ".
compute QtrlyCntyUse3 = " ".
recode Ethnicty_A(''='9').
EXECUTE.
VARIABLE ALIGNMENT Ethnicty_A(RIGHT).
EXECUTE.
string CountyFSPID(a15).
if substr(ru,6,1)=" "  countyfspid=concat("0000000000",ru).
if substr(ru,6,1) ne " "  countyfspid=concat("000000000",ru).
VARIABLE ALIGNMENT CountyFSPID(RIGHT).
EXECUTE.


save outfile ='//covenas/decisionsupport/temp/QTRselect.sav' /keep ru case opdate AssessmentGUID
CountyID
CSINumber
GlobalID
CountyFSPID
Name
PartnershipDate
AssessmentDate
DateOfBirth
CSIDateOfBirth
Gender
Ethnicity
Ethnicty_A
Ethnicty_B
Race1
Race2
Race3
Race4
Race5
DatePartnershipStatusChange
PartnerShipStatus
EmotionalDisturbance
AnotherReason
AttendanceCurr
GradesCurr
Caregivers_Curr
Wages_Curr
Spouse_Curr
Savings_Curr
ChildSupport_Curr
OtherFamily_Curr
Retirement_Curr
Veterans_Curr
Loan_Curr
Housing_Curr
General_Curr
FoodStamps_Curr
TANF_Curr
SSI_Curr
SSDI_Curr
SDI_Curr
TribalBenefits_Curr
OtherSupport_Curr
NoSupport_Curr
Dependent
Foster
Reunified
Adopted
PhysicianCurr
ActiveProblem
AbuseServices
Bathing
Dressing
Toileting
Transfer
Continence
Feeding
Walking
HouseConfinement
Telephone
WalkingDistance
Groceries
Meals
Housework
Handyman
Laundry
Medication
Money
AssessmentID
AssessmentType
Age_Group
AssessmentSource
CreateDate
QtrlyCntyUse1
QtrlyCntyUse2
QtrlyCntyUse3.


get file ='//covenas/decisionsupport/temp/QTRselect.sav'.

 * save translate /TYPE=ODBC /CONNECT='DSN=FSP_Kate;DBQ=//covenas/decisionsupport/Meinzer\Projects\fsp SVC team\Deliv. 7.2 DCR_Client-Level'+
 '-Report_Access2010_Encrypted_2012-1216.accdb'
 /table = 'DCR_3M_AlamedaCounty' /MAP /REPLACE.
 * CACHE.


 * SAVE TRANSLATE OUTFILE='//covenas/decisionsupport/Coelho\FSP\DCR\Checks\qtrSelect.xlsx'
  /TYPE=XLS
  /VERSION=12
  /MAP
  /REPLACE
  /FIELDNAMES
  /CELLS=VALUES.

 * SAVE TRANSLATE OUTFILE='//covenas/decisionsupport/Coelho\FSP\DCR\Checks\qtrSelect.csv'
  /TYPE=CSV
  /ENCODING='Locale'
  /MAP
  /REPLACE
  /FIELDNAMES
  /CELLS=VALUES.



 * GET DATA /TYPE=ODBC /CONNECT=
 'DSN=FSP_Kate;DBQ=//covenas/decisionsupport/MEINZER\PROJECTS\FSP\Deliv. 7.2 DCR_Client-Level'+
 '-Report_Access2010_Encrypted_2012-1216.accdb;'
  'DriverId=25;FIL=MS Access;MaxBufferSize=2048;PageTimeout=5;'
 /SQL = 'SELECT  Code,  Description FROM  Codes_Race'
 /ASSUMEDSTRWIDTH=255
 .
 * CACHE.
 * DATASET NAME DataSet1 WINDOW=FRONT.

 * SAVE TRANSLATE /TYPE=ODBC
  /CONNECT='DSN=FSP_Kate;DBQ=//covenas/decisionsupport/meinzer\projects\fsp\deliv. 7.2 '+
    'dcr_client-level-report_access2010_encrypted_2012-1216.accdb;DriverId=25;FIL=MS '+
    'Access;MaxBufferSize=2048;PageTimeout=5;'
  /ENCRYPTED
  /MISSING=IGNORE
  /TABLE='SPSS_TEMP'
  /KEEP=CountyID, CSINumber, GlobalID, CountyFSPID, Name, PartnershipDate, AssessmentDate, 
    DateOfBirth, CSIDateOfBirth, Gender, Ethnicty_A, Ethnicty_B, Ethnicity, Race1, Race2, Race3, Race4, 
    Race5, ReferredBy, ProviderSiteID, ProgramDesc, CoordinatorID, PartnershipStatus, PAFStatus, 
    DatePartnershipStatusChange, AB2034, GHI, MHSA, Current, Yesterday, 
    WithParents_PastTwelveOccurences, WithParents_PastTwelveDays, WithParents_PriorTwelve, 
    WithOtherFamily_PastTwelveOccurences, WithOtherFamily_PastTwelveDays, WithOtherFamily_PriorTwelve, 
    ApartmentAlone_PastTwelveOccurences, ApartmentAlone_PastTwelveDays, ApartmentAlone_PriorTwelve, 
    SingleRoomOccupancy_PastTwelveOccurences, SingleRoomOccupancy_PastTwelveDays, 
    SingleRoomOccupancy_PriorTwelve, FosterHomeRelative_PastTwelveOccurences, 
    FosterHomeRelative_PastTwelveDays, FosterHomeRelative_PriorTwelve, 
    FosterHomeNonDASHrelative_PastTwelveOccurences, FosterHomeNonDASHrelative_PastTwelveDays, 
    FosterHomeNonDASHrelative_PriorTwelve, EmergencyShelter_PastTwelveOccurences, 
    EmergencyShelter_PastTwelveDays, EmergencyShelter_PriorTwelve, Homeless_PastTwelveOccurences, 
    Homeless_PastTwelveDays, Homeless_PriorTwelve, IndividualPlacement_PastTwelveOccurences, 
    IndividualPlacement_PriorTwelve, IndividualPlacement_PastTwelveDays, 
    AssistedLiving_PastTwelveOccurences, AssistedLiving_PastTwelveDays, AssistedLiving_PriorTwelve, 
    CongregatePlacement_PastTwelveOccurences, CongregatePlacement_PastTwelveDays, 
    CongregatePlacement_PriorTwelve, CommunityCare_PastTwelveOccurences, CommunityCare_PastTwelveDays, 
    CommunityCare_PriorTwelve, MedicalHospital_PastTwelveOccurences, MedicalHospital_PastTwelveDays, 
    MedicalHospital_PriorTwelve, PsychiatricHospital_PastTwelveOccurences, 
    PsychiatricHospital_PastTwelveDays, PsychiatricHospital_PriorTwelve, 
    StatePsychiatric_PastTwelveOccurences, StatePsychiatric_PastTwelveDays, 
    StatePsychiatric_PriorTwelve, GroupHome0DASH11_PastTwelveOccurences, 
    GroupHome0DASH11_PastTwelveDays, GroupHome0DASH11_PriorTwelve, 
    GroupHome12DASH14_PastTwelveOccurences, GroupHome12DASH14_PastTwelveDays, 
    GroupHome12DASH14_PriorTwelve, CommunityTreatment_PastTwelveOccurences, 
    CommunityTreatment_PastTwelveDays, CommunityTreatment_PriorTwelve, 
    ResidentialTreatment_PastTwelveOccurences, ResidentialTreatment_PastTwelveDays, 
    ResidentialTreatment_PriorTwelve, NursingPhysical_PastTwelveOccurences, 
    NursingPhysical_PastTwelveDays, NursingPhysical_PriorTwelve, 
    NursingPsychiatric_PastTwelveOccurences, NursingPsychiatric_PastTwelveDays, 
    NursingPsychiatric_PriorTwelve, LongDASHTermCare_PastTwelveOccurences, 
    LongDASHTermCare_PastTwelveDays, LongDASHTermCare_PriorTwelve, 
    JuvenileHallSLASHCamp_PastTwelveOccurences, JuvenileHallSLASHCamp_PastTwelveDays, 
    JuvenileHallSLASHCamp_PriorTwelve, DJJ_PastTwelveOccurences, DJJ_PastTwelveDays, DJJ_PriorTwelve, 
    Jail_PastTwelveOccurences, Jail_PastTwelveDays, Jail_PriorTwelve, Prison_PastTwelveOccurences, 
    Prison_PastTwelveDays, Prison_PriorTwelve, OtherSetting_PastTwelveOccurences, 
    OtherSetting_PastTwelveDays, OtherSetting_PriorTwelve, UnknownSetting_PastTwelveOccurences, 
    UnknownSetting_PastTwelveDays, UnknownSetting_PriorTwelve, AssessmentID, AssessmentType, Age_Group, 
    AssessmentSource, CreateDate
  /SQL='INSERT INTO DCR_PAFRes (CountyID, CSINumber, GlobalID, CountyFSPID, Name, '+
    'PartnershipDate, AssessmentDate, DateOfBirth, CSIDateOfBirth, Gender, Ethnicty_A, Ethnicty_B, '+
    'Ethnicity, Race1, Race2, Race3, Race4, Race5, ReferredBy, ProviderSiteID, ProgramDesc, '+
    'CoordinatorID, PartnershipStatus, PAFStatus, DatePartnershipStatusChange, AB2034, GHI, MHSA, '+
    '`Current`, Yesterday, WithParents_PastTwelveOccurences, WithParents_PastTwelveDays, '+
    'WithParents_PriorTwelve, WithOtherFamily_PastTwelveOccurences, '+
    'WithOtherFamily_PastTwelveDays, WithOtherFamily_PriorTwelve, '+
    'ApartmentAlone_PastTwelveOccurences, ApartmentAlone_PastTwelveDays, '+
    'ApartmentAlone_PriorTwelve, SingleRoomOccupancy_PastTwelveOccurences, '+
    'SingleRoomOccupancy_PastTwelveDays, SingleRoomOccupancy_PriorTwelve, '+
    'FosterHomeRelative_PastTwelveOccurences, FosterHomeRelative_PastTwelveDays, '+
    'FosterHomeRelative_PriorTwelve, `FosterHomeNon-relative_PastTwelveOccurences`, '+
    '`FosterHomeNon-relative_PastTwelveDays`, `FosterHomeNon-relative_PriorTwelve`, '+
    'EmergencyShelter_PastTwelveOccurences, EmergencyShelter_PastTwelveDays, '+
    'EmergencyShelter_PriorTwelve, Homeless_PastTwelveOccurences, Homeless_PastTwelveDays, '+
    'Homeless_PriorTwelve, IndividualPlacement_PastTwelveOccurences, '+
    'IndividualPlacement_PastTwelveDays, IndividualPlacement_PriorTwelve, '+
    'AssistedLiving_PastTwelveOccurences, AssistedLiving_PastTwelveDays, '+
    'AssistedLiving_PriorTwelve, CongregatePlacement_PastTwelveOccurences, '+
    'CongregatePlacement_PastTwelveDays, CongregatePlacement_PriorTwelve, '+
    'CommunityCare_PastTwelveOccurences, CommunityCare_PastTwelveDays, CommunityCare_PriorTwelve, '+
    'MedicalHospital_PastTwelveOccurences, MedicalHospital_PastTwelveDays, '+
    'MedicalHospital_PriorTwelve, PsychiatricHospital_PastTwelveOccurences, '+
    'PsychiatricHospital_PastTwelveDays, PsychiatricHospital_PriorTwelve, '+
    'StatePsychiatric_PastTwelveOccurences, StatePsychiatric_PastTwelveDays, '+
    'StatePsychiatric_PriorTwelve, `GroupHome0-11_PastTwelveOccurences`, '+
    '`GroupHome0-11_PastTwelveDays`, `GroupHome0-11_PriorTwelve`, '+
    '`GroupHome12-14_PastTwelveOccurences`, `GroupHome12-14_PastTwelveDays`, '+
    '`GroupHome12-14_PriorTwelve`, CommunityTreatment_PastTwelveOccurences, '+
    'CommunityTreatment_PastTwelveDays, CommunityTreatment_PriorTwelve, '+
    'ResidentialTreatment_PastTwelveOccurences, ResidentialTreatment_PastTwelveDays, '+
    'ResidentialTreatment_PriorTwelve, NursingPhysical_PastTwelveOccurences, '+
    'NursingPhysical_PastTwelveDays, NursingPhysical_PriorTwelve, '+
    'NursingPsychiatric_PastTwelveOccurences, NursingPsychiatric_PastTwelveDays, '+
    'NursingPsychiatric_PriorTwelve, `Long-TermCare_PastTwelveOccurences`, '+
    '`Long-TermCare_PastTwelveDays`, `Long-TermCare_PriorTwelve`, '+
    '`JuvenileHall/Camp_PastTwelveOccurences`, `JuvenileHall/Camp_PastTwelveDays`, '+
    '`JuvenileHall/Camp_PriorTwelve`, DJJ_PastTwelveOccurences, DJJ_PastTwelveDays, '+
    'DJJ_PriorTwelve, Jail_PastTwelveOccurences, Jail_PastTwelveDays, Jail_PriorTwelve, '+
    'Prison_PastTwelveOccurences, Prison_PastTwelveDays, Prison_PriorTwelve, '+
    'OtherSetting_PastTwelveOccurences, OtherSetting_PastTwelveDays, OtherSetting_PriorTwelve, '+
    'UnknownSetting_PastTwelveOccurences, UnknownSetting_PastTwelveDays, '+
    'UnknownSetting_PriorTwelve, AssessmentID, AssessmentType, Age_Group, AssessmentSource, '+
    'CreateDate) SELECT CountyID, CSINumber, GlobalID, CountyFSPID, Name, PartnershipDate, '+
    'AssessmentDate, DateOfBirth, CSIDateOfBirth, Gender, Ethnicty_A, Ethnicty_B, Ethnicity, '+
    'Race1, Race2, Race3, Race4, Race5, ReferredBy, ProviderSiteID, ProgramDesc, CoordinatorID, '+
    'PartnershipStatus, PAFStatus, DatePartnershipStatusChange, AB2034, GHI, MHSA, `Current`, '+
    'Yesterday, WithParents_PastTwelveOccurences, WithParents_PastTwelveDays, '+
    'WithParents_PriorTwelve, WithOtherFamily_PastTwelveOccurences, '+
    'WithOtherFamily_PastTwelveDays, WithOtherFamily_PriorTwelve, '+
    'ApartmentAlone_PastTwelveOccurences, ApartmentAlone_PastTwelveDays, '+
    'ApartmentAlone_PriorTwelve, SingleRoomOccupancy_PastTwelveOccurences, '+
    'SingleRoomOccupancy_PastTwelveDays, SingleRoomOccupancy_PriorTwelve, '+
    'FosterHomeRelative_PastTwelveOccurences, FosterHomeRelative_PastTwelveDays, '+
    'FosterHomeRelative_PriorTwelve, FosterHomeNonDASHrelative_PastTwelveOccurences, '+
    'FosterHomeNonDASHrelative_PastTwelveDays, FosterHomeNonDASHrelative_PriorTwelve, '+
    'EmergencyShelter_PastTwelveOccurences, EmergencyShelter_PastTwelveDays, '+
    'EmergencyShelter_PriorTwelve, Homeless_PastTwelveOccurences, Homeless_PastTwelveDays, '+
    'Homeless_PriorTwelve, IndividualPlacement_PastTwelveOccurences, '+
    'IndividualPlacement_PriorTwelve, IndividualPlacement_PastTwelveDays, '+
    'AssistedLiving_PastTwelveOccurences, AssistedLiving_PastTwelveDays, '+
    'AssistedLiving_PriorTwelve, CongregatePlacement_PastTwelveOccurences, '+
    'CongregatePlacement_PastTwelveDays, CongregatePlacement_PriorTwelve, '+
    'CommunityCare_PastTwelveOccurences, CommunityCare_PastTwelveDays, CommunityCare_PriorTwelve, '+
    'MedicalHospital_PastTwelveOccurences, MedicalHospital_PastTwelveDays, '+
    'MedicalHospital_PriorTwelve, PsychiatricHospital_PastTwelveOccurences, '+
    'PsychiatricHospital_PastTwelveDays, PsychiatricHospital_PriorTwelve, '+
    'StatePsychiatric_PastTwelveOccurences, StatePsychiatric_PastTwelveDays, '+
    'StatePsychiatric_PriorTwelve, GroupHome0DASH11_PastTwelveOccurences, '+
    'GroupHome0DASH11_PastTwelveDays, GroupHome0DASH11_PriorTwelve, '+
    'GroupHome12DASH14_PastTwelveOccurences, GroupHome12DASH14_PastTwelveDays, '+
    'GroupHome12DASH14_PriorTwelve, CommunityTreatment_PastTwelveOccurences, '+
    'CommunityTreatment_PastTwelveDays, CommunityTreatment_PriorTwelve, '+
    'ResidentialTreatment_PastTwelveOccurences, ResidentialTreatment_PastTwelveDays, '+
    'ResidentialTreatment_PriorTwelve, NursingPhysical_PastTwelveOccurences, '+
    'NursingPhysical_PastTwelveDays, NursingPhysical_PriorTwelve, '+
    'NursingPsychiatric_PastTwelveOccurences, NursingPsychiatric_PastTwelveDays, '+
    'NursingPsychiatric_PriorTwelve, LongDASHTermCare_PastTwelveOccurences, '+
    'LongDASHTermCare_PastTwelveDays, LongDASHTermCare_PriorTwelve, '+
    'JuvenileHallSLASHCamp_PastTwelveOccurences, JuvenileHallSLASHCamp_PastTwelveDays, '+
    'JuvenileHallSLASHCamp_PriorTwelve, DJJ_PastTwelveOccurences, DJJ_PastTwelveDays, '+
    'DJJ_PriorTwelve, Jail_PastTwelveOccurences, Jail_PastTwelveDays, Jail_PriorTwelve, '+
    'Prison_PastTwelveOccurences, Prison_PastTwelveDays, Prison_PriorTwelve, '+
    'OtherSetting_PastTwelveOccurences, OtherSetting_PastTwelveDays, OtherSetting_PriorTwelve, '+
    'UnknownSetting_PastTwelveOccurences, UnknownSetting_PastTwelveDays, '+
    'UnknownSetting_PriorTwelve, AssessmentID, AssessmentType, Age_Group, AssessmentSource, '+
    'CreateDate FROM SPSS_TEMP'
  /SQL='DROP TABLE SPSS_TEMP'.




*****************************final.

*ha ha.  
*I realized that it just needs to be revised from the final files, and we can integrate the code in.

GET FILE='//covenas/decisionsupport/temp/pafcheckSelect.sav' .

sort cases by ru case opdate.
match files /table='//covenas/decisionsupport/epscg.sav' /file=* /by ru case opdate.

*PartnershipDate.

IF epflag = "O"PartnershipStatus=1.
IF epflag = "C" PartnershipStatus=0.
IF epflag = "O" AND datediff($time,lst_svc, 'year') gt 0 PartnershipStatus=3.
IF epflag = "C" DatePartnershipStatusChange=closdate.
IF epflag = "O"  DatePartnershipStatusChange=PartnershipDate.
if missing(partnershipstatus) partnershipstatus=1.

aggregate outfile=* mode =addvariables
/break case
/records=n.
sort cases by records(D) case opdate assessmentdate(A).

do if lag(case)=case.
compute YearBTWEp =datediff(lag(closdate),opdate,'years').
if YearBTWEp gt 0 and epflag="O" partnershipstatus=3.
if partnershipstatus=3 DatePartnershipStatusChange=opdate.
end if.
if partnershipstatus=1 DatePartnershipStatusChange=opdate.
compute age=datediff(assessmentdate,dateofbirth,'years').
do if age lt 18.
compute age_group=1.
else if age gt 18 and age lt 25.
compute age_group=4.
else if age ge 25 and age lt 60.
compute age_group=7.
ELSE.
compute age_group=10.
end if.


RENAME VARIABLES createdate=createddate.

aggregate outfile='//covenas/decisionsupport/temp/partnershipDate'
   /break = ru case opdate
   /PartnershipDate=max(PartnershipDate).

SAVE OUTFILE='//covenas/decisionsupport/temp\PAFCheckSelectEps.sav' /keep ru DatePartnershipStatusChange Ethnicity
CreatedDate
DateOfBirth
CSIDateOfBirth
AssessmentDate
PartnershipDate
PartnershipStatus
PAFStatus
AssessmentSource
Age_Group
ReferredBy
JuvenileHallSLASHCamp_PastTwelveOccurences
IndividualPlacement_PastTwelveOccurences
MedicalHospital_PastTwelveDays
PsychiatricHospital_PastTwelveDays
StatePsychiatric_PastTwelveDays
GroupHome0DASH11_PastTwelveDays
GroupHome12DASH14_PastTwelveDays
CommunityCare_PastTwelveDays
CommunityTreatment_PastTwelveDays
ResidentialTreatment_PastTwelveDays
NursingPhysical_PastTwelveDays
WithParents_PastTwelveDays
NursingPsychiatric_PastTwelveDays
LongDASHTermCare_PastTwelveDays
JuvenileHallSLASHCamp_PastTwelveDays
DJJ_PastTwelveDays
Jail_PastTwelveDays
Prison_PastTwelveDays
OtherSetting_PastTwelveDays
UnknownSetting_PastTwelveDays
WithOtherFamily_PastTwelveDays
ApartmentAlone_PastTwelveDays
SingleRoomOccupancy_PastTwelveDays
FosterHomeRelative_PastTwelveDays
EmergencyShelter_PastTwelveDays
FosterHomeNonDASHrelative_PastTwelveDays
Homeless_PastTwelveDays
AssistedLiving_PastTwelveDays
IndividualPlacement_PastTwelveDays
CongregatePlacement_PastTwelveDays
WithParents_PastTwelveOccurences
MedicalHospital_PastTwelveOccurences
PsychiatricHospital_PastTwelveOccurences
StatePsychiatric_PastTwelveOccurences
GroupHome0DASH11_PastTwelveOccurences
NursingPhysical_PastTwelveOccurences
NursingPsychiatric_PastTwelveOccurences
GroupHome12DASH14_PastTwelveOccurences
CommunityCare_PastTwelveOccurences
CommunityTreatment_PastTwelveOccurences
LongDASHTermCare_PastTwelveOccurences
ResidentialTreatment_PastTwelveOccurences
Jail_PastTwelveOccurences
Prison_PastTwelveOccurences
OtherSetting_PastTwelveOccurences
UnknownSetting_PastTwelveOccurences
DJJ_PastTwelveOccurences
WithOtherFamily_PastTwelveOccurences
ApartmentAlone_PastTwelveOccurences
SingleRoomOccupancy_PastTwelveOccurences
FosterHomeRelative_PastTwelveOccurences
EmergencyShelter_PastTwelveOccurences
FosterHomeNonDASHrelative_PastTwelveOccurences
Homeless_PastTwelveOccurences
AssistedLiving_PastTwelveOccurences
CongregatePlacement_PastTwelveOccurences
Gender
Ethnicty_A
Ethnicty_B
Race1
Race2
Race3
Race4
Race5
AB2034
GHI
MHSA
WithParents_PriorTwelve
CongregatePlacement_PriorTwelve
MedicalHospital_PriorTwelve
PsychiatricHospital_PriorTwelve
StatePsychiatric_PriorTwelve
GroupHome0DASH11_PriorTwelve
GroupHome12DASH14_PriorTwelve
CommunityCare_PriorTwelve
CommunityTreatment_PriorTwelve
NursingPhysical_PriorTwelve
NursingPsychiatric_PriorTwelve
LongDASHTermCare_PriorTwelve
JuvenileHallSLASHCamp_PriorTwelve
DJJ_PriorTwelve
Jail_PriorTwelve
Prison_PriorTwelve
UnknownSetting_PriorTwelve
WithOtherFamily_PriorTwelve
SingleRoomOccupancy_PriorTwelve
FosterHomeRelative_PriorTwelve
EmergencyShelter_PriorTwelve
Homeless_PriorTwelve
FosterHomeNonDASHrelative_PriorTwelve
AssistedLiving_PriorTwelve
IndividualPlacement_PriorTwelve
ResidentialTreatment_PriorTwelve
OtherSetting_PriorTwelve
CountyID
Current
Yesterday
AssessmentType
ApartmentAlone_PriorTwelve
AssessmentID
AssessmentGUID
CSINumber
CountyFSPID
Name
GlobalID programdesc
providersiteID 
coordinatorID.

*** NONRES.
GET FILE='//covenas/decisionsupport/temp/pafNonResSelect.sav'.
sort cases by ru case opdate.
match files /table='//covenas/decisionsupport/epscg.sav' /file=* /by ru case opdate.

*PartnershipDate.

IF epflag = "O"PartnershipStatus=1.
IF epflag = "C" PartnershipStatus=0.
IF epflag = "O" AND datediff($time,lst_svc, 'year') gt 0 PartnershipStatus=3.
IF epflag = "C" DatePartnershipStatusChange=closdate.
IF epflag = "O"  DatePartnershipStatusChange=PartnershipDate.
if missing(partnershipstatus) partnershipstatus=1.

aggregate outfile=* mode =addvariables
/break case
/records=n.
sort cases by records(D) case opdate assessmentdate(A).

do if lag(case)=case.
compute YearBTWEp =datediff(lag(closdate),opdate,'years').
if YearBTWEp gt 0 and epflag="O" partnershipstatus=3.
if partnershipstatus=3 DatePartnershipStatusChange=opdate.
end if.
if partnershipstatus=1 DatePartnershipStatusChange=opdate.
compute age=datediff(assessmentdate,dateofbirth,'years').
do if age lt 18.
compute age_group=1.
else if age gt 18 and age lt 25.
compute age_group=4.
else if age ge 25 and age lt 60.
compute age_group=7.
ELSE.
compute age_group=10.
end if.


 * RENAME VARIABLES 
programdesc=PAFprogramdesc
providersiteID=PAFprovidersiteID 
coordinatorID=PAFcoordinatorID.

aggregate outfile='//covenas/decisionsupport/temp/partnershipDate'
   /break = ru case opdate
   /PartnershipDate=max(PartnershipDate).


SAVE OUTFILE='//covenas/decisionsupport/temp\PAFnonresCheckSelectEps.sav'  /keep ru case opdate CountyID Ethnicity
CSINumber
GlobalID
CountyFSPID
Name
PartnershipDate
AssessmentDate
DateOfBirth
CSIDateOfBirth
Gender
Ethnicty_A
Ethnicty_B
Race1
Race2
Race3
Race4
Race5
ReferredBy
PartnershipStatus
PAFStatus
DatePartnershipStatusChange
AB2034
GHI
MHSA
HighestGrade
EmotionalDisturbance
AnotherReason
AttendancePast12
AttendanceCurr
GradesCurr
GradesPast12
SuspensionPast12
ExpulsionPast12
NotinschoolPast12
NotinschoolCurr
HighSchoolPast12
HighSchoolCurr
TechnicalPast12
TechnicalCurr
CommunityCollegePast12
CommunityCollegeCurr
GraduatePast12
GraduateCurr
OtherEducationPast12
OtherEducationCurr
EdRecoveryGoals
Past12_Competitive
Past12_CompetitiveAvgHrWeek
Past12_CompetitiveAvgHrWage
Past12_Supported
Past12_SupportedAvgHrWeek
Past12_SupportedAvgHrWage
Past12_Transitional
Past12_TransitionalAvgHrWeek
Past12_TransitionalAvgHrWage
Past12_InDASHHouse
Past12_InDASHHouseAvgHrWeek
Past12_InDASHHouseAvgHrWage
Past12_NonDASHpaid
Past12_NonDASHpaidAvgHrWeek
Past12_OtherEmployment
Past12_OtherEmploymentAvgHrWeek
Past12_OtherEmploymentAvgHrWage
Past12_Unemployed
Current_CompetitiveAvgHrWeek
Current_CompetitiveAvgHrWage
Current_SupportedAvgHrWeek
Current_SupportedAvgHrWage
Current_TransitionalAvgHrWeek
Current_TransitionalAvgHrWage
Current_InDASHHouseAvgHrWeek
Current_InDASHHouseAvgHrWage
Current_NonDASHpaidAvgHrWeek
Current_OtherEmploymentAvgHrWeek
Current_OtherEmploymentAvgHrWage
Current_Unemployed
EmpRecoveryGoals
Caregivers_Past12
Caregivers_Curr
Wages_Past12
Wages_Curr
Spouse_Past12
Spouse_Curr
Savings_Past12
Savings_Curr
ChildSupport_Past12
ChildSupport_Curr
OtherFamily_Past12
OtherFamily_Curr
Retirement_Past12
Retirement_Curr
Veterans_Past12
Veterans_Curr
Loan_Past12
Loan_Curr
Housing_Past12
Housing_Curr
General_Past12
General_Curr
FoodStamps_Past12
FoodStamps_Curr
TANF_Past12
TANF_Curr
SSI_Past12
SSI_Curr
SSDI_Past12
SSDI_Curr
SDI_Past12
SDI_Curr
TribalBenefits_Past12
TribalBenefits_Curr
OtherSupport_Past12
OtherSupport_Curr
NoSupport_Past12
NoSupport_Curr
ArrestPast12
ArrestPrior12
ProbationStatus
ProbPast12
ProbPrior12
ParoleStatus
ParolePast12
ParolePrior12
ConservaStatus
ConservPast12
ConservPrior12
PayeeStatus
PayeePast12
PayeePrior12
WICodeStatus
DepenPast12
DepenPrior12
DepenYear
Foster
Reunified
Adopted
PhyRelated
MenRelated
PhysicianCurr
PhysicianPast12
MentalIllness
ActiveProblem
AbuseServices
Bathing
Dressing
Toileting
Transfer
Continence
Feeding
Walking
HouseConfinement
Telephone
WalkingDistance
Groceries
Meals
Housework
Handyman
Laundry
Medication
Money
AssessmentID
AssessmentGUID
AssessmentType
Age_Group
AssessmentSource
CreateDate
KETCntyUse1
KETCntyUse2
KETCntyUse3
QtrlyCntyUse1
QtrlyCntyUse2
QtrlyCntyUse3
programdesc
providersiteID 
coordinatorID.
*** KET.
GET FILE='//covenas/decisionsupport/temp/KETselect.sav'.

sort  cases by ru case opdate.
match files /table='//covenas/decisionsupport/temp/partnershipDate' /file=* /by ru case opdate.
aggregate outfile=* mode=ADDVARIABLES
   /break = ru case opdate
   /PartnershipDatex=max(assessmentdate).

if missing(partnershipdate) partnershipdate=partnershipdatex.
if missing(partnershipdate) partnershipdate=assessmentdate.

if KETStatus=" " KETStatus="1".

compute age=datediff(assessmentdate,dateofbirth,'years').
do if age lt 18.
compute age_group=1.
else if age gt 18 and age lt 25.
compute age_group=4.
else if age ge 25 and age lt 60.
compute age_group=7.
ELSE.
compute age_group=10.
end if.

**CoordinatorID change??.
if CoordinatorID='' coordinatorid='na'.
 * Compute DatePSCIDChange=DateKETStatusChange.
 * Compute DateProviChange=DateKETStatusChange.
 * Compute DateProgmChange=DateKETStatusChange.

 * IF KETStatus="0" ProgramDesc=" ".
rename vars createdate= createddate.
save outfile='//covenas/decisionsupport/temp/ketfinal.sav'  /keep ru case opdate AssessmentGUID Ethnicity
CountyID
CSINumber
GlobalID
CountyFSPID
Gender
Ethnicty_A
Ethnicty_B
Race1
Race2
Race3
Race4
Race5
ProviderSiteID
ProgramDesc
CoordinatorID
KETStatus
DiscontReason
AB2034
MHSA
HighestGrade
NotinschoolCurr
HighSchoolCurr
TechnicalCurr
CommunityCollegeCurr
GraduateCurr
OtherEducationCurr
CompletePgm
EdRecoveryGoals
Current_Unemployed
EmpRecoveryGoals
ProbationStatus
ParoleStatus
ConservaStatus
PayeeStatus
WICodeStatus
EmergencyType
AssessmentID
AssessmentGUID
AssessmentType
KETCntyUse1
KETCntyUse2
KETCntyUse3
Name
GHI
Current
PartnershipDate
AssessmentDate
DateOfBirth
CSIDateOfBirth
DatePSCIDChange
DateKETStatusChange
DatePartnershipStatusChange
AB2034ChangeDate
GHIChangeDate
MHSAChangeDate
DateResidentialChange
DateSettingChange
DateEmpChange
DateDepen
CreatedDate
DateKETCntyUse1
DateKETCntyUse2
DateKETCntyUse3
DateGradeComplete
DateSuspension
DateExpulsion
DateArrested
DateProbation
DateParole
DateConserva
DatePayee
DateEmergencyChange
DateProviChange
DateProgmChange
PartnerShipStatus
Current_CompetitiveAvgHrWeek
Current_CompetitiveAvgHrWage
Current_SupportedAvgHrWeek
Current_SupportedAvgHrWage
Current_TransitionalAvgHrWeek
Current_TransitionalAvgHrWage
Current_InDASHHouseAvgHrWeek
Current_InDASHHouseAvgHrWage
Current_NonDASHpaidAvgHrWeek
Current_OtherEmploymentAvgHrWeek
Current_OtherEmploymentAvgHrWage
Age_Group
AssessmentSource ResSettingChangeKET.

***dcrqtr.
GET FILE='//covenas/decisionsupport/temp/QTRselect.sav'.
sort  cases by ru case opdate.
match files /table='//covenas/decisionsupport/temp/partnershipDate' /file=* /by ru case opdate.

aggregate outfile=* mode=ADDVARIABLES
   /break = ru case opdate
   /PartnershipDatex=max(assessmentdate).

if missing(partnershipdate) partnershipdate=partnershipdatex.
if missing(partnershipdate) partnershipdate=assessmentdate.


compute age=datediff(assessmentdate,dateofbirth,'years').
do if age lt 18.
compute age_group=1.
else if age gt 18 and age lt 25.
compute age_group=4.
else if age ge 25 and age lt 60.
compute age_group=7.
ELSE.
compute age_group=10.
end if.
rename vars createdate=createddate.

save outfile='//covenas/decisionsupport/temp/3mfinal.sav'  /keep ru case opdate AssessmentGUID
CountyID
CSINumber
GlobalID
CountyFSPID
Name
PartnershipDate
AssessmentDate
DateOfBirth
CSIDateOfBirth
Gender
Ethnicity
Ethnicty_A
Ethnicty_B
Race1
Race2
Race3
Race4
Race5
DatePartnershipStatusChange
PartnerShipStatus
EmotionalDisturbance
AnotherReason
AttendanceCurr
GradesCurr
Caregivers_Curr
Wages_Curr
Spouse_Curr
Savings_Curr
ChildSupport_Curr
OtherFamily_Curr
Retirement_Curr
Veterans_Curr
Loan_Curr
Housing_Curr
General_Curr
FoodStamps_Curr
TANF_Curr
SSI_Curr
SSDI_Curr
SDI_Curr
TribalBenefits_Curr
OtherSupport_Curr
NoSupport_Curr
Dependent
Foster
Reunified
Adopted
PhysicianCurr
ActiveProblem
AbuseServices
Bathing
Dressing
Toileting
Transfer
Continence
Feeding
Walking
HouseConfinement
Telephone
WalkingDistance
Groceries
Meals
Housework
Handyman
Laundry
Medication
Money
AssessmentID
AssessmentType
Age_Group
AssessmentSource
CreatedDate
QtrlyCntyUse1
QtrlyCntyUse2
QtrlyCntyUse3.




get file='//covenas/decisionsupport/temp/ketfinal.sav' .

SAVE TRANSLATE /TYPE=ODBC
  /CONNECT='DSN=DCR;DriverId=25;FIL=MS '+
    'Access;MaxBufferSize=2048;PageTimeout=5;'
  /ENCRYPTED
  /MISSING=RECODE
  /SQL='DROP TABLE DCR_KETs'
  /SQL='CREATE TABLE DCR_KETs (AssessmentGUID varchar (36), Ethnicity varchar (1), CountyID '+
    'varchar (2), CSINumber varchar (9), globalid varchar (36), CountyFSPID varchar (15), Gender '+
    'varchar (1), Ethnicty_A varchar (1), Ethnicty_B varchar (1), Race1 varchar (1), Race2 varchar '+
    '(1), Race3 varchar (1), Race4 varchar (1), Race5 varchar (1), ProviderSiteID varchar (10), '+
    'ProgramDesc varchar (255), CoordinatorID varchar (25), KETStatus varchar (1), DiscontReason '+
    'varchar (2), AB2034 varchar (1), MHSA varchar (1), HighestGrade varchar (2), NotinschoolCurr '+
    'varchar (1), HighSchoolCurr varchar (1), TechnicalCurr varchar (1), CommunityCollegeCurr '+
    'varchar (1), GraduateCurr varchar (1), OtherEducationCurr varchar (1), CompletePgm varchar '+
    '(1), EdRecoveryGoals varchar (1), Current_Unemployed varchar (1), EmpRecoveryGoals varchar '+
    '(1), ProbationStatus varchar (1), ParoleStatus varchar (1), ConservaStatus varchar (10), '+
    'PayeeStatus varchar (1), WICodeStatus varchar (1), EmergencyType varchar (1), AssessmentID '+
    'varchar (5), AssessmentType varchar (3), KETCntyUse1 varchar (15), KETCntyUse2 varchar (15), '+
    'KETCntyUse3 varchar (15), Name varchar (25), GHI varchar (1), `Current` varchar (2), '+
    'PartnershipDate datetime , AssessmentDate datetime , DateOfBirth datetime , CSIDateOfBirth '+
    'datetime , DatePSCIDChange datetime , DateKETStatusChange datetime , '+
    'DatePartnershipStatusChange datetime , AB2034ChangeDate datetime , GHIChangeDate datetime , '+
    'MHSAChangeDate datetime , DateResidentialChange datetime , DateSettingChange datetime , '+
    'DateEmpChange datetime , DateDepen datetime , createddate datetime , DateKETCntyUse1 datetime '+
    ', DateKETCntyUse2 datetime , DateKETCntyUse3 datetime , DateGradeComplete datetime , '+
    'DateSuspension datetime , DateExpulsion datetime , DateArrested datetime , DateProbation '+
    'datetime , DateParole datetime , DateConserva datetime , DatePayee datetime , '+
    'DateEmergencyChange datetime , DateProviChange datetime , DateProgmChange datetime , '+
    'partnershipstatus double , Current_CompetitiveAvgHrWeek double , Current_CompetitiveAvgHrWage '+
    'double , Current_SupportedAvgHrWeek double , Current_SupportedAvgHrWage double , '+
    'Current_TransitionalAvgHrWeek double , Current_TransitionalAvgHrWage double , '+
    '`Current_In-HouseAvgHrWeek` double , `Current_In-HouseAvgHrWage` double , '+
    '`Current_Non-paidAvgHrWeek` double , Current_OtherEmploymentAvgHrWeek double , '+
    'Current_OtherEmploymentAvgHrWage double , Age_Group double , AssessmentSource double )'
  /REPLACE
  /TABLE='SPSS_TEMP'
  /KEEP=AssessmentGUID, Ethnicity, CountyID, CSINumber, globalid, CountyFSPID, Gender, Ethnicty_A, 
    Ethnicty_B, Race1, Race2, Race3, Race4, Race5, ProviderSiteID, ProgramDesc, CoordinatorID, 
    KETStatus, DiscontReason, AB2034, MHSA, HighestGrade, NotinschoolCurr, HighSchoolCurr, 
    TechnicalCurr, CommunityCollegeCurr, GraduateCurr, OtherEducationCurr, CompletePgm, 
    EdRecoveryGoals, Current_Unemployed, EmpRecoveryGoals, ProbationStatus, ParoleStatus, 
    ConservaStatus, PayeeStatus, WICodeStatus, EmergencyType, AssessmentID, AssessmentType, 
    KETCntyUse1, KETCntyUse2, KETCntyUse3, Name, GHI, Current, PartnershipDate, AssessmentDate, 
    DateOfBirth, CSIDateOfBirth, DatePSCIDChange, DateKETStatusChange, DatePartnershipStatusChange, 
    AB2034ChangeDate, GHIChangeDate, MHSAChangeDate, DateResidentialChange, DateSettingChange, 
    DateEmpChange, DateDepen, createddate, DateKETCntyUse1, DateKETCntyUse2, DateKETCntyUse3, 
    DateGradeComplete, DateSuspension, DateExpulsion, DateArrested, DateProbation, DateParole, 
    DateConserva, DatePayee, DateEmergencyChange, DateProviChange, DateProgmChange, partnershipstatus, 
    Current_CompetitiveAvgHrWeek, Current_CompetitiveAvgHrWage, Current_SupportedAvgHrWeek, 
    Current_SupportedAvgHrWage, Current_TransitionalAvgHrWeek, Current_TransitionalAvgHrWage, 
    Current_InDASHHouseAvgHrWeek, Current_InDASHHouseAvgHrWage, Current_NonDASHpaidAvgHrWeek, 
    Current_OtherEmploymentAvgHrWeek, Current_OtherEmploymentAvgHrWage, Age_Group, AssessmentSource
  /SQL='INSERT INTO DCR_KETs (AssessmentGUID, Ethnicity, CountyID, CSINumber, globalid, '+
    'CountyFSPID, Gender, Ethnicty_A, Ethnicty_B, Race1, Race2, Race3, Race4, Race5, '+
    'ProviderSiteID, ProgramDesc, CoordinatorID, KETStatus, DiscontReason, AB2034, MHSA, '+
    'HighestGrade, NotinschoolCurr, HighSchoolCurr, TechnicalCurr, CommunityCollegeCurr, '+
    'GraduateCurr, OtherEducationCurr, CompletePgm, EdRecoveryGoals, Current_Unemployed, '+
    'EmpRecoveryGoals, ProbationStatus, ParoleStatus, ConservaStatus, PayeeStatus, WICodeStatus, '+
    'EmergencyType, AssessmentID, AssessmentType, KETCntyUse1, KETCntyUse2, KETCntyUse3, Name, '+
    'GHI, `Current`, PartnershipDate, AssessmentDate, DateOfBirth, CSIDateOfBirth, '+
    'DatePSCIDChange, DateKETStatusChange, DatePartnershipStatusChange, AB2034ChangeDate, '+
    'GHIChangeDate, MHSAChangeDate, DateResidentialChange, DateSettingChange, DateEmpChange, '+
    'DateDepen, createddate, DateKETCntyUse1, DateKETCntyUse2, DateKETCntyUse3, DateGradeComplete, '+
    'DateSuspension, DateExpulsion, DateArrested, DateProbation, DateParole, DateConserva, '+
    'DatePayee, DateEmergencyChange, DateProviChange, DateProgmChange, partnershipstatus, '+
    'Current_CompetitiveAvgHrWeek, Current_CompetitiveAvgHrWage, Current_SupportedAvgHrWeek, '+
    'Current_SupportedAvgHrWage, Current_TransitionalAvgHrWeek, Current_TransitionalAvgHrWage, '+
    '`Current_In-HouseAvgHrWeek`, `Current_In-HouseAvgHrWage`, `Current_Non-paidAvgHrWeek`, '+
    'Current_OtherEmploymentAvgHrWeek, Current_OtherEmploymentAvgHrWage, Age_Group, '+
    'AssessmentSource) SELECT AssessmentGUID, Ethnicity, CountyID, CSINumber, globalid, '+
    'CountyFSPID, Gender, Ethnicty_A, Ethnicty_B, Race1, Race2, Race3, Race4, Race5, '+
    'ProviderSiteID, ProgramDesc, CoordinatorID, KETStatus, DiscontReason, AB2034, MHSA, '+
    'HighestGrade, NotinschoolCurr, HighSchoolCurr, TechnicalCurr, CommunityCollegeCurr, '+
    'GraduateCurr, OtherEducationCurr, CompletePgm, EdRecoveryGoals, Current_Unemployed, '+
    'EmpRecoveryGoals, ProbationStatus, ParoleStatus, ConservaStatus, PayeeStatus, WICodeStatus, '+
    'EmergencyType, AssessmentID, AssessmentType, KETCntyUse1, KETCntyUse2, KETCntyUse3, Name, '+
    'GHI, `Current`, PartnershipDate, AssessmentDate, DateOfBirth, CSIDateOfBirth, '+
    'DatePSCIDChange, DateKETStatusChange, DatePartnershipStatusChange, AB2034ChangeDate, '+
    'GHIChangeDate, MHSAChangeDate, DateResidentialChange, DateSettingChange, DateEmpChange, '+
    'DateDepen, createddate, DateKETCntyUse1, DateKETCntyUse2, DateKETCntyUse3, DateGradeComplete, '+
    'DateSuspension, DateExpulsion, DateArrested, DateProbation, DateParole, DateConserva, '+
    'DatePayee, DateEmergencyChange, DateProviChange, DateProgmChange, partnershipstatus, '+
    'Current_CompetitiveAvgHrWeek, Current_CompetitiveAvgHrWage, Current_SupportedAvgHrWeek, '+
    'Current_SupportedAvgHrWage, Current_TransitionalAvgHrWeek, Current_TransitionalAvgHrWage, '+
    'Current_InDASHHouseAvgHrWeek, Current_InDASHHouseAvgHrWage, Current_NonDASHpaidAvgHrWeek, '+
    'Current_OtherEmploymentAvgHrWeek, Current_OtherEmploymentAvgHrWage, Age_Group, '+
    'AssessmentSource FROM SPSS_TEMP'
  /SQL='DROP TABLE SPSS_TEMP'.



get file='//covenas/decisionsupport/temp/3mfinal.sav' .


SAVE TRANSLATE /TYPE=ODBC
  /CONNECT='DSN=DCR;DriverId=25;FIL=MS '+
    'Access;MaxBufferSize=2048;PageTimeout=5;'
  /ENCRYPTED
  /MISSING=RECODE
  /SQL='DROP TABLE DCR_3M'
  /SQL='CREATE TABLE DCR_3M (AssessmentGUID varchar (36), CountyID varchar (2), CSINumber '+
    'varchar (9), globalid varchar (36), CountyFSPID varchar (15), Name varchar (25), '+
    'PartnershipDate datetime , AssessmentDate datetime , DateOfBirth datetime , CSIDateOfBirth '+
    'datetime , Gender varchar (1), Ethnicity varchar (1), Ethnicty_A varchar (1), Ethnicty_B '+
    'varchar (1), Race1 varchar (1), Race2 varchar (1), Race3 varchar (1), Race4 varchar (1), '+
    'Race5 varchar (1), DatePartnershipStatusChange datetime , PartnerShipStatus double , '+
    'EmotionalDisturbance varchar (1), AnotherReason varchar (1), AttendanceCurr varchar (1), '+
    'GradesCurr varchar (1), Caregivers_Curr varchar (1), Wages_Curr varchar (1), Spouse_Curr '+
    'varchar (1), Savings_Curr varchar (1), ChildSupport_Curr varchar (1), OtherFamily_Curr '+
    'varchar (1), Retirement_Curr varchar (1), Veterans_Curr varchar (1), Loan_Curr varchar (1), '+
    'Housing_Curr varchar (1), General_Curr varchar (1), FoodStamps_Curr varchar (1), TANF_Curr '+
    'varchar (1), SSI_Curr varchar (1), SSDI_Curr varchar (1), SDI_Curr varchar (1), '+
    'TribalBenefits_Curr varchar (1), OtherSupport_Curr varchar (1), NoSupport_Curr varchar (1), '+
    'Dependent double , Foster double , Reunified double , Adopted double , PhysicianCurr varchar '+
    '(1), ActiveProblem varchar (1), AbuseServices varchar (1), Bathing varchar (1), Dressing '+
    'varchar (1), Toileting varchar (1), Transfer varchar (1), Continence varchar (1), Feeding '+
    'varchar (1), Walking varchar (1), HouseConfinement varchar (1), Telephone varchar (1), '+
    'WalkingDistance varchar (1), Groceries varchar (1), Meals varchar (1), Housework varchar (1), '+
    'Handyman varchar (1), Laundry varchar (1), Medication varchar (1), `Money` varchar (1), '+
    'AssessmentID varchar (5), AssessmentType varchar (3), Age_Group double , AssessmentSource '+
    'double , createddate datetime , QtrlyCntyUse1 varchar (15), QtrlyCntyUse2 varchar (15), '+
    'QtrlyCntyUse3 varchar (15))'
  /REPLACE
  /TABLE='SPSS_TEMP'
  /KEEP=AssessmentGUID, CountyID, CSINumber, globalid, CountyFSPID, Name, PartnershipDate, 
    AssessmentDate, DateOfBirth, CSIDateOfBirth, Gender, Ethnicity, Ethnicty_A, Ethnicty_B, Race1, 
    Race2, Race3, Race4, Race5, DatePartnershipStatusChange, PartnerShipStatus, EmotionalDisturbance, 
    AnotherReason, AttendanceCurr, GradesCurr, Caregivers_Curr, Wages_Curr, Spouse_Curr, Savings_Curr, 
    ChildSupport_Curr, OtherFamily_Curr, Retirement_Curr, Veterans_Curr, Loan_Curr, Housing_Curr, 
    General_Curr, FoodStamps_Curr, TANF_Curr, SSI_Curr, SSDI_Curr, SDI_Curr, TribalBenefits_Curr, 
    OtherSupport_Curr, NoSupport_Curr, Dependent, Foster, Reunified, Adopted, PhysicianCurr, 
    ActiveProblem, AbuseServices, Bathing, Dressing, Toileting, Transfer, Continence, Feeding, Walking, 
    HouseConfinement, Telephone, WalkingDistance, Groceries, Meals, Housework, Handyman, Laundry, 
    Medication, Money, AssessmentID, AssessmentType, Age_Group, AssessmentSource, createddate, 
    QtrlyCntyUse1, QtrlyCntyUse2, QtrlyCntyUse3
  /SQL='INSERT INTO DCR_3M (AssessmentGUID, CountyID, CSINumber, globalid, CountyFSPID, Name, '+
    'PartnershipDate, AssessmentDate, DateOfBirth, CSIDateOfBirth, Gender, Ethnicity, Ethnicty_A, '+
    'Ethnicty_B, Race1, Race2, Race3, Race4, Race5, DatePartnershipStatusChange, '+
    'PartnerShipStatus, EmotionalDisturbance, AnotherReason, AttendanceCurr, GradesCurr, '+
    'Caregivers_Curr, Wages_Curr, Spouse_Curr, Savings_Curr, ChildSupport_Curr, OtherFamily_Curr, '+
    'Retirement_Curr, Veterans_Curr, Loan_Curr, Housing_Curr, General_Curr, FoodStamps_Curr, '+
    'TANF_Curr, SSI_Curr, SSDI_Curr, SDI_Curr, TribalBenefits_Curr, OtherSupport_Curr, '+
    'NoSupport_Curr, Dependent, Foster, Reunified, Adopted, PhysicianCurr, ActiveProblem, '+
    'AbuseServices, Bathing, Dressing, Toileting, Transfer, Continence, Feeding, Walking, '+
    'HouseConfinement, Telephone, WalkingDistance, Groceries, Meals, Housework, Handyman, Laundry, '+
    'Medication, `Money`, AssessmentID, AssessmentType, Age_Group, AssessmentSource, createddate, '+
    'QtrlyCntyUse1, QtrlyCntyUse2, QtrlyCntyUse3) SELECT AssessmentGUID, CountyID, CSINumber, '+
    'globalid, CountyFSPID, Name, PartnershipDate, AssessmentDate, DateOfBirth, CSIDateOfBirth, '+
    'Gender, Ethnicity, Ethnicty_A, Ethnicty_B, Race1, Race2, Race3, Race4, Race5, '+
    'DatePartnershipStatusChange, PartnerShipStatus, EmotionalDisturbance, AnotherReason, '+
    'AttendanceCurr, GradesCurr, Caregivers_Curr, Wages_Curr, Spouse_Curr, Savings_Curr, '+
    'ChildSupport_Curr, OtherFamily_Curr, Retirement_Curr, Veterans_Curr, Loan_Curr, Housing_Curr, '+
    'General_Curr, FoodStamps_Curr, TANF_Curr, SSI_Curr, SSDI_Curr, SDI_Curr, TribalBenefits_Curr, '+
    'OtherSupport_Curr, NoSupport_Curr, Dependent, Foster, Reunified, Adopted, PhysicianCurr, '+
    'ActiveProblem, AbuseServices, Bathing, Dressing, Toileting, Transfer, Continence, Feeding, '+
    'Walking, HouseConfinement, Telephone, WalkingDistance, Groceries, Meals, Housework, Handyman, '+
    'Laundry, Medication, `Money`, AssessmentID, AssessmentType, Age_Group, AssessmentSource, '+
    'createddate, QtrlyCntyUse1, QtrlyCntyUse2, QtrlyCntyUse3 FROM SPSS_TEMP'
  /SQL='DROP TABLE SPSS_TEMP'.

get FILE='//covenas/decisionsupport/temp\PAFCheckSelectEps.sav' .




SAVE TRANSLATE /TYPE=ODBC
  /CONNECT='DSN=DCR;DriverId=25;FIL=MS '+
    'Access;MaxBufferSize=2048;PageTimeout=5;'
  /ENCRYPTED
  /MISSING=RECODE
  /SQL='DROP TABLE DCR_PAFRes'
  /SQL='CREATE TABLE DCR_PAFRes (DatePartnershipStatusChange datetime , Ethnicity varchar (1), '+
    'createddate datetime , DateOfBirth datetime , CSIDateOfBirth datetime , AssessmentDate '+
    'datetime , partnershipdate datetime , PartnershipStatus double , PAFStatus double , '+
    'AssessmentSource double , Age_Group double , ReferredBy double , '+
    'JuvenileHallSLASHCamp_PastTwelveOccurences double , IndividualPlacement_PastTwelveOccurences '+
    'double , MedicalHospital_PastTwelveDays double , PsychiatricHospital_PastTwelveDays double , '+
    'StatePsychiatric_PastTwelveDays double , `GroupHome0-11_PastTwelveDays` double , '+
    '`GroupHome12-14_PastTwelveDays` double , CommunityCare_PastTwelveDays double , '+
    'CommunityTreatment_PastTwelveDays double , ResidentialTreatment_PastTwelveDays double , '+
    'NursingPhysical_PastTwelveDays double , WithParents_PastTwelveDays double , '+
    'NursingPsychiatric_PastTwelveDays double , `Long-TermCare_PastTwelveDays` double , '+
    '`JuvenileHall/Camp_PastTwelveDays` double , DJJ_PastTwelveDays double , Jail_PastTwelveDays '+
    'double , Prison_PastTwelveDays double , OtherSetting_PastTwelveDays double , '+
    'UnknownSetting_PastTwelveDays double , WithOtherFamily_PastTwelveDays double , '+
    'ApartmentAlone_PastTwelveDays double , SingleRoomOccupancy_PastTwelveDays double , '+
    'FosterHomeRelative_PastTwelveDays double , EmergencyShelter_PastTwelveDays double , '+
    '`FosterHomeNon-relative_PastTwelveDays` double , Homeless_PastTwelveDays double , '+
    'AssistedLiving_PastTwelveDays double , IndividualPlacement_PastTwelveDays double , '+
    'CongregatePlacement_PastTwelveDays double , WithParents_PastTwelveOccurences double , '+
    'MedicalHospital_PastTwelveOccurences double , PsychiatricHospital_PastTwelveOccurences double '+
    ', StatePsychiatric_PastTwelveOccurences double , `GroupHome0-11_PastTwelveOccurences` double '+
    ', NursingPhysical_PastTwelveOccurences double , NursingPsychiatric_PastTwelveOccurences '+
    'double , `GroupHome12-14_PastTwelveOccurences` double , CommunityCare_PastTwelveOccurences '+
    'double , CommunityTreatment_PastTwelveOccurences double , '+
    '`Long-TermCare_PastTwelveOccurences` double , ResidentialTreatment_PastTwelveOccurences '+
    'double , Jail_PastTwelveOccurences double , Prison_PastTwelveOccurences double , '+
    'OtherSetting_PastTwelveOccurences double , UnknownSetting_PastTwelveOccurences double , '+
    'DJJ_PastTwelveOccurences double , WithOtherFamily_PastTwelveOccurences double , '+
    'ApartmentAlone_PastTwelveOccurences double , SingleRoomOccupancy_PastTwelveOccurences double '+
    ', FosterHomeRelative_PastTwelveOccurences double , EmergencyShelter_PastTwelveOccurences '+
    'double , `FosterHomeNon-relative_PastTwelveOccurences` double , Homeless_PastTwelveOccurences '+
    'double , AssistedLiving_PastTwelveOccurences double , '+
    'CongregatePlacement_PastTwelveOccurences double , Gender varchar (1), Ethnicty_A varchar (1), '+
    'Ethnicty_B varchar (1), Race1 varchar (1), Race2 varchar (1), Race3 varchar (1), Race4 '+
    'varchar (1), Race5 varchar (1), AB2034 varchar (1), GHI varchar (1), MHSA varchar (1), '+
    'WithParents_PriorTwelve varchar (1), CongregatePlacement_PriorTwelve varchar (1), '+
    'MedicalHospital_PriorTwelve varchar (1), PsychiatricHospital_PriorTwelve varchar (1), '+
    'StatePsychiatric_PriorTwelve varchar (1), `GroupHome0-11_PriorTwelve` varchar (1), '+
    '`GroupHome12-14_PriorTwelve` varchar (1), CommunityCare_PriorTwelve varchar (1), '+
    'CommunityTreatment_PriorTwelve varchar (1), NursingPhysical_PriorTwelve varchar (1), '+
    'NursingPsychiatric_PriorTwelve varchar (1), `Long-TermCare_PriorTwelve` varchar (1), '+
    '`JuvenileHall/Camp_PriorTwelve` varchar (1), DJJ_PriorTwelve varchar (1), Jail_PriorTwelve '+
    'varchar (1), Prison_PriorTwelve varchar (1), UnknownSetting_PriorTwelve varchar (1), '+
    'WithOtherFamily_PriorTwelve varchar (1), SingleRoomOccupancy_PriorTwelve varchar (1), '+
    'FosterHomeRelative_PriorTwelve varchar (1), EmergencyShelter_PriorTwelve varchar (1), '+
    'Homeless_PriorTwelve varchar (1), `FosterHomeNon-relative_PriorTwelve` varchar (1), '+
    'AssistedLiving_PriorTwelve varchar (1), IndividualPlacement_PriorTwelve varchar (1), '+
    'ResidentialTreatment_PriorTwelve varchar (1), OtherSetting_PriorTwelve varchar (1), CountyID '+
    'varchar (2), `Current` varchar (2), Yesterday varchar (2), AssessmentType varchar (3), '+
    'ApartmentAlone_PriorTwelve varchar (3), AssessmentID varchar (5), AssessmentGUID varchar '+
    '(36), CSINumber varchar (9), CountyFSPID varchar (15), Name varchar (25), globalid varchar '+
    '(36), ProgramDesc varchar (255), ProviderSiteID varchar (10), CoordinatorID varchar (25))'
  /REPLACE
  /TABLE='SPSS_TEMP'
  /KEEP=DatePartnershipStatusChange, Ethnicity, createddate, DateOfBirth, CSIDateOfBirth, 
    AssessmentDate, partnershipdate, PartnershipStatus, PAFStatus, AssessmentSource, Age_Group, 
    ReferredBy, JuvenileHallSLASHCamp_PastTwelveOccurences, IndividualPlacement_PastTwelveOccurences, 
    MedicalHospital_PastTwelveDays, PsychiatricHospital_PastTwelveDays, 
    StatePsychiatric_PastTwelveDays, GroupHome0DASH11_PastTwelveDays, GroupHome12DASH14_PastTwelveDays, 
    CommunityCare_PastTwelveDays, CommunityTreatment_PastTwelveDays, 
    ResidentialTreatment_PastTwelveDays, NursingPhysical_PastTwelveDays, WithParents_PastTwelveDays, 
    NursingPsychiatric_PastTwelveDays, LongDASHTermCare_PastTwelveDays, 
    JuvenileHallSLASHCamp_PastTwelveDays, DJJ_PastTwelveDays, Jail_PastTwelveDays, 
    Prison_PastTwelveDays, OtherSetting_PastTwelveDays, UnknownSetting_PastTwelveDays, 
    WithOtherFamily_PastTwelveDays, ApartmentAlone_PastTwelveDays, SingleRoomOccupancy_PastTwelveDays, 
    FosterHomeRelative_PastTwelveDays, EmergencyShelter_PastTwelveDays, 
    FosterHomeNonDASHrelative_PastTwelveDays, Homeless_PastTwelveDays, AssistedLiving_PastTwelveDays, 
    IndividualPlacement_PastTwelveDays, CongregatePlacement_PastTwelveDays, 
    WithParents_PastTwelveOccurences, MedicalHospital_PastTwelveOccurences, 
    PsychiatricHospital_PastTwelveOccurences, StatePsychiatric_PastTwelveOccurences, 
    GroupHome0DASH11_PastTwelveOccurences, NursingPhysical_PastTwelveOccurences, 
    NursingPsychiatric_PastTwelveOccurences, GroupHome12DASH14_PastTwelveOccurences, 
    CommunityCare_PastTwelveOccurences, CommunityTreatment_PastTwelveOccurences, 
    LongDASHTermCare_PastTwelveOccurences, ResidentialTreatment_PastTwelveOccurences, 
    Jail_PastTwelveOccurences, Prison_PastTwelveOccurences, OtherSetting_PastTwelveOccurences, 
    UnknownSetting_PastTwelveOccurences, DJJ_PastTwelveOccurences, 
    WithOtherFamily_PastTwelveOccurences, ApartmentAlone_PastTwelveOccurences, 
    SingleRoomOccupancy_PastTwelveOccurences, FosterHomeRelative_PastTwelveOccurences, 
    EmergencyShelter_PastTwelveOccurences, FosterHomeNonDASHrelative_PastTwelveOccurences, 
    Homeless_PastTwelveOccurences, AssistedLiving_PastTwelveOccurences, 
    CongregatePlacement_PastTwelveOccurences, Gender, Ethnicty_A, Ethnicty_B, Race1, Race2, Race3, 
    Race4, Race5, AB2034, GHI, MHSA, WithParents_PriorTwelve, CongregatePlacement_PriorTwelve, 
    MedicalHospital_PriorTwelve, PsychiatricHospital_PriorTwelve, StatePsychiatric_PriorTwelve, 
    GroupHome0DASH11_PriorTwelve, GroupHome12DASH14_PriorTwelve, CommunityCare_PriorTwelve, 
    CommunityTreatment_PriorTwelve, NursingPhysical_PriorTwelve, NursingPsychiatric_PriorTwelve, 
    LongDASHTermCare_PriorTwelve, JuvenileHallSLASHCamp_PriorTwelve, DJJ_PriorTwelve, Jail_PriorTwelve, 
    Prison_PriorTwelve, UnknownSetting_PriorTwelve, WithOtherFamily_PriorTwelve, 
    SingleRoomOccupancy_PriorTwelve, FosterHomeRelative_PriorTwelve, EmergencyShelter_PriorTwelve, 
    Homeless_PriorTwelve, FosterHomeNonDASHrelative_PriorTwelve, AssistedLiving_PriorTwelve, 
    IndividualPlacement_PriorTwelve, ResidentialTreatment_PriorTwelve, OtherSetting_PriorTwelve, 
    CountyID, Current, Yesterday, AssessmentType, ApartmentAlone_PriorTwelve, AssessmentID, 
    AssessmentGUID, CSINumber, CountyFSPID, Name, globalid, ProgramDesc, ProviderSiteID, CoordinatorID
  /SQL='INSERT INTO DCR_PAFRes (DatePartnershipStatusChange, Ethnicity, createddate, DateOfBirth, '+
    'CSIDateOfBirth, AssessmentDate, partnershipdate, PartnershipStatus, PAFStatus, '+
    'AssessmentSource, Age_Group, ReferredBy, JuvenileHallSLASHCamp_PastTwelveOccurences, '+
    'IndividualPlacement_PastTwelveOccurences, MedicalHospital_PastTwelveDays, '+
    'PsychiatricHospital_PastTwelveDays, StatePsychiatric_PastTwelveDays, '+
    '`GroupHome0-11_PastTwelveDays`, `GroupHome12-14_PastTwelveDays`, '+
    'CommunityCare_PastTwelveDays, CommunityTreatment_PastTwelveDays, '+
    'ResidentialTreatment_PastTwelveDays, NursingPhysical_PastTwelveDays, '+
    'WithParents_PastTwelveDays, NursingPsychiatric_PastTwelveDays, '+
    '`Long-TermCare_PastTwelveDays`, `JuvenileHall/Camp_PastTwelveDays`, DJJ_PastTwelveDays, '+
    'Jail_PastTwelveDays, Prison_PastTwelveDays, OtherSetting_PastTwelveDays, '+
    'UnknownSetting_PastTwelveDays, WithOtherFamily_PastTwelveDays, ApartmentAlone_PastTwelveDays, '+
    'SingleRoomOccupancy_PastTwelveDays, FosterHomeRelative_PastTwelveDays, '+
    'EmergencyShelter_PastTwelveDays, `FosterHomeNon-relative_PastTwelveDays`, '+
    'Homeless_PastTwelveDays, AssistedLiving_PastTwelveDays, IndividualPlacement_PastTwelveDays, '+
    'CongregatePlacement_PastTwelveDays, WithParents_PastTwelveOccurences, '+
    'MedicalHospital_PastTwelveOccurences, PsychiatricHospital_PastTwelveOccurences, '+
    'StatePsychiatric_PastTwelveOccurences, `GroupHome0-11_PastTwelveOccurences`, '+
    'NursingPhysical_PastTwelveOccurences, NursingPsychiatric_PastTwelveOccurences, '+
    '`GroupHome12-14_PastTwelveOccurences`, CommunityCare_PastTwelveOccurences, '+
    'CommunityTreatment_PastTwelveOccurences, `Long-TermCare_PastTwelveOccurences`, '+
    'ResidentialTreatment_PastTwelveOccurences, Jail_PastTwelveOccurences, '+
    'Prison_PastTwelveOccurences, OtherSetting_PastTwelveOccurences, '+
    'UnknownSetting_PastTwelveOccurences, DJJ_PastTwelveOccurences, '+
    'WithOtherFamily_PastTwelveOccurences, ApartmentAlone_PastTwelveOccurences, '+
    'SingleRoomOccupancy_PastTwelveOccurences, FosterHomeRelative_PastTwelveOccurences, '+
    'EmergencyShelter_PastTwelveOccurences, `FosterHomeNon-relative_PastTwelveOccurences`, '+
    'Homeless_PastTwelveOccurences, AssistedLiving_PastTwelveOccurences, '+
    'CongregatePlacement_PastTwelveOccurences, Gender, Ethnicty_A, Ethnicty_B, Race1, Race2, '+
    'Race3, Race4, Race5, AB2034, GHI, MHSA, WithParents_PriorTwelve, '+
    'CongregatePlacement_PriorTwelve, MedicalHospital_PriorTwelve, '+
    'PsychiatricHospital_PriorTwelve, StatePsychiatric_PriorTwelve, `GroupHome0-11_PriorTwelve`, '+
    '`GroupHome12-14_PriorTwelve`, CommunityCare_PriorTwelve, CommunityTreatment_PriorTwelve, '+
    'NursingPhysical_PriorTwelve, NursingPsychiatric_PriorTwelve, `Long-TermCare_PriorTwelve`, '+
    '`JuvenileHall/Camp_PriorTwelve`, DJJ_PriorTwelve, Jail_PriorTwelve, Prison_PriorTwelve, '+
    'UnknownSetting_PriorTwelve, WithOtherFamily_PriorTwelve, SingleRoomOccupancy_PriorTwelve, '+
    'FosterHomeRelative_PriorTwelve, EmergencyShelter_PriorTwelve, Homeless_PriorTwelve, '+
    '`FosterHomeNon-relative_PriorTwelve`, AssistedLiving_PriorTwelve, '+
    'IndividualPlacement_PriorTwelve, ResidentialTreatment_PriorTwelve, OtherSetting_PriorTwelve, '+
    'CountyID, `Current`, Yesterday, AssessmentType, ApartmentAlone_PriorTwelve, AssessmentID, '+
    'AssessmentGUID, CSINumber, CountyFSPID, Name, globalid, ProgramDesc, ProviderSiteID, '+
    'CoordinatorID) SELECT DatePartnershipStatusChange, Ethnicity, createddate, DateOfBirth, '+
    'CSIDateOfBirth, AssessmentDate, partnershipdate, PartnershipStatus, PAFStatus, '+
    'AssessmentSource, Age_Group, ReferredBy, JuvenileHallSLASHCamp_PastTwelveOccurences, '+
    'IndividualPlacement_PastTwelveOccurences, MedicalHospital_PastTwelveDays, '+
    'PsychiatricHospital_PastTwelveDays, StatePsychiatric_PastTwelveDays, '+
    'GroupHome0DASH11_PastTwelveDays, GroupHome12DASH14_PastTwelveDays, '+
    'CommunityCare_PastTwelveDays, CommunityTreatment_PastTwelveDays, '+
    'ResidentialTreatment_PastTwelveDays, NursingPhysical_PastTwelveDays, '+
    'WithParents_PastTwelveDays, NursingPsychiatric_PastTwelveDays, '+
    'LongDASHTermCare_PastTwelveDays, JuvenileHallSLASHCamp_PastTwelveDays, DJJ_PastTwelveDays, '+
    'Jail_PastTwelveDays, Prison_PastTwelveDays, OtherSetting_PastTwelveDays, '+
    'UnknownSetting_PastTwelveDays, WithOtherFamily_PastTwelveDays, ApartmentAlone_PastTwelveDays, '+
    'SingleRoomOccupancy_PastTwelveDays, FosterHomeRelative_PastTwelveDays, '+
    'EmergencyShelter_PastTwelveDays, FosterHomeNonDASHrelative_PastTwelveDays, '+
    'Homeless_PastTwelveDays, AssistedLiving_PastTwelveDays, IndividualPlacement_PastTwelveDays, '+
    'CongregatePlacement_PastTwelveDays, WithParents_PastTwelveOccurences, '+
    'MedicalHospital_PastTwelveOccurences, PsychiatricHospital_PastTwelveOccurences, '+
    'StatePsychiatric_PastTwelveOccurences, GroupHome0DASH11_PastTwelveOccurences, '+
    'NursingPhysical_PastTwelveOccurences, NursingPsychiatric_PastTwelveOccurences, '+
    'GroupHome12DASH14_PastTwelveOccurences, CommunityCare_PastTwelveOccurences, '+
    'CommunityTreatment_PastTwelveOccurences, LongDASHTermCare_PastTwelveOccurences, '+
    'ResidentialTreatment_PastTwelveOccurences, Jail_PastTwelveOccurences, '+
    'Prison_PastTwelveOccurences, OtherSetting_PastTwelveOccurences, '+
    'UnknownSetting_PastTwelveOccurences, DJJ_PastTwelveOccurences, '+
    'WithOtherFamily_PastTwelveOccurences, ApartmentAlone_PastTwelveOccurences, '+
    'SingleRoomOccupancy_PastTwelveOccurences, FosterHomeRelative_PastTwelveOccurences, '+
    'EmergencyShelter_PastTwelveOccurences, FosterHomeNonDASHrelative_PastTwelveOccurences, '+
    'Homeless_PastTwelveOccurences, AssistedLiving_PastTwelveOccurences, '+
    'CongregatePlacement_PastTwelveOccurences, Gender, Ethnicty_A, Ethnicty_B, Race1, Race2, '+
    'Race3, Race4, Race5, AB2034, GHI, MHSA, WithParents_PriorTwelve, '+
    'CongregatePlacement_PriorTwelve, MedicalHospital_PriorTwelve, '+
    'PsychiatricHospital_PriorTwelve, StatePsychiatric_PriorTwelve, GroupHome0DASH11_PriorTwelve, '+
    'GroupHome12DASH14_PriorTwelve, CommunityCare_PriorTwelve, CommunityTreatment_PriorTwelve, '+
    'NursingPhysical_PriorTwelve, NursingPsychiatric_PriorTwelve, LongDASHTermCare_PriorTwelve, '+
    'JuvenileHallSLASHCamp_PriorTwelve, DJJ_PriorTwelve, Jail_PriorTwelve, Prison_PriorTwelve, '+
    'UnknownSetting_PriorTwelve, WithOtherFamily_PriorTwelve, SingleRoomOccupancy_PriorTwelve, '+
    'FosterHomeRelative_PriorTwelve, EmergencyShelter_PriorTwelve, Homeless_PriorTwelve, '+
    'FosterHomeNonDASHrelative_PriorTwelve, AssistedLiving_PriorTwelve, '+
    'IndividualPlacement_PriorTwelve, ResidentialTreatment_PriorTwelve, OtherSetting_PriorTwelve, '+
    'CountyID, `Current`, Yesterday, AssessmentType, ApartmentAlone_PriorTwelve, AssessmentID, '+
    'AssessmentGUID, CSINumber, CountyFSPID, Name, globalid, ProgramDesc, ProviderSiteID, '+
    'CoordinatorID FROM SPSS_TEMP'
  /SQL='DROP TABLE SPSS_TEMP'.



get FILE='//covenas/decisionsupport/temp\PAFnonresCheckSelectEps.sav' .


SAVE TRANSLATE /TYPE=ODBC
  /CONNECT='DSN=DCR;DriverId=25;FIL=MS '+
    'Access;MaxBufferSize=2048;PageTimeout=5;'
  /ENCRYPTED
  /MISSING=RECODE
  /SQL='DROP TABLE DCR_PAFnonRes'
  /SQL='CREATE TABLE DCR_PAFnonRes (CountyID varchar (5), Ethnicity varchar (1), CSINumber '+
    'varchar (9), globalid varchar (36), CountyFSPID varchar (15), Name varchar (25), '+
    'partnershipdate datetime , AssessmentDate datetime , DateOfBirth datetime , CSIDateOfBirth '+
    'datetime , Gender varchar (1), Ethnicty_A varchar (1), Ethnicty_B varchar (1), Race1 varchar '+
    '(1), Race2 varchar (1), Race3 varchar (1), Race4 varchar (1), Race5 varchar (1), ReferredBy '+
    'double , PartnershipStatus double , PAFStatus double , DatePartnershipStatusChange datetime , '+
    'AB2034 varchar (1), GHI varchar (1), MHSA varchar (1), HighestGrade varchar (2), '+
    'EmotionalDisturbance varchar (1), AnotherReason varchar (1), AttendancePast12 varchar (1), '+
    'AttendanceCurr varchar (1), GradesCurr varchar (1), GradesPast12 varchar (1), '+
    'SuspensionPast12 double , ExpulsionPast12 double , NotinschoolPast12 double , NotinschoolCurr '+
    'varchar (1), HighSchoolPast12 double , HighSchoolCurr varchar (1), TechnicalPast12 double , '+
    'TechnicalCurr varchar (1), CommunityCollegePast12 double , CommunityCollegeCurr varchar (1), '+
    'GraduatePast12 double , GraduateCurr varchar (1), OtherEducationPast12 double , '+
    'OtherEducationCurr varchar (1), EdRecoveryGoals varchar (1), Past12_Competitive double , '+
    'Past12_CompetitiveAvgHrWeek double , Past12_CompetitiveAvgHrWage currency , Past12_Supported '+
    'double , Past12_SupportedAvgHrWeek double , Past12_SupportedAvgHrWage currency , '+
    'Past12_Transitional double , Past12_TransitionalAvgHrWeek double , '+
    'Past12_TransitionalAvgHrWage currency , `Past12_In-House` double , `Past12_In-HouseAvgHrWeek` '+
    'double , `Past12_In-HouseAvgHrWage` currency , `Past12_Non-paid` double , '+
    '`Past12_Non-paidAvgHrWeek` double , Past12_OtherEmployment double , '+
    'Past12_OtherEmploymentAvgHrWeek double , Past12_OtherEmploymentAvgHrWage currency , '+
    'Past12_Unemployed double , Current_CompetitiveAvgHrWeek double , Current_CompetitiveAvgHrWage '+
    'currency , Current_SupportedAvgHrWeek double , Current_SupportedAvgHrWage currency , '+
    'Current_TransitionalAvgHrWeek double , Current_TransitionalAvgHrWage currency , '+
    '`Current_In-HouseAvgHrWeek` double , `Current_In-HouseAvgHrWage` currency , '+
    '`Current_Non-paidAvgHrWeek` double , Current_OtherEmploymentAvgHrWeek double , '+
    'Current_OtherEmploymentAvgHrWage currency , Current_Unemployed varchar (1), EmpRecoveryGoals '+
    'varchar (1), Caregivers_Past12 varchar (1), Caregivers_Curr varchar (1), Wages_Past12 varchar '+
    '(1), Wages_Curr varchar (1), Spouse_Past12 varchar (1), Spouse_Curr varchar (1), '+
    'Savings_Past12 varchar (1), Savings_Curr varchar (1), ChildSupport_Past12 varchar (1), '+
    'ChildSupport_Curr varchar (1), OtherFamily_Past12 varchar (1), OtherFamily_Curr varchar (1), '+
    'Retirement_Past12 varchar (1), Retirement_Curr varchar (1), Veterans_Past12 varchar (1), '+
    'Veterans_Curr varchar (1), Loan_Past12 varchar (1), Loan_Curr varchar (1), Housing_Past12 '+
    'varchar (1), Housing_Curr varchar (1), General_Past12 varchar (1), General_Curr varchar (1), '+
    'FoodStamps_Past12 varchar (1), FoodStamps_Curr varchar (1), TANF_Past12 varchar (1), '+
    'TANF_Curr varchar (1), SSI_Past12 varchar (1), SSI_Curr varchar (1), SSDI_Past12 varchar (1), '+
    'SSDI_Curr varchar (1), SDI_Past12 varchar (1), SDI_Curr varchar (1), TribalBenefits_Past12 '+
    'varchar (1), TribalBenefits_Curr varchar (1), OtherSupport_Past12 varchar (1), '+
    'OtherSupport_Curr varchar (1), NoSupport_Past12 varchar (1), NoSupport_Curr varchar (1), '+
    'ArrestPast12 double , ArrestPrior12 varchar (1), ProbationStatus varchar (1), ProbPast12 '+
    'varchar (1), ProbPrior12 varchar (1), ParoleStatus varchar (1), ParolePast12 varchar (1), '+
    'ParolePrior12 varchar (1), ConservaStatus varchar (1), ConservPast12 varchar (1), '+
    'ConservPrior12 varchar (1), PayeeStatus varchar (1), PayeePast12 varchar (1), PayeePrior12 '+
    'varchar (1), WICodeStatus varchar (1), DepenPast12 varchar (1), DepenPrior12 varchar (1), '+
    'DepenYear double , Dependent double , Foster double , Reunified double , Adopted double , '+
    'PhyRelated double , MenRelated double , PhysicianCurr varchar (1), PhysicianPast12 varchar '+
    '(1), MentalIllness varchar (1), ActiveProblem varchar (1), AbuseServices varchar (1), Bathing '+
    'varchar (1), Dressing varchar (1), Toileting varchar (1), Transfer varchar (1), Continence '+
    'varchar (1), Feeding varchar (1), Walking varchar (1), HouseConfinement varchar (1), '+
    'Telephone varchar (1), WalkingDistance varchar (1), Groceries varchar (1), Meals varchar (1), '+
    'Housework varchar (1), Handyman varchar (1), Laundry varchar (1), Medication varchar (1), '+
    '`Money` varchar (1), AssessmentID varchar (5), AssessmentGUID varchar (36), AssessmentType '+
    'varchar (3), Age_Group double , AssessmentSource double , CreateDate datetime , KETCntyUse1 '+
    'varchar (15), KETCntyUse2 varchar (15), KETCntyUse3 varchar (15), QtrlyCntyUse1 varchar (15), '+
    'QtrlyCntyUse2 varchar (15), QtrlyCntyUse3 varchar (15), ProgramDesc varchar (255), '+
    'ProviderSiteID varchar (10), CoordinatorID varchar (25))'
  /REPLACE
  /TABLE='SPSS_TEMP'
  /KEEP=CountyID, Ethnicity, CSINumber, globalid, CountyFSPID, Name, partnershipdate, 
    AssessmentDate, DateOfBirth, CSIDateOfBirth, Gender, Ethnicty_A, Ethnicty_B, Race1, Race2, Race3, 
    Race4, Race5, ReferredBy, PartnershipStatus, PAFStatus, DatePartnershipStatusChange, AB2034, GHI, 
    MHSA, HighestGrade, EmotionalDisturbance, AnotherReason, AttendancePast12, AttendanceCurr, 
    GradesCurr, GradesPast12, SuspensionPast12, ExpulsionPast12, NotinschoolPast12, NotinschoolCurr, 
    HighSchoolPast12, HighSchoolCurr, TechnicalPast12, TechnicalCurr, CommunityCollegePast12, 
    CommunityCollegeCurr, GraduatePast12, GraduateCurr, OtherEducationPast12, OtherEducationCurr, 
    EdRecoveryGoals, Past12_Competitive, Past12_CompetitiveAvgHrWeek, Past12_CompetitiveAvgHrWage, 
    Past12_Supported, Past12_SupportedAvgHrWeek, Past12_SupportedAvgHrWage, Past12_Transitional, 
    Past12_TransitionalAvgHrWeek, Past12_TransitionalAvgHrWage, Past12_InDASHHouse, 
    Past12_InDASHHouseAvgHrWeek, Past12_InDASHHouseAvgHrWage, Past12_NonDASHpaid, 
    Past12_NonDASHpaidAvgHrWeek, Past12_OtherEmployment, Past12_OtherEmploymentAvgHrWeek, 
    Past12_OtherEmploymentAvgHrWage, Past12_Unemployed, Current_CompetitiveAvgHrWeek, 
    Current_CompetitiveAvgHrWage, Current_SupportedAvgHrWeek, Current_SupportedAvgHrWage, 
    Current_TransitionalAvgHrWeek, Current_TransitionalAvgHrWage, Current_InDASHHouseAvgHrWeek, 
    Current_InDASHHouseAvgHrWage, Current_NonDASHpaidAvgHrWeek, Current_OtherEmploymentAvgHrWeek, 
    Current_OtherEmploymentAvgHrWage, Current_Unemployed, EmpRecoveryGoals, Caregivers_Past12, 
    Caregivers_Curr, Wages_Past12, Wages_Curr, Spouse_Past12, Spouse_Curr, Savings_Past12, 
    Savings_Curr, ChildSupport_Past12, ChildSupport_Curr, OtherFamily_Past12, OtherFamily_Curr, 
    Retirement_Past12, Retirement_Curr, Veterans_Past12, Veterans_Curr, Loan_Past12, Loan_Curr, 
    Housing_Past12, Housing_Curr, General_Past12, General_Curr, FoodStamps_Past12, FoodStamps_Curr, 
    TANF_Past12, TANF_Curr, SSI_Past12, SSI_Curr, SSDI_Past12, SSDI_Curr, SDI_Past12, SDI_Curr, 
    TribalBenefits_Past12, TribalBenefits_Curr, OtherSupport_Past12, OtherSupport_Curr, 
    NoSupport_Past12, NoSupport_Curr, ArrestPast12, ArrestPrior12, ProbationStatus, ProbPast12, 
    ProbPrior12, ParoleStatus, ParolePast12, ParolePrior12, ConservaStatus, ConservPast12, 
    ConservPrior12, PayeeStatus, PayeePast12, PayeePrior12, WICodeStatus, DepenPast12, DepenPrior12, 
    DepenYear,  Foster, Reunified, Adopted, PhyRelated, MenRelated, PhysicianCurr, 
    PhysicianPast12, MentalIllness, ActiveProblem, AbuseServices, Bathing, Dressing, Toileting, 
    Transfer, Continence, Feeding, Walking, HouseConfinement, Telephone, WalkingDistance, Groceries, 
    Meals, Housework, Handyman, Laundry, Medication, Money, AssessmentID, AssessmentGUID, 
    AssessmentType, Age_Group, AssessmentSource, CreateDate, KETCntyUse1, KETCntyUse2, KETCntyUse3, 
    QtrlyCntyUse1, QtrlyCntyUse2, QtrlyCntyUse3, ProgramDesc, ProviderSiteID, CoordinatorID
  /SQL='INSERT INTO DCR_PAFnonRes (CountyID, Ethnicity, CSINumber, globalid, CountyFSPID, Name, '+
    'partnershipdate, AssessmentDate, DateOfBirth, CSIDateOfBirth, Gender, Ethnicty_A, Ethnicty_B, '+
    'Race1, Race2, Race3, Race4, Race5, ReferredBy, PartnershipStatus, PAFStatus, '+
    'DatePartnershipStatusChange, AB2034, GHI, MHSA, HighestGrade, EmotionalDisturbance, '+
    'AnotherReason, AttendancePast12, AttendanceCurr, GradesCurr, GradesPast12, SuspensionPast12, '+
    'ExpulsionPast12, NotinschoolPast12, NotinschoolCurr, HighSchoolPast12, HighSchoolCurr, '+
    'TechnicalPast12, TechnicalCurr, CommunityCollegePast12, CommunityCollegeCurr, GraduatePast12, '+
    'GraduateCurr, OtherEducationPast12, OtherEducationCurr, EdRecoveryGoals, Past12_Competitive, '+
    'Past12_CompetitiveAvgHrWeek, Past12_CompetitiveAvgHrWage, Past12_Supported, '+
    'Past12_SupportedAvgHrWeek, Past12_SupportedAvgHrWage, Past12_Transitional, '+
    'Past12_TransitionalAvgHrWeek, Past12_TransitionalAvgHrWage, `Past12_In-House`, '+
    '`Past12_In-HouseAvgHrWeek`, `Past12_In-HouseAvgHrWage`, `Past12_Non-paid`, '+
    '`Past12_Non-paidAvgHrWeek`, Past12_OtherEmployment, Past12_OtherEmploymentAvgHrWeek, '+
    'Past12_OtherEmploymentAvgHrWage, Past12_Unemployed, Current_CompetitiveAvgHrWeek, '+
    'Current_CompetitiveAvgHrWage, Current_SupportedAvgHrWeek, Current_SupportedAvgHrWage, '+
    'Current_TransitionalAvgHrWeek, Current_TransitionalAvgHrWage, `Current_In-HouseAvgHrWeek`, '+
    '`Current_In-HouseAvgHrWage`, `Current_Non-paidAvgHrWeek`, Current_OtherEmploymentAvgHrWeek, '+
    'Current_OtherEmploymentAvgHrWage, Current_Unemployed, EmpRecoveryGoals, Caregivers_Past12, '+
    'Caregivers_Curr, Wages_Past12, Wages_Curr, Spouse_Past12, Spouse_Curr, Savings_Past12, '+
    'Savings_Curr, ChildSupport_Past12, ChildSupport_Curr, OtherFamily_Past12, OtherFamily_Curr, '+
    'Retirement_Past12, Retirement_Curr, Veterans_Past12, Veterans_Curr, Loan_Past12, Loan_Curr, '+
    'Housing_Past12, Housing_Curr, General_Past12, General_Curr, FoodStamps_Past12, '+
    'FoodStamps_Curr, TANF_Past12, TANF_Curr, SSI_Past12, SSI_Curr, SSDI_Past12, SSDI_Curr, '+
    'SDI_Past12, SDI_Curr, TribalBenefits_Past12, TribalBenefits_Curr, OtherSupport_Past12, '+
    'OtherSupport_Curr, NoSupport_Past12, NoSupport_Curr, ArrestPast12, ArrestPrior12, '+
    'ProbationStatus, ProbPast12, ProbPrior12, ParoleStatus, ParolePast12, ParolePrior12, '+
    'ConservaStatus, ConservPast12, ConservPrior12, PayeeStatus, PayeePast12, PayeePrior12, '+
    'WICodeStatus, DepenPast12, DepenPrior12, DepenYear,  Foster, Reunified, Adopted, '+
    'PhyRelated, MenRelated, PhysicianCurr, PhysicianPast12, MentalIllness, ActiveProblem, '+
    'AbuseServices, Bathing, Dressing, Toileting, Transfer, Continence, Feeding, Walking, '+
    'HouseConfinement, Telephone, WalkingDistance, Groceries, Meals, Housework, Handyman, Laundry, '+
    'Medication, `Money`, AssessmentID, AssessmentGUID, AssessmentType, Age_Group, '+
    'AssessmentSource, CreateDate, KETCntyUse1, KETCntyUse2, KETCntyUse3, QtrlyCntyUse1, '+
    'QtrlyCntyUse2, QtrlyCntyUse3, ProgramDesc, ProviderSiteID, CoordinatorID) SELECT CountyID, '+
    'Ethnicity, CSINumber, globalid, CountyFSPID, Name, partnershipdate, AssessmentDate, '+
    'DateOfBirth, CSIDateOfBirth, Gender, Ethnicty_A, Ethnicty_B, Race1, Race2, Race3, Race4, '+
    'Race5, ReferredBy, PartnershipStatus, PAFStatus, DatePartnershipStatusChange, AB2034, GHI, '+
    'MHSA, HighestGrade, EmotionalDisturbance, AnotherReason, AttendancePast12, AttendanceCurr, '+
    'GradesCurr, GradesPast12, SuspensionPast12, ExpulsionPast12, NotinschoolPast12, '+
    'NotinschoolCurr, HighSchoolPast12, HighSchoolCurr, TechnicalPast12, TechnicalCurr, '+
    'CommunityCollegePast12, CommunityCollegeCurr, GraduatePast12, GraduateCurr, '+
    'OtherEducationPast12, OtherEducationCurr, EdRecoveryGoals, Past12_Competitive, '+
    'Past12_CompetitiveAvgHrWeek, Past12_CompetitiveAvgHrWage, Past12_Supported, '+
    'Past12_SupportedAvgHrWeek, Past12_SupportedAvgHrWage, Past12_Transitional, '+
    'Past12_TransitionalAvgHrWeek, Past12_TransitionalAvgHrWage, Past12_InDASHHouse, '+
    'Past12_InDASHHouseAvgHrWeek, Past12_InDASHHouseAvgHrWage, Past12_NonDASHpaid, '+
    'Past12_NonDASHpaidAvgHrWeek, Past12_OtherEmployment, Past12_OtherEmploymentAvgHrWeek, '+
    'Past12_OtherEmploymentAvgHrWage, Past12_Unemployed, Current_CompetitiveAvgHrWeek, '+
    'Current_CompetitiveAvgHrWage, Current_SupportedAvgHrWeek, Current_SupportedAvgHrWage, '+
    'Current_TransitionalAvgHrWeek, Current_TransitionalAvgHrWage, Current_InDASHHouseAvgHrWeek, '+
    'Current_InDASHHouseAvgHrWage, Current_NonDASHpaidAvgHrWeek, Current_OtherEmploymentAvgHrWeek, '+
    'Current_OtherEmploymentAvgHrWage, Current_Unemployed, EmpRecoveryGoals, Caregivers_Past12, '+
    'Caregivers_Curr, Wages_Past12, Wages_Curr, Spouse_Past12, Spouse_Curr, Savings_Past12, '+
    'Savings_Curr, ChildSupport_Past12, ChildSupport_Curr, OtherFamily_Past12, OtherFamily_Curr, '+
    'Retirement_Past12, Retirement_Curr, Veterans_Past12, Veterans_Curr, Loan_Past12, Loan_Curr, '+
    'Housing_Past12, Housing_Curr, General_Past12, General_Curr, FoodStamps_Past12, '+
    'FoodStamps_Curr, TANF_Past12, TANF_Curr, SSI_Past12, SSI_Curr, SSDI_Past12, SSDI_Curr, '+
    'SDI_Past12, SDI_Curr, TribalBenefits_Past12, TribalBenefits_Curr, OtherSupport_Past12, '+
    'OtherSupport_Curr, NoSupport_Past12, NoSupport_Curr, ArrestPast12, ArrestPrior12, '+
    'ProbationStatus, ProbPast12, ProbPrior12, ParoleStatus, ParolePast12, ParolePrior12, '+
    'ConservaStatus, ConservPast12, ConservPrior12, PayeeStatus, PayeePast12, PayeePrior12, '+
    'WICodeStatus, DepenPast12, DepenPrior12, DepenYear, Foster, Reunified, Adopted, '+
    'PhyRelated, MenRelated, PhysicianCurr, PhysicianPast12, MentalIllness, ActiveProblem, '+
    'AbuseServices, Bathing, Dressing, Toileting, Transfer, Continence, Feeding, Walking, '+
    'HouseConfinement, Telephone, WalkingDistance, Groceries, Meals, Housework, Handyman, Laundry, '+
    'Medication, `Money`, AssessmentID, AssessmentGUID, AssessmentType, Age_Group, '+
    'AssessmentSource, CreateDate, KETCntyUse1, KETCntyUse2, KETCntyUse3, QtrlyCntyUse1, '+
    'QtrlyCntyUse2, QtrlyCntyUse3, ProgramDesc, ProviderSiteID, CoordinatorID FROM SPSS_TEMP'
  /SQL='DROP TABLE SPSS_TEMP'.

n 1.

compute DateDownload=$time.
formats datedownload(date11).
exe.
freq datedownload.
match files /file=* /keep datedownload.
exe.
SAVE TRANSLATE /TYPE=ODBC
  /CONNECT='DSN=DCR;DriverId=25;FIL=MS '+
    'Access;MaxBufferSize=2048;PageTimeout=5;'
 /table= 'DateDataDownload' /MAP/REPLACE.



