from bs4 import BeautifulSoup as bs
import urllib2
import pandas as pd
import numpy
from datetime import datetime
import csv, operator
import pandas as pd
import numpy
from datetime import datetime
import csv, operator
from email.mime.multipart import MIMEMultipart
from email.mime.text import MIMEText
from random import choice
import smtplib
import os, re
import base64
import shutil

df = pd.read_csv('//covenas/decisionsupport/Meinzer/production/output/errorcsv.txt', names=['File','Status','Date','Error'])
df=df[df.Status ==  1]
df=df[~df['File'].str.upper().str.contains('TEST')]
df['Date']=pd.to_datetime(df['Date'])
xx=df.groupby('File')['Date'].max().order()
df=pd.DataFrame(xx).reset_index()
df['diff'] = df.apply(lambda x: (datetime.now() - x['Date']).days, axis=1)
df['alert']=1
tens='|'.join(['allEps.sps','pafpull.sps','pafpullsend.sps'])
tenDays=df[(df['diff'] >= 10) & (df.File.str.contains(tens))]
tenDays
thirtyThree='|'.join(['Level_1.sps','Level_1push.sps','Level_1pushp.sps','medicalfalloffa.sps','medicalfalloffpush.sps','allservices.sps','ASOC_Utilization.sps','ASOC_Utilizationpush.sps','ASOC_Utilizationpushp.sps'])
df.thirtyThreeDays=df[(df['diff'] >= 33) & (df.File.str.contains(thirtyThree))]
thirtyThreeDays
leftOver=tens+'|'+thirtyThree
fours=df[(df['diff'] >= 4) & (~df.File.str.contains(leftOver))]
fours
alerts=tenDays.append(thirtyThreeDays)
alerts=fours.append(alerts)
alerts
alerts.to_csv('//covenas/decisionsupport/meinzer/temp/errorlogicsort.csv')
listerror=[]
with open('//covenas/decisionsupport/meinzer/temp/errorlogicsort.csv','r+') as lastWin:
   readLastWin=csv.reader(lastWin,delimiter=',')
   for row in readLastWin:
       #print row
       if row[4]=='1':
         print row
         listerror.append(row[1]+' was last updated '+row[3]+' Days ago!')
listerror
if not listerror:
   listerror.append("""
All syntax have been run within expected timeframe<br>

""")
for row in listerror:
 stringError ='<br> '.join(listerror)
print stringError
url = urllib2.urlopen('http://www.cuteoverload.com')
soup = bs(url)
links = soup.findAll('img', src=True)
linklist=[]
oldlist=[]
stringemp=''
def main(links):
    for link in links:
        linklist.append(link['src']+'\n')    
    with open('//covenas/decisionsupport/meinzer/production/ps/secret/emailimages.txt','r+') as testtxt:
        for row in testtxt:
            oldlist.append(row)
    newlist=linklist+oldlist
    unduplist=list(set(newlist))   
    with open('//covenas/decisionsupport/meinzer/production/ps/secret/emailimages.txt','r+') as testtxt:
        for link in unduplist:
            if 'stats' in link or 'blog' in link or 'logo' in link or 'tweet' in link or 'peegheader' in link or 'quantserve' in link or 'plugins' in link or 'noscript' in lin//covenas/decisionsupport/
                print link
            else:
                link=link.replace('\r\n','')
                link=link.replace('\n','')
                if link.startswith('ht'):
                    testtxt.write(link+'\n')
                else:
                    print link
#if __name__=='__main__':
main(links)
PictureList=[]
with open('//covenas/decisionsupport/meinzer/production/ps/secret/emailimages.txt','r+') as chet:
 for pic in chet:
  PictureList.append('<img src= "'+pic+'" alt="yes" />')
picture=choice(PictureList)
picture=picture+'<br>'
picture=picture.lstrip("'").rstrip("',")
for afile in os.listdir('//covenas/decisionsupport/meinzer/production/output/'):
    if afile.endswith('.spv'):
      src='//covenas/decisionsupport/meinzer/production/output/%s' % afile
      dst='//covenas/decisionsupport/DashboardDataSets/output/%s' % afile
      shutil.copyfile(src,dst)
      print src, dst
stringtest=''
thelist=[]
FAIL=0
SUC=0
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

# Create the body of the message (a plain-text and an HTML version).
text = "Here are the Results of my Error Test"
body = """\
<html>
  <head></head>
  <body>
    <p>Error Log<br>
       There were %s Succesful updates and %s Fail<br>
       %s <br>
       %s
       %s
        <p> if <img src="http://www.colourbox.com/preview/1640168-33706-happy-red-heart-symbol-with-hands-and-legs.jpg" alt="Smiley face" height="30" width="30"> , Success!<br> 
      <p>If file <img src="http://rlv.zcache.ca/cute_sad_face_candy_tins-rd13dfcc9714d40219f07f31d442d632a_w5gqh_8byvr_324.jpg" alt="Frown face" height="38" width="38"> investigate the <a href="//covenas/decisionsupport//dashboarddatasets//output//">Output folder </a><br>
     <p>Then check the <a href="//covenas/decisionsupport//dashboarddatasets//">Syntax </a><br>
    </p>
  </body>
</html> 
""" % (SUC,FAIL,stringError,picture,xx)
SMTP_SERVER = 'allsmtp.acgov.org'
SMTP_PORT = 25

sender = 'whatevs@acbhcs.org'
recipient = 'cmeinzer@acbhcs.org'
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
session.sendmail(sender, recipient, headers + "\r\n\r\n" + body)
session.quit()
