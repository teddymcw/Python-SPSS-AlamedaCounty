from pandas import DataFrame, ExcelFile
import pandas as pd
import json
from pandas import ExcelWriter

def save_xls(list_dfs, xls_path):
    writer = ExcelWriter(xls_path)
    for n, df in enumerate(list_dfs):
        df.to_excel(writer,'sheet%s' % n)
    writer.save()
    
import os

def x(table):
    list=[]
    for item in table.columns:
        list.append(item)
    text='","'.join(list)
    command = 'echo ' + text.strip() + '| clip'
    os.system(command)
    
    

# Path to excel file
# Your path will be different, please modify the path below.
location = r'//covenas/decisionsupport/meinzer/projects/network/Contract Deliverables for Emanio Reports2.xlsx'
xls = ExcelFile(location)
# Parse the excel file
df = xls.parse('contracts')
#df.head()
df[df.ru=='NaN']

df=df.rename(columns={'Provname ':'ProvnameNetwork'})
ru=pd.DataFrame(pd.read_csv('//covenas/decisionsupport/meinzer/tables/rutable.csv'))
df['ru']=df['ru'].apply(str)
df['ru'] = df['ru'].str.replace(r'#', '')
df['ru'] = df['ru'].str.replace(r'\.0', '')
df[['ru']].head(55)
df2=pd.merge(df,ru,on='ru',how='left')
df[['ru']].head(55)
df2=df2.rename(columns={'ProvnameNetwork':'Provname','provname':'provnameDecSupp'})
df3=df2[["agency","provnameDecSupp","ru","Provname","FiscalYear","Clients","ClientsPerMonth","Days",\
"# Case Mgmt Hrs","# Mental Health Hrs","# Med Support Hrs","# Crisis Intervention Hrs","Other Hours","Total Hours"]]
df3.head(33)
df3.to_excel(r'//covenas/decisionsupport/network office/Contract Deliverables for Emanio Reports.xls',index=False,sheet_name='contracts')

ru","svcmode","ab3632RU","DayTx","OutCty","RU2","provname","agency","psmask2","EPSDTGroup","cds_Code","OurKids","SafePassages","school","kidsru","Level3Classic","TAYru","CESDC","svcType","county","svcType3","Level2","start_dt","end_dt","MHSA","OAru","program","Residential","CalWorks","RUCITY","UMBRELLA","frc
ru","Provname ","FiscalYear","Clients","ClientsPerMonth","Days","# Case Mgmt Hrs","# Mental Health Hrs","# Med Support Hrs","# Crisis Intervention Hrs","Other Hours","Total Hours
