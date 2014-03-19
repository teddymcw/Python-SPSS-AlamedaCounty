@ECHO OFF
SET  SendEmailTo1=cmeinzer@acbhcs.org
SET  SendEmailTo2=LHall2@acbhcs.org
SET  SendEmailTo3=kbrindley@acgov.org
SET  SendEmailTo4=GOrozco@acbhcs.org
SET SendEmailFromx=chet@acbhcs.org
"c:\python27\python.exe"  "K:\Meinzer\Production\ps\senderrorReport.py"  %SendEmailFromx% %SendEmailTo1% %SendEmailTo2% %SendEmailTo3% %SendEmailTo4%
pause