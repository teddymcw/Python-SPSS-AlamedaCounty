from pandas import DataFrame
import pandas as pd
from sqlalchemy import create_engine, MetaData, Table, select
import datetime
import pyodbc
import numpy as np

cnxn= pyodbc.connect("DSN=dashboarddatadev")
sql='select * from table'
data=pd.read_sql(sql,cnxn)

ru=pd.DataFrame(pd.read_csv('//covenas/decisionsupport/meinzer/production/backup/csv/rutable.csv'))
parser = lambda x: pd.to_datetime(x, format='%m/%d/%Y', coerce=True)
epscg=pd.DataFrame(pd.read_csv('//covenas/decisionsupport/meinzer/production/backup/csv/epscg.csv',parse_dates=['opdate','closdate','lst_svc','LastService'],date_parser=parser))
clinfo=pd.DataFrame(pd.read_csv('//covenas/decisionsupport/meinzer/production/backup/csv/clinfo.csv',parse_dates=['bday','created'],date_parser=parser))
procedsma=pd.DataFrame(pd.read_csv('//covenas/decisionsupport/meinzer/production/backup/csv/procedsma.csv'))
ru=pd.DataFrame(pd.read_csv('//covenas/decisionsupport/meinzer/production/backup/csv/rutable.csv'))

now=datetime.datetime.now()
if now.day > 15:
    UncookedMonth=(now-datetime.timedelta(days=now.day))-datetime.timedelta(((now-datetime.timedelta(days=now.day)).day-1))
else:
    UncookedMonth=(now-datetime.timedelta(days=now.day-1))

DBstartdate=datetime.datetime(2012,7,1)

sql="""select * from epscg
       where opdate > '2012-7-1'"""
es=pd.read_sql(sql,cnxn)

df=es[(es.opdate < UncookedMonth) & ((es.closdate > DBstartdate) | es.closdate.isnull()) | (es.closdate < datetime.datetime(1901,7,1))]
# test=epscg[epscg.case==461401]

#df.closdate.replace((df.closdate==datetime.datetime(1900,1,1)),np.nan)
df['closdate'] = df.closdate.apply(lambda x: np.nan if x==datetime.datetime(1900,1,1) else x)
df = df.applymap(lambda x: np.nan if x==datetime.datetime(1900,1,1) else x)
# ru=pd.DataFrame(pd.read_csv('//covenas/decisionsupport/meinzer/production/backup/csv/rutable.csv'))

sql="""select * from rutable"""
ru=pd.read_sql(sql,cnxn)

epru=pd.merge(df,ru,how='left',on='ru')
epru.program.replace[' ','0']

epBase=epru[epru.program=='0']

epsbycase=df[['ru','provname','agency','case','opdate','closdate','primdx','primarytherapist','lastservice','epflag']]
# matched=pd.merge(Sorted,last,how='left',on=['ru','case','opdate','lst_svc'])

df['closdate'] = df.closdate.apply(lambda x: datetime.datetime.today()+datetime.timedelta(days=55) if pd.isnull(x) else x)
countMonths=(datetime.datetime.now()-DBstartdate).days/30

df['ep1'] = df.opdate.apply(lambda x: x if x > DBstartdate else DBstartdate)



df['ep1'] = df.ep1.apply(lambda x: datetime.datetime(x.year,x.month,1))
df['ep2'] = df.ep1.apply(lambda x: datetime.datetime((x+datetime.timedelta(days=40)).year,(x+datetime.timedelta(days=40)).month,1))
df['ep3'] = df.ep2.apply(lambda x: datetime.datetime((x+datetime.timedelta(days=40)).year,(x+datetime.timedelta(days=40)).month,1))

import numpy as np
from pandas import Timestamp

months = range(1, 13)
df['ep0'] = df.opdate.where(df.opdate > Timestamp('20140101'), Timestamp('20140101'))
for month in months:
    colname = 'ep%d' % month
    prev_colname = 'ep%d' % (month - 1)
    df[colname] = df[prev_colname] + np.timedelta64(40, 'D')
    df[colname] = (df[prev_colname] + np.timedelta64(40, 'D')).datetime.replace(day=1)

datetime.datetime(df[prev_colname] + np.timedelta64(40, 'D').year,df[prev_colname] + np.timedelta64(40, 'D').month,1)