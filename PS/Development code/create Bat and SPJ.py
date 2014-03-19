

def createFiles(FN):
    batstring=r""""C:\Program Files\IBM\SPSS\Statistics\22\stats.exe" -production "//covenas/decisionsupport/Meinzer\Production\SPJ\%s.spj" """ % (FN)
    spjstring=r"""<?xml version="1.0" encoding="UTF-8"?><job print="false" syntaxErrorHandling="continue" syntaxFormat="interactive" unicode="false" xmlns="http://www.ibm.com/software/analytics/spss/xml/production" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xs//covenas/spssdata/schemaLocation="http://www.ibm.com/software/analytics/spss/xml/production http://www.ibm.com/software/analytics/spss/xml/production/production-1.3.xsd"><output outputFormat="viewer" outputPath="//covenas/decisionsupport/Meinzer\Production\Output\production made\%s.spv"/><syntax syntaxPath="//covenas/decisionsupport/Meinzer\Production\Insert\%s.sps"/></job>""" % (FN,FN)
    SPJloc="//covenas/decisionsupport/Meinzer/Production/SPJ/%s.spj" % FN
    BATloc="//covenas/decisionsupport/Meinzer/Production/bat/%s.bat" % FN
    with open(SPJloc,'w') as spj:
        spj.write(spjstring)
    with open(BATloc,'w') as bat:
        bat.write(batstring)    


FN=raw_input('what is the name of the .sps file without .sps:\n') 
createFiles(FN)
    
