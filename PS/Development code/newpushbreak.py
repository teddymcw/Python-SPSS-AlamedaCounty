#push needs to translate out csv
#select one case
#push
#create py file on 
#host call python file to finish

def createPushFiles():
    """ In use updates push and pushproduction files during odbc update"""
    DBList=[]
    primaryFolder='//covenas/decisionsupport/meinzer/production/DashboardDatasets/'
    for afile in os.listdir(primaryFolder):
          if afile.upper().endswith('.SPS'):
            FileWOext=os.path.splitext(afile)[0]
            FileExt=os.path.splitext(afile)[1]
            DBList.append(FileWOext)
    line1='\ncompute DBcreateDate=$time.'
    line2='\nformat dbcreatedate (datetime23).\n'
    for DBname in DBList:
       list=[]
       list2=[]
       file=primaryFolder+"%s.sps" % DBname
       file2="//covenas/decisionsupport/meinzer/production/push/%spush.sps" % DBname
       file3="//covenas/decisionsupport/meinzer/%s.sps" % DBname


file ='//covenas/decisionsupport/meinzer/production/DashboardDatasets/test.sps'
with open(file, "rb") as f: 
  code=f.read()
  if 'PUSHBREAK' in code.upper():
     results=re.split('pushbreak\\.',code,flags=re.M)
     for i in results:
        if 'SKIPROW' in i.upper():
            skipRow=1
        else:
            skipRow=0
        if 'SQLTABLE' in i.upper():
         if 'OLD PUSH' in i.upper() or 'DO NOT PUSH' in i.upper():
           print 'the file ', file, '\ndid not convert\n',  i.replace('\r\n',' ')
         else:  
           m = re.search('(?<=sqltable)\s*\=\s*\w+',i,flags=re.I)
           print m.group(0)
           m = re.search('(?<=spsstable\=\)\s*\S',i,flags=re.I)
           print m.group(0)
           print skipRow
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