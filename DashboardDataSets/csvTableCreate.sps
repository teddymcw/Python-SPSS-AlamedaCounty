get file='\\covenas\decisionsupport/procedsma.sav'.

SAVE TRANSLATE OUTFILE='//covenas/decisionsupport/Meinzer\pandas\procedsma.csv'
  /TYPE=CSV
  /ENCODING='Locale'
  /MAP
  /REPLACE
  /FIELDNAMES
  /CELLS=VALUES.
get file='//covenas/decisionsupport/AllUR.sav'.

SAVE TRANSLATE OUTFILE='//covenas/decisionsupport/Meinzer\pandas\AllUR.csv'
  /TYPE=CSV
  /ENCODING='Locale'
  /MAP
  /REPLACE
  /FIELDNAMES
  /CELLS=VALUES.
get file='//covenas/decisionsupport/epsCG.sav'.

SAVE TRANSLATE OUTFILE='//covenas/decisionsupport/Meinzer\pandas\epsCG.csv'
  /TYPE=CSV
  /ENCODING='Locale'
  /MAP
  /REPLACE
  /FIELDNAMES
  /CELLS=VALUES.
get file='//covenas/decisionsupport/ruTable.sav '.

SAVE TRANSLATE OUTFILE='//covenas/decisionsupport/Meinzer\pandas\rutable.csv'
  /TYPE=CSV
  /ENCODING='Locale'
  /MAP
  /REPLACE
  /FIELDNAMES
  /CELLS=VALUES.
get file='//covenas/decisionsupport/dxTable.sav'.

SAVE TRANSLATE OUTFILE='//covenas/decisionsupport/Meinzer\pandas\dxTable.csv'
  /TYPE=CSV
  /ENCODING='Locale'
  /MAP
  /REPLACE
  /FIELDNAMES
  /CELLS=VALUES.

get file='//covenas/decisionsupport/dbsvc.sav' .

SAVE TRANSLATE OUTFILE='//covenas/decisionsupport/Meinzer\pandas\dbsvc.csv'
  /TYPE=CSV
  /ENCODING='Locale'
  /MAP
  /REPLACE
  /FIELDNAMES
  /CELLS=VALUES.

n of cases 1000.
SAVE TRANSLATE OUTFILE='//covenas/decisionsupport/Meinzer\pandas\dbsvcl.csv'
  /TYPE=CSV
  /ENCODING='Locale'
  /MAP
  /REPLACE
  /FIELDNAMES
  /CELLS=VALUES.
get file='//covenas/decisionsupport/URagg.sav' .

SAVE TRANSLATE OUTFILE='//covenas/decisionsupport/Meinzer\pandas\URagg.csv'
  /TYPE=CSV
  /ENCODING='Locale'
  /MAP
  /REPLACE
  /FIELDNAMES
  /CELLS=VALUES.
get file='//covenas/spssdata/clinfo.sav' .

SAVE TRANSLATE OUTFILE='//covenas/decisionsupport/Meinzer\pandas\clinfo.csv'
  /TYPE=CSV
  /ENCODING='Locale'
  /MAP
  /REPLACE
  /FIELDNAMES
  /CELLS=VALUES.
get file =  '//covenas/decisionsupport/MedicalData/MedsCurrentUncut.sav'.

SAVE TRANSLATE OUTFILE='//covenas/decisionsupport/Meinzer\pandas\MedsCurrentUncut.csv'
  /TYPE=CSV
  /ENCODING='Locale'
  /MAP
  /REPLACE
  /FIELDNAMES
  /CELLS=VALUES.
get file='//covenas/decisionsupport/addressmhs.sav'.

SAVE TRANSLATE OUTFILE='//covenas/decisionsupport/Meinzer\pandas\addressmhs.csv'
  /TYPE=CSV
  /ENCODING='Locale'
  /MAP
  /REPLACE
  /FIELDNAMES
  /CELLS=VALUES.
get file='//covenas/decisionsupport/staff.sav'.


SAVE TRANSLATE OUTFILE='//covenas/decisionsupport/Meinzer\pandas\staff.csv'
  /TYPE=CSV
  /ENCODING='Locale'
  /MAP
  /REPLACE
  /FIELDNAMES
  /CELLS=VALUES.
