you = ["LHall2@acbhcs.org","cmeinzer@acbhcs.org",'kbrindley@acgov.org','GOrozco@acbhcs.org']
#you = ["cmeinzer@acbhcs.org"]

from bs4 import BeautifulSoup as bs
import urllib2
import os
import pandas as pd
import numpy
from datetime import datetime
import csv, operator
import base64
from random import choice
import smtplib
import shutil
import os, re
from email.mime.multipart import MIMEMultipart
from email.mime.text import MIMEText



df = pd.read_csv('//covenas/decisionsupport/Meinzer/production/output/errorcsv.txt', names=['File','Status','Date','Error','AlertDays'])
df=df[df.Status ==  1]
df=df[~df['File'].str.upper().str.contains('TEST')]
df['Date']=pd.to_datetime(df['Date'])
xx=df.groupby('File')['Date'].max().order()
xx=pd.DataFrame(xx).reset_index()
df=pd.merge(xx,df,on=['File','Date'],how='left')
#new[new['File'].str.upper().str.contains('CLINF')]
#xx=df.groupby(['File'], as_index=False).Date.max()
df['diff'] = df.apply(lambda x: (datetime.now() - x['Date']).days, axis=1)
df=df[(df['diff'] >= df['AlertDays'])]
df['alert']=1
# tens='|'.join(['allEps.sps','pafpull.sps','pafpullsend.sps'])
# tenDays=df[(df['diff'] >= 10) & (df.File.str.contains(tens))]
# tenDays
# thirtyThree='|'.join(['Level_1.sps','Level_1push.sps','Level_1pushp.sps','medicalfalloffa.sps','medicalfalloffpush.sps','allservices.sps','ASOC_Utilization.sps','ASOC_Utilizationpush.sps','ASOC_Utilizationpushp.sps'])
# df.thirtyThreeDays=df[(df['diff'] >= 33) & (df.File.str.contains(thirtyThree))]
# thirtyThreeDays
# leftOver=tens+'|'+thirtyThree
# fours=df[(df['diff'] >= 4) & (~df.File.str.contains(leftOver))]
# fours
# alerts=tenDays.append(thirtyThreeDays)
# alerts=fours.append(alerts)
# alerts
df.to_csv('//covenas/decisionsupport/meinzer/temp/errorlogicsort.csv')

listerror=[]
with open('//covenas/decisionsupport/meinzer/temp/errorlogicsort.csv','r+') as lastWin:
   readLastWin=csv.reader(lastWin,delimiter=',')
   for row in readLastWin:
       #print row
       if row[7]=='1':
         print row
         listerror.append(row[1]+' was last updated '+row[4]+' Days ago!')

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
        # oldscrape=testtxt.read()
        # testtxt.seek(0)
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

main(links)
encoded = base64.b64encode('alameda2013')
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



encoded = base64.b64encode('alameda2013')
# me == my email address
#now at the top you == recipient's email address
me = "alamedaDST@gmail.com"

thelist=[]

with open('//covenas/decisionsupport/Meinzer/production/output/errorcsv.txt','r') as errorlog:
    for line in errorlog:
      if 'New Day!' in line:
         thelist.append(line)
      else:
         thelist.append(line) 
      if 'New Day!' in line:
            break

with open("//covenas/decisionsupport/meinzer/production/output/email Log.txt", "r+") as emailtext:
    for item in thelist:
        emailtext.write(item)  

df = pd.read_csv('//covenas/decisionsupport/Meinzer/production/output/email Log.txt', names=['File','Status','Date','Error','AlertDays'])   
df['count']=1
sorted=df.sort(['Status'])
#count=sorted['count'][sorted.groupby(['Status']).sum().reset_index()]
Fails=sorted[sorted.Status == 0]['count'].sum()
Sucs=sorted[sorted.Status == 1]['count'].sum()

Faildf=sorted[sorted.Status==0]
Sucdf=sorted[sorted.Status==1]
SucArray=Sucdf['File'].unique()

FailArray=Faildf['File'].unique()

FailList=[]
SucList=[]
for item in FailArray:
    FailList.append(item)

for item in SucArray:
    SucList.append(item)

if not FailList:
   FailList.append("""Nothing Failed""")

Sucs
Fails
FailList
SucList

FailString='\n<br>'.join(FailList)
SucString='\n<br>'.join(SucList)


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
    <p><h3><b>Happy Holiday!   Error Log</h3></b><br>
       There were %s Succesful updates and %s Fail<br>
       %s<br>
       <br>
       %s<br>
       <br>
       <h3><b><p>    Here is what Failed </b></h3></p><br>
       %s<br>
       <br>
       <b><h3>Here is what worked </h3></b><br>
       %s
        <p> if <img src="http://www.colourbox.com/preview/1640168-33706-happy-red-heart-symbol-with-hands-and-legs.jpg" alt="Smiley face" height="30" width="30"> , Success!<br> 
      <p>If file <img src="http://rlv.zcache.ca/cute_sad_face_candy_tins-rd13dfcc9714d40219f07f31d442d632a_w5gqh_8byvr_324.jpg" alt="Frown face" height="38" width="38"> investigate the <a href="//covenas/decisionsupport//dashboarddatasets//output//">Output folder </a><br>
     <p>Then check the <a href="//covenas/decisionsupport//dashboarddatasets//">Syntax </a><br>
    </p>
  </body>
</html> 
""" % (Sucs,Fails,stringError,picture,FailString,SucString)

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
