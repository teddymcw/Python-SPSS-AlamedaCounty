import smtplib
from email.mime.multipart import MIMEMultipart
from email.mime.text import MIMEText
import socket
import shutil
import os
import os.path, time
from datetime import datetime,timedelta
import sys

SendEmailFrom=sys.argv[1]
SendEmailTo=sys.argv[2:]
benchmarkstart=datetime.now()

def tryCopy(uptodateList,resultList,errorList,afile,Drive):
    """ """
    freshData=99
    Bigger=99
    ioError=99
    primaryFolder='//covenas/decisionsupport/Meinzer/Production/Backup/stage/'
    src=primaryFolder+afile
    dst=Drive+afile
    dst=dst.replace('_1.s','.s')
    dst=dst.replace('_2.s','.s')            
    dst=dst.replace('_3.s','.s')
    print src+'<source\n dest> '+dst
    try:
        srcTime=datetime.fromtimestamp(os.path.getmtime(src))
        srcTime=srcTime.replace(second=0, microsecond=0)
        ioError=1
        print 'Source time was modified:'
        print srcTime
        dstTime=datetime.fromtimestamp(os.path.getmtime(dst))
        dstTime=dstTime.replace(second=0, microsecond=0)
        ioError=0
        print "destination time was modified:"
        print dstTime
    except Exception,e:
        print e
        shutil.copyfile(src,dst)
        resultList.append(dst)
        ioError=3
    try:
        if srcTime > dstTime:
            freshData=1
            if (os.stat(src).st_size) >= (os.stat(dst).st_size - 10000):
                Bigger=1
                print 'source ', (os.stat(src).st_size - 1000)
                print 'destination ',(os.stat(dst).st_size)
                print '\nsending '+src+ ' to '+dst+'\n'
                shutil.copyfile(src,dst)
                resultList.append(dst)
                print 'complete!'
            else:
                Bigger=0
                raise
        else:
            freshData=0
            print dst, datetime.fromtimestamp(os.path.getmtime(src)).date()
            if dstTime > (datetime.now() - timedelta(hours=24)):
                uptodateList.append('<br><b>'+dst+'</b> is up-to-date <br>on '+(time.ctime(os.path.getmtime(dst)))+'\n<br>')
            else:
                raise
    except Exception,e:  
        print 'there was an exception \n\n'
        if ioError==3:
            pass
        elif ioError==99:
            errorList.append('<b>'+dst+'</b> <br>The Source was missing possibly due to someone having the file open: <br>--The Destination was last Updated %s<br>' %  (time.ctime(os.path.getmtime(dst))))     
        elif ioError==1:
            errorList.append('<b>'+dst+'</b> <br>The destination file could not be overwritten:<br> ')     
        elif freshData==0:
            errorList.append('<b>'+dst+'</b><br>--File in staging is not newer than file in drive <br>--last updated by production %s<br>' %  (time.ctime(os.path.getmtime(dst))))
        elif Bigger==0:
            errorList.append('<b>'+dst+'</b><br>--Why Replacement file is smaller, so overwrite did not happen.  <br>--last updated by production %s<br>' %  (time.ctime(os.path.getmtime(dst))))
        else:
            errorList.append('<b>'+dst+'</b> <br>The Source was last updated: %s<br>--The Destination was last Updated %s<br>' %  (time.ctime(os.path.getmtime(src)),time.ctime(os.path.getmtime(dst))))
    return (uptodateList,resultList,errorList)

def copyFiles():
    primaryFolder='//covenas/decisionsupport/Meinzer/Production/Backup/stage/'
    resultList=[]
    errorList=[]
    lastMod=[]
    uptodateList=[]
    for afile in os.listdir(primaryFolder):
        if afile.upper().endswith('.SAV'):
            if 'EPS_YEAR' in afile.upper():
                uptodateList,resultList,errorList=tryCopy(uptodateList,resultList,errorList,afile,'//covenas/decisionsupport/')
                uptodateList,resultList,errorList=tryCopy(uptodateList,resultList,errorList,afile,'//covenas/spssdata/')
            if 'SERVICES' in afile.upper():
                uptodateList,resultList,errorList=tryCopy(uptodateList,resultList,errorList,afile,'//covenas/decisionsupport/')
                uptodateList,resultList,errorList=tryCopy(uptodateList,resultList,errorList,afile,'//covenas/spssdata/')
            if 'DBSVC' in afile.upper():
                uptodateList,resultList,errorList=tryCopy(uptodateList,resultList,errorList,afile,'//covenas/decisionsupport/')
                uptodateList,resultList,errorList=tryCopy(uptodateList,resultList,errorList,afile,'//covenas/spssdata/')
            if r'EPSCG.' in afile.upper():
                uptodateList,resultList,errorList=tryCopy(uptodateList,resultList,errorList,afile,'//covenas/decisionsupport/')
                uptodateList,resultList,errorList=tryCopy(uptodateList,resultList,errorList,afile,'//covenas/spssdata/')
            if 'STAFF' in afile.upper():
                uptodateList,resultList,errorList=tryCopy(uptodateList,resultList,errorList,afile,'//covenas/decisionsupport/')
                uptodateList,resultList,errorList=tryCopy(uptodateList,resultList,errorList,afile,'//covenas/spssdata/')
            if 'CLINF' in afile.upper():
                uptodateList,resultList,errorList=tryCopy(uptodateList,resultList,errorList,afile,'//covenas/decisionsupport/')
                uptodateList,resultList,errorList=tryCopy(uptodateList,resultList,errorList,afile,'//covenas/spssdata/')
            if 'ALLUR' in afile.upper():
                uptodateList,resultList,errorList=tryCopy(uptodateList,resultList,errorList,afile,'//covenas/decisionsupport/')
                uptodateList,resultList,errorList=tryCopy(uptodateList,resultList,errorList,afile,'//covenas/spssdata/')
            if 'MEDICALTABLE' in afile.upper():
                uptodateList,resultList,errorList=tryCopy(uptodateList,resultList,errorList,afile,'//covenas/decisionsupport/')
                uptodateList,resultList,errorList=tryCopy(uptodateList,resultList,errorList,afile,'//covenas/spssdata/temp/')
    if uptodateList:
        uptodateList.append('<br>The above files were not updated this run, but were updated in last 24 hours')
    else:
        uptodateList.append('<br>:) no files met this criteria')
    if resultList:    
        for item in resultList:
            print item
            lastMod.append(item+"<br> last updated: %s\n<br><br>" % (time.ctime(os.path.getmtime(item))))
    else:
        resultList.append("""No Files were updated during this run<br>""")
        lastMod.append(':(')
    if errorList: 
        errorAnnounce="Here's what didn't update"
        # for item in errorList:
            # print item
        errortest=1
    else:
        errorAnnounce="On this great day There Were No Errors<br>" 
        errorList.append("""Yeah!<br>""")
        errortest=0
    return (uptodateList,errortest,errorAnnounce,resultList,errorList,lastMod)

def initEmail(uptodateList,errortest,errorAnnounce,resultList,errorList,lastMod):
    if errortest==1:
        x=0
        for item in errorList:
            x+=1
        if x==1:
            subjectline='%s File not updated' % x
        else:
            subjectline='%s Files not updated' % x
    if errortest==0:
        subjectline='All Files Up-To-Date!'
    newlist=[]
    text = "Here are the Results of my Eps and Services update"
    stringError='<br>'.join(str(i) for i in errorList)
    stringlist='<br>'.join(str(i) for i in resultList)
    stringMod=' '.join(str(i) for i in lastMod)
    stringUptodate=' '.join(str(i) for i in uptodateList)
    html = """\
    <html>
      <head></head>
      <body>
        <p><h1>Update Log 2.0</h1><br></p>
        <h2>%s</h2>
        <p>%s</p><br>
        <h2>Here is what was updated</h2>
        <p>%s</p><br>
        <h2>These files may not have updated on this specific run, but they are up-to-date in last 24 hours:</h2>
        <p>%s</p><br>
        </body>
    </html> 
    """ % (errorAnnounce,stringError,stringlist,stringUptodate)
    return(subjectline,html,text)
#pulled out of above, gives the last mod time for updated files
#stringMod
        # <h2>Here is when the success happened</h2>
        # <p>%s</p><br>

def sendEmail(subjectline,SendEmailFrom,SendEmailTo,html,text):
    print SendEmailFrom
    print SendEmailTo
    # Create message container - the correct MIME type is multipart/alternative.
    msg = MIMEMultipart('alternative')
    msg['Subject'] = subjectline
    msg['From'] = SendEmailFrom
    msg['To'] = ", ".join(SendEmailTo)
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
    # datapw = base64.b64decode(encoded)
    #import pdb; pdb.set_trace();
    with open('//covenas/decisionsupport/meinzer/production/ps/secret/pw.txt','r') as pw:
        fillPW=pw.readline()
    s.login('alamedaDST@gmail.com', '%s' % fillPW) 
    # sendmail function takes 3 arguments: sender's address, recipient's address
    # and message to send - here it is sent as one string.
    s.sendmail(SendEmailFrom, SendEmailTo, msg.as_string())
    s.quit()

def sendEmailV4(subjectline,SendEmailFrom,SendEmailTo,html,text):
    # subject = ''
    print SendEmailTo
    recipient=', '.join(SendEmailTo)
    body=html
    subject = subjectline
    headers = ["From: " + SendEmailFrom,
               "Subject: " + subject,
               "To: " + recipient,
               "MIME-Version: 1.0",
               "Content-Type: text/html"]
    headers = "\r\n".join(headers)
    session = smtplib.SMTP("allsmtp.acgov.org",25)
    session.ehlo()
    session.starttls()
    session.ehlo
    session.sendmail(SendEmailFrom, SendEmailTo, headers + "\r\n\r\n" + body)
    session.quit()

# SendEmailFrom='chet@acbhcs.org'
# SendEmailTo=['cmeinzer@acbhcs.org']

uptodateList,errortest,errorAnnounce,resultList,errorList,lastMod=copyFiles()
subjectline,html,text=initEmail(uptodateList,errortest,errorAnnounce,resultList,errorList,lastMod)
if socket.gethostname() =='WinSPSSV4':
    sendEmailV4(subjectline,SendEmailFrom,SendEmailTo,html,text)
else:
    sendEmail(subjectline,SendEmailFrom,SendEmailTo,html,text)

benchmarkend=datetime.now()
FinishText = benchmarkend.strftime("%m-%d-%y %H:%M")
StartText = benchmarkstart.strftime("%m-%d-%y %H:%M")
Runtimex = str(benchmarkend-benchmarkstart)[0:7]
error_result="""Service and Ep creation
    Start             Finish           Runtime Hrs:Min:Sec
    %s    %s   %s """  % (StartText,FinishText,Runtimex)
    
with open("//covenas/decisionsupport/meinzer/production/output/Error Log.txt", "r+") as myfile:
    old=myfile.read()
    myfile.seek(0)
    myfile.write(error_result+"\n\n"+ old)