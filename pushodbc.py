import os
import re
from pprint import pprint
import shutil, os
from datetime import datetime
import logging
import sys
import socket
if socket.gethostname() =='WinSPSSV4':
    checkmanual=1
else:
    checkmanual=0

logging.basicConfig(filename='//covenas/decisionsupport/meinzer/production/output/pushodbc.log',level=logging.DEBUG)
logging.debug('pushodbc sent '+ str(datetime.now())+' log in //covenas/decisionsupport/meinzer/production/output/pushodbc.log //covenas/decisionsupport/meinzer/production/output/pushodbcPrints.txt')
primaryFolder='//covenas/decisionsupport/meinzer/production/DashboardDatasets/'

class Tee:
    def write(self, *args, **kwargs):
        self.out1.write(*args, **kwargs)
        self.out2.write(*args, **kwargs)
    def __init__(self, out1, out2):
        self.out1 = out1
        self.out2 = out2

sys.stdout = Tee(open("//covenas/decisionsupport/meinzer/production/output/pushodbcPrints.txt", "w"), sys.stdout)

def main():
    print 'Initializing Dashboard List!'
    DBList=initDBList(primaryFolder,checkmanual)
    createPushFiles(primaryFolder,DBList)
    changeDevToProduction()


def initDBList(primaryFolder,checkmanual):
    line1='\ncompute DBcreateDate=$time.'
    line2='\nformat dbcreatedate (datetime23).\n'
    DBList=[]
    for afile in os.listdir(primaryFolder):
          if afile.upper().endswith('.SPS'):
            FileWOext=os.path.splitext(afile)[0]
            FileExt=os.path.splitext(afile)[1]
            DBList.append(FileWOext)
            print str(checkmanual)+ ' checkmanual'
            if checkmanual==1:
                if os.path.isfile('//covenas/decisionsupport/DashboardDataSets/backup2daysold/%s_Dev%s' % (FileWOext,FileExt)):
                 src='//covenas/decisionsupport/DashboardDataSets/backup2daysold/%s_Dev%s' % (FileWOext,FileExt)
                 dst='//covenas/decisionsupport/DashboardDataSets/backup3daysold/%s_Dev%s' % (FileWOext,FileExt)
                 print '1'
                 shutil.move(src,dst)
                if os.path.isfile('//covenas/decisionsupport/DashboardDataSets/backup1dayold/%s_Dev%s' % (FileWOext,FileExt)):                 
                 src='//covenas/decisionsupport/DashboardDataSets/backup1dayold/%s_Dev%s' % (FileWOext,FileExt)
                 dst='//covenas/decisionsupport/DashboardDataSets/backup2daysold/%s_Dev%s' % (FileWOext,FileExt)
                 print '2'                 
                 shutil.move(src,dst) 
                if os.path.isfile('//covenas/decisionsupport/DashboardDataSets/%s_Dev%s' % (FileWOext,FileExt)):
                 src='//covenas/decisionsupport/DashboardDataSets/%s_Dev%s' % (FileWOext,FileExt)
                 dst='//covenas/decisionsupport/DashboardDataSets/backup1dayold/%s_Dev%s' % (FileWOext,FileExt)
                 print '3'                 
                 shutil.copyfile(src,dst)  
                if os.path.isfile(primaryFolder+'%s' % afile):                
                 src=primaryFolder+'%s' % afile
                 dst='//covenas/decisionsupport/DashboardDataSets/%s_Dev%s' % (FileWOext,FileExt)
                 print '4'                 
                 shutil.copy2(src,dst)
                 print 'copying '+src+' to '+ dst
    for syntax in DBList:
     if checkmanual==1:
        src=primaryFolder+'%s.sps' % syntax
        dst='//covenas/decisionsupport/meinzer/production/Backup/%s.sps' % syntax
        shutil.copy2( src,dst)
    return DBList

def createPushFiles(primaryFolder,DBList):
    line1='\ncompute DBcreateDate=$time.'
    line2='\nformat dbcreatedate (datetime23).\n'
    for DBname in DBList:
       list=[]
       list2=[]
       file=primaryFolder+"%s.sps" % DBname
       file2="//covenas/decisionsupport/meinzer/production/push/%spush.sps" % DBname
       file3="//covenas/decisionsupport/meinzer/%s.sps" % DBname
       with open(file, "rb") as f: 
          code=f.read()
          if 'DASHBOARDDATA' in code.upper():
             results=re.split('pushbreak\\.',code,flags=re.M)
             for i in results:
                if 'TYPE=ODBC' in i.upper() and 'GET DATA' not in i.upper() and 'MATCH F' not in i.upper() :
                 if 'OLD PUSH' in i.upper() or 'DO NOT PUSH' in i.upper():
                   print 'the file ', file, '\ndid not convert\n',  i.replace('\r\n',' ')
                 else:  
                   i=i.lstrip('*')
                   i.replace('\r\n',' ')
                   list.append(i)
                # else:
                    # print i
             with open(file3,'w') as test:
                for item in list:
                  test.write(item)
             with open(file3,'r') as makelist:
                 for itemx in makelist:
                   itemx=itemx.lstrip('*')
                   list2.append(itemx)
             with open(file2,'w') as makesyntax:
                for item2 in list2:
                      item3=item2.lstrip()
                      item3=item3.replace('\r\n','\n')
                      item3=item3.lstrip('*')
                      item3=item3.lstrip(' ')
                      if item3.upper().startswith('GET'):
                         item3='\n'+item3+line1+line2
                         makesyntax.write(item3)
                      else:
                         makesyntax.write(item3)
          else:
             print 'no push found in', file
    print 'these files were updated in push'
    print DBList

def changeDevToProduction():
    DBList=[]
    for afile in os.listdir('//covenas/decisionsupport/meinzer/production/push/'):
       if afile.endswith('.sps'):
          FileWOext=os.path.splitext(afile)[0]
          DBList.append(FileWOext)
    for DB in DBList:
       DBname=DB
       DBname2=DBname+"P"
       file="//covenas/decisionsupport/meinzer/production/push/%s.sps" % DBname
       file2="//covenas/decisionsupport/meinzer/production/pushproduction/%s.sps" % DBname2
       print file, file2
       with open(file,"r") as checkforDashFile:
          DashCheck=checkforDashFile.read()
          if 'DASHBOARD' in DashCheck.upper():
             with open(file, "r") as f: 
                c=f.readlines()   
             with open(file2, 'w') as ts:
                for item in c:
                   itemchange=re.compile(re.escape('dashboarddatadev'),re.IGNORECASE)
                   itemswitch=itemchange.sub('DashboardData',item)
                   ts.write(itemswitch)     
# if __name__ == "__main__":  
    # main()
try:
   main()
except:
   logging.exception('Got exception on main handler')
   raise