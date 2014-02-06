begin program.
import spss
from datetime import date
if date.today() >= date(2014,1,1):
   spss.Submit("""
temp.
select if xdate.tday(opdate) lt yrmoda(2015,1,1) and (xdate.tday(closdate) ge yrmoda(2014,1,1) or closdate lt date.dmy(1,1,1900)).
save outfile='//covenas/decisionsupport/Meinzer/Production/Backup/stage/eps_year_2014.sav' /drop PrimaryTherapist.
""")
if date.today() >= date(2015,1,1):
   spss.Submit("""
temp.
select if xdate.tday(opdate) lt yrmoda(2016,1,1) and (xdate.tday(closdate) ge yrmoda(2015,1,1) or closdate lt date.dmy(1,1,1900)).
save outfile='//covenas/decisionsupport/Meinzer/Production/Backup/stage/eps_year_2015.sav' /drop PrimaryTherapist.
""")

end program.