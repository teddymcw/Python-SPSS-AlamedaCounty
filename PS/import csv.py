import csv
import pyodbc

def withColumnsSQL(csvFile,SQLTable)
    with open (csvFile, 'r') as f:
        reader = csv.reader(f)
        columns = next(reader) 
        query = 'insert into %s({0}) values ({1})' % SQLTable
        query = query.format(','.join(columns), ','.join('?' * len(columns)))
        cursor = connection.cursor()
        for data in reader:
            cursor.execute(query, data)
        cursor.commit()


def noColumnsSQL(csvFile,SQLTable):
    with open (csvFile, 'r') as f:
        reader = csv.reader(f)
        data = next(reader) 
        query = 'insert into dbo.%s values ({0})' % SQLTable
        query = query.format(','.join('?' * len(data)))
        cursor = connection.cursor()
        cursor.execute(query, data)
        for data in reader:
            cursor.execute(query, data)
        cursor.commit()