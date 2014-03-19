

GET DATA /TYPE=ODBC /CONNECT='DSN=mhs;Description=mhs;UID=;Database=CG_Snappers;Trusted_Connection=Yes;APP=IBM SPSS Products: '+
    'Statistics Common;WSID=HPMXL2221NXK'
 /SQL = 'SELECT REPORTING_UNIT as ru, convert(varchar(22), service_stamp, 121) as service_Stamp ,'+
'convert(varchar(23), episode_Stamp,121) AS EPSTAMP, CLIENT_NUMBER as "case", UR_POSTED_STAMP as urstamp, PROCEDURE_CODE as proced, TREATMENT_LOCATION as location ,'+
'HOURS as hours, MINUTES as minute, NUMBER_IN_GROUP as grpsize, PRIMARY_THERAPIST as staff, CO_THERAPIST as co_staff ,'+
'CO_STAFF_HOURS as cs_hours, CO_STAFF_MINUTES as cs_mnts, SERVICE_DATE as svcdate, COST_OF_SERVICE as cost ,'+
'TRIED_FINANCIAL_RESPONSIBILITY as tfinresp, FINANCIAL_RESPONSIBILITY as finresp, ACTUAL_FINANCIAL_RESPONSIBILITY as fin_resp FROM CG_Snappers.dbo.[DIRECT_SERVICES]'+
 ' WHERE SERVICE_DATE >= {ts ''2004-01-01 00:00:00''} AND SERVICE_DATE < {ts ''2009-01-01 00:00:00''} order by reporting_unit   '
 /ASSUMEDSTRWIDTH=255.

CACHE.

execute.

insert file='//covenas/decisionsupport/meinzer/production/ps/modules/varinfo.sps'.

 * save outfile='//covenas/decisionsupport/meinzer/temp/allsvc.sav'.
 * get file='//covenas/decisionsupport/meinzer/temp/allsvc.sav'.

match files /table='//covenas/decisionsupport/rutable.sav'/file=*/by ru.
if ru2 ne " " RU=ru2.

sort cases by  epstamp.
match files /table='//covenas/decisionsupport/Meinzer/Production/Backup/stage/EpStampMatch.sav'   /file=* /by epstamp.


formats case (f8.0).
formats staff(f12).
*staff was 12.5.
formats proced hours minute grpsize co_staff cs_hours cs_mnts svcdate cost tfinresp finresp fin_resp (f12.5).
formats  urstamp svcdate(date11).

sort cases by ru.
match files /table='//covenas/decisionsupport/rutable.sav' /file=* /by ru /drop Level3Classic TAYru svcType EPSDTGroup school  svcType3 CESDC 
cds_Code MHSA start_dt end_dt OAru Level2 program Residential OutCty CalWorks SafePassages RUCITY frc .

match files /file=* /keep=ru provname RU2 agency svcmode OurKids kidsru ab3632RU psmask2 county DayTx
UMBRELLA case opdate closdate epflag primdx refsrce lst_svc StaffEPS PrimaryTherapist epStamp service_Stamp
urstamp proced location hours minute grpsize staff co_staff cs_hours cs_mnts svcdate cost tfinresp finresp fin_resp.

compute svc_Stmp=number(substring(service_stamp,index(service_stamp," ")+1,13),time11)+number(substring(service_stamp,1,10),sdate10).
formats svc_Stmp(datetime23.2).
exe.

temp.
select if not any(proced, 100, 200, 300, 400, 197) AND proced lt 800.
aggregate outfile=* mode=addvariables
   /break ru case opdate
   /LastService=max(svcdate).

aggregate outfile=* mode=addvariables overwrite=yes
   /break ru case opdate
   /LastService=max(svcdate).
*this file would work for network dashboard.

insert file='//covenas/decisionsupport/modules/calsvcdate.sps'.
INSERT file= '//covenas/decisionsupport/modules\duration.sps'.
sort cascs by proced.
match files /table='//covenas/decisionsupport/procedsma.sav' /file=* /by proced.
sort cases by case.
match files /table='//covenas/spssdata/clinfo.sav'  /file=* /by case.
compute svcAge = Trunc((xdate.tday(svcdate) - xdate.tday(bday))/365.25).

 * temp.
 * select if epflag=''.
 * save outfile='//covenas/decisionsupport/temp/orphansvcs.sav'.

if closdate lt date.dmy(1,1,1901) closdate=$sysmis.
do if missing(closdate).
compute epflag='O'.
else.
compute  epflag='C'.
end if.
exe.
*sort cases by service_Stamp.
save outfile='//covenas/decisionsupport/Meinzer/Production/Backup/DBSVC04_09.sav' /keep agency provname ru case opdate closdate svcdate svcmode psmask2 proced county mcsvccat kidsru calendar 
duration duration2 cost LastService proclong svcage PrimaryTherapist staff bday epflag primdx unit svcmode ab3632RU DayTx RU2 service_Stamp svc_Stmp grpsize.



