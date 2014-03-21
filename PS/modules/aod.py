year=2007
month=1
quarter=1
while date.today() >= date(year,month,1):
   print """
temp.
select if quarter=%d and year=2014.
*xsave outfile='//covenas/decisionsupport/Meinzer/Production/Backup/stage/services14_qtr1.sav' /drop quarter year LastService.
save outfile='//covenas/decisionsupport/Meinzer/Production/Backup/stage/services14_qtr1.sav' /drop quarter year LastService.
""" % (quarter)
else:
   print 'not 2014 '