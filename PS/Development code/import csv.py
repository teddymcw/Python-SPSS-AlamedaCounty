import csv
import pyodbc
with open ('//covenas/decisionsupport/meinzer/production/output/errorcsv.csv', 'r') as f:
    reader = csv.reader(f)
    columns = next(reader) 
    query = 'insert into MyTable({0}) values ({1})'
    query = query.format(','.join(columns), ','.join('?' * len(columns)))
    cursor = connection.cursor()
    for data in reader:
        cursor.execute(query, data)
    cursor.commit()



    