
GET FILE='//covenas/decisionsupport/epscg.sav'.
sort cases by ru.
match files /file=* /table='//covenas/decisionsupport/rutable.sav' /by ru /keep ru case opdate epflag PrimaryTherapist agency provname closdate LastService primdx.
rename vars primdx=dx.
sort cases by dx.
match files /file=* /table='//covenas/decisionsupport/dxtable.sav' /by dx /keep ru case opdate epflag PrimaryTherapist agency provname closdate LastService dx dx_descr.

select if  closdate ge datesum($time,-3,'years') or missing(closdate).
*freq closdate opdate /formats=notable /stast=min max.

sort cases by case.
match files/table='//covenas/spssdata/clinfo.sav'//file=* /by case/drop sex .
rename vars name = ClientName.

if agency="TriCity Homeless                        " agency="Abode Services".
 * sort cases by staff.
 * match files /table='//covenas/decisionsupport/staff.sav' /file=* /by staff.
 * rename vars Name = StaffName.
match files /file=* /keep ClientName ru case opdate epflag PrimaryTherapist agency provname closdate LastService dx dx_descr .


save outfile='//covenas/decisionsupport/meinzer/temp/Dashboard_eps3years.sav'.


*pushbreak.
*skiprow.
*remotepush.
*sqlTable = 'DashBoard_Eps3Years'.
*spsstable='//covenas/decisionsupport/meinzer/temp/Dashboard_eps3years.sav'.
*pushbreak.

