import smtplib
from email.mime.multipart import MIMEMultipart
from email.mime.text import MIMEText
import socket
import shutil
import os.path, time
from datetime import datetime,timedelta
import sys

error=sys.argv[1]
args=sys.argv[2:]
argsx= ", ".join(args)
list=[]
if 'CHE' in argsx.upper():
 list.append('cmeinzer@acbhcs.org')
if 'LO' in argsx.upper():
 list.append('LHall2@acbhcs.org')
if 'GA' in argsx.upper():
 list.append('GOrozco@acbhcs.org')
if 'CHR' in argsx.upper():
 list.append('CShaw@acbhcs.org')
if 'KE' in argsx.upper():
 list.append('KCoelho@acbhcs.org')
if 'KI' in argsx.upper():
 list.append('KRassette@acbhcs.org')
if 'JO' in argsx.upper():
 list.append('JEngstrom@acbhcs.org')
if 'JA' in argsx.upper():
 list.append('jbiblin@acbhcs.org')
for item in list:
 print item
whox= list

def alertFinish(error,who):
    subjectline='Your files are complete %s!' % error
    SendEmailFrom='chet@acbhcs.org'
    SendEmailTo=who
    text=''
    html = """\
    <html>
      <head>The request is complete!</head>
              <br>
      <body>What happened<br> 
        %s<br>
        <p><h3>Check the <a href="k://meinzer//production//output//error log.txt//">error log</a> for more details.<br></h3><br></p>
        <br>
         <p></p>
        </body>
    </html> 
    """ % (error)
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

def alertFinishV4(error,who):
    sender='chet@acbhcs.org'
    recipient=', '.join(who)
    text=''
    html = """\
    <html>
      <head>The request is complete!<br></head>
              <br>
      <body>What happened<br> 
        %s<br>
        <p><h3>Check the <a href="k://meinzer//production//output//error log.txt//">error log</a> for more details.<br></h3><br></p>
        <br>
         <p></p>
        </body>
    </html> 
    """ % error
    body=html
    subject = 'Files complete %s! ' % error
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

#alertFinishV4('erroror',['chetstar@gmail.com','cmeinzer@acbhcs.org'])

# SendEmailFrom='chet@acbhcs.org'
# SendEmailTo=['cmeinzer@acbhcs.org']


if socket.gethostname() =='WinSPSSV4':
    alertFinishV4(error,whox)
else:
    alertFinish(error,whox)