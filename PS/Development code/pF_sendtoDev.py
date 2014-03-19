import re
import pyodbc
from datetime import datetime
import csv
from datetime import datetime

benchmarkstart=datetime.now()

def sendTOSQL2(csvLocation,sqlTableName):
    with open (csvLocation, 'r') as f:
        reader = csv.reader(f)
        columns = next(reader) 
        query = 'insert into {0}({1}) values ({2})'
        query = query.format(sqlTableName,','.join(columns), ','.join('?' * len(columns)))
        itemchange=re.compile(re.escape('case,'),re.IGNORECASE)
        query=itemchange.sub('"case",',query)
        itemchange=re.compile(re.escape('full,'),re.IGNORECASE)
        query=itemchange.sub('"full",',query)
        print query
        cnxn= pyodbc.connect("DSN=dashboarddatadev")
        cursor = cnxn.cursor()
        for data in reader:
            cursor.execute(query, data)
        cursor.commit()

def sendTOSQL(csvLocation,sqlTableName):
    with open (csvLocation, 'r') as f:
        x=0
        reader = csv.reader(f)
        columns = next(reader) 
        #import pdb; pdb.set_trace();
        for data in reader:
            x=x+1
            if x != 1:
                query = 'insert into {0}({1}) values ({2})'
                query = query.format(sqlTableName,','.join(columns), ','.join('?' * len(columns)))
                itemchange=re.compile(re.escape('case,'),re.IGNORECASE)
                query=itemchange.sub('"case",',query)
                itemchange=re.compile(re.escape('full,'),re.IGNORECASE)
                query=itemchange.sub('"full",',query)
                print query
                cnxn= pyodbc.connect("DSN=dashboarddatadev")
                cursor = cnxn.cursor()
                for data in reader:
                    cursor.execute(query, data)
                cursor.commit()
            else:
                x=x+1


sendTOSQL('//bhcsdbv03/emanio/programflow/ProgramFlow_admitDCOpeneps1.0.csv','ProgramFlow_admitDCOpeneps')
sendTOSQL('//bhcsdbv03/emanio/programflow/ProgramFlow_MCSvccat1.0.csv','ProgramFlow_MCSvccat')
sendTOSQL('//bhcsdbv03/emanio/programflow/ProgramFlow_programflowDaysBetweenVisits1.0.csv','ProgramFlow_programflowDaysBetweenVisits')
#
sendTOSQL('//bhcsdbv03/emanio/programflow/ProgramFlow_BubbleInandSystemCost1.0.csv','ProgramFlow_BubbleInandSystemCost')
sendTOSQL('//bhcsdbv03/emanio/programflow/ProgramFlow_AvePerClientProgramFlow1.0.csv','ProgramFlow_AvePerClientProgramFlow')
sendTOSQL('//bhcsdbv03/emanio/programflow/ProgramFlow_LOSTIS1.0.csv','ProgramFlow_LOSTIS')
sendTOSQL('//bhcsdbv03/emanio/programflow/ProgramFlow_rusPreandPostList1.0.csv','ProgramFlow_rusPreandPostList')
sendTOSQL('//bhcsdbv03/emanio/programflow/ProgramFlow_Programflow_PrePost1.0.csv','ProgramFlow_Programflow_PrePost')


sendTOSQL2('//bhcsdbv03/emanio/programflow/ProgramFlow_BubbleInandSystemCost2.0.csv','ProgramFlow_BubbleInandSystemCost')
sendTOSQL2('//bhcsdbv03/emanio/programflow/ProgramFlow_AvePerClientProgramFlow2.0.csv','ProgramFlow_AvePerClientProgramFlow')
sendTOSQL2('//bhcsdbv03/emanio/programflow/ProgramFlow_LOSTIS2.0.csv','ProgramFlow_LOSTIS')
sendTOSQL2('//bhcsdbv03/emanio/programflow/ProgramFlow_rusPreandPostList2.0.csv','ProgramFlow_rusPreandPostList')
sendTOSQL2('//bhcsdbv03/emanio/programflow/ProgramFlow_Programflow_PrePost2.0.csv','ProgramFlow_Programflow_PrePost')


benchmarkend=datetime.now()
FinishText = benchmarkend.strftime("%m-%d-%y %H:%M")
StartText = benchmarkstart.strftime("%m-%d-%y %H:%M")
Runtimex = str(benchmarkend-benchmarkstart)[0:7]
error_result="""Service and Ep creation
    Start             Finish           Runtime Hrs:Min:Sec
    %s    %s   %s """  % (StartText,FinishText,Runtimex)
    
with open("//covenas/decisionsupport/meinzer/production/output/Error Log.txt", "r+") as myfile:
    old=myfile.read()
    myfile.seek(0)
    myfile.write(error_result+"\n\n"+ old)