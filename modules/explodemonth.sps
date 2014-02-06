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

