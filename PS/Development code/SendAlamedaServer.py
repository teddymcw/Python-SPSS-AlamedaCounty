import smtplib
import os, re



def SendMail(sender,recipient,subject,*emailbody): 
	SMTP_SERVER = 'allsmtp.acgov.org'
	SMTP_PORT = 25
	thelist=[]
	for line in emailbody:
		thelist.append(line+'\r\n')
		"\n".join(thelist)
	print thelist
	body = '\n'+'\n'.join(thelist)+'\n'
	 
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
	#session.login('DecisionSupp@acbhcs.org', 'DSteam33')
	 
	session.sendmail(sender, recipient, headers + "\r\n\r\n" + body)
	session.quit()

if __name__ == "__main__":
	SendMail('DecisionSupp@acbhcs.org','cmeinzer@acbhcs.org','error test',"say what you want",'chet')

#thelist=[]
#with open('//covenas/decisionsupport/meinzer/production/output/email log.txt','r') as errorlog:
#    for line in errorlog:
#      thelist.append(line)
#      if '********************New Day!' in line:
#            break
#with open('//covenas/decisionsupport/meinzer/production/output/emailtext.txt','r+') as emailtext:
# emailtext.write("\n".join(thelist))