*This section renames the files so they can automatically be run in the next section.
begin program.
import os
for root, dirs, files in os.walk('//covenas/decisionsupport/meinzer/projects/ssi/pending'):
   for afile in files:
      s=root+'/'+afile
      if 'master' in s:
         os.remove(s)
      if afile.startswith('IAR'):
         os.rename(s,s.replace('IAR Pending_SSI_','Cases pending SSI '),1)

files2=os.listdir('//covenas/decisionsupport/meinzer/projects/ssi/pending')
for file in files2:
   if 'IAR P' in file:
      new_name=file.replace("IAR Pending_SSI_","Cases pending SSI ")
      new_name=root+'/'+new_name
      file=root+'/'+file
      os.rename(file,new_name)
   if 'orig' in file:
      new_name=file.replace("_orig","")
      new_name=root+'/'+new_name
      file=root+'/'+file
      os.rename(file,new_name)
end program.

begin program.
import spss
import xlrd, os, re
import csv
from pprint import pprint

for root, dirs, files in os.walk('//covenas/decisionsupport/meinzer/projects/ssi/pending'):
  for afile in files:
   print afile
   SSIworkbook='%s/%s' % (root,afile)
   FileName=SSIworkbook.rpartition('/')[-1]
   stripfile=os.path.splitext(afile)[0]
   filename= os.path.splitext("//covenas/decisionsupport/Meinzer/Projects/SSI/%s" % afile)[0]
   tempfile='//covenas/decisionsupport/temp/correctedx.csv'
   spssfile='//covenas/decisionsupport/Meinzer/Projects/SSI/SPSS/%s.sav' % stripfile
   CorrectedFile='//covenas/decisionsupport/Meinzer/Projects/SSI/%s.csv' % stripfile 
   with open(tempfile,'wb') as writeTemp:
      writer=csv.writer(writeTemp)
      workbook = xlrd.open_workbook(SSIworkbook)
      worksheets = workbook.sheet_names()
      for worksheet_name in worksheets:
       worksheet = workbook.sheet_by_name(worksheet_name)
       num_rows = worksheet.nrows - 1
       curr_row = -1
       while curr_row < num_rows:
    	    curr_row += 1
    	    row = worksheet.row(curr_row)
    	    writer.writerow(row[1:3])

   with open(CorrectedFile,'wb') as writeCorrect:
      writer=csv.writer(writeCorrect)
      with open(tempfile,'rb') as csvfile:
       reader=csv.reader(csvfile)
       for row in reader:
          if row[0].startswith('text'):
            x=[str(item).replace('text:u','') for item in row]
            y=[s.replace("\'","") for s in x]
            writer.writerow(y)
   p=re.compile('\d+')
   k=p.findall(afile)   
   print k         
   month = k[0]
   day = k[1]
   year = k[2]
   print month, day, year            
   cmdspss="""

GET DATA  /TYPE=TXT
  /FILE="%s.csv"
  /ENCODING='Locale'
  /DELCASE=LINE
  /DELIMITERS=","
  /QUALIFIER='"'
  /ARRANGEMENT=DELIMITED
  /FIRSTCASE=2
  /IMPORTCASE=ALL
  /VARIABLES=
  SSN A12
  Name A27.
CACHE.
EXECUTE.

select if not ssn='SSN'.
compute name=ltrim(name).
if substr(name,1,1)='"' name=substr(name,2,rindex(name,'"')-2). 
string nameFirst(a30).
string nameLast(a30).
compute nameFirst=substr(name,index(name,',')+2,30).
compute nameLast=substr(name,1,index(name,',')-1).

do if index(name,' JR') gt 0.
compute name=concat(substr(name,1,(index(name," JR"))-1),substr(name,index(name," JR")+3,55)).
end if.
do if index(name,' DR') gt 0.
compute jrtest=index(name," DR").
compute jrend=index(name," DR")+2.
compute name=concat(substr(name,1,(index(name," DR"))-1),substr(name,index(name," DR")+3,55)).
end if.

string day month year(a4).
compute day='%s'.
compute Month='%s'.
compute Year='%s'.

compute SSIcountyReportAA=date.dmy(number(day,f2.0),number(month,f2.0),number(year,f4.0)).

format SSIcountyReportAA (date11).
save outfile='%s.'  """ % (filename,day,month,year, spssfile)

   spss.Submit(cmdspss)
s='add files\n'
for root, dirs, files in os.walk('//covenas/decisionsupport/meinzer/projects/ssi/spss'):
   if len(files) >1:
      print 'greater than 1'
      for savfile in files:
        line= '/file="%s/%s"\n' % (root,savfile)
        s+=line
      print s

      cmdadd="""
      %s.
      save outfile='//covenas/decisionsupport/meinzer/projects/ssi/combinedexcelfiles.sav'
      """ % s
   elif len(files) ==1:
      cmdadd=("save outfile='//covenas/decisionsupport/meinzer/projects/ssi/combinedexcelfiles.sav'")
   elif len(files) ==0:
      print 'no files'
      cmdadd=('freq ssn')
      break
spss.Submit(cmdadd)

import shutil
spsspath='//covenas/decisionsupport/meinzer/projects/ssi/SPSS'
for root, dirs, files in os.walk(spsspath):
  for afile in files:
   shutil.move(spsspath+'/'+afile,spsspath+' processed/'+afile)

for root, dirs, files in os.walk('//covenas/decisionsupport/meinzer/projects/ssi/pending'):
  for afile in files:
   shutil.move('//covenas/decisionsupport/meinzer/projects/ssi/pending/'+afile,'//covenas/decisionsupport/meinzer/projects/ssi/pending processed/'+afile)

end program.


get file='//covenas/decisionsupport/meinzer/projects/ssi/combinedexcelfiles.sav'.

SAVE TRANSLATE /TYPE=ODBC
  /CONNECT='DSN=SSI;DBQ=//covenas/spssdata/Wong\SSI Advocacy Referrals 02-01-2012.mdb;DriverId=25;FIL=MS '+
    'Access;MaxBufferSize=2048;PageTimeout=5;'
  /ENCRYPTED
  /MISSING=IGNORE
  /TABLE='SPSS_TEMP'
  /KEEP=SSN, Name, nameFirst, nameLast, SSIcountyReportAA
  /SQL='INSERT INTO `IAR Cases Pending` (SSN, Name, nameFirst, nameLast,  '+
    'SSIcountyReportAA) SELECT SSN, Name, nameFirst, nameLast,  '+
    'SSIcountyReportAA FROM SPSS_TEMP'
  /SQL='DROP TABLE SPSS_TEMP'.

string SSNtext (a11).
compute SSNtext=concat(substr(ltrim(ssn), 1,3), substr(ltrim(ssn), 5,2), substr(ltrim(ssn), 8,4)).
if ssnText  = " " problem=1.
freq problem.

compute ssnSSI=number(SSNtext, f11.0).

aggregate outfile=* mode = ADDVARIABLES /break=ssnssi /Records=N.
sort cases by Records (d) ssnssi.
freq Records.

match files /file=* /keep ssnssi Name namefirst namelast SSIcountyReportAA.

SAVE TRANSLATE /TYPE=ODBC
  /CONNECT='DSN=SSI;DBQ=//covenas/spssdata/Wong\SSI Advocacy Referrals '+
    '02-01-2012.mdb;DriverId=25;FIL=MS Access;MaxBufferSize=2048;PageTimeout=5;'
   /TABLE='IARreports' /MAP/append.


GET DATA  /TYPE=ODBC
  /CONNECT='DSN=SSI;DBQ=//covenas/spssdata/Wong\SSI Advocacy Referrals 02-01-2012.mdb;DriverId=25;FIL=MS '+
    'Access;MaxBufferSize=2048;PageTimeout=5;'
  /SQL='SELECT ssnSSI, SSIcountyReportAA, Name, NameLast, NameFirst FROM IARreports'
  /ASSUMEDSTRWIDTH=30.

CACHE.
EXECUTE.
compute NameLast=upcase(ltrim(NameLast)).
compute NameFirst=upcase(ltrim(NameFirst)).

sort cases by ssnSSI SSIcountyReportAA.
match files /file=* /by ssnSSI /last=keep.
select if keep=1.

*make sure all dates are there.
freq SSIcountyReportAA.

save outfile='//covenas/spssdata/SSI\SSIqueue\JustMaxedSSI.sav' /keep ssnSSI SSIcountyReportAA Name NameLast NameFirst.

*need to have generic, non-date name since file will be used in other codes*.
 * save outfile='//covenas/spssdata/SSI\SSIqueue\IARpendingSSI.sav' /keep ssnSSI SSIcountyReportAA Name NameLast NameFirst.
 * get file='//covenas/spssdata/SSI\SSIqueue\IARpendingSSI.sav'.


**CLOSE extra data files before proceeding***
********************************************************Create copy of CLIENT table******************************************************************************

*match in unique clients sorted by max countyreportaa date.

GET DATA  /TYPE=ODBC
  /CONNECT='DSN=SSI;DBQ=//covenas/spssdata/Wong\SSI Advocacy Referrals '+
    '02-01-2012.mdb;DriverId=25;FIL=MS Access;MaxBufferSize=2048;PageTimeout=5;'
  /SQL='SELECT ssnSSI, SSINumber, SSIcountyReport, LNameSSI, FNameSSI, BdaySSI, ssnMEDS, SSNinsyst, SSNSSA, SSNSSA1  FROM CLIENTS '
  /ASSUMEDSTRWIDTH=50.
CACHE.

sort cases by ssnSSI.

match files /table='//covenas/spssdata/SSI\SSIqueue\JustMaxedSSI.sav' /file=* /by ssnSSI
 /keep
ssnSSI
NameLast
NameFirst
LNameSSI
FNameSSI
SSINumber
ssnMEDS
SSNinsyst
SSNSSA
SSNSSA1
SSIcountyReportAA
SSIcountyReport.

exe.

select if NameLast ne " ".
if substr(NameLast,1,5) ne substr(LNameSSI,1,5) lnameprob=1.
if substr(NameFirst,1,5) ne substr(FNameSSI,1,5) fnameprob=1.

do if (substr(NameLast,1,5)=substr(FNameSSI,1,5) AND substr(NameFirst,1,5)=substr(LNameSSI,1,5)).
compute lnameprob=0.
compute fnameprob=0.
end if.

if sum(lnameProb,fnameProb) = 2 ReviewMe=1.
sort cases by ReviewMe(d).
freq ReviewMe.


