GET
  FILE='//covenas/decisionsupport/INSYSTservicesALLXX.sav'.
DATASET NAME DataSet2 WINDOW=FRONT.

aggregate outfile=* 
/break ru
/Unit=max(Unit).
freq unit.
sort cases by ru unit.
save outfile='//covenas/decisionsupport/meinzer/tables/unit.sav'.

