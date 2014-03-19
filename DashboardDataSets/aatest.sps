GET
  FILE='//covenas/decisionsupport/eps_year_2009.sav'.
n of cases 10.
 * freq ru.
save outfile='//covenas\decisionsupport/aaaaa1.sav'.

*pushbreak.
*skiprow.
*sqlTable = 'a1'.
*spsstable='//covenas\decisionsupport/aaaaa1.sav'.
*pushbreak. 

GET
  FILE='//covenas/decisionsupport/eps_year_2009.sav'.
n of cases 10.
freq ru.
save outfile='//covenas\decisionsupport/aaaaa2.sav'.


*pushbreak.
*skiprow.
*sqlTable = 'a2'.
*spsstable='//covenas\decisionsupport/aaaaa2.sav'.
*pushbreak. 
