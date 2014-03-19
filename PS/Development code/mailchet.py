
from bs4 import BeautifulSoup as bs
import urllib2

from datetime import datetime
import csv
from datetime import datetime
from email.mime.multipart import MIMEMultipart
from email.mime.text import MIMEText
from random import choice
import smtplib
import os
import base64
import shutil
import pandas as pd
import sys

SendEmailFrom=sys.argv[1]
SendEmailTo=sys.argv[2:]

def main(SendEmailTo,SendEmailFrom):
    print(SendEmailTo,SendEmailFrom)
    dataResults='//covenas/decisionsupport/Meinzer/production/output/errorcsv.txt'
    stringError = initPull(dataResults)
    url = urllib2.urlopen('http://www.cuteoverload.com')
    emailImage='//covenas/decisionsupport/meinzer/production/ps/secret/emailimages.txt'
    picture=cuteScraper(url,emailImage)
    srcbase='//covenas/decisionsupport/meinzer/production/output/'
    dstbase='//covenas/decisionsupport/DashboardDataSets/output/'
    copyOutput(srcbase,dstbase)
    (html,text)=initEmail(dataResults,picture)
    #SendEmailTo = ["LHall2@acbhcs.org","cmeinzer@acbhcs.org",'kbrindley@acgov.org','GOrozco@acbhcs.org']
    # SendEmailTo = ["cmeinzer@acbhcs.org"]
    # SendEmailFrom = "alamedaDST@gmail.com"
    sendEmail(SendEmailFrom,SendEmailTo,html,text)

# def testit():
    # SendEmailFrom=sys.argv[1]
    # SendEmailTo=sys.argv[2:]
    # return(SendEmailFrom,SendEmailTo)

def initPull(dataResults):
    df = pd.read_csv(dataResults, names=['File','Status','Date','Error','AlertDays'])
    df=df[df.Status ==  1]
    df=df[(~df['File'].str.upper().str.contains('TEST')) | (~df['File'].str.upper().str.contains('New'))]
    df['Date']=pd.to_datetime(df['Date'])
    xx=df.groupby('File')['Date'].max()
    # xx=df.groupby('File')
    # xx=xx['Date'].max().order()
    xx=pd.DataFrame(xx).reset_index()
    df=pd.merge(xx,df,on=['File','Date'],how='left')
    df['diff'] = df.apply(lambda x: (datetime.now() - x['Date']).days, axis=1)
    df=df[(df['diff'] >= df['AlertDays'])]
    df['alert']=1
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
    return stringError

def cuteScraper(url,emailImage):
    linklist=[]
    oldlist=[]
    stringemp=''
    soup = bs(url)
    links = soup.findAll('img', src=True)
    for link in links:
        linklist.append(link['src']+'\n')    
    with open(emailImage,'r+') as testtxt:
        for row in testtxt:
            oldlist.append(row)
    newlist=linklist+oldlist
    unduplist=list(set(newlist))   
    with open(emailImage,'r+') as testtxt:
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
    PictureList=[]
    with open(emailImage,'r+') as chet:
     for pic in chet:
      PictureList.append('<img src= "'+pic+'" alt="yes" />')
    picture=choice(PictureList)
    picture=picture+'<br>'
    picture=picture.lstrip("'").rstrip("',")
    return picture


def copyOutput(srcbase,dstbase):
    for afile in os.listdir('//covenas/decisionsupport/meinzer/production/output/'):
        if afile.endswith('.spv'):
          src=srcbase+'%s' % afile
          dst=dstbase+'%s' % afile
          shutil.copyfile(src,dst)
          print 'Copying output to //covenas/decisionsupport/dashboarddatasets output', src, dst, '\n'


def initEmail(dataResults,picture):
    thelist=[]
    with open(dataResults,'r') as errorlog:
        for line in errorlog:
          if 'New Day!' in line:
             thelist.append(line)
          else:
             thelist.append(line) 
          if 'New Day!' in line:
                break
    with open("//covenas/decisionsupport/meinzer/production/output/email Log.txt", "w") as emailtext:
        for item in thelist:
            emailtext.write(item)
    df = pd.read_csv('//covenas/decisionsupport/Meinzer/production/output/email Log.txt', names=['File','Status','Date','Error','AlertDays'])   
    df['count']=1
    sorted=df.sort(['Status','File'])
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
    text = "Here are the Results of my Error Test"
    html = """\
    <html>
      <head></head>
      <body>
        <p>Error Log<br>
           There were %s Succesful updates and %s Fail<br>
           %s<br>
           <br>
           <h3><b>Here is what Failed </b></h3><br>
           %s<br>
           <br>
           <h3><b>Here is what worked  </b></h3><br>
           %s
            <p> if <img src="http://www.colourbox.com/preview/1640168-33706-happy-red-heart-symbol-with-hands-and-legs.jpg" alt="Smiley face" height="30" width="30"> , Success!<br> 
          <p>If file <img src="http://rlv.zcache.ca/cute_sad_face_candy_tins-rd13dfcc9714d40219f07f31d442d632a_w5gqh_8byvr_324.jpg" alt="Frown face" height="38" width="38"> investigate the <a href="//covenas/decisionsupport//dashboarddatasets//output//">Output folder </a><br>
         <p>Then check the <a href="//covenas/decisionsupport//dashboarddatasets//">Syntax </a><br>
        </p>
      </body>
    </html> 
    """ % (Sucs,Fails,picture,FailString,SucString)
    return(html,text)

def sendEmail(sender,recipientx,html,text):
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
    

main(SendEmailTo,SendEmailFrom)