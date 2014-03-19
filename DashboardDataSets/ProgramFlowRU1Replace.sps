DEFINE DBstartdate() date.dmy(1,7,2012) 
!ENDDEFINE.
define PFkeepRU() "01EM1","01EI1","00621","81601","01087","01H11","01GH1"
!enddefine.
*older adult ru's.

get file='//covenas/decisionsupport/temp/EPSsortedbycase.sav'.
select if any(ru,PFkeepRU).
save outfile='//covenas/decisionsupport/temp/EPSsortedbycaseSelect.sav'.


get file='//covenas/decisionsupport/dbsvcprogramflowsvconly.sav' /keep case svcdate ru  cost duration .

 * aggregate outfile=*
/break ru
/bogus=min(duration).

sort cases by case .
CASESTOVARS
/id case .
exe.
*this file needs to limit rus.
match files /table=* /file='//covenas/decisionsupport/temp/EPSsortedbycaseSelect.sav' /by case.
exe.
*moved for speed.
 * sort cases by ru epflag.
 * match files /file=* /table='//covenas/decisionsupport/temp/incrementpf.sav' /by ru epflag.
string RUx(a6).
*string mcsvccatx(a ).
if missing(svcdate.1) svcdate.1=-99.
compute svcdatex=999999999999999.
compute durationx=9999999.
compute costx=99999999.
compute RUx='99'.
 * save outfile='//covenas/decisionsupport/temp/tempprogramflow.sav'.
sort variables by name.
VARSTOCASES
/make svcdate from svcdate.1 to svcdatex
/make duration from duration.1 to durationx
/make cost from cost.1 to costx
/make SystemRU from ru.1 to rux.

select if svcdate ne 999999999999999.
if svcdate=-99 svcdate=$sysmis.
exe.
sort cases by epflag.
exe.
sort cases by ru .

exe.
match files /file=* /table='//covenas/decisionsupport/temp/incrementpf.sav' /by ru epflag.
exe.
save outfile='//covenas/decisionsupport/meinzer/temp/yearbeforework.sav'.
match files /file=* /keep case epflag closdate increment incrementthing LastService PrimaryTherapist primdx ru SystemRU UnCookedMonth
svcdate duration cost opdate epflag SystemRU.
 * save outfile='//covenas/decisionsupport/temp/allsvcsINSelect.sav' /keep case epflag closdate
increment incrementthing
LastService
PrimaryTherapist
primdx
ru SystemRU
UnCookedMonth
svcdate
duration
cost
opdate epflag SystemRU.

 * get file='//covenas/decisionsupport/temp/allsvcsINSelect.sav'.

vector epIncrement(7,f11).
compute epincrement1=opdate.
loop #count=2 to 7.
compute epIncrement(#count) =datesum(opdate,increment*(#count-1),'days').
end loop.
varstocases
/make epincrement from epincrement1 to epincrement7.
formats epincrement(date11).
compute epincrementClose=datesum(epincrement,increment-1,'days').
formats epincrementClose(date11).

compute daysSinceOp= datediff(epincrement,opdate,'days').
insert file='//covenas/decisionsupport/meinzer/modules/increment.sps'.
*how to cap epincrement?.
if substr(catinc,1,1)='g' epincrementclose=closdate.
if missing(epincrementclose) epincrementclose=uncookedmonth.

*first point of loop break?.

*everything is still here.
*get the system treatement costs for select ru's.
temp.
select if (svcdate ge epincrement) and (svcdate le epincrementclose).
aggregate outfile='//covenas/decisionsupport/temp/programflowInc.sav'
/break  ru case opdate  catinc epflag
/SystemIncCost=sum(cost)
/SystemIncTime=sum(duration).

 * save outfile='//covenas/decisionsupport/temp/PF_SystemRUs.sav'.
 *   get file='//covenas/decisionsupport/temp/PF_SystemRUs.sav'.

*keep year before op.
select if svcdate lt epincrement and svcdate ge datesum(epincrement,-1,'years').

temp.
select if subst(catinc,1,1) = 'a'.
aggregate outfile='//covenas/decisionsupport/temp/workSystemCostsProgramFlowAtEntrance.sav'
/break  ru case opdate 
/EntranceSystemCostLastYear=sum(cost).

aggregate outfile=*
/break  ru case opdate  catinc epflag 
/SystemCostLastYear=sum(cost).

 * sort cases by ru case opdate .
 * match files /file=* /table='//covenas/decisionsupport/temp/workSystemCostsProgramFlowAtEntrance.sav' /by ru case opdate.

sort cases by  ru case opdate  catinc epflag .
match files /file='//covenas/decisionsupport/temp/matchedmoneyincrementx.sav' /table=*  /by  ru case opdate  catinc epflag .
select if any(ru,PFkeepRU).
sort cases by  ru case opdate  catinc epflag.
match files /file=* /table='//covenas/decisionsupport/temp/programflowInc.sav' /by   ru case opdate  catinc epflag.

recode IncrementCost IncrementTime SystemCostLastYear  SystemIncCost
SystemIncTime (sysmis=0).

do if missing(closdate).
compute FakeClose=date.dmy(1,1,3020).
else.
compute FakeClose=closdate.
end if.
formats fakeclose(date11).


 * do if substr(catinc,1,1) = 'g'.
 * compute xaxisincrement = number(substring(catinc,4,rindex(rtrim(catinc),' ')-index(catinc,' ')),f11).
 * ELSE.
 * compute xaxisincrement=number(substring(catinc,index(catinc,'-')+1,rindex(rtrim(catinc),' ')-index(catinc,'-')),f11).
 * end if.

compute xaxisincrement=dayssinceop+increment.


sort cases by ru. 
match files /file=* /table='//covenas/decisionsupport/rutable.sav' /by ru.

rename vars primdx=dx.
sort cases by dx.
match files /file=* /table='//covenas/decisionsupport/dxtable.sav' /by dx.

sort cases by case.
match files /file=* /table='//covenas/spssdata/clinfo.sav' /by case .
insert file='//covenas/decisionsupport/modules/ethnicity.sps'.
compute age=datedif(uncookedmonth,bday,'years').
sort cases by ru.
match files /file=* /table='//covenas/decisionsupport/rutable.sav' /by ru.
string RUProgram(a40).
compute RUProgram = concat(RU,"    ",rtrim(provname)).
*get file='//covenas/decisionsupport/temp/incrementedAllMatched.sav'.

recode  SystemCostLastYear(sysmis=0).
if SystemCostLastYear lt 1000 SystemCostLastYearBogus =1000.
compute SystemCostLastYearBogus=rnd(SystemCostLastYear/1000)*1000.
string SystemCostLabel(a33).
if SystemCostLastYear ge 0 SystemCostLabel='$0 - $499'.
if SystemCostLastYear ge 500 SystemCostLabel='$500 - $1,999'.
if SystemCostLastYear  ge 2000 SystemCostLabel='$2,000 - $4,999'.
if SystemCostLastYear ge 5000 SystemCostLabel='$5,000 - $9,999'.
if SystemCostLastYear ge 10000 SystemCostLabel='$10,000 or greater'.

sort cases by ru.
match files /file=* /table='//covenas/decisionsupport/meinzer/tables/units.sav' /by ru.
if units='day' units='Days'.
if units='minutes' units='Hours'.
string CaseOp(a33).
compute CaseOp=concat(ltrim(string(case,f33)),' ',string(opdate,date11)).
save outfile='//covenas/decisionsupport/temp/incrementedAllMatched.sav' /keep agency provname ru catinc xaxisincrement incrementthing
case name age bday ethnicity RUProgram units SystemCostLastYearBogus  SystemCostLastYearBogus
opdate closdate epflag PrimaryTherapist dx dx_descr dx_grpDSM dx_grpAdult LastService UnCookedMonth
epincrement epincrementClose IncrementDays SystemCostLastYear  SystemIncCost
SystemIncTime IncrementCost IncrementTime increment averagestay TISaveragestay FakeClose SystemCostLabel CaseOp.

*pushbreak.
 *  get file='//covenas/decisionsupport/temp/incrementedAllMatched.sav'.
 *     SAVE TRANSLATE /TYPE=ODBC
    /Connect ='DSN=Dashboarddatadev;UID=;APP=SPSS For'+
    ' Windows;WSID=HPMXL9360ZDD;DATABASE=Dashboarddatadev;Trusted_Connection=Yes'
 /table= 'ProgramFlow_BubbleInandSystemCost' /MAP/REPLACE.
*pushbreak.


get file='//covenas/decisionsupport/temp/incrementedAllMatched.sav'.

aggregate outfile='//covenas/decisionsupport/temp/totalcostinTreatment.sav'
/break ru case opdate 
/TotalCostInTX=sum(incrementcost)
/TotalDurationinTX=sum(incrementtime).

aggregate outfile=*
/break agency provname RUProgram ru catinc xaxisincrement epflag increment
/sumCost=sum(incrementcost)
/sumTime=sum(incrementTime)
/SystemCostLastYear=sum(SystemCostLastYear)
/SystemIncCost=sum(SystemIncCost)
/SystemIncTime=sum(SystemIncTime)
/days=sum(IncrementDays)
/clients=n.

COMPUTE CostPerClient=sumcost/(days/(increment)).
 * compute CostPerClient=((sumCost/days)/Clients)*increment.
compute TimePerClient=sumtime/(days/(increment)).
compute SystemCostLastYearperClient=((SystemCostLastYear/days)/Clients).
compute SystemIncCostperClient=((SystemIncCost/days)/Clients).
compute SystemIncTimeperClient=((SystemIncTime/days)/Clients).

sort cases by ru.
match files /file=* /table='//covenas/decisionsupport/meinzer/tables/units.sav' /by ru.
if units='day' units='Days'.
if units='minutes' units='Hours'.

save outfile='//covenas/decisionsupport/temp/AvePerClientProgramFlowx.sav'.
*pushbreak.
 *     get file='//covenas/decisionsupport/temp/AvePerClientProgramFlowx.sav'.
 *   SAVE TRANSLATE /TYPE=ODBC
 /Connect ='DSN=Dashboarddatadev;UID=;APP=SPSS For'+
 ' Windows;WSID=HPMXL9360ZDD;DATABASE=Dashboarddatadev;Trusted_Connection=Yes'
 /table= 'ProgramFlow_AvePerClientProgramFlow' /MAP/REPLACE.
*pushbreak.

get file='//covenas/decisionsupport/temp/shellToBeLimitedByRU.sav'.
select if any(ru,PFkeepRU).
match files /file=* /table='//covenas/decisionsupport/temp/workSystemCostsProgramFlowAtEntrance.sav' /by ru case opdate .
match files /file=* /table='//covenas/decisionsupport/temp/totalcostinTreatment.sav' /by ru case opdate .

recode EntranceSystemCostLastYear(sysmis=0).
if EntranceSystemCostLastYear lt 1000 EntranceSystemCostLastYear =1000.

*compute xaxisincrement=dayssinceop+increment.

do if substr(catinc,1,1) = 'g'.
compute xaxisincrement = number(substring(catinc,4,rindex(rtrim(catinc),' ')-index(catinc,' ')),f11)-1+increment.
ELSE.
compute xaxisincrement=number(substring(catinc,index(catinc,'-')+1,rindex(rtrim(catinc),' ')-index(catinc,'-')),f11).
end if.

save outfile='//covenas/decisionsupport/temp/programflowLOSTIS.sav' /keep agency ru RUProgram provname case name age bday ethnicity opdate increment TotalCostInTX TotalDurationinTX xaxisincrement
incrementthing catInc closdate epflag PrimaryTherapist dx dx_descr dx_grpDSM dx_grpAdult LastService UnCookedMonth LOS TISNow counter EntranceSystemCostLastYear.

*pushbreak.
 * get file ='//covenas/decisionsupport/temp/programflowLOSTIS.sav'.
 *   SAVE TRANSLATE /TYPE=ODBC
 /Connect ='DSN=Dashboarddatadev;UID=;APP=SPSS For'+
 ' Windows;WSID=HPMXL9360ZDD;DATABASE=Dashboarddatadev;Trusted_Connection=Yes'
 /table= 'ProgramFlow_LOSTIS' /MAP/REPLACE.
*pushbreak.


*this file is ep limited.

get file='//covenas/decisionsupport/meinzer/temp/yearbeforework.sav' /keep case 
closdate
epflag
PrimaryTherapist
primdx
ru
UnCookedMonth
svcdate
duration
cost
SystemRU
LastService
opdate.

*select if opdate ge dbstartdate.

sort cases by ru case opdate(d).
if lag(case)=case and lag(ru) = ru and lag(opdate) ne opdate nextop=lag(opdate).
formats nextop(date11).

aggregate outfile=* mode=addvariables overwrite=yes
/break ru case opdate
/nextop=max(nextop).

select if ru ne systemru.

 * if svcdate lt nextop test=1.
select if svcdate lt nextop or missing(nextop).

select if ((svcdate lt opdate and svcdate ge datesum(opdate,-60,'days')) or (svcdate gt closdate and svcdate le datesum(opdate,60,'days')) ).
*could be double counting.
aggregate outfile=*
/break ru case opdate closdate systemru
/minSvcDate=min(svcdate)
/maxSvcDate=max(svcdate).

if minSvcDate lt opdate PreRU=1.
if maxSvcDate gt closdate PostRU=1.

 * compute testpre=datedif(opdate,minsvcdate,'days').
 * compute testpost=datedif(maxsvcdate,closdate,'days').
rename vars ru =tempru systemru=ru.
sort cases by ru.
match files /file=* /table='//covenas/decisionsupport/rutable.sav'  /by ru.
rename vars  provname = systemProvname ru=SystemRU tempru=ru agency=SystemAgency.
sort cases by ru.
match files /file=* /table='//covenas/decisionsupport/rutable.sav' /by ru /keep provname agency ru case opdate closdate SystemRU systemProvname SystemAgency
minSvcDate
maxSvcDate
PreRU
PostRU.

string RUProgram(a40).
compute RUProgram = concat(RU,"    ",rtrim(provname)).
save outfile='//covenas/decisionsupport/meinzer/temp/rusPreandPostList.sav'.
*pushbreak.
 *   get file='//covenas/decisionsupport/meinzer/temp/rusPreandPostList.sav'.
 *     SAVE TRANSLATE /TYPE=ODBC
 /Connect ='DSN=Dashboarddatadev;UID=;APP=SPSS For'+
 ' Windows;WSID=HPMXL9360ZDD;DATABASE=Dashboarddatadev;Trusted_Connection=Yes'
 /table= 'ProgramFlow_rusPreandPostList' /MAP/REPLACE.
*pushbreak.


*whats the point.
get file='//covenas/decisionsupport/dbsvc.sav' /keep kidsru case mcsvccat svcdate ru provname cost duration epflag opdate.
exe.
 * select if any(ru,PFkeepRU).
insert file='//covenas/decisionsupport/modules/uncookedmonth.sps'.

select if svcdate ge datesum(DBstartdate,-1,'years') and svcdate lt uncookedmonth.

 * save outfile='//covenas/decisionsupport/dbsvcprogramflowsvconlyBeforeVisit1andyearearlier.sav'.
 * get file='//covenas/decisionsupport/dbsvcprogramflowsvconlyBeforeVisit1andyearearlier.sav'  /keep ru svcdate case cost duration mcsvccat.
match files /file=*  /keep ru svcdate case cost duration mcsvccat.
sort cases by case.
CASESTOVARS
/id case.
exe.

sort cases by case.
match files /table=* /file='//covenas/decisionsupport/temp/EPSsortedbycaseSelect.sav' /by case.

string RUx(a6).
string mcsvccatx(a35).
if missing(svcdate.1) svcdate.1=-99.
compute svcdatex=999999999999999.
compute durationx=9999999.
compute costx=99999999.
 * compute RUx='99'.

sort variables by name.
VARSTOCASES
/make svcdate from svcdate.1 to svcdatex
/make duration from duration.1 to durationx
/make cost from cost.1 to costx
/make SystemRU from ru.1 to rux
/make Mcsvccat from mcsvccat.1 to mcsvccatx.
*broke down here when kidru=1.
select if svcdate ne 999999999999999.
exe.
if svcdate=-99 svcdate=$sysmis.
exe.

insert file='//covenas/decisionsupport/modules/uncookedmonth.sps'.
 
*Match files /file=* /keep case mcsvccat   closdate epflag PrimaryTherapist primdx ru UnCookedMonth
svcdate duration cost SystemRU LastService opdate.
*zero out cost duration if condition is not met  and shape into a pre post file.
 * compute costx=cost.
 * compute durationx=duration.
if opdate lt dbstartdate fakeop=dbstartdate.
do if (uncookedmonth gt datesum(closdate,1, 'years')) and ((svcdate lt fakeop and svcdate ge datesum(fakeop,-1,'years')) or (svcdate gt closdate and svcdate le datesum(closdate,1,'years')) ).
compute costx=cost.
compute durationx=duration.
if svcdate lt fakeop prePost=-1.
if svcdate gt closdate prepost=1.
ELSE.
compute costx=0.
compute durationx=0.
end if.

recode costx durationx(sysmis=0).

aggregate outfile='//covenas/decisionsupport/temp/totalforprogramflowexpensivecheap.sav'
/break=ru case opdate closdate prepost
/cost=sum(costx)
/hr=sum(durationx).

select if (uncookedmonth gt datesum(closdate,1, 'years')) and ((svcdate lt fakeop and svcdate ge datesum(fakeop,-1,'years')) or (svcdate gt closdate and svcdate le datesum(closdate,1,'years')) ).
freq prepost.

aggregate outfile=*
/break case prepost ru opdate  closdate mcsvccat
/cost=sum(costx)
/hr=sum(durationx).

 * save outfile='//covenas/decisionsupport/temp/work.sav'.

 * get file='//covenas/decisionsupport/temp/work.sav'.

add files 
/file=*
/file='//covenas/decisionsupport/temp/totalforprogramflowexpensivecheap.sav'.
if mcsvccat='' mcsvccat='Total'.

do if prepost=-1.
compute PreCost=cost.
compute PreTime=hr.
else if prepost=1.
compute postCost=cost.
compute Posttime=hr.
end if.

recode PreCost
PreTime
postCost
Posttime (sysmis=0).

aggregate outfile='//covenas/decisionsupport/meinzer/temp/Programflow_PrePost.sav'
/break ru case opdate closdate mcsvccat
/PreCost=max(PreCost)
/PreTime=max(preTime)
/postCost=max(postCost)
/PostTime=max(postTime).

sort cases by ru.
match files /file=* /table='//covenas/decisionsupport/rutable.sav' /by ru /keep provname agency ru case opdate closdate mcsvccat 
PreCost PreTime postCost PostTime.

string RUProgram(a40).
compute RUProgram = concat(RU,"    ",rtrim(provname)).

string CostLabel(a33).
if PreCost ge 0 CostLabel='a. Low Cost ($0 - $4,999)'.
if PreCost ge 5000 CostLabel='b. Moderate Cost ($5,000 - $9,999)'.
if PreCost ge 10000 CostLabel='c. High Cost ($10,000 or greater)'.

aggregate outfile=* mode=addvariables overwrite=yes
/break ru case opdate
/CostLabel=max(CostLabel).

save outfile='//covenas/decisionsupport/meinzer/temp/Programflow_PrePost.sav'.
*pushbreak.
 *   get file='//covenas/decisionsupport/meinzer/temp/Programflow_PrePost.sav'.
 *     SAVE TRANSLATE /TYPE=ODBC
 /Connect ='DSN=Dashboarddatadev;UID=;APP=SPSS For'+
 ' Windows;WSID=HPMXL9360ZDD;DATABASE=Dashboarddatadev;Trusted_Connection=Yes'
 /table= 'ProgramFlow_Programflow_PrePost' /MAP/REPLACE.
*pushbreak.

insert file='//covenas/decisionsupport/meinzer/modules/RU1.sps'.

 * get file='//covenas/decisionsupport/temp/incrementedAllMatched.sav'.
 * begin program.
 * NI='ProgramFlow_BubbleInandSystemCost'
factor=1.
 * end program.
 * insert file='//covenas/decisionsupport/meinzer/modules/pushemanio.sps'.

 * get file='//covenas/decisionsupport/temp/AvePerClientProgramFlowx.sav'.
 * begin program.
 * NI='ProgramFlow_AvePerClientProgramFlow'
factor=1.
 * end program.
 * insert file='//covenas/decisionsupport/meinzer/modules/pushemanio.sps'.


 * get file ='//covenas/decisionsupport/temp/programflowLOSTIS.sav'.
 * begin program.
 * NI='ProgramFlow_LOSTIS'
factor=1.
 * end program.
 * insert file='//covenas/decisionsupport/meinzer/modules/pushemanio.sps'.


 * get file='//covenas/decisionsupport/meinzer/temp/rusPreandPostList.sav'.
 * begin program.
 * NI='ProgramFlow_rusPreandPostList'
factor=1.
 * end program.
 * insert file='//covenas/decisionsupport/meinzer/modules/pushemanio.sps'.


 * get file='//covenas/decisionsupport/meinzer/temp/Programflow_PrePost.sav'.
 * begin program.
 * NI='ProgramFlow_Programflow_PrePost'
factor=1.
 * end program.
 * insert file='//covenas/decisionsupport/meinzer/modules/pushemanio.sps'.
