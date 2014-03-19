GET
  FILE='//covenas/decisionsupport/eps_year_2009.sav'.
 * n of cases 10000.
freq ru.
save outfile='//covenas\decisionsupport/test21.sav'.


*pushbreak.
*skiprow.
*sqlTable = 'hello_what_data21'.
*spsstable='//covenas\decisionsupport/test21.sav'.
*pushbreak. 

GET
  FILE='//covenas/decisionsupport/eps_year_2010.sav'.
 * n of cases 10000.
freq ru.
save outfile='//covenas\decisionsupport/test22.sav'.

*pushbreak.
*skiprow.
*sqlTable = 'hello_what_data22'.
*spsstable='//covenas\decisionsupport/test22.sav'.
*pushbreak.


GET
  FILE='//covenas/decisionsupport/eps_year_2011.sav'.
 * n of cases 10000.
freq ru.
save outfile='//covenas\decisionsupport/test23.sav'.


*pushbreak.
*skiprow.
*sqlTable = 'hello_what_data23'.
*spsstable='//covenas\decisionsupport/test23.sav'.
*pushbreak.

GET
  FILE='//covenas/decisionsupport/eps_year_2012.sav'.
 * n of cases 10000.
freq ru.
save outfile='//covenas\decisionsupport/test24.sav'.

*pushbreak.
*skiprow.
*sqlTable = 'hello_what_data24'.
*spsstable='//covenas\decisionsupport/test24.sav'.
*pushbreak.


