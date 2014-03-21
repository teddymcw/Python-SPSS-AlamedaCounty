 * add files
/FILE='//covenas/decisionsupport/services02_qtr1.sav'
/FILE='//covenas/decisionsupport/services02_qtr2.sav'
/FILE='//covenas/decisionsupport/services02_qtr3.sav'
/FILE='//covenas/decisionsupport/services02_qtr4.sav'
/FILE='//covenas/decisionsupport/services03_qtr1.sav'
/FILE='//covenas/decisionsupport/services03_qtr2.sav'
/FILE='//covenas/decisionsupport/services03_qtr3.sav'
/FILE='//covenas/decisionsupport/services03_qtr4.sav'
/FILE='//covenas/decisionsupport/services04_qtr1.sav'
/FILE='//covenas/decisionsupport/services04_qtr2.sav'
/FILE='//covenas/decisionsupport/services04_qtr3.sav'
/FILE='//covenas/decisionsupport/services04_qtr4.sav'
/FILE='//covenas/decisionsupport/services05_qtr1.sav'
/FILE='//covenas/decisionsupport/services05_qtr2.sav'
/FILE='//covenas/decisionsupport/services05_qtr3.sav'
/FILE='//covenas/decisionsupport/services05_qtr4.sav'.
get file='\\covenas\decisionsupport\meinzer\temp\allsvcwork_1.sav'.
compute count=1.
freq count.
n of cases 100000.
save outfile='//covenas\decisionsupport/test11a.sav'.
*pushbreak.
*skiprow.
*sqlTable = 'testa'.
*spsstable='//covenas\decisionsupport/test11a.sav'.
*pushbreak.

GET
  FILE='//covenas/decisionsupport/services02_qtr2.sav'.
n of cases 10.
save outfile='//covenas\decisionsupport/test12.sav'.

*pushbreak.
*skiprow.
*sqlTable = 'testb'.
*spsstable='//covenas\decisionsupport/test12.sav'.
*pushbreak.


GET
  FILE='//covenas/decisionsupport/eps_year_2006.sav'.
n of cases 10.
freq ru.
save outfile='//covenas\decisionsupport/test13.sav'.

*pushbreak.
*skiprow.
*sqlTable = 'testc'.
*spsstable='//covenas\decisionsupport/test13.sav'.
*pushbreak.

GET
  FILE='//covenas/decisionsupport/eps_year_2005.sav'.
n of cases 10.
freq ru.
save outfile='//covenas\decisionsupport/test14.sav'.

*pushbreak.
*skiprow.
*sqlTable = 'testd'.
*spsstable='//covenas\decisionsupport/test14.sav'.
*pushbreak.

