#Files=['//covenas/decisionsupport/meinzer/Production\dashboarddatasets/testfail.sps']


#Files=['//covenas/decisionsupport/meinzer/Production\dashboarddatasets/clinfo.sps']
import shutil
import spss
import re, os, pickle
from datetime import datetime


def main(Files):
    """The parser and processor for Syntax Error Reporting """
    try:
        for FilePath in Files:
                Start = datetime.now().replace( microsecond=0)
                DBname, init_Syntax = init_Vars(FilePath)
                cmds = init_cmds(init_Syntax)
                try:
                    # cmd, cmd2, cmd3=run_cmds(cmds) 
                    cmd2=''
                    cmd3=''
                    for cmd in cmds:
                       cmd=cmd.replace('\r\n','\n ')
                       cmd=cmd.replace('\t',' ')
                       print cmd
                       spss.Submit(cmd)  
                       cmd3=cmd2
                       cmd2=cmd     
                    Finish = datetime.now().replace( microsecond=0)                    
                    spss_Output(DBname)       
                    SavedNewname=check_saved_new_name(DBname)
                    if SavedNewname==1:
                        send_result(DBname,'Failure',Start,Finish,0,cmd,cmd2,cmd3)
                    if SavedNewname==0:
                        send_result(DBname,'Success',Start,Finish,1)
                except Exception,e:   
                    Finish = datetime.now().replace( microsecond=0)
                    errorLevel, errorMsg = get_spss_error(e)
                    send_result(DBname,"Failure in code",Start,Finish,0,cmd,cmd2,cmd3,errorLevel, errorMsg )
                    spss_Output(DBname)
                    break

    except IOError:
        print "can't open file or difficulty initializing comands from spss"
        send_result('Can not open File %s' % DBname,Start,Finish)
        spss_Output(DBname)

def send_result(DBname,result,Start,Finish,status,cmd='',cmd2='',cmd3='',errorLevel='', errorMsg=''):
    """Send error result to Error log, email log, and CSV log for checking last success"""
    print result + ' was sent for '+DBname
    FinishText = Finish.strftime("%m-%d-%y %H:%M")
    StartText = Start.strftime("%m-%d-%y %H:%M")
    Runtimex = str(Finish-Start)[0:7]
    error_result="""%s %s
    Start             Finish           Runtime Hrs:Min:Sec
    %s    %s   %s """ % (DBname,result,StartText,FinishText,Runtimex)
    
    error_result_email="""%s <br>
  %s <br> Runtime %s <br>\n
""" % (result,DBname,Runtimex)

    with open("//covenas/decisionsupport/meinzer/production/output/Error Log.txt", "r+") as myfile:
        old=myfile.read()
        myfile.seek(0)
        if status==1:
           myfile.write(error_result+"\n\n"+ old)
        if status==0:
           myfile.write(error_result+'\n'+'This was the problem\n'+errorLevel+" "+ errorMsg+'\n'+cmd3+'\n'+cmd2+'\n'+cmd+"\n\n"+ old)
    with open("//covenas/decisionsupport/meinzer/production/output/email Log.txt", "r+") as emailtext:
                 olde=emailtext.read()
                 emailtext.seek(0)
                 emailtext.write(error_result_email+ olde)
    with open("//covenas/decisionsupport/meinzer/production/output/ErrorCSV.txt", "r+") as ErrorCSV:
                      oldcsv=ErrorCSV.read()
                      ErrorCSV.seek(0)
                      ErrorCSV.write(DBname+','+str(status)+','+FinishText+",0"+"\n"+ oldcsv)
                 
def check_saved_new_name(DBname):
    """ Check if SPSS saved and files as new name but called it a success"""
    with open("//covenas/decisionsupport/meinzer/production/output/text/"+DBname+".txt", "r") as searchfile:
        if 'Warning # 5334' in open("//covenas/decisionsupport/meinzer/production/output/text/"+DBname+".txt", "r").read():
           SavedNewname=True
        else:
           SavedNewname=False   
    return SavedNewname
        

def run_cmds(cmds):
    """This is not functinoal now because i want to pass the cmds in and out """
    cmd2=''
    cmd3=''
    for cmd in cmds:
        cmd=cmd.replace('\r\n','\n ')
        cmd=cmd.replace('\t',' ')
        print cmd
        spss.Submit(cmd)  
        cmd3=cmd2
        cmd2=cmd       
    return cmd, cmd2, cmd3
              
def get_spss_error(e):
    """Check the most recent error in SPSS log """
    print 'Error', e
    errorLevel=str(spss.GetLastErrorLevel())
    errorMsg=spss.GetLastErrorMessage()
    return errorLevel, errorMsg
	
def init_cmds(init_Syntax):
    """initalize the syntax by removing BOMUTF8, seperating on os.linesep """
    with open(init_Syntax,'rb') as f:
        BOM_UTF8 = "\xef\xbb\xbf" 
        code = f.read().lstrip(BOM_UTF8) 
        cmds = re.split("(?<=\\.)%s[\t]*"   %    os.linesep, code, flags=re.M) 
        cmds = [cmd.lstrip() for cmd in cmds if not cmd.startswith("*")] 
        return cmds

def init_Vars(FilePath):
    """Initialize so windows users can use any slash they want and make a DBname """
    FilePath=FilePath.encode('string-escape')
    FilePath=FilePath.replace('\\','/')
    FilePath=FilePath.replace('/x07','/a')
    FilePath=FilePath.replace('//','/')
    FilePath=FilePath.replace('/x08','/b')
    FilePath=FilePath.replace('/x0b','/v')
    FilePath=FilePath.replace('/x0c','/v')
    print 'this is the file path..................... '+FilePath
    if '\\' in FilePath:
        DBname=FilePath.rpartition('\\')[-1]
    if '/' in FilePath:
        DBname=FilePath.rpartition('/')[-1]
    init_Syntax=FilePath
    OutputClose="output close name=%s." % DBname
    OutputNew="output new name=%s." %  DBname
    spss.Submit(OutputClose)
    spss.Submit(OutputNew)
    return DBname, init_Syntax


def spss_Output(DBname):
    """create output with spss and direct file location """
    outputtext="output export /text documentfile='//covenas/decisionsupport/meinzer/production/output/text/%s.txt'." %  DBname
    outputspv="output save outfile='//covenas/decisionsupport/meinzer/production/output/%s.spv'." % DBname
    spss.Submit(outputspv)  
    spss.Submit(outputtext)



if __name__ == "__main__":
    main(Files)
