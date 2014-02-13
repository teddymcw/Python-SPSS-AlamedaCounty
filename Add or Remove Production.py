##requires spss 22

import re, shutil, os, sys
from subprocess import Popen
from subprocess import call
import socket
from datetime import datetime
import logging
from os import walk

primaryFolder='//covenas/decisionsupport/meinzer/production/DashboardDatasets/'

logging.basicConfig(filename='//covenas/decisionsupport/meinzer/production/output/productionMenu.log',level=logging.DEBUG)
logging.debug('Production System '+ str(datetime.now())+' log in //covenas/decisionsupport/meinzer/production/output/productionSystem.log //covenas/decisionsupport/meinzer/production/output/ProductionMenduDeBug.txt')

def main():
    """ the function pusher """
    print 'welcome to Buisness Analytics Dashboard Push System!\n'
    removeOrAdd,DB = promptInfo1()
    if removeOrAdd.upper()=='R':
        remove(DB)
        checkInsert(DB)
        returnMain()
    elif removeOrAdd.upper()=='U': 
        DB=StageMove(DB)
        createPushFilesx(primaryFolder,DB)
        changeDevToProductionx(DB)
        returnMain()
    elif removeOrAdd.upper()=='A':
        ErrorAlertDays,DevProdBoth = promptInfo2()
        AddInsert  = createSyntax(ErrorAlertDays,DevProdBoth,DB) 
        placeInsert(AddInsert)
        returnMain()
    elif removeOrAdd.upper()=='C':
        createFiles(DB)
        returnMain()
    elif removeOrAdd.upper()=='O':
        #loadPushODBC()
        createPushFiles()
        changeDevToProduction()
        returnMain()
    elif removeOrAdd.upper()=='L':
        LookInsert()
        raw=raw_input('hit anykey for main menu')
        returnMain()
    elif removeOrAdd.upper()=='P':
        # createFilesGeneric()
        createSyntaxGeneric(DB)
        # runBat()   
        #returnMain()
    elif removeOrAdd.upper()=='W':
        washDash()
        raw=raw_input('\nhit anykey for main menu')
        returnMain()
    elif removeOrAdd.upper()=='S':
        mypath=raw_input('path to start-will continue through subfolders\n')
        endFill=raw_input('type of file+exention or just extention\n    .sps gets all syntax or graphics.sps will get demographics.sps\n')
        changeEnd(mypath,endFill)        
        returnMain()

def changeEnd(mypath,endFill):
    """ changes mapped drive references to UNC so no more k: and I: because server edition only does UNC"""
    list=[]
    fails=[]
    f = []
    for (dirpath, dirnames, filenames) in walk(mypath):
        for file in filenames:
            f.append(dirpath+'/'+file)
    [list.append(i) for i in f if i.upper().endswith(endFill.upper())] 
    for file in list:
        print file
        try:
            with open(file, "r") as f: 
                c=f.readlines() 
            with open(file, 'w') as ts:
                for item in c:
                    print item
                    itemchange=re.compile(re.escape('k:/'),re.IGNORECASE)
                    itemswitch=itemchange.sub('//covenas/decisionsupport/',item)
                    itemchange=re.compile(re.escape('k:\\'),re.IGNORECASE)
                    itemswitch=itemchange.sub('//covenas/decisionsupport/',itemswitch)
                    itemchange=re.compile(re.escape('i:/'),re.IGNORECASE)
                    itemswitch=itemchange.sub('//covenas/spssdata/',itemswitch)
                    itemchange=re.compile(re.escape('i:\\'),re.IGNORECASE)
                    itemswitch=itemchange.sub('//covenas/spssdata/',itemswitch)
                    itemchange=re.compile(re.escape('k:'),re.IGNORECASE)
                    itemswitch=itemchange.sub('//covenas/decisionsupport/',itemswitch)
                    itemchange=re.compile(re.escape('i:'),re.IGNORECASE)
                    itemswitch=itemchange.sub('//covenas/spssdata/',itemswitch)
                    #print itemswitch
                    ts.write(itemswitch) 
        except Exception,e:
            print e
            fails.append(file)
    if fails:
        print 'There Were ERRORS!\n'
    else:
        fails.append('No Errors\n')
    for item in fails:
        print item
    print 'these files were analyzed\n'
    for file in list:
        print file 

def returnMain():
    """ go back to main menu """
    main()

def loadPushODBC():
    """ will create wash dashboarddatasets folder if on V4 otherwise runs just push file creation"""
    sys.path.append('//covenas/decisionsupport/meinzer/production/ps/')
    import pushodbc
    
def LookInsert():
    """ browse the pushes in the insert files """
    list=[]
    whatFile = raw_input('DashboardDatasets, stage or insert\n')
    if whatFile.upper() in 'DASHBOARDDATASETS':
        whatFile='meinzer/production/dashboarddatasets'
    if whatFile.upper() in 'STAGING' or whatFile.upper() in 'STAGE':
        whatFile='dashboarddatasets/Staging'
    else:
        whatFile='meinzer/production/insert'
    for afile in os.listdir('//covenas/decisionsupport/%s/' % whatFile):
        list.append(afile)
    stringlist=',\n '.join(list)
    if whatFile =='meinzer/production/insert':
        insertfile = raw_input('\n which file do you want to look into?\n\n \n'+ stringlist+'\n')   
        for afile in os.listdir('//covenas/decisionsupport/meinzer/production/insert/'):
            if insertfile.upper() in afile.upper():
              insertfile='//covenas/decisionsupport/meinzer/production/insert/'+afile   
        with open(insertfile, 'rb') as f:
            code=f.read()
            p=re.compile("\w+(?=.sps)",flags=re.M)
            results=p.findall(code)
            print '\nThe file you are checking is'
            print insertfile+'\n'
            print '\n**********your list************'
            for item in results:
                # print '\n'
                if 'ERRORTESTP' not in item.upper():
                    print item 
            print '*************************'
    else:
        insertfile = raw_input('\n hit any key to continue\n \n'+ stringlist+'\n')  



def promptInfo1():
    """ the main source of info for the menu """
    removeOrAdd = raw_input(" \n\n    (L) Look and Browse what is getting pushed\n\
    (U) update staging into production\n\
    (A) add a push to production from existing sequence\n\
    (R) remove push from dev or production\n\
    (P) push sps to Emanio\n\
    (O) ODBC refresh or create new push files\n\
        from syntax in dashboarddatasets\n\n   -step one for new push sequence\n\
    (C) create bat spj for new Sequence\n\
    (S) search and replace syntax\n\
    (W) wash the k:/dashboarddatasets with production files\n").upper()
    if removeOrAdd.upper()=='U':  
        for afile in os.listdir('//covenas/decisionsupport/DashboardDataSets/staging/'):
            print afile
    if removeOrAdd != 'L' and removeOrAdd != 'O' and removeOrAdd != 'P' and removeOrAdd != 'W' and removeOrAdd != 'S':
        DB= raw_input("DB name without sps ")
    else:
            DB='X'
    if removeOrAdd =='R':
        print '\n\nyou will remove all instances of %s from error log, \npress enter or cntr c to stop' % DB
        # remove(DB)
    return (removeOrAdd,DB)

def createFiles(FN):
    """ create the setup for a new task series """
    for item in os.listdir('c:/program files/ibm/spss/statistics/'):
        if '22' in item:
            spssV='22'
    batstring=r""""C:\Program Files\IBM\SPSS\Statistics\22\stats.exe" -production "//covenas/decisionsupport/Meinzer\Production\SPJ\%s.spj" """ % (FN)
    spjstring=r"""<?xml version="1.0" encoding="UTF-8"?><job print="false" syntaxErrorHandling="continue" syntaxFormat="interactive" unicode="false" xmlns="http://www.ibm.com/software/analytics/spss/xml/production" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xs//covenas/spssdata/schemaLocation="http://www.ibm.com/software/analytics/spss/xml/production http://www.ibm.com/software/analytics/spss/xml/production/production-1.3.xsd"><output outputFormat="viewer" outputPath="//covenas/decisionsupport/Meinzer\Production\Output\production made\%s.spv"/><syntax syntaxPath="//covenas/decisionsupport/Meinzer\Production\Insert\%s.sps"/></job>""" % (FN,FN)
    SPJloc="//covenas/decisionsupport/Meinzer/Production/SPJ/%s.spj" % FN
    BATloc="//covenas/decisionsupport/Meinzer/Production/bat/%s.bat" % FN
    with open(SPJloc,'w') as spj:
        spj.write(spjstring)
    with open(BATloc,'w') as bat:
        bat.write(batstring)    


# FN=raw_input('what is the name of the .sps file without .sps:\n') 
# createFiles(FN)

def StageMove(DB):
    """ move file from stage to production and remove dev """
    stageFolder = '//covenas/decisionsupport/DashboardDataSets/staging/'
    for afile in os.listdir(stageFolder):
        if DB.upper() in afile.upper():
            raw=raw_input('\nyou have selected %s, \n\n     No to stop,\n     Y to continue\n' % afile) 
            if raw.upper() in 'NO':
                pass
            else:
                print 'processing'
                changeEnd(stageFolder,afile)
                FileWOext=os.path.splitext(afile)[0]
                FileExt=os.path.splitext(afile)[1]
                afilenodev=re.sub('_dev','',afile, flags=re.I)
                print 'moving ', afilenodev
                src=stageFolder+afile
                dst='//covenas/decisionsupport/meinzer/production/DashboardDataSets/%s' % (afilenodev)
                shutil.move(src,dst)
                src='//covenas/decisionsupport/meinzer/production/DashboardDataSets/%s' % (afilenodev)
                afileWdev=re.sub('\.',r'_Dev.',afilenodev)
                dst='//covenas/decisionsupport/DashboardDataSets/%s' % (afileWdev)
                shutil.copyfile(src,dst)
                return afilenodev
        elif 'BACKUP' in afile.upper() or 'DUMMY' in afile.upper():
                os.remove(stageFolder+afile)

             

def fileToChange(filetochange):
    """ no longer in use """
    if filetochange.upper()=='D':
        insertfile="//covenas/decisionsupport/meinzer/production/insert/dashboardinsert.sps"
    if filetochange.upper()=='MM':
        insertfile="//covenas/decisionsupport/meinzer/production/insert/MonThruF6am.sps"
    if filetochange.upper()=='C':
        insertfile="//covenas/decisionsupport/meinzer/production/insert/monthlycooked.sps" 
    if filetochange.upper()=='P':
        insertfile="//covenas/decisionsupport/meinzer/production/insert/pafpullcg.sps" 
    return insertfile

def checkInsert(DB):
    """ remove pushes from insert file """
    list=[]
    for afile in os.listdir('//covenas/decisionsupport/meinzer/production/insert/'):
        list.append(afile)
    stringlist=', '.join(list)
    insertfile = raw_input('\n which file?\n\n: \n'+ stringlist+'\n')   
    for afile in os.listdir('//covenas/decisionsupport/meinzer/production/insert/'):
        if insertfile.upper() in afile.upper():
          insertfile='//covenas/decisionsupport/meinzer/production/insert/'+afile  
    list=[]
    with open(insertfile, 'r') as f:
        code=f.read()
        results=re.split("\s(?=begin)",code,flags=re.M)
        for i in results:
            if DB.upper() in i.upper():
                print '***************\n important\nYou are deleting \n\n*************', i
                resume= raw_input("Press ctrl c to stop else any key ")
            else:
                list.append(i)
    with open('//covenas/decisionsupport/meinzer/tempholder.sps','w') as test:
                for item in list:
                    item=item.replace('\r\n','\n')
                    item=item.replace('begin','\nbegin') 
                    item=item.replace('\r\r\r','\n') 
                    item=item.replace('\r\n\r\r','\n')
                    test.write(item)
    src='//covenas/decisionsupport/meinzer/tempholder.sps'
    dst=insertfile
    shutil.copyfile(src,dst)
    print src, dst

def promptInfo2():
    """ used to create """
    DevProdBoth = raw_input("(D)ev, (P)roduction, or (B)oth: ").upper()
    ErrorAlertDays = raw_input("# of Days before Alert: ")
    return (ErrorAlertDays,DevProdBoth)

def remove(DB):
    """ take out x from csv, replace with test  """
    list=[]
    DBup=DB.upper()
    with open('//covenas/decisionsupport/meinzer/production/output/errorcsv.txt', "r") as myfile:
            old=myfile.readlines()
            for item in old:
                if DBup in item.upper():
                 item=item.replace(DB,'test')
                 list.append(item)
                else:
                  list.append(item)
    # with open('//covenas/decisionsupport/meinzer/production/output/errorcsv.txt', "w") as myfile:              
        # for item in list:
                # myfile.write(item)
                # print item

def createSyntax(ErrorAlertDays,DevProdBoth,DB):
    """ add a sequence to an insert file"""
    for afile in os.listdir('//covenas/decisionsupport/meinzer/production/DashboardDataSets/'):
      if DB.upper() in afile.upper():
       raw=raw_input('\nyou have selected %s, \n\n     No to stop,\n     Y to continue\n' % afile) 
       if raw.upper() in 'NO':
        AddInsert=""
       else:
        DB = os.path.splitext(afile)[0]
        if DevProdBoth=='D':
            print 'Dev'
            AddInsert="""

begin program.
AlertDays=%s     
Files=['//covenas/decisionsupport/meinzer/Production/dashboarddatasets/%s.sps',
'//covenas/decisionsupport/meinzer/Production/push/%spush.sps']
end program.
insert file='//covenas/decisionsupport/meinzer/production/ps/errorTestPickles.sps'.        """ % (ErrorAlertDays,DB,DB)
        
        elif DevProdBoth=='P':
            print 'Production'
            AddInsert="""

begin program.
AlertDays=%s  
Files=['//covenas/decisionsupport/meinzer/Production/dashboarddatasets/%s.sps',
'//covenas/decisionsupport/meinzer/Production/pushproduction/%spushP.sps']
end program.
insert file='//covenas/decisionsupport/meinzer/production/ps/errorTestPickles.sps'.        """ % (ErrorAlertDays,DB,DB)
        elif DevProdBoth=='B':
            print 'Both'
            print 'erroralert = '+str(ErrorAlertDays)
            AddInsert="""

begin program.
AlertDays=%s  
Files=['//covenas/decisionsupport/meinzer/Production/dashboarddatasets/%s.sps',
'//covenas/decisionsupport/meinzer/Production/push/%spush.sps',
'//covenas/decisionsupport/meinzer/Production/pushproduction/%spushP.sps']
end program.
insert file='//covenas/decisionsupport/meinzer/production/ps/errorTestPickles.sps'.        """ % (ErrorAlertDays,DB,DB,DB)
        else:
            print 'you did not make sense'
            AddInsert=''# DevProdBoth = raw_input("Dev Production or Both: ")
    return AddInsert    

def placeInsert(AddInsert):
    """ put the create syntax into an insert file of your choice"""
    list=[]
    if AddInsert == '':
        print 'nothing added'
        returnMain()
    for afile in os.listdir('//covenas/decisionsupport/meinzer/production/insert/'):
        list.append(afile)
    stringlist=', '.join(list)
    insertfile = raw_input('\n which file?\n\n: \n'+ stringlist+'\n')   
    for afile in os.listdir('//covenas/decisionsupport/meinzer/production/insert/'):
        if insertfile.upper() in afile.upper():
          file='//covenas/decisionsupport/meinzer/production/insert/'+afile 
    with open(file, "rb") as f: 
        code=f.readlines()
        code.append(AddInsert)
    with open(file, 'w') as ts:
        for item in code:
            item=item.replace('\r\n','\n')             
            ts.write(item) 

def createFilesGeneric():
    """ Not in use because overwriting files while running multiple caused conflict"""
    if socket.gethostname() =='WinSPSSV4':
        version='22'
    else:
        version='22'
    batstring=r""""C:\Program Files\IBM\SPSS\Statistics\%s\stats.exe" -production "//covenas/decisionsupport/Meinzer\Production\SPJ\generic.spj" """ % (version)
    spjstring=r"""<?xml version="1.0" encoding="UTF-8"?><job print="false" syntaxErrorHandling="continue" syntaxFormat="interactive" unicode="false" xmlns="http://www.ibm.com/software/analytics/spss/xml/production" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xs//covenas/spssdata/schemaLocation="http://www.ibm.com/software/analytics/spss/xml/production http://www.ibm.com/software/analytics/spss/xml/production/production-1.3.xsd"><output outputFormat="viewer" outputPath="//covenas/decisionsupport/Meinzer\Production\Output\production made\%s.spv"/><syntax syntaxPath="//covenas/decisionsupport/temp\%s.sps"/></job>""" % ('generic','generic')
    SPJloc="//covenas/decisionsupport/Meinzer/Production/SPJ/%s.spj" % 'generic'
    BATloc="//covenas/decisionsupport/Meinzer/Production/bat/temp/%s.bat" % 'generic'
    with open(SPJloc,'w') as spj:
        spj.write(spjstring)
    with open(BATloc,'w') as bat:
        bat.write(batstring)    

def createSyntaxGeneric(DB):
    """ creates the syntax for pushing a file dev and or production"""
    DB= raw_input("DB name without with or without extension   i.e. sps \n")
    DevProdBoth = raw_input("(F) File (D)ev, (P)roduction:\n ").upper()
    for afile in os.listdir('//covenas/decisionsupport/meinzer/production/dashboarddatasets/'):
        if DB.upper() in afile.upper():
            whatUwant=raw_input('----------you wanted %s? yes or no \n' % afile)
            if 'Y' in whatUwant.upper():
                DB = os.path.splitext(afile)[0]
                break
            else:
                print '\n----------next match'
    if 'N' in whatUwant.upper():
        print '\ntry again\n'
        DB= raw_input("DB name without with or without extension   i.e. sps \n")
        for afile in os.listdir('//covenas/decisionsupport/meinzer/production/dashboarddatasets/'):
            if DB.upper() in afile.upper():
                whatUwant=raw_input('----------you wanted %s? yes or no \n' % afile)
                if 'Y' in whatUwant.upper():
                    DB = os.path.splitext(afile)[0]
                    break
                else:
                    print '\n----------next match'
    list=[]
    #import pdb; pdb.set_trace()
    if 'F' in DevProdBoth.upper():
        list.append('//covenas/decisionsupport/meinzer/Production/dashboarddatasets/%s.sps' % DB)
    if 'D' in DevProdBoth.upper():
        list.append("//covenas/decisionsupport/meinzer/Production/push/%spush.sps" % DB)
    if 'P' in DevProdBoth.upper():
        list.append("//covenas/decisionsupport/meinzer/Production/pushproduction/%spushP.sps" % DB)
    who=raw_input('\n----------who should be emailed?')
    liststring=list[0:]
    syntax="""begin program.
AlertDays=99  
Files=%s
end program.
insert file='//covenas/decisionsupport/meinzer/production/ps/errorTestPickles2.sps'.        
*insert file='//covenas/decisionsupport/meinzer/production/ps/errorLevel.sps'.  
*HOST COMMAND=['c:\python%s\python "//covenas/decisionsupport/meinzer/production/ps/finishAlert.py" "%s"'].""" % (liststring,str(sys.version_info[0])+str(sys.version_info[1]),who)
    p=re.compile('\n',re.M)
    splitsyntax=p.split(syntax)
    batstring=r""""C:\Program Files\IBM\SPSS\Statistics\%s\stats.exe" -production "\\covenas\decisionsupport\Meinzer\Production\SPJ\%s.spj" """ % ('22',DB)                  
    spjstring=r"""<?xml version="1.0" encoding="UTF-8"?><job print="false" syntaxErrorHandling="continue" syntaxFormat="interactive" unicode="false" xmlns="http://www.ibm.com/software/analytics/spss/xml/production" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="http://www.ibm.com/software/analytics/spss/xml/production http://www.ibm.com/software/analytics/spss/xml/production/production-1.3.xsd"><output outputFormat="viewer" outputPath="\\covenas\decisionsupport\Meinzer\Production\Output\production made\%s.spv"/><syntax syntaxPath="\\covenas\decisionsupport\temp\%s.sps"/></job>""" % (DB,DB)
    SPJloc="//covenas/decisionsupport/Meinzer/Production/SPJ/%s.spj" % DB
    BATloc="//covenas/decisionsupport/Meinzer/Production/bat/temp/%s.bat" % DB
    with open(SPJloc,'w') as spj:
        spj.write(spjstring)
    with open(BATloc,'w') as bat:
        bat.write(batstring)   
    with open('//covenas/decisionsupport/temp/%s.sps' % DB,'w+') as gen:
        for item in splitsyntax:
            item=item.replace(', ',',\n')
            gen.write(item+'\n')
    print '\n****you are about to run the following spss syntax***\n'
    for line in splitsyntax:
        print line
    print '\n\n----------is that okay?\n'
    xx = raw_input("control c to stop, \notherwise hit any key")
    errorList=[]
    try:
        call(r"\\covenas\decisionsupport\meinzer\production\bat\temp\%s.bat" % DB)
        print '\nPushing your file!!!!\n'
        with open('//covenas/decisionsupport/temp/errorresult.txt','r') as ER:
            error=ER.readline()
    except Exception,e:
        print 'there was an exception'
        error='\nThere was an error in your file\n'+str(e)
    print error
    call(r'c:\python%s\python \\covenas\decisionsupport\meinzer\production\ps\finishAlert2.py "%s" %s ' % (str(sys.version_info[0])+str(sys.version_info[1]),error,who))
    finished = raw_input('press any key to close this window')

def runBat():
    """ not in use because generic overwritten when running two processes"""
    Popen(r"//covenas/decisionsupport/meinzer/production/bat/generic.bat")
    print '\nPushing your file!!!!\n'

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
    """ updates during odbc push """
    DBList=[]
    for afile in os.listdir('//covenas/decisionsupport/meinzer/production/push/'):
        if afile.upper().endswith('.SPS'):
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

def washDash():
    """ takes the production version and replaces the dev"""
    primaryFolder='//covenas/decisionsupport/meinzer/production/DashboardDatasets/'
    DBList=[]
    for afile in os.listdir(primaryFolder):
          if afile.upper().endswith('.SPS'):
            FileWOext=os.path.splitext(afile)[0]
            FileExt=os.path.splitext(afile)[1]
            DBList.append(FileWOext)
            # if os.path.isfile('//covenas/decisionsupport/DashboardDataSets/backup2daysold/%s_Dev%s' % (FileWOext,FileExt)):
                # src='//covenas/decisionsupport/DashboardDataSets/backup2daysold/%s_Dev%s' % (FileWOext,FileExt)
                # dst='//covenas/decisionsupport/DashboardDataSets/backup3daysold/%s_Dev%s' % (FileWOext,FileExt)
                # print '1'
                # shutil.move(src,dst)
            # if os.path.isfile('//covenas/decisionsupport/DashboardDataSets/backup1dayold/%s_Dev%s' % (FileWOext,FileExt)):                 
                # src='//covenas/decisionsupport/DashboardDataSets/backup1dayold/%s_Dev%s' % (FileWOext,FileExt)
                # dst='//covenas/decisionsupport/DashboardDataSets/backup2daysold/%s_Dev%s' % (FileWOext,FileExt)
                # print '2'                 
                # shutil.move(src,dst) 
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
        src=primaryFolder+'%s.sps' % syntax
        dst='//covenas/decisionsupport/meinzer/production/Backup/%s.sps' % syntax
        shutil.copy2( src,dst)

def createPushFilesx(primaryFolder,DB):
    """ makes emanio push files during update stagign"""
    DB=os.path.splitext(DB)[0]
    line1='\ncompute DBcreateDate=$time.'
    line2='\nformat dbcreatedate (datetime23).\n'
    list=[]
    list2=[]
    file=primaryFolder+"%s.sps" % DB
    file2="//covenas/decisionsupport/meinzer/production/push/%spush.sps" % DB
    file3="//covenas/decisionsupport/meinzer/%s.sps" % DB
    print file
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
        print 'no push found in ', file

def changeDevToProductionx(DB):
    """change dev pushes to production pushes"""
    DB=os.path.splitext(DB)[0]
    DBname=DB+'push'
    DBname2=DBname+"P"
    file="//covenas/decisionsupport/meinzer/production/push/%s.sps" % DBname
    file2="//covenas/decisionsupport/meinzer/production/pushproduction/%s.sps" % DBname2
    print file, file2+'\n'
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

if __name__ == "__main__":
    try:
       main()
    except:
       logging.exception('Got exception on main handler')
       raise
