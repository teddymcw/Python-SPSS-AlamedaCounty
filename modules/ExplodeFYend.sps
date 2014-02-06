get file='//covenas/decisionsupport/meinzer/temp/oalos.sav'.
insert file='//covenas/decisionsupport/modules/uncookedmonth.sps'.

if epflag="O" TISmonthsNow=datediff($time,opdate,'months').


if sysmis(closdate) closdate=datesum($time,1,'months').
compute Countyears=datediff($time,DBstartdate,"years").

vector dateEp(50,f11).
do if xdate.quarter(opdate) le 2.
compute dateEp1=date.dmy(30,6, xdate.year(opdate)).
else if xdate.quarter(opdate) ge 3.
compute dateep1=date.dmy(30,6, xdate.year(opdate)+1).
end if.
*select if closdate gt dateep1.
do if xdate.quarter(dbstartdate) lt 3.
 do if dateep1 le date.dmy(30,6,xdate.year(dbstartdate)). 
   compute dateep1=date.dmy(30,6,xdate.year(dbstartdate)). 
 end if.
else if xdate.quarter(dbstartdate) ge 3.
 do if dateep1 le date.dmy(30,6,xdate.year(dbstartdate)+1).
   compute dateep1=date.dmy(30,6,xdate.year(dbstartdate)+1). 
  end if.
end if.
*formats dateep1(date11).
compute #dateindex=1.
loop #count=1 to countyears.
do if datesum(dateep(#dateindex),1,'years','closest') lt closdate.
compute dateep(#dateindex+1) = datesum(dateep(#dateindex),1,"years","closest").
end if.
compute #dateindex=#dateindex+1.
end loop.
formats dateep1 to dateep50(date11).
VARSTOCASES
/make Endfy from dateep1 to dateep50.

*formats calendar(date11).

compute counter=1.
*freq counter.
select if closdate gt endfy.
*freq counter.
compute TISmonths=datediff(endfy,opdate,'months').

do if  any(ru,OAkeepRU).
string TIS(a40).
if TISMonths ge 0 and TISMonths lt 3 TIS="1. 0-2 months".
if TISMonths ge 3 and TISMonths lt 6 TIS="2. 3-5 months".
if TISMonths ge 6 and TISMonths lt 13 TIS="3. 6-12 months".
if TISMonths ge 13 and TISMonths lt 25 TIS="4. 13-24 months ".
if TISMonths ge 25 and TISMonths lt 37 TIS="5. 25-36 months".
if TISMonths ge 37 TIS="6. 37 months or More".
end if.

string FiscalYear (a10).
do if xdate.month(endfy) lt 7.
compute FiscalYear=concat("FY ",substr(string(xdate.year(endfy)-1,n4),3,2),"-",substr(string(xdate.year(endfy),n4),3,2)).
else if xdate.month(endfy) ge 7.
compute FiscalYear=concat("FY ",substr(string(xdate.year(endfy),n4),3,2),"-",substr(string(xdate.year(endfy)+1,n4),3,2)).
end if.

select if endfy lt datesum(uncookedmonth,-1,'days').

aggregate outfile='//covenas/decisionsupport/meinzer/temp/TISoaEndFY.sav'
   /break=ru TIS EndFY FiscalYear
   /TimeinService=sum(counter).

aggregate outfile=*
   /break fiscalyear
   /bogus=max(counter).

CASESTOVARS
/id=bogus.

save outfile="//covenas/decisionsupport/temp/fytableTIS.sav".

get file='//covenas/decisionsupport/rutable.sav' /keep provname ru.
select if any(ru,OAkeepRU).
string TIS1 to TIS6 (a40).
do if  any(ru,OAkeepRU).
compute TIS1="1. 0-2 months".
compute TIS2="2. 3-5 months".
compute TIS3="3. 6-12 months".
compute TIS4="4. 13-24 months ".
compute TIS5="5. 25-36 months".
compute TIS6="6. 37 months or More".
end if.

VARSTOCASES
/make TIS from TIS1 to TIS6.

compute bogus=1.
match files /file=* /table="//covenas/decisionsupport/temp/fytable.sav" /by bogus.
string FiscalYear.x(a10).
compute FiscalYear.x="-99".

VARSTOCASES
/make FiscalYear from Fiscalyear.1 to FiscalYear.x.
select if not FiscalYear = "-99".

insert file='//covenas/decisionsupport/modules/uncookedmonth.sps'.
sort cases by ru tis fiscalyear.
match files /table='//covenas/decisionsupport/meinzer/temp/TISoaEndFY.sav' /file=* /by ru tis fiscalyear.

compute cookedmonth=datesum(uncookedmonth,-1,'days').

select if not xdate.year(cookedmonth) = 2000+number(substr(fiscalyear,7,2),n4).

save outfile='//covenas/decisionsupport/meinzer/temp/TISoaEndFYshell.sav'.

*get file='//covenas/decisionsupport/meinzer/temp/TISoaEndFY.sav'.




*if endfy ge opdate and endfy le closdate check=1.
