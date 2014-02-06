string FiscalYear (a10).
do if xdate.month(closdate) lt 7.
compute fiscalyear=concat("FY ",substr(string(xdate.year(closdate)-1,n4),3,2),"-",substr(string(xdate.year(closdate),n4),3,2)).
else if xdate.month(closdate) ge 7.
compute fiscalyear=concat("FY ",substr(string(xdate.year(closdate),n4),3,2),"-",substr(string(xdate.year(closdate)+1,n4),3,2)).
end if.
