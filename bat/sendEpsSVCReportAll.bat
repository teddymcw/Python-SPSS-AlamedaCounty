@ECHO OFF
SET  SendEmailTo1=cmeinzer@acbhcs.org
SET  SendEmailTo2=LHall2@acbhcs.org
SET  SendEmailTo4=GOrozco@acbhcs.org
SET  SendEmailTo5=KCoelho@acbhcs.org
SET  SendEmailTo6=JEngstrom@acbhcs.org
SET  SendEmailTo7=CShaw@acbhcs.org
SET SendEmailFrom=chet@acbhcs.org
"c:\python27\python.exe"  "K:\Meinzer\Production\ps\CopyEpsSvcSend.py"  %SendEmailFrom% %SendEmailTo1% %SendEmailTo2% %SendEmailTo4% %SendEmailTo5% %SendEmailTo6% %SendEmailTo7%
pause