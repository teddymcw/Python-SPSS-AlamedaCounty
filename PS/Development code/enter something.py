def main():
    var, frequency, DB=promptInfo()
    AddInsert = createSyntax(var, frequency,DB) 
    placeInsert(dashorMonth)
    
    
    
def promptInfo():
    dashorMonth = raw_input("D for Dashboard M for Monthly")
    var = raw_input("Remove (R), Dev(D), Production(P), or Both(B): ")
    frequency=raw_input('Days for run between:\n ')
    DB= raw_input("DB name without sps ")
    return (dashorMonth,var,frequency,DB)

def createSyntax(var, frequency,DB, AddInsert=''):
    if var=='D':
        print 'Dev'
        AddInsert="""
begin program.
Files=['//covenas/decisionsupport/meinzer/Production\dashboarddatasets/%s.sps',
'//covenas/decisionsupport/meinzer/Production\push/%spush.sps']
end program.
insert file='//covenas/decisionsupport/meinzer/production/ps/errorTestPickles.sps'.        """ % (DB,DB)
        
    elif var=='P':
        print 'Production'
        AddInsert="""
begin program.
Files=['//covenas/decisionsupport/meinzer/Production\dashboarddatasets/%s.sps',
'//covenas/decisionsupport/meinzer/Production\pushproduction/%spushP.sps']
end program.
insert file='//covenas/decisionsupport/meinzer/production/ps/errorTestPickles.sps'.        """ % (DB,DB)
    elif var=='B':
        print 'Both'
        AddInsert="""
begin program.
Files=['//covenas/decisionsupport/meinzer/Production\dashboarddatasets/%s.sps',
'//covenas/decisionsupport/meinzer/Production\push/%spush.sps,
'//covenas/decisionsupport/meinzer/Production\pushproduction/%spushP.sps']
end program.
insert file='//covenas/decisionsupport/meinzer/production/ps/errorTestPickles.sps'.        """ % (DB,DB,DB)
    else:
        print 'you did not make sense'
        AddInsert=''# var = raw_input("Dev Production or Both: ")
    return AddInsert    

    
def placeInsert(dashorMonth):
    if dashorMonth='D':
        file = '//covenas/decisionsupport/meinzer/dashboardinsertx.sps'
        with open(file, "rb") as f: 
            code=f.readlines()
        code.append(AddInsert)
        with open(file, 'w') as ts:
            for item in code:
                item=item.replace('\r\n','\n')
                ts.write(item) 
    else if dashorMonth='M':
        file = '//covenas/decisionsupport/meinzer/dashboardinsertx.sps'
        with open(file, "rb") as f: 
            code=f.readlines()
        code.append(AddInsert)
        with open(file, 'w') as ts:
            for item in code:
                item=item.replace('\r\n','\n')
                ts.write(item) 
    
def remove():
    """ take out x from csv, replace with test remove from insert file """
    pass

def updateDaysSince():
    pass
    
# # # with open(filex, "rb") as f: 
      # # # code=f.readlines()
    
# # # with open(file, "rb") as f: 
      # # # code=f.readlines()
# # # code.append(AddInsert)
# # # with open(file2, 'w') as ts:
    # # # for item in code:
        # # # item=item.replace('\r\n','\n')
        # # # ts.write(item) 

