import re
import os, os.path
import socket, shutil
computerName=(socket.gethostname())
#chets computer
if computerName=='HPMXL2221NXK':
  folder='C:/Users/meinzerc/AppData/Local/Temp'
  print 'chets computer'
elif computerName=='WinSPSSV4':
  folder="C:/Documents and Settings/meinzerc/Local Settings/Temp"
  print 'you are on v4'
elif computerName=='WinSPSSV1':
  folder='C:/Documents and Settings/meinzerc/Local Settings/Temp'
  print 'you are on v4'
#janets new computer
elif computerName=='HP2UA3081880':
  folder='C:/Users/biblin/AppData/Local/Temp'
#janets old computer
elif computerName=='HPMXL9360ZDD':
  folder='C:/DOCUME~1/biblin/LOCALS~1/Temp'

print "\n\n\n\n**************\nCleaning folder ", folder  

for root, _, files in os.walk(folder):
    for f in files:
         print f
         DeletePath = os.path.join(root, f)
#       if "pas" in DeletePath or 'sps' in DeletePath:
         try:
#                 if os.path.isfile(file_path):
                    os.unlink(DeletePath)
                    print 'Success Cleaning file: ', DeletePath 
         except Exception, e:
             pass
         try:         
                    os.rmdir(root)
         except Exception, e:
             pass

for root, _, files in os.walk(folder):
    for f in files:
         try:
             os.rmdir(root)
             print 'cleaned', f
         except Exception, e:
            pass
shutil.rmtree(folder)
for root, dirs, files in os.walk(folder, topdown=False):
    for name in files:
        filename = os.path.join(root, name)
        os.chmod(filename, stat.S_IWUSR)
        os.remove(filename)
    for name in dirs:
        os.rmdir(os.path.join(root, name)) 
print 14*'*'