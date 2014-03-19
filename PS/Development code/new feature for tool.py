from subprocess import Popen

#test change

def main():
    removeOrAdd,DB = promptInfo1()
    if removeOrAdd.upper()=='R':
        remove(DB)
        checkInsert(DB)
        returnMain()
    elif removeOrAdd.upper()=='U':
        StageMove(DB)
        loadPushODBC()
        returnMain()
    elif removeOrAdd.upper()=='A':
        ErrorAlertDays,dashorMonth,DevProdBoth = promptInfo2()
        AddInsert  = createSyntax(ErrorAlertDays,DevProdBoth,DB) 
        placeInsert(dashorMonth,AddInsert)
        returnMain()
    elif removeOrAdd.upper()=='C':
        createFiles(DB)
        returnMain()
    elif removeOrAdd.upper()=='P':
        loadPushODBC()
        returnMain()
    elif removeOrAdd.upper()=='L':
        LookInsert(DB)
        returnMain()
    elif removeOrAdd.upper()=='PUSH':
        createFilesGeneric(DB)
        returnMain()


def promptInfo1():
    """ """
    removeOrAdd = raw_input(" \n\n (push)\n(R) remove from production\n(A) add to production\n(U) update staging to production\n(C) create bat spj\n(P) pushODBC File Create\n(L) Look in InsertFiles:\n ").upper()
    if removeOrAdd.upper()=='U':  
        for afile in os.listdir('//covenas/decisionsupport/DashboardDataSets/staging/'):
            print afile
    if removeOrAdd != 'L' and removeOrAdd != 'P':
        DB= raw_input("DB name without sps ")
    else:
        if removeOrAdd == 'L':
            DB= raw_input("type\nD = dashboardinsert.sps\nMM = MonThruF6am.sps\nC = monthlycooked.sps'").upper()
        else:
            DB='X'
    if removeOrAdd =='R':
        print '\n\nyou will remove all instances of %s from error log, \npress enter or cntr c to stop' % DB
        # remove(DB)
    return (removeOrAdd,DB)

def createFilesGeneric():
    import socket
    if socket.gethostname() =='WinSPSSV4':
        version='22'
    else:
        version='21'
    batstring=r""""C:\Program Files\IBM\SPSS\Statistics\%s\stats.exe" -production "//covenas/decisionsupport/Meinzer\Production\SPJ\generic.spj" """ %s (version)
    spjstring=r"""<?xml version="1.0" encoding="UTF-8"?><job print="false" syntaxErrorHandling="continue" syntaxFormat="interactive" unicode="false" xmlns="http://www.ibm.com/software/analytics/spss/xml/production" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xs//covenas/spssdata/schemaLocation="http://www.ibm.com/software/analytics/spss/xml/production http://www.ibm.com/software/analytics/spss/xml/production/production-1.3.xsd"><output outputFormat="viewer" outputPath="//covenas/decisionsupport/Meinzer\Production\Output\production made\%s.spv"/><syntax syntaxPath="//covenas/decisionsupport/temp\%s.sps"/></job>""" % ('generic','generic')
    SPJloc="//covenas/decisionsupport/\Meinzer\\Production\\SPJ\\%s.spj" % 'generic'
    BATloc="//covenas/decisionsupport/Meinzer/Production/bat/%s.bat" % 'generic'
    with open(SPJloc,'w') as spj:
        spj.write(spjstring)
    with open(BATloc,'w') as bat:
        bat.write(batstring)    

createFilesGeneric()
        
def createSyntaxGeneric(DB):
    DevProdBoth = raw_input("(F) File (D)ev, (P)roduction, ").upper()
    list=[]
    if 'F' in DevProdBoth.upper():
        list.append('//covenas/decisionsupport/meinzer/Production/dashboarddatasets/%s.sps' % DB)
    if 'D' in DevProdBoth.upper():
        list.append('//covenas/decisionsupport/meinzer/Production/push/%spush.sps'% DB)
    if 'P' in DevProdBoth.upper():
        list.append('//covenas/decisionsupport/meinzer/Production/pushproduction/%spushP.sps'% DB)
    liststring=list[0:]
    syntax="""begin program.
AlertDays=99  
File=%s
end program.
insert file='//covenas/decisionsupport/meinzer/production/ps/errorTestPickles.sps'.        """ % (liststring)
    splitsyntax=syntax.split('\n')
    with open('//covenas/decisionsupport/temp/generic.sps','w+') as gen:
        for item in splitsyntax:
            gen.write(item+'\n')
    print 'you are about to run'
    for line in splitsyntax:
     print line
    print 'is that okay?'
    xx = raw_input("control c to stop, \notherwise hit any key")


def runBat():
    Popen(r"//covenas/decisionsupport/meinzer/production/bat/generic.bat")
    
    Popen("//covenas/decisionsupport/temp/generic.bat")