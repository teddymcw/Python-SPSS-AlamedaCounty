 * begin program.
 * import spss
syntax=r"""
GET DATA /TYPE=XLSX
  /FILE='//Covenas/A&D_Fin/Network Office/Contract Monitoring/EMANIO/Contract Deliverables for Emanio Reports.xlsx'
  /SHEET=name 'contracts'
  /CELLRANGE=full
  /READNAMES=on
  /ASSUMEDSTRWIDTH=32767.
 * EXECUTE.
 * """
spss.Submit(syntax)
end program.
*.
 * OMS /SELECT ALL /DESTINATION FORMAT = TABTEXT
  OUTFILE = "//covenas/decisionsupport/temp/test.txt" /TAG =
"outputToTextx".

GET
  FILE='//covenas/decisionsupport/epscg.sav'.
n 2000.
save outfile='//covenas/decisionsupport/temp/epscgtest.sav'.
get file='//covenas/decisionsupport/temp/epscgtest.sav'.
SAVE TRANSLATE /TYPE=ODBC
/Connect ='DSN=DashboardDatadev;UID=;APP=SPSS For'+
' Windows;WSID=HPMXL9360ZDD;DATABASE=DashboardDatadev;Trusted_Connection=Yes'
/table= 'testSPSSpush' /MAP/REPLACE.
 * save outfile='//covenas/decisionsupport/temp/test.sav'.
*save outfile='//bhcsdbv03/emanio/test.sav'.

 * OMSEND TAG=["outputToTextx"]. 


 * compute DateDownload=$time.
 * formats datedownload(date11).
 * exe.
 * freq datedownload.
 * save outfile='//covenas/decisionsupport/temp/test.sav'.
 * dataset close *.

 * begin program.
 * AlertDays=4
Files=['//covenas/decisionsupport/meinzer/Production\dashboarddatasets/Level2.sps']
end program.
 * insert file='//covenas/decisionsupport/meinzer/production/ps/errorTestPickles.sps'.