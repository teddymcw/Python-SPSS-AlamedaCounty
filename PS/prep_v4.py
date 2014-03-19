import subprocess

base=r'c:\python27\python //covenas/decisionsupport/meinzer/production/ps/'
pushodbc=base+r'pushodbc.py'
Network=base+r'networkcontracttableupdate.py'
newday=base+r'newday.py'
delete_tempfiles=base+r'deletetempall.py'

subprocess.Popen(newday)
subprocess.Popen(delete_tempfiles)
subprocess.Popen(pushodbc)
subprocess.Popen(Network)


x=raw_input('press any key to close')