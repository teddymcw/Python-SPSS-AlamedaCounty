DEFINE DBstartdate() date.dmy(1,7,2012) 

*older adult ru's.
!ENDDEFINE.
define PFkeepRU() "01EM1","01EI1","00621","81601","01087","01H11" 
!enddefine.


*admits DC open eps.
*explode out eps by month.
get file='//covenas/decisionsupport/epsCG.sav'  /keep ru case opdate closDate epflag primarytherapist primdx lastService .
insert file='//covenas/decisionsupport/modules/uncookedmonth.sps'.

*no ops in uncooked month and only eps that overlap > dbstartdate.
select if opdate lt UnCookedMonth and (Closdate ge DBstartdate or sysmis(closdate)).

*this select will limit the entire file here because it is always the base in matches.
select if any(ru,PFkeepRU).
sort cases by ru.
match files /file=* /table='//covenas/decisionsupport/rutable.sav' /by ru /keep kidsru agency provname ru program case opdate closDate epflag primarytherapist primdx lastService uncookedmonth.

recode program(sysmis=0).
select if program ne 1.

match files /file=* /keep ru provname agency case opdate closdate primdx primarytherapist lastservice uncookedmonth epflag.

sort cases by case epflag.

save outfile='//covenas/decisionsupport/temp/EPSsortedbycase.sav'.

*put closdate a month in thefuture so i can explode up to that date.
if sysmis(closdate) closdate=datesum($time,1,'months').
compute CountMonths=datediff($time,DBstartdate,"months").

*explode algorithm.
vector dateEp(50,f11).
compute dateEp1=date.dmy(0,xdate.month(opdate)+1, xdate.year(opdate)).
if dateep1 le datesum(datesum(DBstartdate,1,'months'),-1,'days') dateep1=datesum(datesum(DBstartdate,1,'months'),-1,'days').
compute #dateindex=1.
loop #count=1 to countmonths.
do if xdate.tday(date.dmy(0,xdate.month(dateep(#dateindex))+1,xdate.year(dateep(#dateindex)))) lt xdate.tday(closdate).
compute dateep(#dateindex+1) = datesum(dateep(#dateindex),1,"month","closest").
end if.
compute #dateindex=#dateindex+1.
end loop.
 * formats opdate closdate dateep1 to dateep50(moyr6).
formats dateep1 to dateep50(date11).

*.
VARSTOCASES
/make calendar from dateep1 to dateep50.

formats calendar(date11).

compute counter=1.
compute calendar =date.moyr(xdate.month(calendar), xdate.year(calendar)).

*take out fake future closdates.
if closdate gt $time closdate=$sysmis.

sort cases by ru case opdate calendar.
match files /file=* /by ru case opdate /first=admit.
sort cases by ru case closdate calendar.
match files /file=* /by ru case closdate /last=Discharges.

if missing(closdate) Discharges=$sysmis.
if xdate.month(opdate) ne xdate.month(calendar) admit=$sysmis.
if xdate.month(closdate) ne xdate.month(calendar) discharges=$sysmis.

insert file='//covenas/decisionsupport/meinzer/modules/calfiscalyear.sps'.

select if calendar lt uncookedmonth and calendar ge DBstartdate.

sort cases by ru.
match files /table='//covenas/decisionsupport/rutable.sav' /file=* /by ru .
sort cases by case.
match files /table='//covenas/spssdata/clinfo.sav' /file=* /by case.
rename vars primdx=dx.
sort cases by dx.
match files /table='//covenas/decisionsupport/dxtable.sav' /file=* /by dx .
sort cases by case calendar.
match files /table='//covenas/decisionsupport/MEdicalTable.sav' /file=* /by Case calendar /keep agency provname ethnic hispanic sex bday dx_grpDSM fiscalyear uncookedmonth
name ru case opdate closdate calendar counter admit discharges dx dx_descr calendar counter admit Discharges full inmedstable lastservice.
insert file='//covenas/decisionsupport/modules/ethnicity.sps'.

rename vars name=Clientname.
compute age=datedif(calendar,bday,'years').
aggregate outfile=* mode=ADDVARIABLES overwrite=yes
/break=ru case
/age=min(age).

sort cases by ru case fiscalyear.
match files /file=* /by ru case fiscalyear /first=RuFYCase1.

*What about missing LastService? should you definately show up or only after 90 days after op?.
if missing(lastservice) lastService=opdate.
 * compute check =datedif(uncookedmonth,lastService,'days') .
if missing(closdate) and datedif(uncookedmonth,lastService,'days') ge 90  noSvc90Client=1.

string RUProgram(a40).
compute RUProgram = concat(RU,"    ",rtrim(provname)).

do if missing(closdate).
compute FakeClose=date.dmy(1,1,3020).
else.
compute FakeClose=closdate.
end if.
formats fakeclose(date11).

save outfile='//covenas/decisionsupport/temp/ProgramFlow_admitDCOpenepsx.sav' /drop hispanic RaceEthnicityCode .

*pushbreak.
 *  get file='//covenas/decisionsupport/temp/ProgramFlow_admitDCOpenepsx.sav'.
 *   SAVE TRANSLATE /TYPE=ODBC
 /Connect ='DSN=Dashboarddatadev;UID=;APP=SPSS For'+
 ' Windows;WSID=HPMXL9360ZDD;DATABASE=Dashboarddatadev;Trusted_Connection=Yes'
 /table= 'ProgramFlow_admitDCOpeneps' /MAP/REPLACE.
*pushbreak.



*create bubble calculate  costs.

get file ='//covenas/decisionsupport/temp/EPSsortedbycase.sav'.
compute LOS=datediff(closdate,opdate,'days').
if epflag="O" TISNow=datediff($time,opdate,'days').

*determine increment for each ru and epflag.

aggregate outfile=* mode=addvariables
/break ru
/sdstay=sd(los)
/averagestay=mean(los)
/TISsdstay=sd(TISNow)
/TISaveragestay=mean(TISNow).

do if epflag='C'.
compute TISaveragestay=$sysmis.
else. 
compute averagestay=$sysmis.
end if.
exe. 
*for 7 categories devide by 8.
do if epflag='C'.
compute increment=((sdstay*2)+averagestay)/8.
else.
compute increment=((TISsdstay*2)+TISaveragestay)/8.
end if.

compute increment=rnd(increment).
string incrementthing lostext(a10).

do if increment lt 21.
compute incrementthing='Days'.
else if increment ge 21 and increment lt 365.
compute incrementthing='Months'.
compute increment=rnd(30*(rnd(increment/31.4))).
else.
compute incrementthing='Years'.
compute increment=365*rnd((increment/365)).
end if.

aggregate outfile='//covenas/decisionsupport/temp/incrementpf.sav'
/break ru epflag
/increment=max(increment)
/incrementthing=max(incrementthing).

format increment(f4.0).

*all select eps with increment information.
sort cases by ru case opdate.
save outfile='//covenas/decisionsupport/temp/incrementedUsedLater.sav'.
*used for what?.
*get file='//covenas/decisionsupport/temp/incrementedUsedLater.sav'.


*explode out increment.
vector epIncrement(7,f11).
compute epincrement1=opdate.
loop #count=2 to 7.
compute epIncrement(#count) =datesum(opdate,increment*(#count-1),'days').
end loop.
varstocases
/make epincrement from epincrement1 to epincrement7.
formats epincrement(date11).
if missing(closdate) closdate=datesum($time,2,'days').
select if epincrement le closdate.
if closdate gt $time closdate=$sysmis.
compute daysSinceOp= datediff(epincrement,opdate,'days').

*need catinc- the string a 1-2 b3-4 c d.
insert file='//covenas/decisionsupport/meinzer/modules/increment.sps'.

*could potentially select eps here and do the above part outside of loop.

*this shell is used ???.
aggregate outfile='//covenas/decisionsupport/temp/PFshellLOSTIS.sav'
/break ru 
/CatInc=max(catinc).

sort cases by ru case opdate epflag catinc.
*what is this for?.
save outfile='//covenas/decisionsupport/temp/incremented.sav'.

*/what is the point of this section.
get file='//covenas/decisionsupport/dbsvc.sav' /keep kidsru agency provname ru case opdate closdate proced svcdate cost calendar duration psmask2 MCsvcCat svcMode PrimaryTherapist staff proclong epflag.

insert file='//covenas/decisionsupport/modules/uncookedmonth.sps'.

select if opdate lt uncookedmonth and (closdate ge DBstartdate or sysmis(closdate) ) and svcdate lt uncookedmonth.

*select if svcdate ge datesum(DBstartdate,-1,'years') and svcdate lt uncookedmonth.
*check is it still f.
*also, consider doing a visit1 on days.

if any(svcMode,"05","10") AND MCSvcCat ne "F. Crisis Stabilization" Duration=1.
do if missing(closdate).
compute epflag='O'.
else.
compute  epflag='C'.
end if.
insert file='//covenas/decisionsupport/modules/noshow.sps'.

sort cases by ru epflag.
match files /file=* /table='//covenas/decisionsupport/temp/incrementpf.sav' /by ru epflag.
match files /file=* /table='//covenas/decisionsupport/meinzer/tables/units.sav' /by ru.
if units='day' duration=1.
format increment(f4.0).

save outfile='//covenas/decisionsupport/dbsvcprogramflowsvconly.sav'.

 * get file='//covenas/decisionsupport/dbsvcprogramflowsvconly.sav'.
compute daysSinceOp=datediff(svcdate,opdate,'days').

insert file='//covenas/decisionsupport/meinzer/modules/increment.sps'.

sort cases by proced.
match files /file=* /table='//covenas/decisionsupport/procedsma.sav' /by proced.
if mcsvccat='' mcsvccat='Z. Other'.

save outfile='//covenas/decisionsupport/temp/daysbetweenvisitslater.sav'.

aggregate outfile='//covenas/decisionsupport/temp/programflowMCSvccatwork.sav'
/break  agency provname ru mcsvccat epflag catinc  
/IncrementCost=sum(cost)
/IncrementTime=sum(duration).

aggregate outfile=*
/break  ru case opdate epflag catinc  
/IncrementCost=sum(cost)
/IncrementTime=sum(duration).

match files /file='//covenas/decisionsupport/temp/incremented.sav' /table=*  /by ru case opdate epflag catinc.

insert file='//covenas/decisionsupport/modules/uncookedmonth.sps'.

if missing(closdate) closdatex=1.
if closdatex=1 closdate=uncookedmonth.
compute epincrementClose=datesum(epincrement,increment-1,'days').
formats epincrementClose(date11).
select if epincrement lt uncookedmonth.
if closdate ge epincrementclose IncrementDays=increment.
*.
if closdate ge epincrement and closdate le epincrementclose IncrementDays=datediff(closdate,datesum(epincrement,-1,'days'),'days').
if substr(catinc,1,1) ='g' incrementdays= datediff(closdate,epincrement, 'days').
if closdatex=1  closdate=$sysmis.

sort cases by  ru case opdate  catinc epflag .
save outfile='//covenas/decisionsupport/temp/matchedmoneyincrementx.sav'.

get file='//covenas/decisionsupport/dbsvcprogramflowsvconly.sav' /keep case svcdate ru  cost duration .

 * aggregate outfile=*
/break ru
/bogus=min(duration).

sort cases by case .
CASESTOVARS
/id case .
exe.
*this file needs to limit rus.
match files /table=* /file='//covenas/decisionsupport/temp/EPSsortedbycase.sav' /by case.
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

temp.
select if (svcdate ge epincrement) and (svcdate le epincrementclose).
aggregate outfile='//covenas/decisionsupport/temp/programflowInc.sav'
/break  ru case opdate  catinc epflag
/SystemIncCost=sum(cost)
/SystemIncTime=sum(duration).

 * save outfile='//covenas/decisionsupport/temp/PF_SystemRUs.sav'.
 *   get file='//covenas/decisionsupport/temp/PF_SystemRUs.sav'.
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

*get file='//covenas/decisionsupport/temp/PF_SystemRUs.sav'.
*pushbreak.
*do not push.
 *     get file='//covenas/decisionsupport/temp/PF_SystemRUs.sav'.
 * SAVE TRANSLATE /TYPE=ODBC
 /Connect ='DSN=Dashboarddatadev;UID=;APP=SPSS For'+
 ' Windows;WSID=HPMXL9360ZDD;DATABASE=Dashboarddatadev;Trusted_Connection=Yes'
 /table= 'PF_SystemRUs' /MAP/REPLACE.
*pushbreak.


get file='//covenas/decisionsupport/temp/programflowMCSvccatwork.sav'.
string RUProgram(a40).
compute RUProgram = concat(RU,"    ",rtrim(provname)).

sort cases by ru.
match files /file=* /table='//covenas/decisionsupport/meinzer/tables/units.sav' /by ru.
if units='day' units='Days'.
if units='minutes' units='Hours'.

save outfile='//covenas/decisionsupport/temp/programflowMCSvccat.sav'.
*pushbreak.
 *     get file='//covenas/decisionsupport/temp/programflowMCSvccat.sav'.
 * SAVE TRANSLATE /TYPE=ODBC
 /Connect ='DSN=Dashboarddatadev;UID=;APP=SPSS For'+
 ' Windows;WSID=HPMXL9360ZDD;DATABASE=Dashboarddatadev;Trusted_Connection=Yes'
 /table= 'ProgramFlow_MCSvccat' /MAP/REPLACE.
*pushbreak.

get file='//covenas/decisionsupport/temp/incrementedUsedLater.sav'.
*This makes the shell.
compute dayssinceop=los.
if missing(los) dayssinceop=tisnow.
insert file='//covenas/decisionsupport/meinzer/modules/increment.sps'.

compute counter=1.

add files 
/file=*
/file='//covenas/decisionsupport/temp/PFshellLOSTIS.sav'.

aggregate outfile=* mode=addvariables
/break ru catinc
/numbCats=n.

select if not missing(case) or missing(case) and numbcats=1.

rename vars primdx=dx.
sort cases by dx.
match files /file=* /table='//covenas/decisionsupport/dxtable.sav' /by dx.

sort cases by case.
match files /file=* /table='//covenas/spssdata/clinfo.sav' /by case .
insert file='//covenas/decisionsupport/modules/ethnicity.sps'.
compute age=datedif(uncookedmonth,bday,'years').
sort cases by ru.

if missing(case) name='No One in Category'.

string RUProgram(a40).
compute RUProgram = concat(RU,"    ",rtrim(provname)).

do if missing(closdate).
compute FakeClose=date.dmy(1,1,3020).
else.
compute FakeClose=closdate.
end if.
formats fakeclose(date11).

sort cases by ru case opdate .
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

*why is this file so huge?  does it need to be.
get file='//covenas/decisionsupport/temp/daysbetweenvisitslater.sav'.

compute svcdate=xdate.date(Svcdate).
sort cases by case ru svcdate.
match files /file=* /by case ru svcdate /first=keep.
select if keep=1.
exe.
delete vars keep.

save outfile='//covenas/decisionsupport/temp/programflowMCSvccatworkx.sav'.


compute McSvccat='Visit of Any Type'.
exe.
add files 
/file=* 
/file='//covenas/decisionsupport/temp/programflowMCSvccatworkx.sav'.

sort cases by ru case  opdate mcsvccat svcdate.
do if case=lag(case) and ru=lag(ru) and MCSvcCat=lag(MCSvcCat) and opdate=lag(opdate).
compute DaysUntilNextVisit_ofSameType=datediff(svcdate,lag(svcdate),'days').
end if.

aggregate outfile=* mode=addvariables
/break ru case opdate mcsvccat 
/AveDifferenceDuringEp=mean(DaysUntilNextVisit_ofSameType).

compute AveDifferenceDuringEpx=rnd(AveDifferenceDuringEp).

string DaysBetwenVisits_text AveDifferenceDuringEp_text(a22).
compute DaysBetwenVisits_text=concat(ltrim(string(DaysUntilNextVisit_ofSameType,f9)),' Days').
compute AveDifferenceDuringEp_text=concat(ltrim(string(AveDifferenceDuringEp,f9)),' Days').
if DaysBetwenVisits_text='1 Days' DaysBetwenVisits_text = '1 Day'.
if AveDifferenceDuringEp_text='1 Days' AveDifferenceDuringEp_text = '1 Day'.

if missing(DaysUntilNextVisit_ofSameType) DaysBetwenVisits_text=''.
if missing(AveDifferenceDuringEp) AveDifferenceDuringEp_text=''.

if DaysUntilNextVisit_ofSameType gt 16 DaysBetwenVisits_text='Over 16 Days'.
if AveDifferenceDuringEp gt 16 AveDifferenceDuringEp_text='Over 16 Days'.

string RUProgram(a40).
compute RUProgram = concat(RU,"    ",rtrim(provname)).

save outfile ='//covenas/decisionsupport/temp/programflowDaysBetweenVisits.sav' /keep agency
provname epflag
ru RUProgram
svcdate
MCSvcCat
case
opdate
catInc
closdate
DaysUntilNextVisit_ofSameType
AveDifferenceDuringEp
AveDifferenceDuringEpx
DaysBetwenVisits_text
AveDifferenceDuringEp_text.

*pushbreak.
 *   get file ='//covenas/decisionsupport/temp/programflowDaysBetweenVisits.sav'.
 *     SAVE TRANSLATE /TYPE=ODBC
 /Connect ='DSN=Dashboarddatadev;UID=;APP=SPSS For'+
 ' Windows;WSID=HPMXL9360ZDD;DATABASE=Dashboarddatadev;Trusted_Connection=Yes'
 /table= 'ProgramFlow_programflowDaysBetweenVisits' /MAP/REPLACE.
*pushbreak.


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



get file='//covenas/decisionsupport/dbsvc.sav' /keep kidsru case mcsvccat svcdate ru provname cost duration epflag opdate.
 * select if kidsru=1.
 * select if index(substr(agency,1,1),"ABC",1) >0.
 * exe.
 * delete vars kidsru.
exe.
 * select if any(ru,PFkeepRU).
insert file='//covenas/decisionsupport/modules/uncookedmonth.sps'.

select if svcdate ge datesum(DBstartdate,-1,'years') and svcdate lt uncookedmonth.

save outfile='//covenas/decisionsupport/dbsvcprogramflowsvconlyBeforeVisit1andyearearlier.sav'.
get file='//covenas/decisionsupport/dbsvcprogramflowsvconlyBeforeVisit1andyearearlier.sav'  /keep ru svcdate case cost duration mcsvccat.

sort cases by case.
CASESTOVARS
/id case.
exe.

sort cases by case.
match files /table=* /file='//covenas/decisionsupport/temp/EPSsortedbycase.sav' /by case.

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
save outfile='//covenas/decisionsupport/temp/programflowfailspot.sav'.
 * compute test= datesum(closdate,1, 'years').
 * if (svcdate gt closdate and datedif(closdate,svcdate,'days') le 365 ) test=1.

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

save outfile='//covenas/decisionsupport/temp/work.sav'.

get file='//covenas/decisionsupport/temp/work.sav'.

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
