begin program.
import spss
from datetime import date
if date.today() >= date(2013,7,1):
   spss.Submit("""
temp.
select if quarter=3 and year=2013.
*xsave outfile='//covenas/decisionsupport/Meinzer/Production/Backup/stage/services13_qtr3.sav' /drop quarter year LastService.
save outfile='//covenas/decisionsupport/Meinzer/Production/Backup/stage/services13_qtr3.sav' /drop quarter year LastService.
""")
else:
   print 'not 2013 7,1'

if date.today() >= date(2013,10,1):
   spss.Submit("""
temp.
select if quarter=4 and year=2013.
*xsave outfile='//covenas/decisionsupport/Meinzer/Production/Backup/stage/services13_qtr4.sav' /drop quarter year LastService.
save outfile='//covenas/decisionsupport/Meinzer/Production/Backup/stage/services13_qtr4.sav' /drop quarter year LastService.
""")
else:
   print 'not 2013 10,1'

if date.today() >= date(2014,1,1):
   spss.Submit("""
temp.
select if quarter=1 and year=2014.
*xsave outfile='//covenas/decisionsupport/Meinzer/Production/Backup/stage/services14_qtr1.sav' /drop quarter year LastService.
save outfile='//covenas/decisionsupport/Meinzer/Production/Backup/stage/services14_qtr1.sav' /drop quarter year LastService.
""")
else:
   print 'not 2014 '

if date.today() >= date(2014,4,1):
   spss.Submit("""
temp.
select if quarter=2 and year=2014.
*xsave outfile='//covenas/decisionsupport/Meinzer/Production/Backup/stage/services14_qtr2.sav' /drop quarter year LastService.
save outfile='//covenas/decisionsupport/Meinzer/Production/Backup/stage/services14_qtr2.sav' /drop quarter year LastService.
""")

if date.today() >= date(2014,7,1):
   spss.Submit("""
temp.
select if quarter=3 and year=2014.
*xsave outfile='//covenas/decisionsupport/Meinzer/Production/Backup/stage/services14_qtr3.sav' /drop quarter year LastService.
save outfile='//covenas/decisionsupport/Meinzer/Production/Backup/stage/services14_qtr3.sav' /drop quarter year LastService.
""")

if date.today() >= date(2014,10,1):
   spss.Submit("""
temp.
select if quarter=4 and year=2014.
*xsave outfile='//covenas/decisionsupport/Meinzer/Production/Backup/stage/services14_qtr4.sav' /drop quarter year LastService.
save outfile='//covenas/decisionsupport/Meinzer/Production/Backup/stage/services14_qtr4.sav' /drop quarter year LastService.
""")

if date.today() >= date(2015,1,1):
   spss.Submit("""
temp.
select if quarter=1 and year=2015.
*xsave outfile='//covenas/decisionsupport/Meinzer/Production/Backup/stage/services15_qtr1.sav' /drop quarter year LastService.
save outfile='//covenas/decisionsupport/Meinzer/Production/Backup/stage/services15_qtr1.sav' /drop quarter year LastService.
""")

end program.

