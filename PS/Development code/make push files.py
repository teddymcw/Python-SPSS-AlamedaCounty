def createPushFiles(primaryFolder,DB):
    line1='\ncompute DBcreateDate=$time.'
    line2='\nformat dbcreatedate (datetime23).\n'
    list=[]
    list2=[]
    file=primaryFolder+"%s.sps" % DB
    file2="//covenas/decisionsupport/meinzer/production/push/%spush.sps" % DB
    file3="//covenas/decisionsupport/meinzer/%s.sps" % DB
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

def changeDevToProduction():
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