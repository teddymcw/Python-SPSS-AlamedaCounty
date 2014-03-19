DEFINE DBStartDate() date.dmy(1,7,2011) !ENDDEFINE.

*this section creates hour and cost fy client and takes last monthly services out wide.

get file='//covenas/decisionsupport/dbsvc.sav' 
/keep agency provname ru case opdate closdate svcdate cost calendar duration staff LastService epflag PrimaryTherapist proclong proced.
select if not any (proced, 200,300,400,197).
insert file='//covenas/decisionsupport/modules\Uncookedmonth.sps'.

temp.
select if svcdate ge datesum(uncookedmonth,-3,'years').
save outfile='//covenas/decisionsupport/temp/3YearsofSvccm.sav'.

insert file='//covenas/decisionsupport/modules\Level2_RUselect.sps'.

if agency="TriCity Homeless                        " agency="Abode Services".

if agency = "TeleCare" AND xday.tday(opdate) lt YRMODA(2011,11,01) dropme=1.
select if missing(dropme).

select if opdate lt UnCookedMonth and (svcdate ge datesum(DBStartDate,-3,'months')).
save outfile='//covenas/decisionsupport/meinzer/temp/level2svcs.sav' /drop staff primarytherapist proclong.

*hours billed.
 * get file='//covenas/decisionsupport/meinzer/temp/level2svcs.sav'.

insert file='//covenas/decisionsupport/meinzer/modules/calfiscalyear.sps'.

aggregate outfile=* mode=ADDVARIABLES
   /break agency case fiscalyear
   /ClientFYHours=sum(duration)
   /ClientFYCosts=sum(cost).

aggregate outfile=* mode=ADDVARIABLES
   /break agency fiscalyear
   /FYHours=sum(duration)
   /FYCosts=sum(cost).

aggregate outfile='//covenas/decisionsupport/meinzer/temp/hoursbilledclientdetail.sav' 
   /break agency case calendar
   /monthcost=sum(cost)
   /MonthHours=sum(duration)
   /FYCosts=max(ClientFYCosts)
   /FYHours=max(ClientFYHours).

aggregate outfile=*
   /break= agency case calendar
   /svcdate=max(svcdate)
   /ClientMonthcost=sum(cost)
   /ClientMonthHours=sum(duration)
   /FYCosts=max(fycosts)
   /FYHours=max(fyhours).

aggregate outfile='//covenas/decisionsupport/meinzer/temp/hoursbilledTotalsnew.sav' 
   /break agency calendar
   /permonthcost=sum(ClientMonthcost)
   /MonthHours=sum(ClientMonthHours)
   /FYCosts=max(fycosts)
   /FYHours=max(fyhours)
   /MedianHoursPerClient=median(ClientMonthHours).

 * get file='//covenas/decisionsupport/meinzer/temp/hoursbilledTotalsnew.sav' .

match files /file=* /drop calendar  clientmonthcost ClientMonthHours fycosts fyhours.

CASESTOVARS
/id agency case .

sort cases by agency case.
save outfile='//covenas/decisionsupport/meinzer/temp/level2svcwide.sav'.

*eps without program.
*take programs out wide.
*match in wide programs to everything.
*drop down programs so each episode in a case is match with every program ep.
*the final result is client roster list.

get file='//covenas/decisionsupport/epsCG.sav'  /keep ru case opdate closDate staff.

match files /table='//covenas/decisionsupport/rutable.sav' /file=* /by ru /keep agency  ru case opdate closdate  program staff.

insert file='//covenas/decisionsupport/modules\Level2_RUselect.sps'.

*need to give telecare pru's a chance to show up to cover eps.
if agency = "TeleCare" AND xday.tday(opdate) lt YRMODA(2011,11,01) dropme=1.
select if missing(dropme).

 * select if xdate.tday(Closdate) ge yrmoda(2011,1,1) or sysmis(closdate).

insert file='//covenas/decisionsupport/modules\Uncookedmonth.sps'.

temp.
select if closdate gt datesum(uncookedmonth, -3,'years').
save outfile='//covenas/decisionsupport/temp/3yearsofEpsforLevel2.sav'.

*dates i'm not sure about because we want at least everyone on the dashboard, but when did level 2 start?.
compute bogus=1.
temp.
select if closdate ge dbstartdate or missing(closdate).
aggregate outfile='//covenas/decisionsupport/temp/AllLevel2clientsSinceDBStartdate.sav' 
/break case
/Keepme=max(bogus).

if agency="TriCity Homeless                        " agency="Abode Services".

select if opdate lt UnCookedMonth and (Closdate ge DBStartDate or sysmis(closdate)).

recode program(sysmis=0).

select if program=1.
exe.
match files /file=* /drop ru program.

save outfile='//covenas/decisionsupport/meinzer/temp/prulevel2list.sav'.

*use 99 so when i drop down i can delete that row.
sort cases by agency case.
CASESTOVARS
/id agency case .
compute clx=99.
compute ox=99.

*the order is import because i need clx and ox to end their variables.
sort variables by   name.

sort cases by agency  case .
save outfile='//covenas/decisionsupport/meinzer/temp/pruswide.sav'.

*evaluate all eps whether overlapping with any pru.
get file='//covenas/decisionsupport/epsCG.sav'  /keep ru case opdate closDate.

match files /table='//covenas/decisionsupport/rutable.sav' /file=* /by ru /keep agency  ru case opdate closdate  program.

insert file='//covenas/decisionsupport/modules\Level2_RUselect.sps'.
if agency = "TeleCare" AND xday.tday(opdate) lt YRMODA(2011,11,01) and program ne 1 dropme=1.
select if missing(dropme).

if agency="TriCity Homeless                        " agency="Abode Services".


insert file='//covenas/decisionsupport/modules\Uncookedmonth.sps'.
select if opdate lt UnCookedMonth and (Closdate ge DBStartDate or sysmis(closdate)).

recode program(sysmis=0).

sort cases by  agency case.
match files /table='//covenas/decisionsupport/meinzer/temp/pruswide.sav' /file=* /by agency case .
exe.
*keep missing rows with no program opdate, watch for this 9 again, it represents eps without programs.
recode opdate.1(sysmis=9).

VARSTOCASES
/make progOp from Opdate.1 to ox
/make progClosdate from closdate.1 to clx.
*delete the holding place.
select if progop ne 99.

if missing(closdate) closdate=datesum($time,5,'days').
if missing(progclosdate) and progop ne 9 progclosdate=datesum($time,5,'days').
if closdate ge progop and closdate le progclosdate RefConnect=1.
if opdate ge progop and opdate le progclosdate RefConnect=1.
if opdate le progop and closdate ge progclosdate RefConnect=1.
exe.
*is it a problem not to recode procop =9?.

*did an ep have a program.
aggregate outfile=* mode=ADDVARIABLES
   /break agency case opdate 
   /TeamWithPRU=max(RefConnect).
*did a pru have an ep.
aggregate outfile=* mode=ADDVARIABLES
   /break agency case progop 
   /PRUConnections=sum(RefConnect).

sort cases by case.
match files /table='//covenas/spssdata/clinfo.sav' /file=* /by case /keep agency ru case name agency opdate closdate  bday TeamWithPRU PRUConnections program RefConnect progop progclosdate .
sort cases by ru case opdate.
match files /table='//covenas/decisionsupport/epsCG.sav' /file=* /by ru case opdate /keep agency case name opdate closdate bday primdx TeamWithPRU PRUConnections program RefConnect progop progclosdate .

*What age? opdate.
compute Age = trunc((Xdate.tday(opdate) - xdate.tday(Bday)) /365.25).
formats age(f2).

if closdate lt $time  and program=0 LOS = trunc((xdate.tday(closDate) - xday.tday(opdate))/30).

insert file='//covenas/decisionsupport/modules/uncookedmonth.sps'.
if missing(closdate) and program=0 TIS = trunc((xdate.tday(Uncookedmonth) - xday.tday(opdate))/30).

save outfile='//covenas/decisionsupport/meinzer/temp/level2work.sav'.

*create client roster, a list of each month a client was open on team or in PRU only.
get file='//covenas/decisionsupport/meinzer/temp/level2work.sav'.

recode TeamWithPRU PRUConnections(sysmis=0).
exe.
temp.
select if TeamWithPRU ne 1 and program ne 1.
aggregate outfile='//covenas/decisionsupport/meinzer/temp/TeamOnly.sav'
   /break agency case name opdate closdate
   /TeamOnly=max(RefConnect).

temp.
select if program=1 AND PRUConnections le 1.
save outfile='//covenas/decisionsupport/meinzer/temp/ProgramOnly.sav'.

*get file to one pru referal per ep, only want yoru program op clos if ref.
if RefConnect=1 programopdate=progop.
if RefConnect=1  programclosdate=progclosdate.
aggregate outfile=*
   /break agency case name program opdate closdate age primdx los tis PRUConnections
   /ProgOp=max(programopdate)
/ProgClos=max(programclosdate).

formats progop  progclos (date11).
recode program(sysmis=0).
select if program=0 or PRUConnections le 1.

insert file='//covenas/decisionsupport/meinzer/modules/explodemonth.sps'.
exe.

do if program=1.
compute opdate=$sysmis.
compute closdate=$sysmis.
end if.
if closdate ge datesum($time,+1,'days') closdate=$sysmis.
if progclos ge datesum($time,+1,'days') progclos=$sysmis.

sort cases by agency case calendar.
match files /table='//covenas/decisionsupport/meinzer/temp/hoursbilledclientdetail.sav' /file=* /by agency case calendar.

if agency="TriCity Homeless                        " agency="Abode Services".

insert file='//covenas/decisionsupport/modules/uncookedmonth.sps'.
select if calendar lt uncookedmonth.
*recode monthcost MonthHours FYCosts FYHours (sysmis=0).

do if calendar lt datesum(uncookedmonth,-2,'months').
compute TIS=$sysmis.
end if.

save outfile='//covenas/decisionsupport/meinzer/temp/masterLevel2ClientRoster.sav'.

*pushbreak.
*sqlTable = 'Level2_ClientRoster'.
*spsstable='//covenas/decisionsupport/meinzer/temp/masterLevel2ClientRoster.sav'.
*pushbreak.



****Never open to team.  count per month.
get file='//covenas/decisionsupport/meinzer/temp/ProgramOnly.sav'.

match files /file=* /keep agency case opdate closdate.
if agency="TriCity Homeless                        " agency="Abode Services".

insert file='//covenas/decisionsupport/meinzer/modules/explodemonth.sps'.
insert file='//covenas/decisionsupport/modules/uncookedmonth.sps'.
select if calendar lt uncookedmonth.
sort cases by case.
match files /table='//covenas/spssdata/clinfo.sav'  /file=* /by case /keep case name agency opdate closdate calendar counter.

sort cases by agency case.
save outfile='//covenas/decisionsupport/meinzer/temp/ProgramOnlyCasesLevel2.sav'.

aggregate outfile=*
   /break=agency calendar
   /NeverOpenToTeam=sum(counter).

insert file='//covenas/decisionsupport/meinzer/modules/calFiscalYear.sps'.

sort cases by agency calendar fiscalyear.
save outfile='//covenas/decisionsupport/meinzer/temp/Level2permonthProgramOnly.sav'.

*pushbreak.
*sqlTable = 'Level2_ProgramOnly'.
*spsstable='//covenas/decisionsupport/meinzer/temp/Level2permonthProgramOnly.sav'.
*pushbreak.

*pushbreak.
*sqlTable = 'Level2_ProgramOnly_CaseList'.
*spsstable='//covenas/decisionsupport/meinzer/temp/ProgramOnlyCasesLevel2.sav'.
*pushbreak.


*************monthly open cases .
*create file with every month an ep existed, plus 2 before db startdate.
*****************************no svc in 90.
get file='//covenas/decisionsupport/epsCG.sav'  /keep ru case opdate closDate .

match files /table='//covenas/decisionsupport/rutable.sav' /file=* /by ru /keep agency  ru case opdate closdate  program.
insert file='//covenas/decisionsupport/modules\Level2_RUselect.sps'.
if agency = "TeleCare" AND xday.tday(opdate) lt YRMODA(2011,11,01) dropme=1.
select if missing(dropme).

if agency="TriCity Homeless                        " agency="Abode Services".

recode program(sysmis=0).
select if program=0.

insert file='//covenas/decisionsupport/modules\Uncookedmonth.sps'.
select if opdate lt UnCookedMonth and (Closdate ge DBStartDate or sysmis(closdate)).


insert file='//covenas/decisionsupport/meinzer/modules/explodemonth.sps'.
compute counter=1.

sort cases by agency case.
save outfile='//covenas/decisionsupport/meinzer/temp/Everymonthlevel2.sav'.

aggregate outfile=*
   /break=agency calendar
   /MonthlyOpenCases=sum(counter).

insert file='//covenas/decisionsupport/meinzer/modules/calfiscalyear.sps'.

sort cases by agency calendar fiscalyear.
save outfile='//covenas/decisionsupport/meinzer/temp/Level2MonthlyOpenCases.sav'.

*check if month had service in 90 days.
get file='//covenas/decisionsupport/meinzer/temp/Everymonthlevel2.sav'.
*start months after end of the month is 90 days from opdate.
select if datesum(calendar,1,'months') ge datesum(opdate,3,'months').

sort cases by agency case.
match files /table='//covenas/decisionsupport/meinzer/temp/level2svcwide.sav' /file=* /by agency case.

if missing(svcdate.1) svcdate.1=-99.
compute svce=999.
sort variables by   name.
VARSTOCASES
/make svcdate from svcdate.1 to svce.

select if svcdate ne 999.

recode svcdate(-99=sysmis).
if missing(svcdate) Nosvc90=1.

*does a month have a svc in 90 days.
if xdate.tday(datesum(calendar,1,'months'))-xdate.tday(svcdate) ge 90 or xdate.tday(datesum(calendar,1,'months'))-xdate.tday(svcdate) lt 0 Nosvc90=1.
recode nosvc90(sysmis=0).


aggregate outfile=*
   /break agency case calendar 
   /NoSvc90=min(nosvc90).

sort cases by case.
match files /table='//covenas/spssdata/clinfo.sav' /file=* /by case /keep case name nosvc90 calendar agency bday.

insert file='//covenas/decisionsupport/modules/uncookedmonth.sps'.

temp.
select if nosvc90=1.
select if calendar lt uncookedmonth.
save outfile='//covenas/decisionsupport/temp/noSVC90CaseList.sav'.

aggregate outfile='//covenas/decisionsupport/meinzer/temp/nosvc90Level2Clients.sav'
   /break agency calendar
   /ClientswithNo90SVCperMonth=sum(NoSvc90).

*****************************************.

*admits DCs.

get file='//covenas/decisionsupport/epsCG.sav'  /keep  ru case opdate closDate epflag .

insert file='//covenas/decisionsupport/modules\Level2_RUselect.sps'.

sort cases by ru.
match files /table='//covenas/decisionsupport/rutable.sav' /file=* /by ru /keep agency ru case opdate closdate epflag program.
if agency = "TeleCare" AND xday.tday(opdate) lt YRMODA(2011,11,01) dropme=1.
select if missing(dropme).

if agency="TriCity Homeless                        " agency="Abode Services".

recode program(sysmis=0).
select if program =0.


insert file='//covenas/decisionsupport/modules\Uncookedmonth.sps'.
select if opdate lt UnCookedMonth and (Closdate ge DBStartDate or sysmis(closdate)).
*this file assigns fy to created vars admit and discharge using calendar months.
insert file='//covenas/decisionsupport/meinzer/modules/admitdischarge.sps'.

compute calendarOpen = date.MOYR(xdate.month(opdate),xdate.year(opdate)).
compute calendarClose = date.MOYR(xdate.month(closdate),xdate.year(closdate)).
formats calendarOpen calendarClose(MOYR6).
compute counter=1.
rename vars admit=fiscalyear.
temp.
select if fiscalYear ne " ".
aggregate outfile='//covenas/decisionsupport/meinzer/temp/level2fiscaladmits.sav' 
	/break= fiscalyear agency 
	/FYAdmits=sum(counter).

rename vars fiscalyear = deletex.
rename vars discharge=fiscalyear.	
temp.
select if fiscalYear ne " ".
aggregate outfile='//covenas/decisionsupport/meinzer/temp/level2fiscalDischarge.sav'
	/break= fiscalyear agency
	/FYDischarges=sum(counter).

rename vars calendaropen=calendar.	
temp.
select if not missing(calendar).
aggregate outfile='//covenas/decisionsupport/meinzer/temp/level2Monthadmits.sav'
	/break= calendar agency 
	/MonthlyAdmits=sum(counter).

rename vars calendar=deletexx.	
rename vars calendarclose=calendar.	
temp.
select if not missing(calendar).
aggregate outfile='//covenas/decisionsupport/meinzer/temp/level2monthdischarge.sav'
	/break= calendar agency
	/MonthlyDischarges=sum(counter).


get file='//covenas/decisionsupport/rutable.sav' /keep agency  ru provname  program.
insert file='//covenas/decisionsupport/modules\Level2_RUselect.sps'.

recode program(sysmis=0).
select if program=0.

aggregate outfile=*
   /break agency 
   /program=max(program).
*this file adds months since dbstartdate wide, and drops down so that every row gets everymonth.
insert file='//covenas/decisionsupport/meinzer/modules/calshell.sps'.
select if not (agency = "TeleCare" AND xdate.tday(calendar) lt YRMODA(2011,11,01)).
insert file='//covenas/decisionsupport/modules\Uncookedmonth.sps'.
select if calendar lt UnCookedMonth.

sort cases by calendar agency.
match files /table='//covenas/decisionsupport/meinzer/temp/level2Monthadmits.sav' /file=* /by calendar agency.
match files /table='//covenas/decisionsupport/meinzer/temp/level2monthdischarge.sav' /file=* /by  calendar agency.

insert file='//covenas/decisionsupport/meinzer/modules/calfiscalyear.sps'.
sort cases by fiscalyear agency.
match files /table='//covenas/decisionsupport/meinzer/temp/level2fiscalDischarge.sav' /file=* /by fiscalyear agency.
match files /table='//covenas/decisionsupport/meinzer/temp/level2fiscaladmits.sav' /file=* /by fiscalyear agency.

select if calendar ge DBStartDate.
sort cases by agency fiscalyear calendar.

save outfile='//covenas/decisionsupport/meinzer/temp/level2work2.sav'.
get file='//covenas/decisionsupport/meinzer/temp/level2work2.sav'.

if agency="TriCity Homeless                        " agency="Abode Services".

sort cases by  agency calendar fiscalyear.
match files /table='//covenas/decisionsupport/meinzer/temp/Level2MonthlyOpenCases.sav' /file=* /by agency calendar fiscalyear.
sort cases by agency Calendar.
match files /table='//covenas/decisionsupport/meinzer/temp/nosvc90Level2Clients.sav' /file=* /by agency calendar.
match files /table='//covenas/decisionsupport/meinzer/temp/hoursbilledTotalsnew.sav' /file=* /by agency calendar.
match files /table='//covenas/decisionsupport/meinzer/temp/Level2permonthProgramOnly.sav' /file=* /by agency calendar.
*match files /table='//covenas/decisionsupport/meinzer/temp/l2programonlyclientcount.sav' /file=* /by agency calendar.

*cut out telecare months before nov.
select if not (agency = "TeleCare" AND xdate.tday(calendar) lt YRMODA(2011,11,01)).

if index(agency,'Abode Se') gt 0 TotalCapacity=60.
if index(agency,'BACS') gt 0 TotalCapacity=40.
if index(agency,'Hume') gt 0 TotalCapacity=50.
if index(agency,'Options') gt 0 TotalCapacity=450.
if index(agency,'Pathways') gt 0 TotalCapacity=70.
if index(agency,'Stars') gt 0 TotalCapacity=45.
if index(agency,'TeleCare') gt 0 TotalCapacity=50.

save outfile='//covenas/decisionsupport/meinzer/temp/Level2ProgramCaseLoadReport.sav'.

*pushbreak.
*sqlTable = 'Level2_ProgramCaseLoadReport'.
*spsstable='//covenas/decisionsupport/meinzer/temp/Level2ProgramCaseLoadReport.sav'. 
*pushbreak.


aggregate outfile=*
   /break FiscalYear agency
   /FYCosts=max(FYCosts)
   /FYHours=max(FYHours)
   /FYAdmits=Max(FYAdmits)
   /FYDischarges=max(FyDischarges).

recode FYCosts FYHours FYAdmits FYDischarges(sysmis=0).
select if FYCosts ne 0 and FYHours ne 0 and FYAdmits ne 0 and  FYDischarges ne 0.

save outfile='//covenas/decisionsupport/temp/Level2ProgCaseLoadFY.sav'.

*pushbreak.
*sqlTable = 'Level2_Level2ProgCaseLoadFY'.
*spsstable='//covenas/decisionsupport/temp/Level2ProgCaseLoadFY.sav'.
*pushbreak.

*pushbreak.
*sqlTable = 'Level2_NoService90ClientList'.
*spsstable='//covenas/decisionsupport/temp/noSVC90CaseList.sav'.
*pushbreak.



*this file still has uncooked svcs and is only 2 years of svcs.
get file='//covenas/decisionsupport/temp/3YearsofSvccm.sav'.

sort cases by case.
match files/table='//covenas/decisionsupport/temp/AllLevel2clientsSinceDBStartdate.sav' /file=* /by case.
select if keepme=1.
match files/table='//covenas/spssdata/clinfo.sav'//file=* /by case/drop sex .
rename vars name = ClientName.
sort cases by staff.
match files /table='//covenas/decisionsupport/staff.sav' /file=* /by staff.
rename vars Name = StaffName.

if agency="TriCity Homeless                        " agency="Abode Services".



save outfile='//covenas/decisionsupport/temp/Level2_Svcsx.sav' /keep ru case opdate agency provname StaffName proclong svcdate ClientName LastService.

 * get file='//covenas/decisionsupport/temp/3yearsofEpsforLevel2.sav'.

 * sort cases by case.
 * match files/table='//covenas/decisionsupport/temp/AllLevel2clientsSinceDBStartdate.sav' /file=* /by case.
 * select if keepme=1.
 * match files/table='//covenas/spssdata/clinfo.sav'//file=* /by case/drop sex .
 * rename vars name = ClientName.
 * sort cases by staff.
 * match files /table='//covenas/decisionsupport/staff.sav' /file=* /by staff.
 * rename vars Name = StaffName.

 * if agency="TriCity Homeless                        " agency="Abode Services".
*this is no longer being used.  we are using all epse for all ru's for three years.
*all epse 3 yeasr is made in the alleps syntax..
 * save outfile='//covenas/decisionsupport/temp/Level2Eps.sav'.

 * aggregate outfile='//covenas/decisionsupport/temp/Level2Eps.sav'
   /break=ClientName RU case opdate epflag PrimaryTherapist agency provname 
  	/closedate  = max(closdate)
   /LastService=max(LastService).


*pushbreak.
*sqlTable = 'AllSvc3Years'.
*spsstable='//covenas/decisionsupport/temp/Level2_Svcsx.sav'.
*pushbreak.

*pushbreak.
*sqlTable = 'Level2TeamOnly'.
*spsstable='//covenas/decisionsupport/meinzer/temp/Level2TeamOnly.sav'.
*pushbreak.

*do not push
*pushbreak.
*sqlTable = 'AllEps3Years'.
*spsstable='//covenas/decisionsupport/temp/Level2Eps.sav'.
*pushbreak.


