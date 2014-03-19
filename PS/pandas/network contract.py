import xlrd
import csv
#from pprint import pprint

exlWorkbook=r'\\Covenas\A&D_Fin\Network Office\Contract Monitoring\EMANIO\Contract Deliverables for Emanio Reports.xlsx'
tempfile='//covenas/decisionsupport/temp/correctedx.csv'
CorrectedFile='//covenas/decisionsupport/temp/corrected.csv'

def ExcelToCSV(exlWorkbook,tempfile,CorrectedFile):
  """ constructed to consume a specific SSI document in which there are an unknown # of worksheets """
  with open(tempfile,'wb') as writetest:
    writer=csv.writer(writetest)
    workbook = xlrd.open_workbook(exlWorkbook)
    worksheets = workbook.sheet_names()
    for worksheet_name in worksheets:
      worksheet = workbook.sheet_by_name(worksheet_name)
      num_rows = worksheet.nrows - 1
      curr_row = -1
      while curr_row < num_rows:
          curr_row += 1
          row = worksheet.row(curr_row)
          writer.writerow(row[1:])
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
GET DATA /TYPE=XLSX
  /FILE='\\Covenas\A&D_Fin\Network Office\Contract Monitoring\EMANIO\Contract Deliverables for Emanio Reports.xlsx'
  /SHEET=name 'contracts'
  /CELLRANGE=full
  /READNAMES=on
  /ASSUMEDSTRWIDTH=32767.
EXECUTE.



import pandas as pd
xl = pd.ExcelFile("\\Covenas\A&D_Fin\Network Office\Contract Monitoring\EMANIO\Contract Deliverables for Emanio Reports.xlsx")

xl.sheet_names  # in your example it may be different

#dfs = {sheet: xl.parse(sheet) for sheet in xl.sheet_names}
#dfs['contracts']
df =xl.parse('contracts')
df.rename(columns = {'Total Hours' : 'CDtotalhours',"Days" : "CDDays", "Provname" : "ProvnameNetwork"}, inplace=True)
df.drop(['agency','provnameDecSupp'],1,inplace=True)