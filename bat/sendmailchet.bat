@ECHO OFF
SET  SendEmailTo1=cmeinzer@acbhcs.org
SET SendEmailFromx=chet@acbhcs.org
"c:\python27\python.exe"  "K:\Meinzer\Production\ps\sendmail.py"  %SendEmailFromx% %SendEmailTo1% 
pause
