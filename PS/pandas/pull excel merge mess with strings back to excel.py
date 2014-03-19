from pandas import DataFrame, ExcelFile
import pandas as pd
import json


# Path to excel file
# Your path will be different, please modify the path below.
location = r'c:/users/meinzerc/Desktop/table.xlsx'

# Create ExcelFile object
xls = ExcelFile(location)

# Parse the excel file
table = xls.parse('Sheet1')
df.head()

location = r'c:/users/meinzerc/Desktop/base.xlsx'

# Create ExcelFile object
xls = ExcelFile(location)

# Parse the excel file
base = xls.parse('Sheet2')
base.head()

base.columns = ['File', 'b', 'c', 'd', 'e','f','g','h']
basecut= base[['File','h']]
h=pd.DataFrame(basecut.h)
final=basecut.File.str.split('\\xa0+\s*\\xa0*')
abc=pd.DataFrame(final.tolist(), columns = ['a','b','c','e','f'],index=final.index)
work=pd.merge(abc,h,how='left',left_index=True,right_index=True)
work=work.rename(columns={'h':'value'})
work.value=work.value.str.lstrip(' ').str.rstrip(' ')
table.columns=['t']
mt=table.t.str.split('-(?!C)')
FTable=pd.DataFrame(mt.tolist(), columns = ['value','detail'])
combine=pd.merge(work,FTable,how='left',on='value')
combine.to_excel('//covenas/decisionsupport/medicalthing.xls')
FTable.to_excel('//covenas/decisionsupport/medtable.xls')



#How do I quickly make new columns that hold the three chunks contained in the column 'File'?

recieved messy data like this
d = {   'File' : pd.Series(['firstname lastname                   05/31/1996                 9999999999  ', 'FN SometimesMiddileInitial. LN                    05/31/1996                 9999999999  ']), 
    'Status' : pd.Series([0., 0.]), 
    'Error' : pd.Series([2., 2.])}
df=pd.DataFrame(d)

#In reality, i'm starting from a very messy excel file. so my first attempt looks like 

from pandas import DataFrame, ExcelFile
import pandas as pd
import json


location = r'c:/users/meinzerc/Desktop/table.xlsx'
xls = ExcelFile(location)
table = xls.parse('Sheet1')
df.head()
splitdf = df['File'].str.split('\s*)


