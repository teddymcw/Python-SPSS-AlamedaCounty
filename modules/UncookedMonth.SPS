if xdate.mday($time) le 15 UnCookedMonth = DateSum($time,-1,"months").
if xdate.mday($time) gt 15 UnCookedMonth = $time.
compute UnCookedMonth =date.moyr(xdate.month(UnCookedMonth), xdate.year(UnCookedMonth)).
formats UnCookedMonth(date11).

*wrong uncooked for testing fy change.
 * if xdate.mday($time) le 15 UnCookedMonth = $time.
 * if xdate.mday($time) gt 15 UnCookedMonth = DateSum($time,+1,"months").
 * compute UnCookedMonth =date.moyr(xdate.month(UnCookedMonth), xdate.year(UnCookedMonth)).
 * formats UnCookedMonth(moyr6).
