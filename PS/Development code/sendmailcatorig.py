import csv
import base64
encoded = base64.b64encode('alameda2013')


from random import choice
import smtplib

import os, re
PictureList=[]
with open('//covenas/decisionsupport/meinzer/production/xtras/images.txt','r+') as chet:
 for pic in chet:
  PictureList.append(pic)
picture=choice(PictureList)


import shutil
for afile in os.listdir('//covenas/decisionsupport/meinzer/production/output/'):
    if afile.endswith('.spv'):
      src='//covenas/decisionsupport/meinzer/production/output/%s' % afile
      dst='//covenas/decisionsupport/DashboardDataSets/output/%s' % afile
      shutil.copyfile(src,dst)
      print src, dst


listerror=[]
with open('//covenas/decisionsupport/meinzer/production/output/ErrorTestLastWincsv.csv','r+') as lastWin:
   readLastWin=csv.reader(lastWin,delimiter=',')
   for row in readLastWin:
       if row[4]=='1':
         listerror.append(row[0]+' was last updated '+row[1]+" That's "+row[3]+' Days ago!')

if not listerror:
   listerror.append("""
All syntax have a success within permissible timeframe<br>
""")
else:
        listerror.insert(0,'Uh oh!  At Least one update is overdue!')    

for row in listerror:
 stringError ='<br> '.join(listerror)
# import urllib2
# from bs4 import BeautifulSoup
# page = BeautifulSoup(urllib2.urlopen("http://www.cuteoverload.com"))
# page.findAll('img')


from email.mime.multipart import MIMEMultipart
from email.mime.text import MIMEText

encoded = base64.b64encode('alameda2013')
# me == my email address
# you == recipient's email address
me = "alamedaDST@gmail.com"
you = ["LHall2@acbhcs.org","cmeinzer@acbhcs.org",'kbrindley@acgov.org','GOrozco@acbhcs.org']
#you = ["cmeinzer@acbhcs.org"]
stringtest=''
thelist=[]
SUC=0
FAIL=0
with open('//covenas/decisionsupport/meinzer/production/output/email log.txt','r') as errorlog:
    for line in errorlog:
      if '********************New Day!' in line:
         thelist.append(line+"<br>")
      else:
        if "Suc" in line: 
         SUC+=1
         thelist.append('<img src="http://www.colourbox.com/preview/1640168-33706-happy-red-heart-symbol-with-hands-and-legs.jpg" alt="Smiley face" height="30" width="30">'+"<br>"+line) 
        elif "Fai" in line:
         FAIL+=1
         thelist.append('<img src="http://rlv.zcache.ca/cute_sad_face_candy_tins-rd13dfcc9714d40219f07f31d442d632a_w5gqh_8byvr_324.jpg" alt="Frown face" height="38" width="38">'+"<br>"+line)  
        else:        
         thelist.append(line)
      if '********************New Day!' in line:
            break
    xx=stringtest.join(thelist)
    print xx


# Create message container - the correct MIME type is multipart/alternative.
msg = MIMEMultipart('alternative')
msg['Subject'] = "Error Test"
msg['From'] = me
msg['To'] = ", ".join(you)


# Create the body of the message (a plain-text and an HTML version).
text = "Here are the Results of my Error Test"
html = """\
<html>
  <head></head>
  <body>
    <p>Error Log<br>
           There were %s Succesful updates and %s Fail<br>
    %s <br>
       %s <br>
       %s
        <p> if <img src="http://www.colourbox.com/preview/1640168-33706-happy-red-heart-symbol-with-hands-and-legs.jpg" alt="Smiley face" height="30" width="30"> , Success!<br> 
      <p>If file <img src="http://rlv.zcache.ca/cute_sad_face_candy_tins-rd13dfcc9714d40219f07f31d442d632a_w5gqh_8byvr_324.jpg" alt="Frown face" height="38" width="38"> investigate the <a href="//covenas/decisionsupport//dashboarddatasets//output//">Output folder </a><br>
     <p>Then check the <a href="//covenas/decisionsupport//dashboarddatasets//">Syntax </a><br>
    </p>
  </body>
</html> 
""" % (SUC,FAIL,stringError,picture,xx)

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
datapw = base64.b64decode(encoded)
s.login('alamedaDST@gmail.com', datapw)
# sendmail function takes 3 arguments: sender's address, recipient's address
# and message to send - here it is sent as one string.
s.sendmail(me, you, msg.as_string())

s.quit()