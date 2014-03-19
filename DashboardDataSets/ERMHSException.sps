get file='//covenas/spssdata/AB3632exceptionStart.sav' .
sort cases by ru.
match files/table='//covenas/spssdata/ruTable.sav' /file=* /by ru.
select if (daytx=1 AND kidsru=1 )OR cesdc=1 or (any(psmask2,65537,700) AND ab3632RU=1).
*Took Out - Thunder Road and Guidance Clinic and EBAC TNS.

select if not any(RU,"01197","01195","81465","81462", "81231",  "81232", "81422", "81423").
 * freq ab3632RU.
 * freq agency.
 * sort cases by ru.
 * split file by ru.

 * temp.
 * select if any(ab3632ru, 0, $sysmis).
 * freq provname.

 * compute FY = 1213.
 * if xdate.tday(Svcdate) ge yrmoda(2013,07,01) FY = 1314.

string FiscalYear (a10).
do if xdate.month(svcdate) lt 7.
compute fiscalyear=concat("FY ",substr(string(xdate.year(svcdate)-1,n4),3,2),"-",substr(string(xdate.year(svcdate),n4),3,2)).
else if xdate.month(svcdate) ge 7.
compute fiscalyear=concat("FY ",substr(string(xdate.year(svcdate),n4),3,2),"-",substr(string(xdate.year(svcdate)+1,n4),3,2)).
end if.

 * freq cost/format=notable/stat=sum.
 * format cost(dollar8.0).
 * sort cases by FiscalYear Payor.
 * split file by FiscalYear Payor.
 * freq cost/form=notable/stat sum.
 * split file off.

save outfile = '//covenas/decisionsupport/temp/ERMHSExptnWork.sav' /keep FiscalYear District_Name agency ru provname case ClientID name opdate svcdate Cost psmask2 residential.
*Variables Requested: Ab3632ID, InsystID, First_FY_svc, Last_FY_svc, ClientName, RU, Program, District, OpenDate, Closdate.

get file = '//covenas/decisionsupport/temp/ERMHSExptnWork.sav'.
display vars.

sort cases by ru case opdate. 
match files /table= '//covenas/decisionsupport/epscg.sav' /file=* /by ru case opdate /keep FiscalYear District_Name agency ru provname case ClientID name opdate closdate svcdate cost psmask2 residential.

 * Aggregate outfile = * mode=ADDVARIABLES
   /Break= FiscalYear ru case
   /First_FY_RUsvc= min(svcdate)
   /Last_FY_RUsvc= max(svcdate)
   /FY_RUsvcCost = sum(cost).

Aggregate outfile = '//covenas/decisionsupport/temp/ERMHSExptnWork2.sav'
   /Break= FiscalYear District_Name agency ru provname case ClientID name opdate closdate psmask2 residential
   /First_FY_RUsvc= min(svcdate)
   /Last_FY_RUsvc= max(svcdate).

get file = '//covenas/decisionsupport/temp/ERMHSExptnWork2.sav'.

rename variables ClientID= Ab3632ID.
rename variables case=InsystID.

SORT CASES BY Agency Provname FiscalYear.

save outfile= '//covenas/decisionsupport/temp/ERMHSException.sav'.

*pushbreak.
*sqlTable = 'ERMHSException'.
*spsstable='//covenas/decisionsupport/temp/ERMHSException.sav'.
*pushbreak.


*Psmask2 900 Report and Non 900 Report. 



*get file = '//covenas/decisionsupport/temp/ERMHSExptnReport.sav'.
 * sort cases by ru InsystID fiscalyear.
 * match files /file* /by ru InsystID fiscalyear/ first=rufycase1.


