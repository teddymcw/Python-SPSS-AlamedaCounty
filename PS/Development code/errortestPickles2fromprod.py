#test files to observe - uncomment out 8 or 9
#Files=['//covenas/decisionsupport/meinzer/Production\dashboarddatasets/test.sps']
#Files=['//covenas/decisionsupport/meinzer/Production\dashboarddatasets/testfail.sps']
#Files=['//covenas/decisionsupport/meinzer/Production\dashboarddatasets/clinfo.sps']
#Files=['//covenas/decisionsupport/meinzer/Production\dashboarddatasets/CSOC_Consecutive_High_Level_Svcs.sps']
#still needs error info passed.
#different from version 0 because this has the error level message import for on the fly.

import shutil
import spss
import re, os
from datetime import datetime

def main(Files):
    """The parser and processor for Syntax Error Reporting """
    errorLevel='0'
    errorMsg='No Error'
    SavedNewname=0
    try:
        for FilePath in Files:
            Start = datetime.now().replace( microsecond=0)
            DBname, init_Syntax = init_Vars(FilePath)
            cmds = init_cmds(init_Syntax)
            cmd=''
            cmd2=''
            cmd3=''
            try:
                for cmd in cmds:
                    cmd=cmd.replace('\r\n','\n ')
                    cmd=cmd.replace('\t',' ')
                    print cmd
                    spss.Submit(cmd)  
                    cmd3=cmd2
                    cmd2=cmd 
                Finish = datetime.now().replace( microsecond=0)                    
                spss_Output(DBname)    
                print DBname, ' output saved'  
                SavedNewname=check_saved_new_name(DBname)
                if SavedNewname==1:
                    send_result(DBname,'Failure',Start,Finish,0,'x',cmd,cmd2,cmd3)
                    break
                if SavedNewname==0:
                    send_result(DBname,'Success',Start,Finish,1,'x')
            except Exception,e:   
                Finish = datetime.now().replace( microsecond=0)
                errorLevel, errorMsg = get_spss_error(e)
                send_result(DBname,"Failure in code",Start,Finish,0,'x',cmd,cmd2,cmd3,errorLevel, errorMsg )
                break
            send_output_to_dev(DBname)  
    except IOError:
        print "can't open file or difficulty initializing comands from spss"
        send_result('Can not open File %s' % DBname,Start,Finish)
    if SavedNewname==1:
        errorMsg='The File was saved as a new name! be cautious.'
    errorList=[]
    errorList.append(DBname+' ')
    errorList.append(errorMsg+' ')
    errorList.append(errorLevel)
    with open('//covenas/decisionsupport/temp/errorresult.txt','w+') as ER:
        for item in errorList:
            ER.write(item)

def init_Vars(FilePath):
    FilePath=FilePath.encode('string-escape')
    #FilePath= map(os.path.normpath, FilePath)
    FilePath=FilePath.replace('\\','/')
    FilePath=FilePath.replace('/x07','/a')
    #FilePath=FilePath.replace('//','/')
    FilePath=FilePath.replace('/x08','/b')
    FilePath=FilePath.replace('/x0b','/v')
    FilePath=FilePath.replace('/x0c','/v')
    print 'this is the file path..................... '+FilePath
    DBname = os.path.split(os.path.normpath(FilePath))[-1]
    #if '\\' in FilePath:
    #    DBname=FilePath.rpartition('\\')[-1]
    #if '/' in FilePath:
    #    DBname=FilePath.rpartition('/')[-1]
    init_Syntax=FilePath
    OutputClose="output close name=%s." % DBname
    OutputNew="output new name=%s." %  DBname
    spss.Submit(OutputClose)
    spss.Submit(OutputNew)
    return (DBname, init_Syntax)

def init_cmds(init_Syntax):
    with open(init_Syntax,'rb') as f:
        BOM_UTF8 = "\xef\xbb\xbf" 
        code = f.read().lstrip(BOM_UTF8) 
        #r = re.compile('(?<=\.)\s*?^\s*',re.M)
        r = re.compile('(?<=\.)\s*?^\s*|\s*\Z|\A\s*',re.M)
        cmds = r.split(code) 
        #cmds = re.split("(?<=\\.)%s[ \t]*"   %    os.linesep, code, flags=re.M) 
        #cmds = re.split(r'(?<=\.)[ \t]*%s' % os.linesep, code, flags=re.M)
        cmds = [cmdx.lstrip() for cmdx in cmds if not cmdx.startswith("*")] 
        return cmds

def run_cmds(cmd,cmd2,cmd3,cmds):
    for cmd in cmds:
        cmd=cmd.replace('\r\n','\n ')
        cmd=cmd.replace('\t',' ')
        print cmd
        spss.Submit(cmd)  
        cmd3=cmd2
        cmd2=cmd       
    return (cmd, cmd2, cmd3)

def send_result(DBname,result,Start,Finish,status,AlertDays='x',cmd='',cmd2='',cmd3='',errorLevel='', errorMsg=''):
    """ """
    print result + ' was sent for '+DBname
    FinishText = Finish.strftime("%m-%d-%y %H:%M")
    StartText = Start.strftime("%m-%d-%y %H:%M")
    Runtimex = str(Finish-Start)[0:7]
    error_result="""%s %s
    Start             Finish           Runtime Hrs:Min:Sec
    %s    %s   %s """ % (DBname,result,StartText,FinishText,Runtimex)
    
    error_result_email="""%s <br>
  %s <br> Runtime %s <br>\n""" % (result,DBname,Runtimex)

    with open("//covenas/decisionsupport/meinzer/production/output/Error Log.txt", "r+") as myfile:
        old=myfile.read()
        myfile.seek(0)
        if status==1:
           myfile.write(error_result+"\n\n"+ old)
        if status==0:
           myfile.write(error_result+'\n'+'This was the problem\n'+errorLevel+" "+ errorMsg+'\n'+cmd3+'\n'+cmd2+'\n'+cmd+"\n\n"+ old)
    with open("//covenas/decisionsupport/meinzer/production/output/ErrorCSV.txt", "r+") as ErrorCSV:
                      oldcsv=ErrorCSV.read()
                      ErrorCSV.seek(0)
                      ErrorCSV.write(DBname+','+str(status)+','+FinishText+",0"+','+str(AlertDays)+"\n"+ oldcsv)

def check_saved_new_name(DBname):
    """ check saved new name"""
    if 'push' in DBname.lower():
        SavedNewname=False 
    else:
        try:
            if 'Warning # 5334' in open("//covenas/decisionsupport/meinzer/production/output/text/"+DBname+".txt", "r").read():
               SavedNewname=True
            else:
               SavedNewname=False   
        except:
            print 'there was an exception in check save new file'
    return SavedNewname
        
def get_spss_error(e):
    print 'Error', e
    errorLevel=str(spss.GetLastErrorLevel())
    errorMsg=spss.GetLastErrorMessage()
    return (errorLevel, errorMsg)

def spss_Output(DBname):
    """ """
    outputtext=r"output export /text documentfile='\\covenas\decisionsupport/meinzer/production/output/text/%s.txt'." %  DBname
    outputspv=r"output save outfile='\\covenas\decisionsupport/meinzer/production/output/%s.spv'." % DBname
    spss.Submit(outputspv)  
    spss.Submit(outputtext)

def send_output_to_dev(DBname):
    src=r"\\covenas\decisionsupport\meinzer\production\output\%s.spv" % DBname
    dst=r"\\covenas\decisionsupport\dashboarddatasets\output\%s.spv" % DBname
    if os.path.isfile(src):
        print 'copying ', src, " to x", dst
        shutil.copyfile(src,dst)