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
n of cases 3000000.
save outfile='//covenas\decisionsupport/test11a.sav'.
*pushbreak.
*skiprow.
*sqlTable = 'testa'.
*spsstable='//covenas\decisionsupport/test11a.sav'.
*pushbreak.

