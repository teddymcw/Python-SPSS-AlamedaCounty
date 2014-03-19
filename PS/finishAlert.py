import smtplib
from email.mime.multipart import MIMEMultipart
from email.mime.text import MIMEText
import socket
import shutil
import os.path, time
from datetime import datetime,timedelta
import sys

args=sys.argv[1:]
argsx= ", ".join(args)
list=[]
if 'CHE' in argsx.upper():
 list.append('cmeinzer@acbhcs.org')
if 'LOR' in argsx.upper():
 list.append('LHall2@acbhcs.org')
if 'GAB' in argsx.upper():
 list.append('GOrozco@acbhcs.org')
if 'CHR' in argsx.upper():
 list.append('CShaw@acbhcs.org')
if 'KEN' in argsx.upper():
 list.append('KCoelho@acbhcs.org')
if 'KIM' in argsx.upper():
 list.append('KRassette@acbhcs.org')
if 'JOH' in argsx.upper():
 list.append('JEngstrom@acbhcs.org')
if 'JAN' in argsx.upper():
 list.append('jbiblin@acbhcs.org')
for item in list:
 print item
whox= list

def alertFinish(who=whox):
    subjectline='Your files are complete'
    SendEmailFrom='chet@acbhcs.org'
    SendEmailTo=who
    #whatRan="<br> ".join(Files)
    text=''
    html = """\
    <html>
      <head>The request is complete!</head>
      <body>
        <p><h1>check the <a href="k://meinzer//production//output//error log.txt//">error log</a><br></h1><br></p>
        <br>
         <p></p>
        </body>
    </html> 
    """ 
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

def alertFinishV4(who=whox):
    subjectline='Your files are complete'
    SendEmailFrom='chet@acbhcs.org'
    SendEmailTo=who
    recipient=', '.join(SendEmailTo)
    #whatRan="<br> ".join(Files)
    text=''
    html = """\
    <html>
      <head>Your Files are complete</head>
      <body>
        <p><h1>check the <a href="k://meinzer//production//output//error log.txt//">error log </a><br></h1><br></p>
        <br>
         <p></p>
        </body>
    </html> 
    """ 
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
    session.sendmail(SendEmailFrom, recipient, headers + "\r\n\r\n" + body)
    session.quit()

# SendEmailFrom='chet@acbhcs.org'
# SendEmailTo=['cmeinzer@acbhcs.org']


if socket.gethostname() =='WinSPSSV4':
    alertFinishV4()
else:
    alertFinish()