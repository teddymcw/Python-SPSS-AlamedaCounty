DEFINE DBstartdate() date.dmy(1,7,2012) 
!ENDDEFINE.


*admits DC open eps.
*explode out eps by month.
get file='//covenas/decisionsupport/epsCG.sav'  /keep ru case opdate closDate epflag primarytherapist primdx lastService .
insert file='//covenas/decisionsupport/modules/uncookedmonth.sps'.


*no ops in uncooked month and only eps that overlap > dbstartdate.
select if opdate lt UnCookedMonth and (Closdate ge DBstartdate or sysmis(closdate)).

*this select will limit the entire file here because it is always the base in matches.
 * select if any(ru,PFkeepRU).
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
* is added to the ep exploded shell below?.
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

*this shell is used in an add files to make a shell for limited number of ru eps.
aggregate outfile='//covenas/decisionsupport/temp/PFshellLOSTIS.sav'
/break ru 
/CatInc=max(catinc).

sort cases by ru case opdate epflag catinc.
*file used as the base for matching in services     needs to have everything.
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
match files /table='//covenas/decisionsupport/temp/incrementpf.sav' /file=* /by ru epflag.
match files /table='//covenas/decisionsupport/meinzer/tables/units.sav'  /file=* /by ru.
if units='day' duration=1.
format increment(f4.0).

save outfile='//covenas/decisionsupport/dbsvcprogramflowsvconly.sav'.

 * get file='//covenas/decisionsupport/dbsvcprogramflowsvconly.sav'.
compute daysSinceOp=datediff(svcdate,opdate,'days').

insert file='//covenas/decisionsupport/meinzer/modules/increment.sps'.

sort cases by proced.
match files /file=* /table='//covenas/decisionsupport/procedsma.sav' /by proced.
if mcsvccat='' mcsvccat='Z. Other'.

*this file has everything in it!.
save outfile='//covenas/decisionsupport/temp/daysbetweenvisitslater.sav'.

*this file used later to .
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

*this is all eps with increment info.
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
save outfile='//covenas/decisionsupport/temp/shellToBeLimitedByRU.sav'.

*this file is all services incremented    yowza!.
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

insert file='//covenas/decisionsupport/meinzer/modules/base.sps'.

 * get file='//covenas/decisionsupport/temp/ProgramFlow_admitDCOpenepsx.sav'.

 * begin program.
 * NI='ProgramFlow_admitDCOpeneps'
factor=1.
 * end program.
 * insert file='//covenas/decisionsupport/meinzer/modules/pushemanio.sps'.
*pushbreak.


 * get file='//covenas/decisionsupport/temp/programflowMCSvccat.sav'.

 * begin program.
 * NI='ProgramFlow_MCSvccat'
factor=1.
 * end program.
 * insert file='//covenas/decisionsupport/meinzer/modules/pushemanio.sps'.


 * get file ='//covenas/decisionsupport/temp/programflowDaysBetweenVisits.sav'.

 * begin program.
 * NI='ProgramFlow_programflowDaysBetweenVisits'
factor=1.
 * end program.
 * insert file='//covenas/decisionsupport/meinzer/modules/pushemanio.sps'.


