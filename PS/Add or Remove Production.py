##requires spss 22

import re, shutil, os, sys
import subprocess
import socket
from datetime import datetime
import logging
import smtplib
from email.mime.multipart import MIMEMultipart
from email.mime.text import MIMEText

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
        modOrDash = raw_input('type "Module" for module\n\n... otherwise anykey for dash?\n') 
        DB=StageMove(DB,modOrDash)
        if 'mod' not in modOrDash.lower():
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
        createSyntaxGeneric(DB)
    elif removeOrAdd.upper()=='W':
        washDash()
        raw=raw_input('\nhit anykey for main menu')
        returnMain()
    elif removeOrAdd.upper()=='E':
        raw=raw_input('\nhit anykey for main menu')
        returnMain()
    elif removeOrAdd.upper()=='S':
        mypath=raw_input('path to start-will continue through subfolders\n')
        endFill=raw_input('type of file+exention or just extention\n    .sps gets all syntax or graphics.sps will get demographics.sps\n')
        changeEnd(mypath,endFill)        
        returnMain()
    elif removeOrAdd.upper()=='B':
        printAllPushBreak()
        returnMain()

def changeEnd(mypath,endFill):
    """ changes mapped drive references to UNC so no more k: and I: because server edition only does UNC"""
    list=[]
    fails=[]
    f = []
    for (dirpath, dirnames, filenames) in os.walk(mypath):
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
    listx=[]
    listx2=[]
    listx3=[]
    num=0
    list=[]
    whatFile = raw_input('DashboardDatasets, stage or insert\n')
    if whatFile.upper() in 'DASHBOARDDATASETS':
        whatFile='meinzer/production/dashboarddatasets'
    elif whatFile.upper() in 'STAGING' or whatFile.upper() in 'STAGE':
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
            code=code.upper().split('BEGIN')
            for item in code:
                item=item.upper().split('END P')
                listx.append(item)
            for part in listx:
                for item in part:
                    if 'FILES' in item.upper():
                        #print item
                        num+=1
                        #print num
                        p=re.compile("\w+(?=.SPS)",flags=re.I)
                        results=p.findall(item)
                        listx2.append(results)
                        m = re.compile('(?<=WHEN)\s*\=\s*\S+',flags=re.I)
                        when=m.findall(item)
                        listx3.append(when)
                        new=zip(listx2,listx3)
        x=2
        print '****************************Your File***********'
        for item in new:
            for list in item:
                if x%2==1:
                    print 'Pushed ', list
                    print '\n'
                else:
                   print list
                x+=1               
        # with open(insertfile, 'rb') as f:
        #     code=f.read()
        #     p=re.compile("\w+(?=.sps)",flags=re.M)
        #     results=p.findall(code)
        #     print '\nThe file you are checking is'
        #     print insertfile+'\n'
        #     print '\n**********your list************'
        #     for item in results:
        #         # print '\n'
        #         if 'ERRORTESTP' not in item.upper():
        #             print item 
        #     print '*************************'
    else:
        insertfile = raw_input('\n hit any key to continue\n \n'+ stringlist+'\n')  



def promptInfo1():
    """ the main source of info for the menu """
    removeOrAdd = raw_input(" \n\n    (L) Look and Browse what is getting pushed\n\
    (U) update staging into production\n\
    (A) add a push to production from existing sequence\n\
    (R) remove push from dev or production\n\
    (P) push sps to Emanio\n\
    (O) refresh push files\n\
    (C) create bat spj insert for new Sequence\n\
    (S) search and replace syntax\n\
    (B) print all pushbreaks\n\
    (W) wash the k:/dashboarddatasets with production files\n").upper()
    if removeOrAdd.upper()=='U':  
        for afile in os.listdir('//covenas/decisionsupport/DashboardDataSets/staging/'):
            print afile
    if removeOrAdd != 'L' and removeOrAdd != 'O' and removeOrAdd != 'P' and removeOrAdd != 'W' and removeOrAdd != 'S' and removeOrAdd != 'B':
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
    batstring=r""""C:\Program Files\IBM\SPSS\Statistics\22\stats.exe" "\\covenas\decisionsupport\Meinzer\Production\SPJ\%s.spj" -production -server bhcsstat1:3022 -user program\meinzerc -password %%cpw%%""" % (FN)
    spjstring=r"""<?xml version="1.0" encoding="UTF-8"?><job print="false" syntaxErrorHandling="continue" syntaxFormat="interactive" unicode="false" xmlns="http://www.ibm.com/software/analytics/spss/xml/production" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="http://www.ibm.com/software/analytics/spss/xml/production http://www.ibm.com/software/analytics/spss/xml/production/production-1.3.xsd"><output outputFormat="viewer" outputPath="\\covenas\decisionsupport\Meinzer\Production\Output\production made\%s.spv"/><syntax syntaxPath="\\covenas\decisionsupport\Meinzer\Production\Insert\%s.sps"/></job>""" % (FN,FN)
    SPJloc="//covenas/decisionsupport/Meinzer/Production/SPJ/%s.spj" % FN
    BATloc="//covenas/decisionsupport/Meinzer/Production/bat/%s.bat" % FN
    with open(SPJloc,'w') as spj:
        spj.write(spjstring)
    with open(BATloc,'w') as bat:
        bat.write(batstring)   
    if not os.path.isfile(r"\\covenas\decisionsupport\Meinzer\Production\insert\%s.sps" % FN):
        with open(r"\\covenas\decisionsupport\Meinzer\Production\insert\%s.sps" % FN,'w') as insert:
            insert.write("*fresh insert file.")          


# FN=raw_input('what is the name of the .sps file without .sps:\n') 
# createFiles(FN)

def StageMove(DB,modOrDash):
    # import pdb; pdb.set_trace()
    """ move file from stage to production and remove dev """
    stageFolder = '//covenas/decisionsupport/DashboardDataSets/staging/'
    dashProdFolder ='//covenas/decisionsupport/meinzer/production/DashboardDataSets/'
    dashDevFolder = '//covenas/decisionsupport/DashboardDataSets/'
    modProdFolder ='//covenas/decisionsupport/meinzer/production/modules/'
    modDevFolder = '//covenas/decisionsupport/modules/'    
    if 'mod' in modOrDash.lower():
        print 'you chose Module\n'
        prodFolder = modProdFolder
        devFolder = modDevFolder
    else:
        print 'you chose DashBoard\n'
        prodFolder = dashProdFolder
        devFolder = dashDevFolder
    for afile in os.listdir(stageFolder):
        if DB.upper() in afile.upper() and os.path.isfile(os.path.join(stageFolder,afile)):
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
                dst=prodFolder+'%s' % (afilenodev)
                shutil.move(src,dst)
                src=prodFolder+'%s' % (afilenodev)
                if 'mod' in modOrDash.lower():
                    dst=devFolder+'%s' % (afilenodev)
                else:
                    afileWdev=re.sub('\.',r'_Dev.',afilenodev)
                    dst=devFolder+'%s' % (afileWdev)
                shutil.copyfile(src,dst)
                return (afilenodev)
        elif 'BACKUP' in afile.upper() or 'DUMMY' in afile.upper():
                os.remove(stageFolder+afile)

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
    DevProdBoth = raw_input("(F) File (D)ev, (P)roduction:\n ").upper()
    ErrorAlertDays = raw_input("when should the file run (one or more without commasbetween)?\nhelp for options\n ")
    if 'HELP' in ErrorAlertDays.upper():
        print '\n   type the word below\nAlways\nDaily\nWeekly\nMonthly\nQuarterly (16th of month 1,4,7,10)\nYearly (16th Sept) \nSaturday\nSunday\n'
        ErrorAlertDays = raw_input("when should the file run (one or more without commasbetween)?\n ")
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
      if DB.upper() in afile.upper() and os.path.isfile(os.path.join('//covenas/decisionsupport/meinzer/production/DashboardDataSets/',afile)):
        raw=raw_input('\nyou have selected %s, \n\n     No to stop,\n     Y to continue\n' % afile) 
       #import pdb;pdb.set_trace();
        if raw.upper() in 'NO':
            AddInsert=""
        else:
            DB = os.path.splitext(afile)[0]
            list=[]
            if 'F' in DevProdBoth.upper():
                list.append('//covenas/decisionsupport/meinzer/Production/dashboarddatasets/%s.sps' % DB)
            if 'D' in DevProdBoth.upper():
                list.append("//covenas/decisionsupport/meinzer/Production/push/%spush.sps" % DB)
            if 'P' in DevProdBoth.upper():
                list.append("//covenas/decisionsupport/meinzer/Production/pushproduction/%spushP.sps" % DB)

            liststring=list[0:]
            AddInsert="""begin program.
when='%s'  
Files=%s
end program.
insert file='//covenas/decisionsupport/meinzer/production/ps/errorTestPickles.sps'.""" % (ErrorAlertDays,liststring)
            break
    p=re.compile('\n',re.M)
    AddInsert=p.split(AddInsert)
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
    insertfile = raw_input('\n which file?\n\n'+ stringlist+'\n')   
    for afile in os.listdir('//covenas/decisionsupport/meinzer/production/insert/'):
        if insertfile.upper() in afile.upper():
          file='//covenas/decisionsupport/meinzer/production/insert/'+afile 
    with open(file, "rb") as f: 
        code=f.readlines()
        code.append('\n')
        for line in AddInsert:
            line=line.replace(', ',',\n')
            code.append(line+'\n')
        code.append('\n')
    with open(file, 'w') as ts:
        for item in code:
            item=item.replace('\r\n','\n')             
            ts.write(item) 


def createSyntaxGeneric(DB):
    """ creates the syntax for pushing a file dev and or production"""
    DB= raw_input("DB name without with or without extension   i.e. sps \n")
    DevProdBoth = raw_input("(F) File (D)ev, (P)roduction:\n ").upper()
    for afile in os.listdir('//covenas/decisionsupport/meinzer/production/dashboarddatasets/'):
        if DB.upper() in afile.upper() and os.path.isfile(os.path.join('//covenas/decisionsupport/meinzer/production/DashboardDataSets/',afile)):
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
            if DB.upper() in afile.upper() and os.path.isfile(os.path.join('//covenas/decisionsupport/meinzer/production/DashboardDataSets/',afile)):
                whatUwant=raw_input('----------you wanted %s? yes or no \n' % afile)
                if 'Y' in whatUwant.upper():
                    DB = os.path.splitext(afile)[0]
                    break
                else:
                    print '\n----------next match'
    list=[]
    if 'F' in DevProdBoth.upper():
        list.append('//covenas/decisionsupport/meinzer/Production/dashboarddatasets/%s.sps' % DB)
    if 'D' in DevProdBoth.upper():
        list.append("//covenas/decisionsupport/meinzer/Production/push/%spush.sps" % DB)
    if 'P' in DevProdBoth.upper():
        list.append("//covenas/decisionsupport/meinzer/Production/pushproduction/%spushP.sps" % DB)
    who=raw_input('\n----------who should be emailed?')
    where=raw_input('\n----------Local computer or Server?')    
    if 'LOC' in where.upper():
        Serverx=0
    elif "SER" in where.upper():
        Serverx=1
    else:
        Serverx=1
        print 'Defaulting to Server'
    liststring=list[0:]
    syntax="""begin program.
when='fly'  
Files=%s
end program.
insert file='//covenas/decisionsupport/meinzer/production/ps/errorTestPickles.sps'.""" % (liststring)
    p=re.compile('\n',re.M)
    splitsyntax=p.split(syntax)
    if Serverx==1:
        batstring=r""""C:\Program Files\IBM\SPSS\Statistics\22\stats.exe"  "\\covenas\decisionsupport\Meinzer\production\spj\%s.spj" -production -server inet:bhcsstat1:3022 -user program\meinzerc -password %%mypassword%%""" % DB
    else:
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
        startEmail(DB, who,liststring)
        FNULL=open(os.devnull,'w')
        subprocess.call(r"\\covenas\decisionsupport\meinzer\production\bat\temp\%s.bat" % DB,stdout=FNULL,stderr=subprocess.STDOUT)
        FNULL.close()
        stars='*'*10
        for i in stars:
            print i
        print '\nPushing your file!!!!\n'
        with open('//covenas/decisionsupport/temp/errorresult.txt','r') as ER:
            error=ER.readline()
    except Exception,e:
        print 'there was an exception'
        error='\nThere was an error in your file\n'+str(e)
    print error
    subprocess.call(r'c:\python%s\python \\covenas\decisionsupport\meinzer\production\ps\finishAlert2.py "%s" %s ' % (str(sys.version_info[0])+str(sys.version_info[1]),error,who))
    finished = raw_input('press any key to close this window')


def createPushFiles():
    """ In use updates push and pushproduction files during odbc update"""
    DBList=[]
    primaryFolder='//covenas/decisionsupport/meinzer/production/DashboardDatasets/'
    for afile in os.listdir(primaryFolder):
          if afile.upper().endswith('.SPS'):
            FileWOext=os.path.splitext(afile)[0]
            FileExt=os.path.splitext(afile)[1]
            DBList.append(FileWOext)
    for DB in DBList:
        createPushFilesx(primaryFolder,DB)


def changeDevToProduction():
    """ updates during odbc push """
    DBList=[]
    for afile in os.listdir('//covenas/decisionsupport/meinzer/production/push/'):
        if afile.upper().endswith('.SPS'):
            FileWOext=os.path.splitext(afile)[0]
            DBList.append(FileWOext)
    for DB in DBList:
        insensitive=re.compile(re.escape('push'),re.I)
        DB=insensitive.sub('',DB)
        changeDevToProductionx(DB)
        
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

def makeRemoteSyntax(spssTable,SQLtable):
    Syntax=r"""get file =  '%s.sav'.
    compute DBcreateDate=$time.
    formats dbcreatedate (datetime23).
    SAVE TRANSLATE OUTFILE='//bhcsdbv03/emanio/%s.csv'
      /TYPE=CSV
      /ENCODING='Locale'  /MAP   /REPLACE  /FIELDNAMES  /CELLS=VALUES.
    n of cases 1.

    SAVE TRANSLATE /TYPE=ODBC
    /Connect ='DSN=DashboardDatadev;UID=;APP=SPSS For'+
    ' Windows;WSID=HPMXL9360ZDD;DATABASE=DashboardDatadev;Trusted_Connection=Yes'
    /table= '%s' /MAP/REPLACE.


     """ % (spssTable,SQLtable,SQLtable)
    return Syntax

def makeSQLPushbase():
    SQLPushbase=r"""
import re
import pyodbc
from datetime import datetime
import csv
import logging

logging.basicConfig(filename='//bhcsdbv03/emanio/bhcsdbv03.log',level=logging.DEBUG)
logging.debug('Start push  at '+ str(datetime.now()))
benchmarkstart=datetime.now()

def sendTOSQL(csvLocation,sqlTableName):
    x=0
    with open (csvLocation, 'r') as f:
        reader = csv.reader(f)
        columns = next(reader) 
        #import pdb; pdb.set_trace();
        for data in reader:
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
                if x % 1000000==0:
                    xstar=str(x)[0]
                    logging.debug(r'%s,000,000 rows processed and counting' % (xstar))
                x=x+1
"""                  
    return SQLPushbase

def createPushFilesx(primaryFolder,DB):
    """ makes emanio push files during update stagign"""
    DB=os.path.splitext(DB)[0]
    list=[]
    list2=[]
    listpypush=[]
    fileDB=primaryFolder+"%s.sps" % DB
    fileDev="//covenas/decisionsupport/meinzer/production/push/%spush.sps" % DB
    fileProduction="//covenas/decisionsupport/meinzer/%s.sps" % DB
    print fileDB
    with open(fileDB, "rb") as f: 
            code=f.read()
            if 'PUSHBREAK' in code.upper():
                results=re.split('pushbreak\\.',code,flags=re.M)
                for i in results:
                    if 'SKIPROW' in i.upper() or 'REMOTEPUSH'in i.upper() or 'REMOTE PUSH'in i.upper():
                        skipRow=1
                    else:
                        skipRow=0
                    if 'SQLTABLE' in i.upper():
                        if 'OLD PUSH' in i.upper() or 'DO NOT PUSH' in i.upper():
                            print 'the file ', fileDB, '\ndid not convert\n',  i.replace('\r\n',' ')
                        else:  
                            m = re.search('(?<=SQLTABLE)\s*\=\s*\S+',i,flags=re.I)
                            print  m.group(0)         
                            SQLtable=m.group(0).replace('=','').replace(',','').replace("'","") 
                            SQLtable=SQLtable.strip().strip('.') 
                            SQLtable=os.path.splitext(SQLtable)[0]                            
                            m = re.search('(?<=SPSSTABLE)\s*\=\s*\S+[\s\S]*',i,flags=re.I)
                            spssTable=m.group(0).replace('=','').replace(',','').replace('"','').replace("'","")
                            insensitive=re.compile(re.escape('.sav'),re.I)
                            spssTable=insensitive.sub('',spssTable)
                            spssTable=spssTable.rstrip('.')
                            spssTable=spssTable.strip("'")
                            spssTable=spssTable.strip('"')
                            spssTable=os.path.splitext(spssTable)[0]
                            Syntax=r"""get file =  '%s.sav'.
                            compute DBcreateDate=$time.
                            formats dbcreatedate (datetime23).
                            SAVE TRANSLATE /TYPE=ODBC
                            /Connect ='DSN=DashboardDatadev;UID=;APP=SPSS For'+
                            ' Windows;WSID=HPMXL9360ZDD;DATABASE=DashboardDatadev;Trusted_Connection=Yes'
                            /table= '%s' /MAP/REPLACE.

                            """ % (spssTable,SQLtable)
                            if skipRow==1:
                                hostcmd=r"""host command=['c:\python27\python "//bhcsdbv03/emanio/Aremote%s.py"'].""" % DB
                                Syntax=makeRemoteSyntax(spssTable,SQLtable)
                                SQLPushbase=makeSQLPushbase()
                                line0=r"""benchmarkend=datetime.now()"""
                                line1=r"""FinishText = benchmarkend.strftime("%m-%d-%y %H:%M")"""
                                line2=r"""StartText = benchmarkstart.strftime("%m-%d-%y %H:%M")"""
                                line3=r"Runtimex = str(benchmarkend-benchmarkstart)[0:7]"
                                line5=r'with open("//bhcsdbv03/emanio/Error Log.txt", "r+") as myfile:'
                                line6=r"    old=myfile.read()"
                                line7=r"    myfile.seek(0)"
                                line8=r'    myfile.write("""%s ' % DB+"bhcsdbv03"
                                line9=r"    Start             Finish           Runtime Hrs:Min:Sec"
                                line10=r'    %s    %s   %s """  % (StartText,FinishText,Runtimex)+"\n\n"+ old)'
                                SQLPush=r"""
try:
    sendTOSQL('//bhcsdbv03/emanio/%s.csv','%s')                                 
except:
    logging.exception('Got exception on main handler %s')
    raise

logging.debug('Finished push %s at '+ str(datetime.now()))
"""  % (SQLtable,SQLtable,SQLtable,SQLtable)       
                                listpypush.append(SQLPush)
                                listpypush.append('\n')
                            else:
                                print 'do not skip row!'
                            print Syntax
                            list.append(Syntax)
                            list.append('\n')
                #import pdb; pdb.set_trace();
                try:
                  if listpypush:
                    with open(r"//bhcsdbv03/emanio/Aremote%s.py" % DB, 'w+') as callpy:
                        callpy.write(r"""import subprocess
from datetime import datetime
import logging
logging.basicConfig(filename='//bhcsdbv03/emanio/bhcsdbv03.log',level=logging.DEBUG)
logging.debug('Start chain %s at '+ str(datetime.now()))   
try:       
    log = open("//bhcsdbv03/emanio/bhcsdbv03psexec.log", 'a+')                  
    c=subprocess.Popen(r"//bhcsdbv03/emanio/Bremote%s.bat", stdout=log, stderr=log, shell=True)
    #stdout, stderr = p.communicate()
    #print stderr
    print 'it worked'
except:
    logging.exception('Got exception on main handler chain %s')
    raise

print 'it worked'""" % (DB, DB, DB))       
                    with open(r"//bhcsdbv02/emanio/Aremote%s.py" % DB, 'w+') as callpy:
                        callpy.write(r"""import subprocess
from datetime import datetime
import logging
logging.basicConfig(filename='//bhcsdbv02/emanio/bhcsdbv02.log',level=logging.DEBUG)
logging.debug('Start chain %s at '+ str(datetime.now()))   
try:                         
    log = open("//bhcsdbv02/emanio/bhcsdbv02psexec.log", 'a+')               
    c=subprocess.Popen(r"//bhcsdbv02/emanio/Bremote%s.bat", stdout=log, stderr=log, shell=True)
    #stdout, stderr = p.communicate()
    #print stderr
    print 'it worked'
except:
    logging.exception('Got exception on main handler chain %s')
    raise

print 'it worked'""" % (DB, DB, DB))               
                    with open(r"//bhcsdbv03/emanio/Bremote%s.bat" % DB, 'w+') as hostfile:
                        hostfile.write(r"""psexec \\bhcsdbv03 -c -f -i \\bhcsdbv03\emanio\CopenPyFile%s.bat -u meinzerc -p %%mypassword%%""" % DB)
                    with open(r"//bhcsdbv02/emanio/Bremote%s.bat" % DB, 'w+') as hostfile:
                        hostfile.write(r"""psexec \\bhcsdbv02 -c -f -i \\bhcsdbv02\emanio\CopenPyFile%s.bat -u meinzerc -p %%mypassword%%""" % DB)                        
                    # with open(r"//bhcsdbv02/emanio/Aremote%s.bat" % DB, 'w+') as hostfile:
                    #     hostfile.write(r"""psexec \\bhcsdbv02 -c -f \\bhcsdbv02\emanio\CopenPyFile%s.bat""" % DB)                        
                    with open(r"\\bhcsdbv03\emanio\CopenPyFile%s.bat" % DB, 'w+') as batToPy:
                        batToPy.write(r"""c:\python27\python \\bhcsdbv03\emanio\DsendToSQL%s.py""" % DB)   
                    with open(r"\\bhcsdbv02\emanio\CopenPyFile%s.bat" % DB, 'w+') as batToPy:
                        batToPy.write(r"""c:\python27\python \\bhcsdbv02\emanio\DsendToSQL%s.py""" % DB)                            
                    with open(r"//bhcsdbv03/emanio/DsendToSQL%s.py" % DB,'w+') as test:
                        test.write(SQLPushbase)
                        for item in listpypush:
                            test.write(item)   
                        test.write(line0+'\n')
                        test.write(line1+'\n')
                        test.write(line2+'\n')
                        test.write(line3+'\n')
                        test.write(line5+'\n')
                        test.write(line6+'\n')
                        test.write(line7+'\n')
                        test.write(line8+'\n')
                        test.write(line9+'\n')
                        test.write(line10)
                        #need end benchmark 
                    with open(r"//bhcsdbv03/emanio/DsendToSQL%s.py" % DB,'r') as devcopy:    
                        code=devcopy.readlines()
                        with open(r"//bhcsdbv02/emanio/DsendToSQL%s.py" % DB,'w') as productioncopy:
                            for line in code:
                                itemchange=re.compile(re.escape('dashboarddatadev'),re.IGNORECASE)
                                line=itemchange.sub('DashboardData',line)
                                itemchange=re.compile(re.escape('bhcsdbv03'),re.IGNORECASE)
                                line=itemchange.sub('bhcsdbv02',line) 
                                productioncopy.write(line)  
                except:
                    print 'no listpy'   
                #import pdb;pdb.set_trace();                             
                with open(fileProduction,'w') as test:
                    for item in list:
                        test.write(item)
                    try:
                        test.write(hostcmd)
                    except:
                        print 'no host cmd'
                with open(fileProduction,'r') as makelist:
                    for itemx in makelist:
                        itemx=itemx.lstrip('*')
                        if 'REPLACE' in itemx.upper():
                            list2.append(itemx+'\n')
                        else:
                            list2.append(itemx)
                with open(fileDev,'w') as makesyntax:
                    for item2 in list2:
                          item3=item2.lstrip()
                          item3=item3.replace('\r\n','\n')
                          item3=item3.lstrip('*')
                          item3=item3.lstrip(' ')
                          makesyntax.write(item3)
            else:
                print 'no push found in', fileDB
                print 'these files were updated in push'

def changeDevToProductionx(DB):
    """change dev pushes to production pushes"""
    DB=os.path.splitext(DB)[0]
    DBname=DB+'push'
    DBname2=DBname+"P"
    fileDev="//covenas/decisionsupport/meinzer/production/push/%s.sps" % DBname
    fileProduction="//covenas/decisionsupport/meinzer/production/pushproduction/%s.sps" % DBname2
    print fileDev, fileProduction+'\n'
    try:
        with open(fileDev,"r") as checkforDashFile:
            DashCheck=checkforDashFile.read()
            if 'DASHBOARD' in DashCheck.upper():
                with open(fileDev, "r") as f: 
                    c=f.readlines()   
                with open(fileProduction, 'w') as ts:
                    for item in c:
                        itemchange=re.compile(re.escape('dashboarddatadev'),re.IGNORECASE)
                        itemswitch=itemchange.sub('DashboardData',item)
                        itemchange=re.compile(re.escape('bhcsdbv03'),re.IGNORECASE)
                        itemswitch=itemchange.sub('bhcsdbv02',itemswitch)                        
                        ts.write(itemswitch)
    except:
        print '\n   ********Hey    No push file, was that expect?'

def startEmail(DB, whox,whatFile):  
    list=[]
    if 'CHE' in whox.upper():
     list.append('cmeinzer@acbhcs.org')
    if 'LO' in whox.upper():
     list.append('LHall2@acbhcs.org')
    if 'GA' in whox.upper():
     list.append('GOrozco@acbhcs.org')
    if 'CHR' in whox.upper():
     list.append('CShaw@acbhcs.org')
    if 'KE' in whox.upper():
     list.append('KCoelho@acbhcs.org')
    if 'KI' in whox.upper():
     list.append('KRassette@acbhcs.org')
    if 'JO' in whox.upper():
     list.append('JEngstrom@acbhcs.org')
    if 'JA' in whox.upper():
     list.append('jbiblin@acbhcs.org')
    for item in list:
     print item
    who= list    
    if socket.gethostname() =='WinSPSSV4':
        sender='chet@acbhcs.org'
        recipient=', '.join(who)
        text=''
        html = """\
        <html>
          <head>Processing your request!<br></head>
            </html> <br> %s
        """ % whatFile
        body=html
        subject = 'Processing your request to run %s! ' % DB
        headers = ["From: " + sender,
                   "Subject: " + subject,
                   "To: " + recipient,
                   "MIME-Version: 1.0",
                   "Content-Type: text/html"]
        headers = "\r\n".join(headers)
        session = smtplib.SMTP("allsmtp.acgov.org",25)
        session.ehlo()
        session.starttls()
        session.ehlo
        session.sendmail(sender, who, headers + "\r\n\r\n" + body)
        session.quit()
    else:  
        subjectline='Processing your request to run %s! ' % DB
        SendEmailFrom='chet@acbhcs.org'
        SendEmailTo=who
        text=''
        html = """\
        <html>
          <head>Running your request!</head>
                  <br><br> %s
        
        </html> 
        """ % whatFile 
        msg = MIMEMultipart('alternative')
        msg['Subject'] = subjectline
        msg['From'] = SendEmailFrom
        msg['To'] = ", ".join(SendEmailTo)
        # Record the MIME types of both parts - text/plain and text/html.
        part1 = MIMEText(text, 'plain')
        part2 = MIMEText(html, 'html')
        # Attach parts into message container.
        # According to RFC 2046, the last part of a multipart message, in this case
        # the HTML message, is best and preferred.
        msg.attach(part1)
        msg.attach(part2)
        SMTP_SERVER = 'smtp.gmail.com'
        SMTP_PORT = 587
        # Send the message via local SMTP server.
        s = smtplib.SMTP("smtp.gmail.com", 587)
        s.ehlo()
        s.starttls()
        s.ehlo
        with open('//covenas/decisionsupport/meinzer/production/ps/secret/pw.txt','r') as pw:
            fillPW=pw.readline()
        s.login('alamedaDST@gmail.com', '%s' % fillPW) 
        # sendmail function takes 3 arguments: sender's address, recipient's address
        # and message to send - here it is sent as one string.
        s.sendmail(SendEmailFrom, SendEmailTo, msg.as_string())
        s.quit()

def printAllPushBreak():
    for afile in os.listdir('//covenas/decisionsupport/meinzer/production/insert/'):
            insertfile='//covenas/decisionsupport/meinzer/production/insert/'+afile   
            if 'BACK' not in afile.upper():
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

if __name__ == "__main__":
    try:
       main()
    except:
       logging.exception('Got exception on main handler')
       raise
