import pandas as pd
import numpy as np
import datetime
parser = lambda x: pd.to_datetime(x, format='%m/%d/%Y', coerce=True)
epscg=pd.DataFrame(pd.read_csv('//covenas/decisionsupport/meinzer/pandas/epscg.csv',parse_dates=['opdate','closdate','lst_svc','LastService'],date_parser=parser))
clinfo=pd.DataFrame(pd.read_csv('//covenas/decisionsupport/meinzer/pandas/clinfo.csv',parse_dates=['bday','created'],date_parser=parser))
procedsma=pd.DataFrame(pd.read_csv('//covenas/decisionsupport/pandas/procedsma.csv'))
ru=pd.DataFrame(pd.read_csv('//covenas/decisionsupport/meinzer/pandas/rutable.csv'))


# get file='k:\eps_year_2013.sav' 
#    /keep ru case opdate emp_ent staff epflag primdx sec_dx1 lst_svc.
df=epscg[(epscg.opdate < datetime.datetime(2014,1,1)) & ((epscg.closdate >= datetime.datetime(2013,1,1)) | epscg.closdate.isnull())] 
df['closdate'].min()
df['opdte'].max()
df.epflag.value_counts()
df=df[df.epflag=='O'].value_counts()
eps=pd.merge(eps,ru,how='left',on='ru')