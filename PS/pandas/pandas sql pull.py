# Import libraries
from pandas import DataFrame
import pandas as pd
from sqlalchemy import create_engine, MetaData, Table, select

# Parameters
ServerName = "BHCSDBV03"
Database = "dashboarddatadev"
TableName = "dashboard_eps3years"

# Create the connection
engine = create_engine('mssql+pyodbc://' + ServerName + '/' + Database)
conn = engine.connect()

# Required for querying tables
metadata = MetaData(conn)

# Table to query
tbl = Table(TableName, metadata, autoload=True, schema="dbo")
#tbl.create(checkfirst=True)

# Select all
sql = tbl.select()

# run sql code
result = conn.execute(sql)

# Insert to a dataframe
df = DataFrame(data=list(result), columns=result.keys())

# Close connection
conn.close()

print 'Done'
df=rutable
from pandas.io import sql
import pyodbc
con= pyodbc.connect("DSN=dashboarddatadev")
sql.write_frame(df, con=con, name='table_name_for_df', 
                if_exists='replace', flavor='mysql')

