SAVE TRANSLATE OUTFILE='K:\temp\rulist.csv'
  /TYPE=CSV
  /ENCODING='Locale'
  /MAP
  /REPLACE
/keep ru
  /FIELDNAMES 
  /CELLS=VALUES.

begin program.
  
import csv, os, re
ruList=[]
with open('k:/temp/rulist.csv','rb') as f:
    reader=csv.reader(f)
    next(reader)
    for row in reader:
        row=''.join(row)
        ruList.append(row)

translate='REPLACE'
count=0
pushList=[]
for l in ruList:
    while count < 2:
        if count > 1:
            translate='APPEND'
        syntax="""
*pushbreak.
 * get file='//covenas/decisionsupport/temp/ProgramFlow_admitDCOpenepsx%s.sav'.
 * SAVE TRANSLATE /TYPE=ODBC
/Connect ='DSN=Dashboarddatadev;UID=;APP=SPSS For'+
' Windows;WSID=HPMXL9360ZDD;DATABASE=Dashboarddatadev;Trusted_Connection=Yes'
/table= 'ProgramFlow_admitDCOpeneps' /MAP/%s.
*pushbreak.
 * get file='//covenas/decisionsupport/temp/incrementedAllMatched%s.sav'.
 * SAVE TRANSLATE /TYPE=ODBC
/Connect ='DSN=Dashboarddatadev;UID=;APP=SPSS For'+
' Windows;WSID=HPMXL9360ZDD;DATABASE=Dashboarddatadev;Trusted_Connection=Yes'
/table= 'ProgramFlow_BubbleInandSystemCost' /MAP/%s.
*pushbreak.
 * get file='//covenas/decisionsupport/temp/AvePerClientProgramFlowx%s.sav'.
 * SAVE TRANSLATE /TYPE=ODBC
/Connect ='DSN=Dashboarddatadev;UID=;APP=SPSS For'+
' Windows;WSID=HPMXL9360ZDD;DATABASE=Dashboarddatadev;Trusted_Connection=Yes'
/table= 'ProgramFlow_AvePerClientProgramFlow' /MAP/%s.
*pushbreak.
 * get file='//covenas/decisionsupport/temp/programflowMCSvccat%s.sav'.
 * SAVE TRANSLATE /TYPE=ODBC
/Connect ='DSN=Dashboarddatadev;UID=;APP=SPSS For'+
' Windows;WSID=HPMXL9360ZDD;DATABASE=Dashboarddatadev;Trusted_Connection=Yes'
/table= 'ProgramFlow_MCSvccat' /MAP/%s.
*pushbreak.
 * get file ='//covenas/decisionsupport/temp/programflowLOSTIS%s.sav'.
 * SAVE TRANSLATE /TYPE=ODBC
/Connect ='DSN=Dashboarddatadev;UID=;APP=SPSS For'+
' Windows;WSID=HPMXL9360ZDD;DATABASE=Dashboarddatadev;Trusted_Connection=Yes'
/table= 'ProgramFlow_LOSTIS' /MAP/%s.
*pushbreak.
 * get file ='//covenas/decisionsupport/temp/programflowDaysBetweenVisits%s.sav'.
 * SAVE TRANSLATE /TYPE=ODBC
/Connect ='DSN=Dashboarddatadev;UID=;APP=SPSS For'+
' Windows;WSID=HPMXL9360ZDD;DATABASE=Dashboarddatadev;Trusted_Connection=Yes'
/table= 'ProgramFlow_programflowDaysBetweenVisits' /MAP/%s.
*pushbreak.
 * get file='//covenas/decisionsupport/meinzer/temp/Programflow_PrePost%s.sav'.
 * SAVE TRANSLATE /TYPE=ODBC
/Connect ='DSN=Dashboarddatadev;UID=;APP=SPSS For'+
' Windows;WSID=HPMXL9360ZDD;DATABASE=Dashboarddatadev;Trusted_Connection=Yes'
/table= 'ProgramFlow_Programflow_PrePost' /MAP/%s.
*pushbreak.
 * get file='//covenas/decisionsupport/meinzer/temp/rusPreandPostList%s.sav'.
 * SAVE TRANSLATE /TYPE=ODBC
/Connect ='DSN=Dashboarddatadev;UID=;APP=SPSS For'+
' Windows;WSID=HPMXL9360ZDD;DATABASE=Dashboarddatadev;Trusted_Connection=Yes'
/table= 'ProgramFlow_rusPreandPostList' /MAP/%s.
*pushbreak.
""" % (l,translate,l,translate,l,translate,l,translate,l,translate,l,translate,l,translate,l,translate)
        pushList.append(syntax)
        count=count+1
import pdb
with open('k:/temp/programpush.sps','w') as programflow:
        for item in pushList:
            programflow.write(item+'\n')
#needs other push files created

primaryFolder='k:/temp/'
DB=os.path.splitext('programpush.sps')[0]
line1='\ncompute DBcreateDate=$time.'
line2='\nformat dbcreatedate (datetime23).\n'
list=[]
list2=[]
file=primaryFolder+"%s.sps" % DB
file2="//covenas/decisionsupport/meinzer/production/push/%spush.sps" % DB
file3="//covenas/decisionsupport/meinzer/%s.sps" % DB
print file
#pdb.set_trace()
with open(file, "rb") as f: 
    code=f.read()
    if 'DASHBOARDDATA' in code.upper():
        results=re.split('pushbreak\\.',code,flags=re.M)
        for i in results:
            if 'TYPE=ODBC' in i.upper() and 'GET DATA' not in i.upper() and 'MATCH F' not in i.upper() :
             if 'OLD PUSH' in i.upper() or 'DO NOT PUSH' in i.upper():
               print 'the file ', file, '\ndid not convert\n',  i.replace('\r\n',' ')
             else:  
               i=i.lstrip('*')
               i.replace('\r\n',' ')
               list.append(i)
        with open(file3,'w') as test:
            for item in list:
              test.write(item)
        with open(file3,'r') as makelist:
             for itemx in makelist:
               itemx=itemx.lstrip('*')
               list2.append(itemx)
        with open(file2,'w') as makesyntax:
            for item2 in list2:
                  item3=item2.lstrip()
                  item3=item3.replace('\r\n','\n')
                  item3=item3.lstrip('*')
                  item3=item3.lstrip(' ')
                  if item3.upper().startswith('GET'):
                     item3='\n'+item3+line1+line2
                     makesyntax.write(item3)
                  else:
                     makesyntax.write(item3)
    else:
        print 'no push found in ', file

DBname=DB+'push'
DBname2=DBname+"P"
file="//covenas/decisionsupport/meinzer/production/push/%s.sps" % DBname
file2="//covenas/decisionsupport/meinzer/production/pushproduction/%s.sps" % DBname2
print file, file2
with open(file,"r") as checkforDashFile:
    DashCheck=checkforDashFile.read()
    if 'DASHBOARD' in DashCheck.upper():
        with open(file, "r") as f: 
            c=f.readlines()   
        with open(file2, 'w') as ts:
            for item in c:
               itemchange=re.compile(re.escape('dashboarddatadev'),re.IGNORECASE)
               itemswitch=itemchange.sub('DashboardData',item)
               ts.write(itemswitch)

pushList=[]
count=0
for l in ruList:
    while count < 2:
        syntax="""
 DEFINE DBstartdate() date.dmy(1,7,2012) !ENDDEFINE.
 * define PFkeepRU() '81441','81442','88036','01101','01D81','01E81','01GF1','01ES1','01E31','768001','768002','768003','768004','768005','768006','768007','76800P' !ENDDEFINE.
define PFkeepRU() '%s'.
select if ru=PFkeepRU.
*admits DC open eps.
*explode out eps by month line 25.
get file='//covenas/decisionsupport/epsCG.sav'  /keep ru case opdate closDate epflag primarytherapist primdx lastService .
insert file='//covenas/decisionsupport/modules/uncookedmonth.sps'.

select if opdate lt UnCookedMonth and (Closdate ge DBstartdate or sysmis(closdate)).

recode program(sysmis=0).
select if program ne 1.
match files /file=* /keep ru provname agency case opdate closdate primdx primarytherapist lastservice uncookedmonth epflag.
sort cases by case epflag.
save outfile='//covenas/decisionsupport/temp/programflowEPSsortedbycase.sav'.

if sysmis(closdate) closdate=datesum($time,1,'months').
compute CountMonths=datediff($time,DBstartdate,"months").

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

VARSTOCASES
/make calendar from dateep1 to dateep50.

formats calendar(date11).

compute counter=1.
compute calendar =date.moyr(xdate.month(calendar), xdate.year(calendar)).

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
match files /file=* /table='//covenas/decisionsupport/rutable.sav' /by ru .
sort cases by case.
match files /file=* /table='//covenas/spssdata/clinfo.sav' /by case.
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
save outfile='//covenas/decisionsupport/temp/programflownosvc.sav'.
 * get file='//covenas/decisionsupport/temp/programflownosvc.sav'.

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


save outfile='//covenas/decisionsupport/temp/ProgramFlow_admitDCOpenepsx%s.sav' /drop hispanic RaceEthnicityCode .

*create bubble calculate  costs.

get file ='//covenas/decisionsupport/temp/programflowEPSsortedbycase.sav'.
compute LOS=datediff(closdate,opdate,'days').
if epflag="O" TISNow=datediff($time,opdate,'days').

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

sort cases by ru case opdate.
save outfile='//covenas/decisionsupport/temp/incrementedUsedLater.sav'.
 *   get file='//covenas/decisionsupport/temp/incrementedUsedLater.sav'.

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

insert file='//covenas/decisionsupport/meinzer/modules/increment.sps'.


aggregate outfile='//covenas/decisionsupport/temp/PFshellLOSTIS.sav'
/break ru 
/CatInc=max(catinc).

sort cases by ru case opdate epflag catinc.
save outfile='//covenas/decisionsupport/temp/incremented.sav'.

 *   get file='//covenas/decisionsupport/temp/incremented1.sav'.
 * aggregate outfile=*
/break ru catinc
/daysSinceOp=max(daysSinceOp).

get file='//covenas/decisionsupport/dbsvc.sav' /keep kidsru agency provname ru case opdate closdate proced svcdate cost calendar duration psmask2 MCsvcCat svcMode PrimaryTherapist staff proclong epflag.
 * select if kidsru=1.
 * exe.
 * select if index(substr(agency,1,1),"ABC",1) >0.
 * delete vars kidsru.
exe.
 * select if any(ru,PFkeepRU).
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

save outfile='//covenas/decisionsupport/temp/daysbetweenvisitswork.sav'.

 * get file='//covenas/decisionsupport/temp/daysbetweenvisitswork.sav'.

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
match files /table=* /file='//covenas/decisionsupport/temp/programflowEPSsortedbycase.sav' /by case.
exe.
*moved for speed.
 * sort cases by ru epflag.
 * match files /file=* /table='//covenas/decisionsupport/temp/incrementpf.sav' /by ru epflag.
string RUx(a6).
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
*this file only used next.
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

 save outfile='//covenas/decisionsupport/temp/PF_SystemRUs%s.sav'.
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
save outfile='//covenas/decisionsupport/temp/incrementedAllMatched%s.sav' /keep agency provname ru catinc xaxisincrement incrementthing
case name age bday ethnicity RUProgram units SystemCostLastYearBogus  SystemCostLastYearBogus
opdate closdate epflag PrimaryTherapist dx dx_descr dx_grpDSM dx_grpAdult LastService UnCookedMonth
epincrement epincrementClose IncrementDays SystemCostLastYear  SystemIncCost
SystemIncTime IncrementCost IncrementTime increment averagestay TISaveragestay FakeClose SystemCostLabel CaseOp.

get file='//covenas/decisionsupport/temp/incrementedAllMatched%s.sav'.

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

save outfile='//covenas/decisionsupport/temp/AvePerClientProgramFlowx%s.sav'.


get file='//covenas/decisionsupport/temp/programflowMCSvccatwork.sav'.
string RUProgram(a40).
compute RUProgram = concat(RU,"    ",rtrim(provname)).

sort cases by ru.
match files /file=* /table='//covenas/decisionsupport/meinzer/tables/units.sav' /by ru.
if units='day' units='Days'.
if units='minutes' units='Hours'.

save outfile='//covenas/decisionsupport/temp/programflowMCSvccat%s.sav'.

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

save outfile='//covenas/decisionsupport/temp/programflowLOSTIS%s.sav' /keep agency ru RUProgram provname case name age bday ethnicity opdate increment TotalCostInTX TotalDurationinTX xaxisincrement
incrementthing catInc closdate epflag PrimaryTherapist dx dx_descr dx_grpDSM dx_grpAdult LastService UnCookedMonth LOS TISNow counter EntranceSystemCostLastYear.


get file='//covenas/decisionsupport/temp/daysbetweenvisitswork.sav'.

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

save outfile ='//covenas/decisionsupport/temp/programflowDaysBetweenVisits%s.sav' /keep agency
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
 * get file='//covenas/decisionsupport/dbsvcprogramflowsvconlyBeforeVisit1andyearearlier.sav'  .

sort cases by case.
CASESTOVARS
/id case.
exe.

sort cases by case.
match files /table=* /file='//covenas/decisionsupport/temp/programflowEPSsortedbycase.sav' /by case.

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

select if svcdate ne 999999999999999.
if svcdate=-99 svcdate=$sysmis.

 * compute test= datesum(closdate,1, 'years').
 * if (svcdate gt closdate and datedif(closdate,svcdate,'days') le 365 ) test=1.

insert file='//covenas/decisionsupport/modules/uncookedmonth.sps'.
 
Match files /file=* /keep case mcsvccat   closdate epflag PrimaryTherapist primdx ru UnCookedMonth
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

save outfile='//covenas/decisionsupport/meinzer/temp/Programflow_PrePost%s.sav'.

get file='//covenas/decisionsupport/meinzer/temp/yearbeforework.sav' /keep case mcsvccat
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

select if opdate ge dbstartdate.

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
save outfile='//covenas/decisionsupport/meinzer/temp/rusPreandPostList%s.sav'.

""" % (l,l,l,l,l,l,l,l,l,l,l)
        pushList.append(syntax)
        count=count+1

with open('k:/temp/programsytnax.sps','w') as programflow:
        for item in pushList:
            programflow.write(item+'\n')