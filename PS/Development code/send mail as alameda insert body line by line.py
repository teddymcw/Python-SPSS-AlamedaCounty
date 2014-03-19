sender = 'whatevs@acbhcs.org'
recipient = 'cmeinzer@acbhcs.org'
subject = ''


import smtplib
import os, re

thelist=['line1','line2','line3']
#with open('//covenas/decisionsupport/meinzer/production/output/email log.txt','r') as errorlog:
#    for line in errorlog:
#      thelist.append(line)
#      if '********************New Day!' in line:
#            break
 
SMTP_SERVER = 'allsmtp.acgov.org'
SMTP_PORT = 25
 


#link to file <p>Then check the <a href="//covenas/decisionsupport//dashboarddatasets//">Syntax </a><br>
body = '<br>\n\n'.join(thelist)+'\n'
morebody="""  <html>
      <head>  </head>
      <body>
        <p><br>
               <br>
        <br>
            <br>
      </body>
    </html> """
body=body+morebody 
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

 
session.sendmail(sender, recipient, headers + "\r\n\r\n" + body)
session.quit()
