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
            
            