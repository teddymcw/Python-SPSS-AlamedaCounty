import xlrd
import csv
#from pprint import pprint

SSIworkbook='C:\Users\meinzerc\Desktop\Copy of Cases pending SSI 07_12_13.xls'
tempfile='//covenas/decisionsupport/temp/correctedx.csv'
CorrectedFile='//covenas/decisionsupport/temp/corrected.csv'

def SSIExcelToCSV(SSIworkbook,tempfile,CorrectedFile):
  """ constructed to consume a specific SSI document in which there are an unknown # of worksheets """
  with open(tempfile,'wb') as writetest:
    writer=csv.writer(writetest)
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

  with open(CorrectedFile,'wb') as writetest:
    writer=csv.writer(writetest)
    with open(tempfile,'rb') as csvfile:
      reader=csv.reader(csvfile)
      for row in reader:
  #       pprint(row)
        if row[0].startswith('text'):
          x=[str(item).replace('text:u','') for item in row]
          y=[s.replace("'","") for s in x]
          writer.writerow(y)
  print 'your file is waiting here '+CorrectedFile

#with open(CorrectedFile) as csvfile:
#   reader=csv.reader(csvfile)
#   for row in reader:
#      print row
