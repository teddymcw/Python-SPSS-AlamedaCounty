import smtplib
from email.mime.multipart import MIMEMultipart
from email.mime.text import MIMEText
import socket
import shutil
import os.path, time
from datetime import datetime 
import sys

# SendEmailFrom=sys.argv[1]
# SendEmailTo=sys.argv[2:]


primaryFolder='//covenas/decisionsupport/Meinzer/Production/Backup/epssvcupdate/'
def tryCopy(list,errorList,dstfile,srcfile):
    src=primaryFolder+srcfile
    dst=dstfile
    try:
        if datetime.fromtimestamp(os.path.getmtime(src)).date() == datetime.now().date():
            print 'sending '+src+ ' to '+dst
            #shutil.copyfile(src,dst)
            print 'complete!'
        else:
            print dst, datetime.fromtimestamp(os.path.getmtime(src)).date()
            print datetime.now().date()
            # list.append(dst)
            # errorList.append(dst+' last modified: %s' %  (time.ctime(os.path.getmtime(src))))
            raise
    except Exception,e:  
        errorList.append(e)
        list.append(dst)
        # list.append(dst+' could not be copied'+dst+' last modified: %s' %  (time.ctime(os.path.getmtime(src))))
        # print dst+' could not be copied '+dst+' last modified: %s' %  (time.ctime(os.path.getmtime(src)))
    return (list,errorList)

def copyFiles():
    primaryFolder='//covenas/decisionsupport/Meinzer/Production/Backup/epssvcupdate/'
    for afile in os.listdir(primaryFolder):
        list=[]
        errorList=[]
        if afile.upper().endswith('.SAV'):
            if 'EPS_YEAR' in afile.upper():
                list,errorList=tryCopy(list,errorList,'//covenas/decisionsupport/%s' % afile,afile)
                list,errorList=tryCopy(list,errorList,'//covenas/spssdata/%s' % afile,afile)
            if 'SERVICES' in afile.upper():
                list,errorList=tryCopy(list,errorList,'//covenas/decisionsupport/%s' % afile,afile)
                list,errorList=tryCopy(list,errorList,'//covenas/spssdata/%s' % afile,afile)
            if 'DBSVC' in afile.upper():
                list,errorList=tryCopy(list,errorList,'//covenas/decisionsupport/temp/%s' % afile,afile)
                list,errorList=tryCopy(list,errorList,'//covenas/spssdata/temp/%s' % afile,afile)
            if r'EPSCG.' in afile.upper():
                list,errorList=tryCopy(list,errorList,'//covenas/decisionsupport/%s' % afile,afile)
                list,errorList=tryCopy(list,errorList,'//covenas/spssdata/%s' % afile,afile)
            if 'STAFF' in afile.upper():
                list,errorList=tryCopy(list,errorList,'//covenas/decisionsupport/%s' % afile,afile)
                list,errorList=tryCopy(list,errorList,'//covenas/spssdata/%s' % afile,afile)
            if 'CLINF' in afile.upper():
                list,errorList=tryCopy(list,errorList,'//covenas/decisionsupport/%s' % afile,afile)
                list,errorList=tryCopy(list,errorList,'//covenas/spssdata/%s' % afile,afile)
            if 'ALLUR' in afile.upper():
                list,errorList=tryCopy(list,errorList,'//covenas/decisionsupport/%s' % afile,afile)
                list,errorList=tryCopy(list,errorList,'//covenas/spssdata/%s' % afile,afile)
            if list:    
                for item in list:
                    print item
                    print " last modified: %s" % (time.ctime(os.path.getmtime(item)))
            else:
                list.append("""All files up to date<br>""")
            if errorList:    
                for item in errorList:
                    print item
            else:
                errorList.append("""No Errors<br>""")
            return (list,errorList)

def initEmail(list,errorList):
    newlist=[]
    text = "Here are the Results of my Eps and Services update"
    newlist=zip(list,errorList)
    stringError='<br>'.join(str(i) for i in newlist)
    html = """\
    <html>
      <head></head>
      <body>
        <p>Error Log<br>
        </p>%s
      </body>
    </html> 
    """ % (stringError)
    return(html,text)

def sendEmail(me,you,html,text):
    print me
    print you
    # Create message container - the correct MIME type is multipart/alternative.
    msg = MIMEMultipart('alternative')
    msg['Subject'] = "Error Test"
    msg['From'] = me
    msg['To'] = ", ".join(you)
    # encoded = base64.b64encode('alameda2013')
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
    # datapw = base64.b64decode(encoded)
    s.login('alamedaDST@gmail.com', 'alameda2013')
    # sendmail function takes 3 arguments: sender's address, recipient's address
    # and message to send - here it is sent as one string.
    s.sendmail(me, you, msg.as_string())
    s.quit()

def sendEmailV4(sender,recipientx,html,text):
    # subject = ''
    print recipientx
    recipient=', '.join(recipientx)
    body=html
    subject = 'Error Test Results'
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
    session.sendmail(sender, recipientx, headers + "\r\n\r\n" + body)
    session.quit()

# SendEmailFrom='chet@acbhcs.org'
# SendEmailTo=['cmeinzer@acbhcs.org']

list,errorList=copyFiles()
html,text=initEmail(list,errorList)
if socket.gethostname() =='WinSPSSV4':
    sendEmailV4(SendEmailFrom,SendEmailTo,html,text)
else:
    sendEmail(SendEmailFrom,SendEmailTo,html,text)
        