year=2001
month=1
quarter=1
while date.today() >= date(year,month,1):
    print """
temp.
select if quarter=%d and year=%d.
save outfile='//covenas/decisionsupport/Meinzer/Production/Backup/stage/services%s_qtr%d.sav' /drop quarter year LastService.
""" % (quarter,year,str(year)[2:4],quarter)
    month=month+3
    quarter=quarter+1
    if month==13:
        month=1
        quarter=1
        year=year+1

begin program.
from datetime import date
import spss
year=2001

while date.today() >= date(year,1,1):
    spss.Submit("""
temp.
select if opdate lt date.dmy(1,1,%d) and ((closdate) ge date.dmy(1,1,%d) or closdate lt date.dmy(1,1,1901)).
save outfile='//covenas/decisionsupport/Meinzer/Production/Backup/stage/eps_year_%d.sav'.
""" % (year+1,year,year))
    year=year+1
end program.


