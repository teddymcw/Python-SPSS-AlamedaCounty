from bs4 import BeautifulSoup as bs
import urllib2
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
import socket
# import pdb
from datetime import datetime

import logging
logging.basicConfig(filename='//covenas/decisionsupport/sendmaillog.log',level=logging.DEBUG)
logging.debug('email sent'+ str(datetime.now()))


SendEmailFrom=sys.argv[1]
SendEmailTo=sys.argv[2:]
# SendEmailFrom='chet@acbhcs.org'
# SendEmailTo=['cmeinzer@acbhcs.org']

def main(SendEmailTo,SendEmailFrom):
    print(SendEmailTo,SendEmailFrom)
    dataResults='//covenas/decisionsupport/Meinzer/production/output/errorcsv.txt'
    stringError = initPull(dataResults)
    url = urllib2.urlopen('http://www.cuteoverload.com')
    emailImage='//covenas/decisionsupport/meinzer/production/ps/secret/emailimages.txt'
    picture=cuteScraper(url,emailImage)
    srcbase='//covenas/decisionsupport/meinzer/production/output/'
    dstbase='//covenas/decisionsupport/DashboardDataSets/output/'
    #copyOutput(srcbase,dstbase)
    (html,text)=initEmail(dataResults,picture,stringError)
    #SendEmailTo = ["LHall2@acbhcs.org","cmeinzer@acbhcs.org",'kbrindley@acgov.org','GOrozco@acbhcs.org']
    # SendEmailTo = ["cmeinzer@acbhcs.org"]
    # SendEmailFrom = "alamedaDST@gmail.com"
    if socket.gethostname() =='WinSPSSV4':
        sendEmailV4(SendEmailFrom,SendEmailTo,html,text)
    else:
        sendEmail(SendEmailFrom,SendEmailTo,html,text)
# def testit():
    # SendEmailFrom=sys.argv[1]
    # SendEmailTo=sys.argv[2:]
    # return(SendEmailFrom,SendEmailTo)
#dataResults='//covenas/decisionsupport/Meinzer/production/output/errorcsv.txt'
def initPull(dataResults):
    df=pd.read_csv(dataResults, names=['File','Status','Date','Error','AlertDays'])
    df=df.convert_objects(convert_numeric=True)
    df=df[pd.notnull(df['AlertDays'])]
    dmax=pd.DataFrame(df.groupby('File').max().reset_index())
    dmaxlim=dmax[['File','Date']]
    dfalert=pd.merge(dmaxlim,df,on=['File','Date'],how='left')
    dfalert=dfalert[['File','Date','AlertDays']]
    df=pd.read_csv(dataResults, names=['File','Status','Date','Error','AlertDays'])
    df=df.convert_objects(convert_numeric=True)
    df=df[df.Status ==  1]
    #df=df[(~df['File'].str.upper().str.contains('TEST')) | (~df['File'].str.upper().str.contains('New'))]
    df=df[(~df['File'].str.upper().str.contains('TEST'))]
    df=df[(~df['File'].str.upper().str.contains('New'))]
    df['Date']=pd.to_datetime(df['Date'])
    xx=df.groupby('File')['Date'].max()
    # xx=df.groupby('File')
    # xx=xx['Date'].max().order()
    xx=pd.DataFrame(xx).reset_index()
    df=pd.merge(xx,df,on=['File','Date'],how='left')
    df['diff'] = df.apply(lambda x: (datetime.now() - x['Date']).days, axis=1)
    df.drop('AlertDays',1,inplace=True)
    df=pd.merge(df,dfalert,on=['File'],how='left')
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
             listerror.append(row[1]+' was last updated '+row[6]+' Days ago!') 
    if not listerror:
       listerror.append("""
    All syntax have been run within expected timeframe<br>

    """)
    for row in listerror:
        stringError ='<br> '.join(listerror)
    return stringError

def cuteScraper(url,emailImage):
    # import pdb
    # pdb.set_trace();
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
            if 'stats' in link or 'blog' in link or 'logo' in link or 'tweet' in link or 'peegheader' in link or 'quantserve' in link or 'plugins' in link or 'noscript' in link:
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


def initEmail(dataResults,picture,stringError):
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
    sorted = df
    #sorted=df.sort(['Status','File'])
    # pdb.set_trace()
    Fails=sorted[sorted.Status == 0]['count'].sum()
    Sucs=sorted[sorted.Status == 1]['count'].sum()
    Faildf=sorted[sorted.Status==0]
    Sucdf=sorted[sorted.Status==1]
    # import pdb; pdb.set_trace();
    Fx=Faildf.groupby('File')['Date'].max().reset_index()
    Sx=Sucdf.groupby('File')['Date'].max().reset_index()
    try:
        if Fx.empty:
            FailArray=[]
        else:
            Fx['concat']= Fx['File']+' '+ Fx['Date'].apply(str) 
            FailArray=Fx['concat'].unique()
    except:
        print 'somethign could not be analyzed and failed'
        FailArray=[]
    try:
        if Sx.empty:
            SucArray=[]
        else:
            Sx['concat']= Sx['File']+' '+ Sx['Date'].apply(str) 
            SucArray=Sx['concat'].unique()
    except:
        print 'somethign could not be analyzed and failed' 
        SucArray=[]    
    FailList=[]
    SucList=[]
    for item in FailArray:
        FailList.append(item)
    for item in SucArray:
        SucList.append(item)
    if not FailList:
       FailList.append("""Nothing Failed""")
    if not SucList:
       SucList.append("""Nothing Ran since NewDay""")
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
           There were %s Successful updates and %s Fail<br>
           %s<br>
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
    """ % (Sucs,Fails,stringError,picture,FailString,SucString)
    return(html,text)


def sendEmail(me,you,html,text):
    print me
    print you
    # Create message container - the correct MIME type is multipart/alternative.
    msg = MIMEMultipart('alternative')
    msg['Subject'] = "Error Test"
    msg['From'] = me
    msg['To'] = ", ".join(you)
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

try:
   main(SendEmailTo,SendEmailFrom)
except:
   logging.exception('Got exception on main handler')
   raise
