import pandas as pd
import datetime
import pyodbc
sql="""select * from Episodes"""
cnxn= pyodbc.connect("DSN=mhs")
episodes=pd.read_sql(sql,cnxn)

sql="""select * from staff_master
       where opdate <= '2011-7-1' AND opdate >= '2010-7-1'"""
cnxn= pyodbc.connect("DSN=dashboarddatadev")
staff=pd.read_sql(sql,cnxn)