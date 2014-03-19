import pandas as pd
df = DataFrame(pd.read_csv('k:/temp/rulist.csv', index_col=False, header=0))


 * begin program.
 * import pandas as pd
df = DataFrame(pd.read_csv('k:/temp/rulist.csv', index_col=False, header=0))
ruList=[]
for x in df.ru.unique():
   ruList.append(x)
end program.

 * n of cases 10000.
 * exe.
 * save outfile='k:/meinzer/temp/programflowcut.sav'.
get file='k:/meinzer/temp/programflowcut.sav'.



 * GET DATA
  /TYPE=ODBC
  /CONNECT='DSN=mhs;Description=mhs;UID=;Trusted_Connection=Yes;APP=IBM SPSS Products: '+
    'Statistics Common;WSID=HPMXL2221NXK;DATABASE=CG_Snappers'
  /SQL='SELECT REFERRAL_CODE, PROVIDER_NAME FROM CG_Snappers.dbo.[PROVIDER_MASTER]'
  /ASSUMEDSTRWIDTH=255.

 * CACHE.
 * EXECUTE.
 * DATASET NAME DataSet10 WINDOW=FRONT.
 * begin program.
 * from pandas import DataFrame
import pandas as pd
from sqlalchemy import create_engine, MetaData, Table, select

 * # Parameters
ServerName = "BHCSCGDB2"
Database = "CG_Snappers"
TableName = "PROVIDER_MASTER"

 * # Create the connection
engine = create_engine('mssql+pyodbc://' + ServerName + '/' + Database)
conn = engine.connect()

 * # Required for querying tables
metadata = MetaData(conn)

 * # Table to query
tbl = Table(TableName, metadata, autoload=True, schema="dbo")
#tbl.create(checkfirst=True)

 * # Select all
sql = tbl.select()

 * # run sql code
result = conn.execute(sql)

 * # Insert to a dataframe
df = DataFrame(data=list(result), columns=result.keys())

 * # Close connection
conn.close()
ru=DataFrame(df.REFERRAL_CODE)
ru.head()
ruList=[]
for x in ru.REFERRAL_CODE.unique():
   ruList.append(x)
end program.

 * begin program.
 * for item in ruList:
 print item
end program.