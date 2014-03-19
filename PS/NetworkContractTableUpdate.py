import pandas as pd
import xlrd
xl = pd.ExcelFile(r"\\Covenas\A&D_Fin\Network Office\Contract Monitoring\EMANIO\Contract Deliverables for Emanio Reports.xlsx")

xl.sheet_names  # in your example it may be different

#dfs = {sheet: xl.parse(sheet) for sheet in xl.sheet_names}
#dfs['contracts']
df =xl.parse('contracts')
df.rename(columns = {'Total Hours' : 'CDtotalhours',"Days" : "CDDays", "Provname" : "ProvnameNetwork"}, inplace=True)
df.drop(['agency','provnameDecSupp'],1,inplace=True)
df['FiscalYear']=df.FiscalYear.apply(lambda x: 'FY '+str(x))
df.drop(['Notes'],1,inplace=True)
df.to_csv("//covenas/decisionsupport/meinzer/tables/networkContractUpdate.csv",sep=',',encoding='utf-8')
