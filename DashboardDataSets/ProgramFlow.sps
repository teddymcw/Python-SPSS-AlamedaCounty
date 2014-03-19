 * SAVE TRANSLATE OUTFILE='//covenas/decisionsupport/temp\rulist.csv'
  /TYPE=CSV
  /ENCODING='Locale'
  /MAP
  /REPLACE
/keep ru
  /FIELDNAMES 
  /CELLS=VALUES.
DEFINE DBstartdate() date.dmy(1,7,2012) !ENDDEFINE.


get file='//covenas/decisionsupport/dbsvc.sav' /keep kidsru agency provname ru case opdate closdate proced svcdate cost calendar duration psmask2 MCsvcCat svcMode PrimaryTherapist staff proclong epflag.

insert file='//covenas/decisionsupport/modules/uncookedmonth.sps'.
select if opdate lt uncookedmonth and (closdate ge DBstartdate or sysmis(closdate) ) and svcdate lt uncookedmonth.
if any(svcMode,"05","10") AND MCSvcCat ne "F. Crisis Stabilization" Duration=1.
do if missing(closdate).
compute epflag='O'.
else.
compute  epflag='C'.
end if.
insert file='//covenas/decisionsupport/modules/noshow.sps'.

sort cases by ru epflag.
save outfile='//covenas/decisionsupport/dbsvcprogramflowsvconlypre.sav'.

insert file='//covenas/decisionsupport/meinzer/production/ps/programflowx.sps'.
