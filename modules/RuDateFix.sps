*recode 0-9 to Jan 1990 (start) and Jan 2019 (end).
 * recode start_dt (0 thru 9=190).
 * recode end_dt (0 thru 9=119).

 * compute RUStart = date.moyr(number(substr(string(start_dt,n4),1,2),f2),(number(substr(string(start_dt,n4),3,2),f2))).
 * compute RUEnd = date.moyr(number(substr(string(end_dt,n4),1,2),f2),(number(substr(string(end_dt,n4),3,2),f2))).
 * formats RUStart RUEnd (moyr6).

*match files /file=* /drop start_dt end_dt.


 * get file='//covenas/decisionsupport/rutable.sav' /keep start_dt end_dt ru.

compute start_dtx=start_dt.
compute end_dtx=end_dt.

recode start_dtx (0 thru 9=150).
recode end_dtx (0 thru 9=150).


compute StartRU = date.moyr(number(substr(string(start_dtx,n4),1,2),f2),(number(substr(string(start_dtx,n4),3,2),f2))).
compute EndRU = date.moyr(number(substr(string(end_dtx,n4),1,2),f2),(number(substr(string(end_dtx,n4),3,2),f2))).
exe.
delete vars start_dtx end_dtx.

*if missing(endru) endru=date.mdy(1,1,2020).
formats startru endru (date11).
if startru le date.moyr(1,1950) startru=$sysmis.
if endru le date.moyr(1,1950) endru=$sysmis.
