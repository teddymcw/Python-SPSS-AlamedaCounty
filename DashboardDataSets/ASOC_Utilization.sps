* update freq everyday.


 * Hi Everyone,

 * The Adult System of Care has asked for utilization data about the clients 
who were closed to SvcTeams but remain open to programs.

 * Please look at clients currently open to program AND closed to team. 
 *    For the 12 months following their closure to team, how many of the following have they had?

 * 1.	Hospitalizations
2.	PES Admits
3.	CJ admits
4.	Overall System Costs
5.	Subacute Admits
6.	Sausal Creek Admits
7.	CRP

 * Please let me know if you have any questions.

 * -	John
********************.
GET file='//covenas/decisionsupport/epscg.sav'
   /KEEP ru case opdate closdate epflag.

INSERT File='//covenas/decisionsupport/modules/uncookedmonth.sps'.
SELECT IF opdate lt uncookedmonth.

SORT CASES by ru.
MATCH FILES /table='//covenas/decisionsupport/rutable.sav'/file=*/by ru
   /keep agency ru provname case opdate closdate epflag psmask2 program level2 uncookedmonth.

RECODE program(SYSMIS=0).
RECODE level2(sysmis=0).

IF (any(psmask2, 513, 550) OR Level2=1) AND epflag = "O" AND program = 0 OpenToT = 1.
IF (any(psmask2, 513, 550) OR Level2=1) AND epflag = "O" AND program = 1 OpenToP = 1.

TEMPORARY.
SELECT IF (any(psmask2, 513,550) OR Level2=1) AND program = 0.
AGGREGATE outfile= * mode=addvariables
   /break=case
   /TeamClosDate=max(closdate)
   /TeamProv=max(provname).
*having a teamclosdate and a team closdate is very confusing!. why not use an overwrite = yes.
AGGREGATE outfile = * mode=addvariables
   /break=case
   /OpenToTeam=max(OpenToT)
   /OpenToProgram=max(OpenToP)
   /TeamCloseDate=max(TeamClosdate)
   /TeamProvname=max(TeamProv).

RECODE OpenToTeam(sysmis = 0).
RECODE OpentoProgram(sysmis=0).
*aparently fine to have a space between any and the parameter..
 * if any (psmask2,513,550) test=1.
 * freq test.

SELECT IF (ANY(psmask2, 513, 550) OR Level2=1).
SELECT IF (OpenToProgram=1 AND OpenToTeam=0).

compute cohort=1.
aggregate outfile ='//covenas/decisionsupport/temp/opentoprogcohort.sav'
   /break = case
   /TeamClosedate=max(TeamClosedate)
   /TeamProvname=max(TeamProvname)
   /cohort=max(cohort).

save outfile='//covenas/decisionsupport/temp/programOnlyEpWork.sav'.
 * IF (ANY(psmask2, 513, 550) OR Level2=1) 
AND (OpenToProgram=1 AND OpenToTeam=0) keep=1.
 * freq keep.

*one problem is . 
*     do if opdate GE datesum(uncookedmonth,-1,'years').
 *           IF opdate LT datesum(uncookedmonth,-1,'years') keep=1..
*there is no way i wrote this because it doesn't make sense. only opdates after a year and before a year?.  .

*let's simplify it, but i still don't know what you want...  probably.

GET file='//covenas/decisionsupport/epscg.sav'
   /KEEP ru case opdate closdate epflag.

INSERT File='//covenas/decisionsupport/modules/uncookedmonth.sps'.
select if opdate gt datesum(uncookedmonth,-1,'years').

 * IF opdate GT TeamCloseDate and (opdate GE datesum(uncookedmonth,-1,'years')) and  (opdate LT uncookedmonth) keep=1.
 * freq keep.
*I'm keeping twice as many eps as before..
SORT CASES by ru.
MATCH FILES /table='//covenas/decisionsupport/rutable.sav'/file=*/by ru
   /keep agency ru provname case opdate closdate epflag psmask2 program level2 uncookedmonth.

sort cases by case.
match files /table='//covenas/decisionsupport/temp/opentoprogcohort.sav' /file=* /by case.

select if cohort=1.

select if opdate gt teamclosedate.

*complicated for no reason and doesn't work..
 * DO IF opdate GT TeamCloseDate.
 *     do if opdate GE datesum(uncookedmonth,-1,'years').
 *           IF opdate LT datesum(uncookedmonth,-1,'years') keep=1.
 * END IF.
 * END IF.

COMPUTE HospitalAdmit = 0.
COMPUTE PESAdmit = 0.
COMPUTE CJAdmit = 0.
COMPUTE SubAcuteAdmit = 0.
COMPUTE SausalCreekAdmit = 0.
COMPUTE CrisisResponseAdmit = 0.

IF psmask2=5  HospitalAdmit = 1.
IF ru="01016"  PESAdmit =1. 
IF Agency="CJ Mental Health" CJAdmit=1.
IF psmask2=17 SubAcuteAdmit=1.
IF ANY(ru, "01GH1", "81203") SausalCreekAdmit=1.
IF Agency="Crisis Response"  CrisisResponseAdmit=1.

AGGREGATE outfile = '//covenas/decisionsupport/temp/HotSpots.sav'
   /break = case 
   /HospitalAdmits = sum(HospitalAdmit)
   /PESAdmits = sum(PESAdmit)
   /CJAdmits = sum(CJAdmit)
   /SubAcuteAdmits = sum(SubAcuteAdmit)
   /SausalCreekAdmits = sum(SausalCreekAdmit)
   /CrisisResponseAdmits =sum(CrisisResponseAdmit).

 * SELECT IF (any(psmask2, 513, 550) OR level2=1) AND Program=1 AND epflag = "O".
 * AGGREGATE outfile =  '//covenas/decisionsupport/Coelho\temp\ProgOpenClientAgg.sav'
   /break = case
   /TeamProvname=max(Provname)
   /TeamCloseDate=max(TeamCloseDate).

GET FILE='//covenas/decisionsupport/dbsvc.sav'
   /KEEP case proced cost svcdate.

INSERT FILE= '//covenas/decisionsupport/modules\NoShow.sps'.

INSERT FILE ='//covenas/decisionsupport/modules/uncookedmonth.sps'.

SELECT IF svcdate GT datesum(uncookedmonth,-1,'years') 
and svcdate LT uncookedmonth.

SORT CASES by case.
MATCH FILES /table='//covenas/decisionsupport/temp/opentoprogcohort.sav' /file = * /by case.

SELECT IF cohort=1.

SELECT IF svcdate GT TeamCloseDate.
*Do we want the cost for all treatment or just hos pes cj acut sausal criss?..
AGGREGATE outfile = '//covenas/decisionsupport/temp\SvcCostProgramOnly.sav'
   /break = case
   /TotalCost = sum(cost).

get file='//covenas/decisionsupport/temp/programOnlyEpWork.sav'.

SELECT IF (any(psmask2, 513, 550) OR level2=1) AND Program=1 AND epflag = "O".

SORT CASES by case. 
match files /table= '//covenas/decisionsupport/temp/HotSpots.sav' /file=* /by case.
match files /table= '//covenas/decisionsupport/temp\SvcCostProgramOnly.sav' /file=* /by case.
match files /table= '//covenas/decisionsupport/clinfocg.sav' /file=* /by case.

DO IF HospitalAdmits=0 AND PESAdmits=0 AND CJAdmits=0 AND SubAcuteAdmits=0 AND 
SausalCreekAdmits=0 AND CrisisResponseAdmits=0 .
RECODE HospitalAdmits PESAdmits CJAdmits SubAcuteAdmits SausalCreekAdmits
CrisisResponseAdmits(0=sysmis).
END IF.

INSERT FILE='//covenas/decisionsupport/Modules/ClientName.sps'.
COMPUTE Age = ((xdate.tday($time) - xdate.tday(bday))/365.25).

COMPUTE HospSort=HospitalAdmits.
DO IF missing(HospitalAdmits).
COMPUTE HospSort=0.
END IF.

COMPUTE PESSort=PESAdmits.
DO IF missing(PESAdmits).
COMPUTE PESSort=0.
END IF.

COMPUTE CJSort=CJAdmits.
DO IF missing(CJAdmits).
COMPUTE CJSort=0.
END IF.

COMPUTE SubAcuteSort=SubAcuteAdmits.
DO IF missing(SubAcuteAdmits).
COMPUTE SubAcuteSort=0.
END IF.

COMPUTE SausalCreekSort=SausalCreekAdmits.
DO IF missing(SausalCreekAdmits).
COMPUTE SausalCreekSort=0.
END IF.

COMPUTE CrisisResponseSort=CrisisResponseAdmits.
DO IF missing(CrisisResponseAdmits).
COMPUTE CrisisResponseSort=0.
END IF.

SORT CASES BY HospitalAdmits(d) HospSort(d) PESAdmits(d) PESSort(d) CJAdmits(d) CJSort(d)
CrisisResponseAdmits(d) CrisisResponseSort(d) SausalCreekAdmits(d) SausalCreekSort(d) 
SubAcuteAdmits(d) SubAcuteSort(d).

SAVE OUTFILE='//covenas/decisionsupport/Coelho/temp/ASOCClientList.sav'
   /KEEP Agency ru provname case ClientName age sex opdate 
   HospitalAdmits PESAdmits CJAdmits SubAcuteAdmits SausalCreekAdmits CrisisResponseAdmits 
   HospSort PESSort CJSort SubAcuteSort SausalCreekSort CrisisResponseSort TeamClosedate
   TeamProvname psmask2 Level2 TotalCost.

*pushbreak.
*sqlTable = 'L1_ASOCClientList'.
*spsstable='//covenas/decisionsupport/Coelho/temp/ASOCClientList.sav'.
*pushbreak.



