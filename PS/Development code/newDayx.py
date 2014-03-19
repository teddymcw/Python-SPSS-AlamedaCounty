from datetime import datetime
with open("//covenas/decisionsupport/meinzer/production/output/Error Log.txt", "r+") as myfile:
      datemake = datetime.now()
      today = datemake.strftime("%m - %d - %y")
      old=myfile.read()
      myfile.seek(0)
      myfile.write('********************New Day! *******   '+today+"\n\n" + old)

with open("//covenas/decisionsupport/meinzer/production/output/errorcsv.txt", "r+") as myfile:
      datemake = datetime.now()
      today = datemake.strftime("%m - %d - %y")
      old=myfile.read()
      myfile.seek(0)
      myfile.write('New Day!,,')
      
      
      +today