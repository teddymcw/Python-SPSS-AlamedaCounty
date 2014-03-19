add files
	/file='//covenas/decisionsupport/temp\GuidanceClinicALLkids.sav'
	/file='//covenas/decisionsupport/temp\HospALLkids.sav'.


compute keepMe=1.
agg outfile='//covenas/decisionsupport/temp\KeepEps.sav' /break=case/keepMe=max(keepMe).

get file='//covenas/decisionsupport/temp\INSYSTservicesALLXX.sav'
	/keep ru case opdate closdate proclong svcdate epflag PrimaryTherapist staff Agency provname.

sort cases by case.
match files/table='//covenas/decisionsupport/temp\KeepEps.sav' /file=* /by case.
select if keepMe=1.
match files/table='//covenas/decisionsupport/clinfoCG.sav'//file=* /by case/drop sex .
rename vars name = ClientName.
sort cases by staff.
match files /table='//covenas/spssdata/staff.sav' /file=* /by staff.
rename vars Name = StaffName.

agg outfile='//covenas/decisionsupport/temp\KidsEps.sav'/break=ClientName RU case opdate epflag PrimaryTherapist agency provname
	/closedate  = max(closdate) /LastSvc = max(Svcdate).

save outfile='//covenas/decisionsupport/temp\KidsSvcs.sav' /keep ru case opdate agency provname StaffName proclong svcdate ClientName.


get file='//covenas/decisionsupport/temp\KidsEps.sav'.

SAVE TRANSLATE /TYPE=ODBC
 /Connect ='DSN=DashboardData;UID=;APP=SPSS For'+
 ' Windows;WSID=HPMXL9360ZDD;DATABASE=DashboardData;Trusted_Connection=Yes'
 /table= 'KidsEps' /MAP/REPLACE.


get file='//covenas/decisionsupport/temp\KidsSvcs.sav'.


SAVE TRANSLATE /TYPE=ODBC
 /Connect ='DSN=DashboardData;UID=;APP=SPSS For'+
 ' Windows;WSID=HPMXL9360ZDD;DATABASE=DashboardData;Trusted_Connection=Yes'
 /table= 'KidsSvcs' /MAP/REPLACE.

