import sys


args=sys.argv[1:]
argsx= ", ".join(args)
list=[]
if 'CHE' in argsx.upper():
 list.append('cmeinzer@acbhcs.org')
if 'LOR' in argsx.upper():
 list.append('LHall2@acbhcs.org')
if 'GAB' in argsx.upper():
 list.append('GOrozco@acbhcs.org')
if 'CHR' in argsx.upper():
 list.append('CShaw@acbhcs.org')
if 'KEN' in argsx.upper():
 list.append('KCoelho@acbhcs.org')
if 'KIM' in argsx.upper():
 list.append('KRassette@acbhcs.org')
if 'JOH' in argsx.upper():
 list.append('JEngstrom@acbhcs.org')
if 'JAN' in argsx.upper():
 list.append('jbiblin@acbhcs.org')
for item in list:
 print item