get file='//covenas/decisionsupport/Meinzer/Production/Backup/epssvcupdate/staff.sav'.
rename vars position=PositionKeep.
rename vars name=nameKeep.

match files/table='//covenas/spssdata/staff_id3.sav' /file=* /by staff.
exe.
rename vars name=namedrop.
rename vars namekeep=Name.   
rename vars position=positiondrop.
rename vars positionkeep=Position.
compute doc=0.
compute nurse=0.
exe.
delete vars positiontype.

insert file='//covenas/decisionsupport/meinzer/modules/staffmask.sps'.

match files /file=* /keep name intern DayTxStaff AccessStaff staff doc nurse id position PositionType manager partner notes.

sort cases by staff.
 * save outfile='//covenas/spssdata/staff_id3.sav'.
save outfile='//covenas/decisionsupport/Meinzer/Production/Backup/stage/staff_id3.sav'.


