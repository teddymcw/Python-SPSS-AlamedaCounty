GET
  FILE='//covenas/decisionsupport/eps_year_2009.sav'.
n of cases 10.
freq ru.
save outfile='//covenas\decisionsupport/aaaaaa1.sav'.


*pushbreak.
*skiprow.
*sqlTable = 'a1'.
*spsstable='//covenas\decisionsupport/aaaaaa1.sav'.
*pushbreak. 
