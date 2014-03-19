DEFINE DBstartdateLevel1() date.dmy(1,1,2003) !ENDDEFINE.

*The code below creates the tables for the matches below. 
*Please run this before running the code below.

GET FILE= '//covenas/spssdata/Temp\Episodes.sav'.

SORT CASES by ru.
MATCH FILES /table = '//covenas/decisionsupport/rutable.sav' /file = * /by ru
   /keep ru case opdate closdate psmask2 program.

SELECT IF any(psmask2, 513, 550).

RECODE program(sysmis=0).
SELECT IF program = 0.

SORT CASES by case opdate.
EXECUTE. 

DO IF case = lag(case).
IF xdate.tday(opdate) - xdate.tday(lag(closdate)) le 180 opdate = lag(opdate).
END IF.

AGGREGATE OUTFILE = '//covenas/decisionsupport/Coelho\temp\EarliestandLastMungedOpdate.sav'
   /break = case
   /EarliestOpdate=min(opdate)
   /LastMungedOpdate=max(opdate). 

* code starts here.

GET FILE ='//covenas/spssdata/Temp\Episodes.sav'.
INSERT File='//covenas/decisionsupport/modules/uncookedmonth.sps'.
SORT CASES by ru.

MATCH FILES /table='//covenas/spssdata/rutable.sav' /file =*/ by ru 
   /KEEP ru case opdate program epflag closdate lst_svc agency psmask2 provname uncookedmonth.

RECODE program(sysmis=0).

TEMPORARY.
SELECT IF (psmask2=513 AND program=0) OR (psmask2=550 AND program=0).
SAVE OUTFILE='//covenas/spssdata/temp\AgencySvcTeamAll.sav'
   /KEEP ru case provname agency opdate closdate epflag lst_svc uncookedmonth.

COMPUTE SvcTeamClient=1.

TEMPORARY.
SELECT IF(psmask2=513 AND epflag='O' AND program=0) 
OR (psmask2=550 AND epflag='O' and program=0).
AGGREGATE outfile ='//covenas/spssdata/temp\AgencySvcTeam.sav' 
   /break = 	ru case provname agency psmask2 uncookedmonth
	  /svcteamopdate=min(opdate).

COMPUTE SvcTeamClient=1.

TEMPORARY.
SELECT IF (psmask2=513 AND epflag='O' and program=0) 
OR (psmask2=550 AND epflag='O' and program=0).
AGGREGATE  outfile ='//covenas/spssdata/temp\SvcTeamList.sav' 
   /break = 	case 
   /SvcTeamClient=min(SvcTeamClient).

if psmask2=5 hospSvc=1.

TEMPORARY.
SELECT IF psmask2=5.
SAVE OUTFILE ='//covenas/spssdata/temp\hospEps.sav' 
   /KEEP ru case opdate closdate lst_svc Agency HospSvc uncookedmonth.

if ru='01016' PESSvc=1.

TEMPORARY.
SELECT IF ru='01016'.
SAVE OUTFILE ='//covenas/spssdata/temp\PESEps.sav' 
   /KEEP ru case opdate closdate lst_svc Agency PESSvc uncookedmonth.


if ru='81142' CJSvc=1.

TEMPORARY.
SELECT IF ru='81142'.
SAVE OUTFILE ='//covenas/spssdata/temp\CJEps.sav' 
   /KEEP ru case opdate closdate lst_svc Agency CJSvc uncookedmonth.

get file='//covenas/spssdata/temp\CJEps.sav'.

GET FILE ='//covenas/spssdata/temp\hospEps.sav'.
INSERT file='//covenas/decisionsupport/modules/uncookedmonth.sps'.
SELECT IF opdate ge DBstartdateLevel1.

SORT CASES by Case.
MATCH FILES /table='//covenas/spssdata/temp\SvcTeamList.sav' /file=*/by case.
SELECT IF SvcTeamClient=1.

IF opdate ge datesum(uncookedmonth,-10,'years') HospWithin10=1.
IF opdate ge datesum(uncookedmonth,-3,'years') HospWithin3=1.
IF opdate ge datesum(uncookedmonth,-1,'years') HospWithin1=1.

aggregate outfile='//covenas/spssdata/temp\SvcTeam_HospEps.sav' 
   /break = case
   /HospAdmitsLast10Years=sum(HospWithin10)
   /HospAdmitsLast3Years=sum(HospWithin3)
   /HospAdmitsLastYear=sum(HospWithin1).


GET file ='//covenas/spssdata/temp\PESEps.sav'.
SELECT IF opdate ge DBstartdateLevel1.


SORT CASES by Case.
MATCH FILES  /table='//covenas/spssdata/temp\SvcTeamList.sav' /file=*/by case.
SELECT IF SvcTeamClient=1.

IF opdate ge datesum(uncookedmonth,-10,'years') PESWithin10=1.
IF opdate ge datesum(uncookedmonth,-3,'years')  PESWithin3=1.
IF opdate ge datesum(uncookedmonth,-1,'years') PESWithin1=1.

AGGREGATE outfile='//covenas/spssdata/temp\SvcTeam_PESEps.sav' 
   /break = case
   /PESAdmitsLast10Years=sum(PESWithin10)
   /PESAdmitsLast3Years=sum(PESWithin3)
   /PESAdmitsLastYear=sum(PESWithin1).

GET file ='//covenas/spssdata/temp\CJEps.sav'.

SELECT IF opdate ge datesum(uncookedmonth,-3,'years'). 

SORT CASES by Case.
MATCH FILES /table='//covenas/spssdata/temp\SvcTeamList.sav' /file=*/by case.
SELECT IF SvcTeamClient=1.

IF opdate ge datesum(uncookedmonth,-3,'years') CJWithin3=1.
IF opdate ge datesum(uncookedmonth,-1,'years') CJWithin1=1.

AGGREGATE outfile='//covenas/spssdata/temp\SvcTeam_CJEps.sav' 
   /break = case
   /CJAdmitsLast3Years=sum(CJWithin3)
   /CJAdmitsLastYear=sum(CJWithin1).

*get file='//covenas/spssdata/temp\SvcTeam_CJEps.sav'.

 * ADD FILES
   /FILE='//covenas/spssdata/services12_qtr2.sav'
   /FILE='//covenas/spssdata/services12_qtr3.sav'
   /FILE='//covenas/spssdata/services12_qtr4.sav'
   /FILE='//covenas/spssdata/services13_qtr1.sav'
   /FILE='//covenas/spssdata/services13_qtr2.sav'
   /FILE='//covenas/spssdata/services13_qtr3.sav'
	  /KEEP ru case svcdate proced hours minute grpsize staff co_staff cs_hours cs_mnts cost.
***Have Chet to Emanioize this portion of the svcdate selection.  Make dynamic based on uncooked month.!!!.

GET FILE='//covenas/decisionsupport/dbsvc.sav'
   /KEEP ru case svcdate proced staff duration cost.

INSERT FILE= '//covenas/decisionsupport/modules\NoShow.sps'.

INSERT FILE ='//covenas/decisionsupport/modules/uncookedmonth.sps'.
SELECT IF svcdate GT datesum(uncookedmonth,-18,'months') 
and svcdate LT uncookedmonth.

SAVE OUTFILE='//covenas/decisionsupport/temp/dbsvc1andhalfyears.sav'.

SORT CASES by ru.
MATCH FILES /table='//covenas/decisionsupport/RuTable.sav'/file=*/by ru
   /KEEP ru case svcdate staff psmask2 agency duration provname cost uncookedmonth.

AGGREGATE outfile=*mode=addvariables 
   /break =ru case 
   /lastsvc=max(svcdate).

SELECT IF svcdate ge datesum(uncookedmonth,-1,'years').

SORT CASES by Case.
MATCH FILES /table='//covenas/spssdata/temp\SvcTeamList.sav'/file=*/by case.
SELECT IF SvcTeamClient=1.

INSERT FILE='//covenas/decisionsupport/modules\CalSvcdate.sps'.

SORT CASES by case calendar.
MATCH FILES /table='//covenas/decisionsupport/MedicalTable.sav'/file=*/by case calendar
   /KEEP ru case psmask2 svcdate duration calendar 
   agency provname cost InMedsTable full lastsvc staff.

SORT CASES by staff.
MATCH FILES /table='//covenas/spssdata/staff.sav' /file=* /by staff.
*freq position.

RENAME VARIABLES name=StaffName.

RECODE full(sysmis=0).
if InMedsTable=1 and full=1 MCCost=cost.
if InMedsTable=1 AND full=0 AND psmask2=5 MCCost=Cost.
if InMedsTable=1 AND full=0 AND any(ru,"01GH1", "81203", "01016") MCCost=cost.

SAVE OUTFILE='//covenas/spssdata/SvcTeam\SvcTeamCost_year_Work.sav'.

GET FILE='//covenas/spssdata/SvcTeam\SvcTeamCost_year_Work.sav'.
INSERT file='//covenas/decisionsupport/modules/staffmask.sps'.
IF doc=1 medshours=duration.
 * IF any(Position,1,2,3) medsHours=duration.
IF medsHours gt 0 duration=0.
***investigate lastsvc. why in this agg??? appeared in the earlier work???.
AGGREGATE outfile='//covenas/spssdata/SvcTeam\SvcTeamCost_CaseAgg.sav'
   /break=ru case provname agency lastsvc
   /TotSvcTeamHrs=sum(duration)
   /TotMedsHours=sum(MedsHours)
   /TotSvcTeamCost=sum(cost).

GET file ='//covenas/spssdata/temp\AgencySvcTeam.sav'.
MATCH FILES /table='//covenas/spssdata/SvcTeam\SvcTeamCost_CaseAgg.sav' /file=* /by ru case provname agency.

SORT CASES by case.
MATCH FILES /table='//covenas/spssdata/LastMedsINSYST.sav' /file=* /by case.
MATCH FILES /table='//covenas/spssdata/temp\SvcTeam_HospEps.sav' /file=* /by case.
MATCH FILES /table='//covenas/spssdata/temp\SvcTeam_PESEps.sav' /file=* /by case.
MATCH FILES /table='//covenas/spssdata/temp\SvcTeam_CJEps.sav' /file=* /by case.
MATCH FILES /table='//covenas/spssdata/clinfocg.sav' /file=* /by case.
MATCH FILES /table='//covenas/decisionsupport/Coelho\temp\EarliestandLastMungedOpdate.sav' /file=* /by case.
EXECUTE.

COMPUTE LoS = datedif($time,SvcTeamopdate,'years').

COMPUTE LoSMunged = datedif($time,lastmungedopdate,'years').

FORMATS LoS LoSMunged(f4.1).

COMPUTE age=datedif($time,bday,'years').
FORMATS age(f2).
*freq LastMedsInsyst.
*Freq Age.
*freq provname.

RENAME VARIABLES LoS =CurrentEpisodeInYears.
RENAME VARIABLES LoSMunged = CurrentLevel1EngagementInYears.
***Ask about SvcTeamCMHrsLastYear. Seems like SvcTeams do more than Case managment.
RENAME VARIABLES TotSvcTeamHrs =SvcTeamCMHrsLastYear.
RENAME VARIABLES TotMedsHours=SvcTeamMedsHrsLastYear.
RENAME VARIABLES TotSvcTeamCost =SvcTeamCostLastYear.
RENAME VARIABLES earliestopdate=Level1StartDate.
SORT CASES by agency provname case.
exe.

STRING lname(a15).
COMPUTE Lname=substr(name,1,15).

STRING fname(a15).
COMPUTE Fname=substr(name,16,30).

STRING ClientName(a30).
COMPUTE ClientName=concat(rtrim(fname), " ",ltrim(lname)).

COMPUTE HospSort=HospAdmitsLastYear.
DO IF missing(HospAdmitsLastYear).
COMPUTE HospSort=0.
END IF.

COMPUTE PESSort=PESAdmitsLastYear.
DO IF missing(PESAdmitsLastYear).
COMPUTE PESSort=0.
END IF.

COMPUTE CJSort=CJAdmitsLastYear.
DO IF missing(CJAdmitsLastYear).
COMPUTE CJSort=0.
END IF.

FORMATS HospSort PESSort CJSort CurrentEpisodeInYears CurrentLevel1EngagementInYears
SvcTeamMedsHrsLastYear SvcTeamCMHrsLastYear HospAdmitsLastYear PESAdmitsLastYear
CJAdmitsLastYear HospAdmitsLast3Years PESAdmitsLast3Years CJAdmitsLast3Years
HospAdmitsLast10Years PESAdmitsLast10Years(F8.0).

SAVE OUTFILE ='//covenas/spssdata/SvcTeam\L1_Outfile.sav'
   /keep agency provname case ClientName age Level1StartDate SvcTeamOpdate lastsvc 
   CurrentEpisodeInYears CurrentLevel1EngagementInYears SvcTeamMedsHrsLastYear 
   SvcTeamCMHrsLastYear HospAdmitsLastYear HospSort PESAdmitsLastYear PESSort 
   CJAdmitsLastYear CJSort HospAdmitsLast3Years PESAdmitsLast3Years 
   CJAdmitsLast3Years HospAdmitsLast10Years PESAdmitsLast10Years LastMedsINSYST 
   psmask2.


*pushbreak.
*sqlTable = 'L1_ClientUtilization'.
*spsstable='//covenas/spssdata/SvcTeam\L1_Outfile.sav'.
*pushbreak.



 * get file ='//covenas/spssdata/Temp\Episodes.sav'.
 * get file ='//covenas/spssdata/temp\hospEps.sav'.
 * get file='//covenas/spssdata/temp\SvcTeamList.sav'.
 * get file='//covenas/spssdata/SvcTeam\SvcTeamCost_year_Work.sav'.
 * get file='//covenas/spssdata/clinfocg.sav'.
 * get file='//covenas/spssdata/temp\earliestandlastmungedopdate.sav'.

 * GET file='//covenas/spssdata/SvcTeam\L1_Outfile.sav'.

 * TEMPORARY.
 * SELECT IF psmask2=550.
 * SAVE TRANSLATE OUTFILE='//covenas/decisionsupport/Coelho/ASOC/Level 1 Utilization History/LevOne_Utilization_ClientDetail_Sep13_FSP.xls'
  /TYPE=XLS /VERSION=8 /MAP /REPLACE /FIELDNAMES
  /CELLS=VALUES .

 * TEMPORARY.
 * SELECT IF psmask2=513.
 * SAVE TRANSLATE OUTFILE='//covenas/decisionsupport/Coelho/ASOC/Level 1 Utilization History/LevOne_Utilization_ClientDetail_Sep13_SVCTEAM.xls'
  /TYPE=XLS /VERSION=8 /MAP /REPLACE /FIELDNAMES
  /CELLS=VALUES.


 * get file ='//covenas/spssdata/Temp\Episodes.sav'.
 * get file ='//covenas/spssdata/temp\hospEps.sav'.
 * get file='//covenas/spssdata/temp\SvcTeamList.sav'.
 * get file='//covenas/spssdata/SvcTeam\SvcTeamCost_year_Work.sav'.
 * get file='//covenas/spssdata/clinfocg.sav'.
 * get file='//covenas/decisionsupport/coelho\temp\earliestandlastmungedopdate.sav'.
