pd.to_datetime(s, format='%d/%m/%Y')
#five departments with the most distinct titles
by_dept.title.nunique().order(ascending=False)[:5]



names = ['Bob','Jessica','Mary','John','Mel']
births = [968, 155, 77, 578, 973]
BabyDataSet = zip(names,births)
df = DataFrame(data = BabyDataSet, columns=['Names', 'Births'])
df.dtypes
df.Births.dtype

df[['Names','Births']]
# df['ColumnName'][inclusive:exclusive]
df['Names'][0:3]
df['col'][5:]
df[['col', 'test']][:3]

#rename variable name
df = df.rename(columns={'$a': 'a', '$b': 'b'})

#sort the file

Sorted = df.sort(['Births'], ascending=[0])
Sorted.head(1)

df['Births'].max()

#select if
dfx=df[df['Births'] == df['Births'].max()]

#IS EQUAL TO [Find all of the records in the Births column where it is equal to 973]
[df['Births'] == df['Births'].max()] 

#IS EQUAL TO Select all of the records in the Names column WHERE [The Births column is equal to 973]
df['Names'][df['Births'] == df['Births'].max()] 

df['Births'].plot()

# Maximum value in the data set
MaxValue = df['Births'].max()

# Name associated with the maximum value
MaxName = df['Names'][df['Births'] == df['Births'].max()].values

# Text to display on graph
Text = str(MaxValue) + " - " + MaxName

# Add text to graph
plt.annotate(Text, xy=(1, MaxValue), xytext=(8, 0), 
                 xycoords=('axes fraction', 'data'), textcoords='offset points')
                 
plt.show()

#unique
df['Names'].unique()
for x in df['Names'].unique():
    print x

print df['Names'].describe()

#2
# Create a groupby onject
Name = df.groupby(df['Names'])


#delete a column
del df['Names']


# Import libraries
from pandas import ExcelFile, DataFrame, concat, date_range
import pandas as pd
import matplotlib.pyplot as plt
import numpy as np

df.to_excel('Lesson3.xlsx', index=False)

# Location of file
Location = r'C:\Users\hdrojas\.xy\startups\Lesson3.xlsx'

# Create ExcelFile object
xlsx = ExcelFile(Location)

# Parse a specific sheet
df = xlsx.parse('sheet1',index_col='StatusDate')
df.dtypes
#list index
df.index

#convert to upper
df.Names = df.Names.apply(lambda x: x.upper())
# Only grab where Status == 1
df = df[df['Status'] == 1]

#- For all records in the State column where they are equal to NJ, replace them with NY.
df.Names[df.Names == 'BOB'] = 'Chet' 
df.Names[df.Names == 'Chet'] = 'John'
df.Names[df.Names == 'MARY'] = 'John'

#agg by Names to get Sum
Daily = df.reset_index().groupby(['Names']).sum()
Daily.head()


data = [1000,2000,3000]
idx = date_range(start='12/31/2011', end='12/31/2013', freq='A')
BHAG = DataFrame(data, index=idx, columns=['BHAG'])
BHAG

combine datasets
#Remember when we choose axis = 0 we are appending row wise.
combined = concat([ALL,BHAG], axis=0)







svc2=pd.DataFrame(pd.read_csv('//covenas/decisionsupport/services10_qtr2.csv'))
svc=pd.DataFrame(pd.read_csv('//covenas/decisionsupport/meinzer/tables/services13_qtr1.csv'))
eps=pd.DataFrame(pd.read_csv('//covenas/decisionsupport/meinzer/tables/eps_year_2013.csv'))
ru=pd.DataFrame(pd.read_csv('//covenas/decisionsupport/meinzer/tables/rutable.csv'))

values=['00621','00622','01012','01011']
values2=['00621','00622','01012','01011','01D31','01D32','01D33']
values3=['00621','00622','01012','01011','01D31','01D32','01D33','01016']

eps=eps[eps.ru.isin(values3)]
ru=ru[ru.ru.isin(values)]
svc=svc[svc.ru.isin(values2)]

pd.merge(eps,ru,on='ru')
pd.ix[:5,:5]

eps[counter]=1
eps.groupby('ru').max()


first or last by

lst = [1, 2, 3, 1, 2, 3]

s = Series([1, 2, 3, 10, 20, 30], lst)

grouped = s.groupby(level=0)

grouped.first()


grouped.last()

grouped.sum()





#eps=eps[eps['ru'].isin(['00622','00621','01012'])]
#eps=eps[(epsdf.ru ==  '00621') | (epsdf.ru == '00622') | (epsdf.ru =='01011') | (epsdf.ru == '01012')]





#casetovars varstocases

d = {'one':[1,1],'two':[2,2]}
i = ['a','b']

# Create dataframe
df = DataFrame(data = d, index = i)
df

#varstocases
df.stack()

#casestoVars
df.unstack()



#aggregate
d = {'one':[1,1,1,1,1],'two':[2,2,2,2,2],'letter':['a','a','b','b','c']}

# Create dataframe
df = DataFrame(d)
df

one = df.groupby('letter')

# Apply sum function
one.sum()
letterone = df.groupby(['letter','one']).sum()
letterone

#You may want to not have the columns you are grouping by become your index, this can be easily achieved as shown below.

letterone = df.groupby(['letter','one'], as_index=False).sum()
letterone






#combine datasets or addfiles
# Create a dataframe with dates as your index
States = ['NY', 'NY', 'NY', 'NY', 'FL', 'FL', 'GA', 'GA', 'FL', 'FL'] 
data = [1.0, 2, 3, 4, 5, 6, 7, 8, 9, 10]
idx = date_range('1/1/2012', periods=10, freq='MS')
df1 = DataFrame(data, index=idx, columns=['Revenue'])
df1['State'] = States

# Create a second dataframe
data2 = [10.0, 10.0, 9, 9, 8, 8, 7, 7, 6, 6]
idx2 = date_range('1/1/2013', periods=10, freq='MS')
df2 = DataFrame(data2, index=idx2, columns=['Revenue'])
df2['State'] = States

# Combine dataframes
df = concat([df1,df2])
df


#calculate outliers

df['x-Mean'] = abs(df['Revenue'] - df['Revenue'].mean())
df['1.96*std'] = 1.96*df['Revenue'].std()  
df['Outlier'] = abs(df['Revenue'] - df['Revenue'].mean()) > 1.96*df['Revenue'].std()
df


#group by lambda!
df = concat([df1,df2]) #reset dataframe to prevent error

# Method 2
# Group by multiple items

StateMonth = df.groupby(['State', lambda x: x.month])

df['Outlier'] = StateMonth.transform( lambda x: abs(x-x.mean()) > 1.96*x.std() )
df['x-Mean'] = StateMonth.transform( lambda x: abs(x-x.mean()) )
df['1.96*std'] = StateMonth.transform( lambda x: 1.96*x.std() )
df





df = concat([df1,df2]) #reset dataframe to prevent error

# Method 3
# Group by item

State = df.groupby('State')

def s(group):
    group['x-Mean'] = abs(group['Revenue'] - group['Revenue'].mean())
    group['1.96*std'] = 1.96*group['Revenue'].std()  
    group['Outlier'] = abs(group['Revenue'] - group['Revenue'].mean()) > 1.96*group['Revenue'].std()
    return group

Newdf = State.apply(s)
Newdf



df = concat([df1,df2]) #reset dataframe to prevent error

# Method 3
# Group by multiple items

StateMonth = df.groupby(['State', lambda x: x.month])

def s(group):
    group['x-Mean'] = abs(group['Revenue'] - group['Revenue'].mean())
    group['1.96*std'] = 1.96*group['Revenue'].std()  
    group['Outlier'] = abs(group['Revenue'] - group['Revenue'].mean()) > 1.96*group['Revenue'].std()
    return group

Newdf = StateMonth.apply(s)
Newdf




# Convert data types 
df.Date = df.Date.astype('datetime64')
df.StandardDate = df.StandardDate.astype('datetime64')
df.DateSK = df.DateSK.astype('int')
df.Day = df.Day.astype('int')
df.DOWInMonth = df.DOWInMonth.astype('int')
df.DayOfYear = df.DayOfYear.astype('int')
df.WeekOfYear = df.WeekOfYear.astype('int')
df.WeekOfMonth = df.WeekOfMonth.astype('int')
df.Month = df.Month.astype('int')
df.Quarter = df.Quarter.astype('int')
df.Year = df.Year.astype('int')

print 'Data Types'
print df.dtypes


#From Excel to DataFrame
from pandas import DataFrame, ExcelFile
import pandas as pd
import json


# Path to excel file
# Your path will be different, please modify the path below.
location = r'//covenas/decisionsupport/meinzer/projects/network/Contract Deliverables for Emanio Reports.xls'

# Create ExcelFile object
xls = ExcelFile(location)

# Parse the excel file
df = xls.parse('contracts')
df.head()

import pandas as pd
from datetime import datetime
d = {'ru' : pd.Series([1., 1., 1.,1]),
   'case' : pd.Series([2., 2., 2., 2.]),
      'opdate' : pd.Series([datetime(2012, 5, 2), datetime(2012, 5, 2), datetime(2012, 5, 2),datetime(2012, 5, 2)]),
   'lst_svc' : pd.Series([datetime(2012, 5, 2), datetime(2012, 5, 3), datetime(2012, 5, 5),datetime(2012, 5, 5)])}

df=pd.DataFrame(d)

df['lastMark'] = (df.groupby(['ru','case','opdate'])['lst_svc'].transform(max) == df['lst_svc']).astype(int)

Sorted = df.sort(['ru','case','opdate','lst_svc'], ascending=[0])
grouped=Sorted.groupby(['ru','case','opdate'])
last=grouped.max().reset_index()
last['lastMark']=1
matched=pd.merge(Sorted,last,how='left',on=['ru','case','opdate','lst_svc'])




by_dept.size().tail() # total records for each department

import os
def x(table):
    list=[]
    for item in table.columns:
        list.append(item)
    text='","'.join(list)
    command = 'echo ' + text.strip() + '| clip'
    os.system(command)

# if you literally want to mark the records theres a bunch of ways
def f(s):
    s2 = pd.Series(0, index=s.index)
    s2.iloc[-1] = 1
    return s2


eps=pd.DataFrame(pd.read_csv('//covenas/decisionsupport/meinzer/tables/eps_year_2013.csv'))[['ru', 'case', 'opdate', 'emp_ent', 'staff', 'epflag', 'primdx', 'sec_dx1', 'lst_svc']]
eps=eps[eps['epflag'] =='O']
ru=pd.DataFrame(pd.read_csv('//covenas/decisionsupport/meinzer/tables/rutable.csv'))
eps=pd.merge(eps,ru,how='left',on='ru')
epss=eps[eps['psmask2'] == '513']
epss.program.fillna(0)

epsx=epss[epss.program == '0']
epsx['initmark']=1
epsx.initmark.sum()
df=epsx
df['lastMark'] = (df.groupby(['ru','case','opdate'])['lst_svc'].transform(max) == df['lst_svc']).astype(int)
df=df[df.lastMark == 1]
df.lastMark.sum()
clinfo=pd.DataFrame(pd.read_csv('//covenas/decisionsupport/meinzer/tables/clinfo.csv'))
epsclinfo=pd.merge(eps,clinfo,how='left',on='case')
nc=epsclinfo.rename(columns={'name':'ClientName','primdx':'dx'})

dxtable=pd.DataFrame(pd.read_csv('//covenas/decisionsupport/meinzer/tables/dxtable.csv'))
epsdx=pd.merge(nc,dxtable,how='left',on='dx')
nc1=epsdx.rename(columns={'dx':'Primdx', 'dx_descr': 'Primdx_descr', 'dx_grpDSM':'Primdx_grpdsm'})
nc2=nc1.rename(columns={'sec_dx1' :'dx'})
epsdx2=pd.merge(nc2,dxtable,how='left',on='dx')
nc3=epsdx2.rename(columns={'dx':'SecDx','dx_descr':'SecDx_descr','dx_grpDSM':'SecDx_grpDSM'})

staff=pd.DataFrame(pd.read_csv('//covenas/decisionsupport/meinzer/tables/staff.csv'))
StaffMerge=pd.merge(nc3,staff,how='left',on='staff')[["ru","provname","agency","case","opdate","emp_ent","Primdx","SecDx",
"ClientName","bornname","Primdx_descr","Primdx_grpdsm","SecDx_descr","SecDx_grpDSM","name",'educ','lst_svc']]
nc4=StaffMerge.rename(columns={'name' :'StaffName','emp_ent':'emp'}) 
nc4.educ.fillna(99)
df=nc4
df['edLevel']=''
df.ix[df.educ < 6, ['edLevel']] = "Elementary School"
df.ix[(df.educ > 5) & (df.educ < 9), ['edLevel']] = "Middle School"
df.ix[(df.educ >= 9) & (df.educ < 12), ['edLevel']] = "Some High School"
df.ix[df.educ == 12, ['edLevel']] = "High School Graduate"
df.ix[(df.educ >= 13) & (df.educ <= 15), ['edLevel']] = "Some College"
df.ix[(df.educ >= 16),['edLevel']] =  "College Graduate or More"
df.ix[df.educ == 99, ['edLevel']] ="Missing"


df.ix[df.educ.last(), ['edLevel']] ="final"
grouped=(df.groupby(['Primdx_grpdsm'])
df['PrimDSMgrpCase1'] = grouped['case'].transform(max) == df['case']).astype(int)

dfeped = df.sort(['ru','case','opdate','lst_svc'],ascending=True).drop_duplicates(['case','ru','opdate'],take_last=True)
# if you literally want to mark the records theres a bunch of ways
# def f(s):
    # s2 = pd.Series(0, index=s.index)
    # s2.iloc[-1] = 1
    # return s2

# df["lastMark"] = df.groupby(['ru','case','opdate'])['lst_svc'].apply(f)
# df

# ep1=df.sort(['ru','case','opdate','lst_svc'],ascending=True).drop_duplicates(['case','ru','opdate'],take_last=True).index
# df['ep1']=0
# df['ep1'].iloc[ep1] =1


svc2=pd.DataFrame(pd.read_csv('//covenas/decisionsupport/services10_qtr2.csv',parse_dates=True))
svc=pd.DataFrame(pd.read_csv('//covenas/decisionsupport/meinzer/tables/services13_qtr1.csv',,parse_dates=True))
dfsvc=pd.concat([svc,svc2])
#svcconcat.svcdate.head(22)
#svcconcat.svcdate.tail(22)

df=dfsvc[~dfsvc.proced.isin([300,400,197])]
df[df.svcdate > datetime(2012, 6, 5)]


from datetime import datetime
d = {'ru' : pd.Series([1., 1., 1.,3, 3,3,3]),
   'case' : pd.Series([2., 2., 2., 2., 2,2,2]),
      'opdate' : pd.Series([datetime(2012, 5, 2), datetime(2012, 5, 2), datetime(2012, 5, 2),datetime(2012, 5, 2), datetime(2012, 5, 3),datetime(2012, 5, 3),datetime(2012, 5, 2)]),
   'lst_svc' : pd.Series([datetime(2012, 5, 2), datetime(2012, 5, 3), datetime(2012, 5, 5),datetime(2012, 5, 5),datetime(2012, 6, 5),datetime(2012, 5, 2)])}

df=pd.DataFrame(d)

def f(s):
    s2 = pd.Series(0, index=s.index)
    s2.iloc[-1] = 1
    return s2

df["PrimDSMgrpCase1"] = df.groupby(['Primdx_grpdsm','case'])['case'].apply(f)
df

ep1=df.sort(['ru','case','opdate','lst_svc'],ascending=True).drop_duplicates(['case','ru','opdate'],take_last=True).index
df['ep1']=0
df['ep1'].iloc[ep1] =1

df.opdate[df.lst_svc.idxmin()]

df.xs(df.ru.idxmax())

df[df.ru.isin([1,2])]
df[df.lst_svc > datetime(2011, 6, 5)]
To return a Series of the same shape as the original

In [102]: s.where(s > 0)

df.ru=df.ru.where(df.ru > 1,9)
df[df.ru >5]=1

#nulls
df['Provname '][pd.isnull(df.ru)]



