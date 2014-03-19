import pyodbc
cnxn= pyodbc.connect("DSN=dashboarddatadev")
cursor = cnxn.cursor()
cursor.execute("create table abc123(agency varchar(100), ethnicity varchar(30))")
cursor.commit()

import pyodbc, csv

connect_string = 'DRIVER={SQL Server};SERVER=some_hostname_or_ip_here;DATABASE=some_database;UID=some_user;PWD=some_password'
connect_string = "DSN=dashboarddatadev"

def get_data(tblName, cnxn):
    cursor = cnxn.cursor()
    cursor.execute('SELECT * FROM %s' %(tblName))
    return [row for row in cursor]

def get_columns(tblName, cnxn):
    cursor = cnxn.cursor()
    cursor.execute("SELECT * FROM INFORMATION_SCHEMA.Columns WHERE TABLE_NAME = '%s'" %(tblName))
    return [row[3] for row in cursor]

def qexport(tblName):
    connection = pyodbc.connect(connect_string)
    outfile = open('%s.csv' %(tblName), 'wb')
    writer = csv.writer(outfile)
    writer.writerow(get_columns(tblName, connection))
    writer.writerows(get_data(tblName, connection))
    outfile.close()

if __name__ == "__main__":
    import sys
    qexport(sys.argv[1])

import pyodbc
import re

def sendTOSQL(csvLocation,sqlTableName):
    with open (csvLocation, 'r') as f:
        reader = csv.reader(f)
        columns = next(reader) 
        query = 'insert into {0}({1}) values ({2})'
        query = query.format(sqlTableName,','.join(columns), ','.join('?' * len(columns)))
        itemchange=re.compile(re.escape('case'),re.IGNORECASE)
        query=itemchange.sub('"case"',query)
        print query
        cnxn= pyodbc.connect("DSN=dashboarddatadev")
        cursor = cnxn.cursor()
        for data in reader:
            cursor.execute(query, data)
        cursor.commit()

Consider building the query dynamically to ensure the number of placeholders matches your table and CSV file format. Then it's just a matter of ensuring your table and CSV are correct, instead of checking that you typed enough ? placeholders in your code.

The following sample assumes the CSV contains column names in the first line, connection is already built, file name is test.csv, and table name is MyTable, and Python 3:

...
with open ('k:/temp/testsql.csv', 'r') as f:
    reader = csv.reader(f)
    columns = next(reader) 
    query = 'create table adeletechettest({0}) values ({1})'
    query = query.format(','.join(columns), ','.join('?' * len(columns)))
    cnxn= pyodbc.connect("DSN=dashboarddatadev")
    cursor = cnxn.cursor()
    for data in reader:
        cursor.execute(query, data)
    cursor.commit()




connection = pyodbc.connect('DRIVER={SQL Server};SERVER=yourServer;DATABASE=yourDatabase;UID=yourUsername;PWD=yourPass')

#then to call the database just use a cursor 
cur = connection.cursor() 
cur.execute("SELECT tablex.id, tablex.name FROM tablex")

for row in cur:
    print "ID: %s"% row.id
    print "NAME: %s" row.name

##OR the one-line way

cur.execute("SELECT tablex.id, tablex.name FROM tablex")

resultList = [(row.id, row.name) for row in cur]



cnxn = pyodbc.connect('DRIVER={SQL Server};SERVER=bhcsdbv03;DATABASE=dashboarddatadev;UID=meinzerc')
cursor = cnxn.cursor()

#Make a connection using a DSN. Since DSNs usually don't store passwords, you'll probably need to provide the PWD keyword.

cnxn = pyodbc.connect('DSN=test;PWD=password')
cursor = cnxn.cursor()


SAVE TRANSLATE /TYPE=ODBC
/Connect ='DSN=DashboardDatadev;UID=;APP=SPSS For'+
' Windows;WSID=HPMXL9360ZDD;DATABASE=DashboardDatadev;Trusted_Connection=Yes'
/table= 'CSOC_ConsecutiveHighLevelSvcsClientList' /MAP/REPLACE.


>>> cursor.execute("create table tmp(a int, b varchar(30))")
<pyodbc.Cursor object at 0x0B408758>
>>> cnxn.commit()

import pyodbc
cnxn= pyodbc.connect("DSN=dashboarddatadev")

>>> cursor = cnxn.cursor()
>>> cursor.execute("create table aaachettest(a int, b varchar(30))")
<pyodbc.Cursor object at 0x01F23800>
>>> cursor.commit()



