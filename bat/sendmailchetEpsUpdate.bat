@ECHO OFF
SET SendEmailFrom=chet@acbhcs.org
SET  SendEmailTo1=cmeinzer@acbhcs.org
"c:\python27\python.exe"  "\\covenas\decisionsupport\Meinzer\Production\ps\copyEpsSvcsend.py"  %SendEmailFrom% %SendEmailTo1% 