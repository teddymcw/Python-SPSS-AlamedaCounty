GET DATA /TYPE=ODBC   /CONNECT='DSN=mhs;Description=mhs;UID=;DATABASE=CG_Snappers;Trusted_Connection=Yes;APP=IBM SPSS Products: '+
    'Statistics Common;WSID=HPMXL2221NXK'
 /SQL = 'SELECT REPORTING_UNIT as ru, CLIENT_NUMBER as "case", OPENING_DATE as opdate, CLOSING_DATE as closdate, '+
 'DIAGNOSIS_AXIS_THREE as dx3, REFERRAL_SOURCE as refsrce, REFERRAL_DESTINATION_ONE as ref_dest, REFERRAL_DESTINATION_TWO as refdest2, '+
 'REFERRAL_DESTINATION_THREE as refdest3, PHYSICIAN as doctor, EMPLOYMENT_STATUS_ENTRY as emp_ent, EMPLOYMENT_STATUS_EXIT as emp_end, '+
 'TYPE_OF_EMPLOYMENT as emp_type, PRIMARY_THERAPIST as staff, SM.STAFF_NAME as PrimaryTherapist, FINANCIAL_RESPONSIBILITY as payor, LAST_SERVICE_DATE as lst_svc, '+
 'EPISODE_STATUS_FLAG as epflag, ADMISSION_LEGAL_STATUS as adlegal, SUPPLEMENTAL_AXIS_ONE as supp_dx1, PRIMARY_DIAGNOSIS as primdx, '+
 'SECONDARY_DIAGNOSIS as sec_dx1, DIAGNOSIS_AXIS_TWO as dx2, DIAGNOSIS_AXIS_FIVE as gaf, OPENING_GAF as opgaf, PAST_GAF as pastgaf, '+
 'convert(varchar(23), episode_Stamp,121) AS EPSTAMP, REASON_FOR_DISCHARGE as dreason,  ADMISSION_LIVING_SITUATION as adliv, '+
 'DISCHARGE_LIVING_SITUATION as disliv, TREATMENT_OF_MINORS as lconsent, Episodes.LAST_CHANGE_STAMP as lchange '+
 'FROM CG_Snappers.dbo.Episodes Episodes Left outer JOIN  DBO.STAFF_MASTER SM ON SM.STAFF_NUMBER = Episodes.PRIMARY_THERAPIST'
 /ASSUMEDSTRWIDTH=255.

cache.
exe.
insert file='//covenas/decisionsupport/meinzer/production/ps/modules/varinfo.sps'.
if missing(closdate) closdate=date.dmy(17,11,1858).
compute closdate=date.dmy(xdate.mday(closdate),xdate.month(closdate),xdate.year(closdate)).

variable labels				
ru"RUNAME INFO.REPORTING UNIT"
case"CLIENT NUMBER"
opdate"OPENING DATE"
closdate"CLOSING DATE"
dx3"DIAGNOSIS AXIS THREE"
refsrce"REFERRAL SOURCE"
ref_dest"REFERRAL_DESTINATION_ONE"
refdest2"REFERRAL_DESTINATION_TWO"
refdest3"REFERRAL_DESTINATION_THREE"
doctor"PHYSICIAN"
emp_ent"EMPLOYMENT_STATUS_ENTRY"
emp_end"EMPLOYMENT_STATUS_EXIT"
emp_type"TYPE_OF_EMPLOYMENT"
staff"PRIMARY_THERAPIST"
payor"FINANCIAL_RESPONSIBILITY"
lst_svc"LAST_SERVICE_DATE"
epflag"EPISODE_STATUS_FLAG"
adlegal"ADMISSION_LEGAL_STATUS"
supp_dx1"SUPPLEMENTAL_AXIS_ONE"
primdx"PRIMARY_DIAGNOSIS"
sec_dx1"SECONDARY_DIAGNOSIS"
dx2"DIAGNOSIS_AXIS_TWO"
gaf"DIAGNOSIS_AXIS_FIVE"
opgaf"OPENING_GAF"
pastgaf"PAST_GAF"
epstamp"EPISODE_STAMP"
dreason"REASON_FOR_DISCHARGE"
adliv"ADMISSION_LIVING_SITUATION"
disliv"DISCHARGE_LIVING_SITUATION"
lconsent"TREATMENT_OF_MINORS"
lchange"LAST_CHANGE_STAMP".

if substr(epstamp,20,1) = " " epstamp=concat(rtrim(epstamp),".000").
rename variables epstamp=epStamp2.
string epStamp(a23).
compute epstamp = substr(epstamp2,1,23).	 

sort cases by ru.
match files/table='//covenas/decisionsupport/rutable.sav'/file=*/by ru.
if ru2 ne "  " RU=ru2.

sort cases by EpStamp.
save outfile='//covenas/decisionsupport/Meinzer/Production/Backup/stage/EpStampMatch.sav' /keep epstamp Opdate. 

sort cases by ru case opdate epstamp.
match file/file=*/by ru case opdate/last=keep.
select if keep=1.

formats case(f8).
formats opdate closdate lst_svc lchange(date11).
formats doctor emp_ent emp_end emp_type staff dreason adliv disliv (f12.0).

sort cases by ru case opdate.
save outfile='//covenas/decisionsupport/Meinzer/Production/Backup/stage/EpsALL.sav' /keep ru case opdate closdate dx3 refsrce ref_dest refdest2 refdest3 doctor emp_ent emp_end emp_type PrimaryTherapist
lst_svc epflag adlegal supp_dx1 primdx sec_dx1 dx2 gaf opgaf pastgaf epstamp dreason adliv disliv lconsent lchange.

*just in case epflag is missing.
select if opdate ge date.dmy(1,1,2004) OR epflag = "O" OR closdate ge date.dmy(1,7,2004).

match files/file=* /keep ru case opdate closdate dx3 refsrce ref_dest refdest2 payor refdest3 doctor emp_ent emp_end emp_type staff PrimaryTherapist
lst_svc epflag adlegal supp_dx1 primdx sec_dx1 dx2 gaf opgaf pastgaf epstamp dreason  adliv disliv lconsent lchange.

*not sure this works!.
TEMPORARY.
if closdate lt date.dmy(2,2,1901) closdate=$sysmis.
save outfile='//covenas/decisionsupport/Meinzer/Production/Backup/stage/EpsCGx.sav'  /keep case Opdate RU CLOSDATE EPFLAG PrimDx  refsrce  lst_svc staff  PrimaryTherapist. 
 * save outfile='//covenas/spssdata/EpsCGx.sav'  /keep case Opdate RU CLOSDATE EPFLAG PrimDx  refsrce  lst_svc staff  PrimaryTherapist. 
select if opdate ge date.dmy(1,1,2007) OR epflag = "O" OR closdate ge date.dmy(1,1,2007).

 * if closdate = date.dmy(17,11,1858) closdate=$sysmis.

*save outfile='//covenas/decisionsupport/Eps08now.sav'  /drop Staff gaf opgaf pastgaf .
*save outfile='//covenas/spssdata/Eps08now.sav'  /drop Staff gaf opgaf pastgaf .

save outfile='//covenas/decisionsupport/Meinzer/Production/Backup/stage/Episodes.sav' /drop PrimaryTherapist.

add files
          /file="//covenas/spssdata/housing\Adliv_BigEpFile.sav"
          /file=*
          /keep ru case opdate LChange adliv.

*sort cases by ru.
*match files/table="//covenas/spssdata/rutable.sav"/file=*/by ru/keep ru case opdate LChange adliv psmask2.

compute drop=0.
sort cases by ru case opdate LChange.
exe.
do if case=lag(case) and ru=lag(ru) and opdate=lag(opdate).
if adliv=lag(adliv) drop=1.
end if.
execute.
*freq drop.
select if drop=0.
save outfile="//covenas/spssdata/housing\Adliv_BigEpFile.sav"/drop drop.

 * get file='//covenas/decisionsupport/Meinzer/Production/Backup/stage//epstemp.sav'.

 * temp.
 * select if opdate lt date.dmy(1,1,2001) and ((closdate) ge date.dmy(1,1,2000) or closdate lt date.dmy(1,1,1901)).
*xsave outfile='//covenas/decisionsupport/eps_year_2000.sav' /drop PrimaryTherapist.
 * save outfile='//covenas/decisionsupport/Meinzer/Production/Backup/stage/eps_year_2000.sav' /drop PrimaryTherapist.

 * temp.
 * select if opdate lt date.dmy(1,1,2002) and ((closdate) ge date.dmy(1,1,2001) or closdate lt date.dmy(1,1,1901)).
*xsave outfile='//covenas/decisionsupport/eps_year_2001.sav' /drop PrimaryTherapist.
 * save outfile='//covenas/decisionsupport/Meinzer/Production/Backup/stage/eps_year_2001.sav' /drop PrimaryTherapist.

 * temp.
 * select if opdate lt date.dmy(1,1,2003) and ((closdate) ge date.dmy(1,1,2002) or closdate lt date.dmy(1,1,1901)).
*xsave outfile='//covenas/decisionsupport/eps_year_2002.sav' /drop PrimaryTherapist.
 * save outfile='//covenas/decisionsupport/Meinzer/Production/Backup/stage/eps_year_2002.sav' /drop PrimaryTherapist.

 * temp.
 * select if opdate lt date.dmy(1,1,2004) and ((closdate) ge date.dmy(1,1,2003) or closdate lt date.dmy(1,1,1901)).
*xsave outfile='//covenas/decisionsupport/eps_year_2003.sav' /drop PrimaryTherapist.
 * save outfile='//covenas/decisionsupport/Meinzer/Production/Backup/stage/eps_year_2003.sav' /drop PrimaryTherapist.

 * temp.
 * select if opdate lt date.dmy(1,1,2005) and ((closdate) ge date.dmy(1,1,2004) or closdate lt date.dmy(1,1,1901)).
*xsave outfile='//covenas/decisionsupport/eps_year_2004.sav' /drop PrimaryTherapist.
 * save outfile='//covenas/decisionsupport/Meinzer/Production/Backup/stage/eps_year_2004.sav' /drop PrimaryTherapist.

 * temp.
 * select if opdate lt date.dmy(1,1,2006) and ((closdate) ge date.dmy(1,1,2005) or closdate lt date.dmy(1,1,1901)).
*xsave outfile='//covenas/decisionsupport/eps_year_2005.sav' /drop PrimaryTherapist.
 * save outfile='//covenas/decisionsupport/Meinzer/Production/Backup/stage/eps_year_2005.sav' /drop PrimaryTherapist.

 * temp.
 * select if opdate lt date.dmy(1,1,2007) and ((closdate) ge date.dmy(1,1,2006) or closdate lt date.dmy(1,1,1901)).
*xsave outfile='//covenas/decisionsupport/eps_year_2006.sav' /drop PrimaryTherapist.
 * save outfile='//covenas/decisionsupport/Meinzer/Production/Backup/stage/eps_year_2006.sav' /drop PrimaryTherapist.

 * temp.
 * select if opdate lt date.dmy(1,1,2008) and ((closdate) ge date.dmy(1,1,2007) or closdate lt date.dmy(1,1,1901)).
*xsave outfile='//covenas/decisionsupport/eps_year_2007.sav' /drop PrimaryTherapist.
 * save outfile='//covenas/decisionsupport/Meinzer/Production/Backup/stage/eps_year_2007.sav' /drop PrimaryTherapist.

 * temp.
 * select if opdate lt date.dmy(1,1,2009) and ((closdate) ge date.dmy(1,1,2008) or closdate lt date.dmy(1,1,1901)).
*xsave outfile='//covenas/decisionsupport/eps_year_2008.sav' /drop PrimaryTherapist.
 * save outfile='//covenas/decisionsupport/Meinzer/Production/Backup/stage/eps_year_2008.sav' /drop PrimaryTherapist.

 * temp.
 * select if opdate lt date.dmy(1,1,2010) and ((closdate) ge date.dmy(1,1,2009) or closdate lt date.dmy(1,1,1901)).
*xsave outfile='//covenas/decisionsupport/eps_year_2009.sav' /drop PrimaryTherapist.
 * save outfile='//covenas/decisionsupport/Meinzer/Production/Backup/stage/eps_year_2009.sav' /drop PrimaryTherapist.

 * temp.
 * select if opdate lt date.dmy(1,1,2011) and ((closdate) ge date.dmy(1,1,2010) or closdate lt date.dmy(1,1,1901)).
*xsave outfile='//covenas/decisionsupport/eps_year_2010.sav' /drop PrimaryTherapist.
 * save outfile='//covenas/decisionsupport/Meinzer/Production/Backup/stage/eps_year_2010.sav' /drop PrimaryTherapist.

 * temp.
 * select if opdate lt date.dmy(1,1,2012) and ((closdate) ge date.dmy(1,1,2011) or closdate lt date.dmy(1,1,1901)).
*xsave outfile='//covenas/decisionsupport/eps_year_2011.sav' /drop PrimaryTherapist.
 * save outfile='//covenas/decisionsupport/Meinzer/Production/Backup/stage/eps_year_2011.sav' /drop PrimaryTherapist.

 * temp.
 * select if opdate lt date.dmy(1,1,2013) and ((closdate) ge date.dmy(1,1,2012) or closdate lt date.dmy(1,1,1901)).
*xsave outfile='//covenas/decisionsupport/eps_year_2012.sav' /drop PrimaryTherapist.
 * save outfile='//covenas/decisionsupport/Meinzer/Production/Backup/stage/eps_year_2012.sav' /drop PrimaryTherapist.

 * temp.
 * select if opdate lt date.dmy(1,1,2014) and ((closdate) ge date.dmy(1,1,2013) or closdate lt date.dmy(1,1,1901)).
*xsave outfile='//covenas/decisionsupport/eps_year_2013.sav' /drop PrimaryTherapist.
 * save outfile='//covenas/decisionsupport/Meinzer/Production/Backup/stage/eps_year_2013.sav' /drop PrimaryTherapist.

 * insert file='//covenas/decisionsupport/meinzer/production/ps/modules/epsadd.sps'.



GET DATA /TYPE=ODBC /CONNECT='DSN=mhs;Description=mhs;UID=;Database=CG_Snappers;Trusted_Connection=Yes;APP=IBM SPSS Products: '+
    'Statistics Common;WSID=HPMXL2221NXK'
 /SQL = 'SELECT REPORTING_UNIT as ru, convert(varchar(22), service_stamp, 121) as service_Stamp ,'+
'convert(varchar(23), episode_Stamp,121) AS EPSTAMP, CLIENT_NUMBER as "case", UR_POSTED_STAMP as urstamp, PROCEDURE_CODE as proced, TREATMENT_LOCATION as location ,'+
'HOURS as hours, MINUTES as minute, NUMBER_IN_GROUP as grpsize, PRIMARY_THERAPIST as staff, CO_THERAPIST as co_staff ,'+
'CO_STAFF_HOURS as cs_hours, CO_STAFF_MINUTES as cs_mnts, SERVICE_DATE as svcdate, COST_OF_SERVICE as cost ,'+
'TRIED_FINANCIAL_RESPONSIBILITY as tfinresp, FINANCIAL_RESPONSIBILITY as finresp, ACTUAL_FINANCIAL_RESPONSIBILITY as fin_resp FROM CG_Snappers.dbo.[DIRECT_SERVICES]'+
 ' WHERE SERVICE_DATE >= {ts ''2007-01-01 00:00:00''} AND SERVICE_DATE < {ts ''2011-01-01 00:00:00''} order by reporting_unit   '
 /ASSUMEDSTRWIDTH=255.

CACHE.

execute.

insert file='//covenas/decisionsupport/meinzer/production/ps/modules/varinfo.sps'.


match files /table='//covenas/decisionsupport/rutable.sav'/file=*/by ru.
if ru2 ne " " RU=ru2.

sort cases by  epstamp.
match files /table='//covenas/decisionsupport/Meinzer/Production/Backup/stage/EpStampMatch.sav'   /file=* /by epstamp.

 * temp.
 * select if missing(opdate).
 * freq ru.

formats case (f8.0).
formats staff(f12).
*staff was 12.5.
formats proced hours minute grpsize co_staff cs_hours cs_mnts svcdate cost tfinresp finresp fin_resp (f12.5).
formats  urstamp svcdate(date11).

sort cases by ru case opdate.
match files /table='//covenas/decisionsupport/Meinzer/Production/Backup/stage/epscgx.sav' /rename Staff = StaffEPS /file=* /by ru case opdate /keep all.
if missing(closdate) closdate=date.dmy(17,11,1858).
 * save outfile='//covenas/decisionsupport/meinzer/temp/allsvcwork.sav'.
 * get file='//covenas/decisionsupport/meinzer/temp/allsvcwork.sav'.

 * select if any(ru,'00621','','').
 * save outfile='//covenas/decisionsupport/meinzer/temp/allsvcworkone.sav'.
*get file='//covenas/decisionsupport/meinzer/temp/allsvcworkone.sav'.

 * insert file='//covenas/decisionsupport/modules/calsvcdate.sps'.
 * insert file='//covenas/decisionsupport/modules/duration.sps'.

*other vars needed by dashboards.
*unit 	agency 	ru 	case 	opdate	closdate	proced	svcdate	cost 	duration	psmask2	mcsvccat	svcmode	primarytherapist	staff	proclong 	epflag	county	kidsru	calendar	service_stamp	mcpay	costffpelig	svcage	payor	provname.

*i'm going to ru for
*agency psmask2 county svcmode UMBRELLA.

sort cases by ru.
match files /table='//covenas/decisionsupport/rutable.sav' /file=* /by ru /drop Level3Classic TAYru svcType EPSDTGroup school  svcType3 CESDC 
cds_Code MHSA start_dt end_dt OAru Level2 program Residential OutCty CalWorks SafePassages RUCITY frc .

match files /file=* /keep=ru provname RU2 agency svcmode OurKids kidsru ab3632RU psmask2 county DayTx
UMBRELLA case opdate closdate epflag primdx refsrce lst_svc StaffEPS PrimaryTherapist epStamp service_Stamp
urstamp proced location hours minute grpsize staff co_staff cs_hours cs_mnts svcdate cost tfinresp finresp fin_resp.

 * compute justdate=number(substring(service_stamp,1,10),sdate10).
 * compute justtime=number(substring(service_stamp,index(service_stamp," ")+1,13),time11).
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
save outfile='//covenas/decisionsupport/Meinzer/Production/Backup/DBSVCuntil2011.sav' /keep agency provname ru case opdate closdate svcdate svcmode psmask2 proced county mcsvccat kidsru calendar 
duration duration2 cost LastService proclong svcage PrimaryTherapist staff bday epflag primdx unit svcmode ab3632RU DayTx RU2 service_Stamp svc_Stmp grpsize.
 * save outfile='//covenas/decisionsupport/Meinzer/Production/Backup/stage/DBSVC.sav' /keep agency provname ru case opdate closdate svcdate svcmode psmask2 proced county mcsvccat kidsru calendar 
duration duration2 cost LastService proclong svcage PrimaryTherapist staff bday epflag primdx unit svcmode ab3632RU DayTx RU2 service_Stamp svc_Stmp.
*
case svcdate proced ru  opdate agency provname psMask2 svcage closdate proclong epflag primarytherapist staff bday calendar.

 * sort cases by proced.
 * match files /table='//covenas/decisionsupport/procedsma.sav' /file=* /by proced.
* /keep unit proclong mcsvccat mcsvccatdetail fspSvcCat	FspSvcCatShort	MedicareExempt MC_SvcCat.
* network vars    /keep ru case proced svcdate cost calendar duration..
*level2 agency provname ru case opdate closdate svcdate cost calendar duration.
*insyst.
*proced	unit	ProcLong	MCSvcCat	MCSvcCatDetail	fspSvcCat	FspSvcCatShort	MedicareExempt	MC_SvcCat	RU	case	Opdate	EPFLAG	PrimaryTherapist	CLOSDATE	epStamp	
lst_svc	PrimDx	psmask2	agency	provname	kidsru	ab3632RU	county	oldRU	svcmode	frc	ClientID	LastMedsINSYST	LastAidCodeINsyst	bday	cin	InsystPrimAidCode	InMedsTable	
eCounty	calendar	Full	UserName	Medical_Number	medical_Eligibility_Stamp	service_Stamp	staff	svcdate	cost	fin_resp	counter	SvcAge	duration	duration2	AB3632svc	PartBElig	PartAElig	payor	MCpay	CostFFPElig	costSMA.


*This match files makes the classic "SERVICES_QTR" set of variables with the addition of service_Stamp , some of these are actually episode variables.
match files /file=*  /keep case ru opdate primdx closdate service_Stamp case urstamp proced location hours minute 
grpsize staff co_staff cs_hours cs_mnts svcdate cost tfinresp finresp fin_resp svc_Stmp cost LastService.

variable labels
ru	"REPORTING_UNIT"
opdate	"OPENING_DATE"
primdx	"PRIMARY_DIAGNOSIS"
closdate	"PROJECT_VIEW.CLOSING_DATE"
svc_stmp	"PROJECT_VIEW.SERVICE_STAMP"
case	"PROJECT_VIEW.CLIENT_NUMBER"
urstamp	"PROJECT_VIEW.UR_POSTED_STAMP"
proced	"PROJECT_VIEW.PROCEDURE_CODE"
location	"PROJECT_VIEW.TREATMENT_LOCATION"
hours	"PROJECT_VIEW.HOURS"
minute	"PROJECT_VIEW.MINUTES"
grpsize	"PROJECT_VIEW.NUMBER_IN_GROUP"
staff	"PROJECT_VIEW.PRIMARY_THERAPIST"
co_staff	"PROJECT_VIEW.CO_THERAPIST"
cs_hours	"PROJECT_VIEW.CO_STAFF_HOURS"
cs_mnts	"PROJECT_VIEW.CO_STAFF_MINUTES"
svcdate	"PROJECT_VIEW.SERVICE_DATE"
cost	"PROJECT_VIEW.COST_OF_SERVICE"
tfinresp	"PROJECT_VIEW.TRIED_FINANCIAL_RESPONSIBILITY"
finresp	"PROJECT_VIEW.FINANCIAL_RESPONSIBILITY"
fin_resp	"PROJECT_VIEW.ACTUAL_FINANCIAL_RESPONSIBILITY".


COMPUTE quarter=XDATE.QUARTER(svcdate).
COMPUTE year=XDATE.YEAR(svcdate).

 * if closdate = date.dmy(17,11,1858) closdate=$sysmis.
if missing(closdate) closdate=date.dmy(17,11,1858).
if missing(urstamp) urstamp=date.dmy(17,11,1858).
 * temp.
 * select if quarter=1 and year=2007.
 * save outfile='//covenas/decisionsupport/services07_qtr1.sav' /drop quarter year LastService.
 * save outfile='//covenas/spssdata/services07_qtr1.sav' /drop quarter year LastService.

 * temp.
 * select if quarter=2 and year=2007.
 * save outfile='//covenas/decisionsupport/services07_qtr2.sav' /drop quarter year LastService.
 * save outfile='//covenas/spssdata/services07_qtr2.sav' /drop quarter year LastService.

 * temp.
 * select if quarter=3 and year=2007.
 * save outfile='//covenas/decisionsupport/services07_qtr3.sav' /drop quarter year LastService.
 * save outfile='//covenas/spssdata/services07_qtr3.sav' /drop quarter year LastService.

 * temp.
 * select if quarter=4 and year=2007.
 * save outfile='//covenas/decisionsupport/services07_qtr4.sav' /drop quarter year LastService.
 * save outfile='//covenas/spssdata/services07_qtr4.sav' /drop quarter year LastService.

temp.
select if quarter=1 and year=2008.
*xsave outfile='//covenas/decisionsupport/services08_qtr1.sav' /drop quarter year LastService.
save outfile='//covenas/decisionsupport/Meinzer/Production/Backup/stage/services08_qtr1.sav' /drop quarter year LastService.

temp.
select if quarter=2 and year=2008.
*xsave outfile='//covenas/decisionsupport/services08_qtr2.sav' /drop quarter year LastService.
save outfile='//covenas/decisionsupport/Meinzer/Production/Backup/stage/services08_qtr2.sav' /drop quarter year LastService.

temp.
select if quarter=3 and year=2008.
*xsave outfile='//covenas/decisionsupport/services08_qtr3.sav' /drop quarter year LastService.
save outfile='//covenas/decisionsupport/Meinzer/Production/Backup/stage/services08_qtr3.sav' /drop quarter year LastService.

temp.
select if quarter=4 and year=2008.
*xsave outfile='//covenas/decisionsupport/services08_qtr4.sav' /drop quarter year LastService.
save outfile='//covenas/decisionsupport/Meinzer/Production/Backup/stage/services08_qtr4.sav' /drop quarter year LastService.

temp.
select if quarter=1 and year=2009.
*xsave outfile='//covenas/decisionsupport/services09_qtr1.sav' /drop quarter year LastService.
save outfile='//covenas/decisionsupport/Meinzer/Production/Backup/stage/services09_qtr1.sav' /drop quarter year LastService.

temp.
select if quarter=2 and year=2009.
*xsave outfile='//covenas/decisionsupport/services09_qtr2.sav' /drop quarter year LastService.
save outfile='//covenas/decisionsupport/Meinzer/Production/Backup/stage/services09_qtr2.sav' /drop quarter year LastService.

temp.
select if quarter=3 and year=2009.
*xsave outfile='//covenas/decisionsupport/services09_qtr3.sav' /drop quarter year LastService.
save outfile='//covenas/decisionsupport/Meinzer/Production/Backup/stage/services09_qtr3.sav' /drop quarter year LastService.

temp.
select if quarter=4 and year=2009.
*xsave outfile='//covenas/decisionsupport/services09_qtr4.sav' /drop quarter year LastService.
save outfile='//covenas/decisionsupport/Meinzer/Production/Backup/stage/services09_qtr4.sav' /drop quarter year LastService.

temp.
select if quarter=1 and year=2010.
*xsave outfile='//covenas/decisionsupport/services10_qtr1.sav' /drop quarter year LastService.
save outfile='//covenas/decisionsupport/Meinzer/Production/Backup/stage/services10_qtr1.sav' /drop quarter year LastService.

temp.
select if quarter=2 and year=2010.
*xsave outfile='//covenas/decisionsupport/services10_qtr2.sav' /drop quarter year LastService.
save outfile='//covenas/decisionsupport/Meinzer/Production/Backup/stage/services10_qtr2.sav' /drop quarter year LastService.

temp.
select if quarter=3 and year=2010.
*xsave outfile='//covenas/decisionsupport/services10_qtr3.sav' /drop quarter year LastService.
save outfile='//covenas/decisionsupport/Meinzer/Production/Backup/stage/services10_qtr3.sav' /drop quarter year LastService.

temp.
select if quarter=4 and year=2010.
*xsave outfile='//covenas/decisionsupport/services10_qtr4.sav' /drop quarter year LastService.
save outfile='//covenas/decisionsupport/Meinzer/Production/Backup/stage/services10_qtr4.sav' /drop quarter year LastService.


GET DATA /TYPE=ODBC /CONNECT='DSN=mhs;Description=mhs;UID=;Database=CG_Snappers;Trusted_Connection=Yes;APP=IBM SPSS Products: '+
    'Statistics Common;WSID=HPMXL2221NXK'
 /SQL = 'SELECT REPORTING_UNIT as ru, convert(varchar(22), service_stamp, 121) as service_Stamp ,'+
'convert(varchar(23), episode_Stamp,121) AS EPSTAMP, CLIENT_NUMBER as "case", UR_POSTED_STAMP as urstamp, PROCEDURE_CODE as proced, TREATMENT_LOCATION as location ,'+
'HOURS as hours, MINUTES as minute, NUMBER_IN_GROUP as grpsize, PRIMARY_THERAPIST as staff, CO_THERAPIST as co_staff ,'+
'CO_STAFF_HOURS as cs_hours, CO_STAFF_MINUTES as cs_mnts, SERVICE_DATE as svcdate, COST_OF_SERVICE as cost ,'+
'TRIED_FINANCIAL_RESPONSIBILITY as tfinresp, FINANCIAL_RESPONSIBILITY as finresp, ACTUAL_FINANCIAL_RESPONSIBILITY as fin_resp FROM CG_Snappers.dbo.[DIRECT_SERVICES]'+
 ' WHERE SERVICE_DATE >= {ts ''2011-01-01 00:00:00''} order by reporting_unit   '
 /ASSUMEDSTRWIDTH=255.

CACHE.

execute.

match files /table='//covenas/decisionsupport/rutable.sav'/file=*/by ru.
if ru2 ne " " RU=ru2.

sort cases by  epstamp.
match files /table='//covenas/decisionsupport/Meinzer/Production/Backup/stage/EpStampMatch.sav'   /file=* /by epstamp.

 * temp.
 * select if missing(opdate).
 * freq ru.

formats case (f8.0).
formats staff(f12).
*staff was 12.5.
formats proced hours minute grpsize co_staff cs_hours cs_mnts svcdate cost tfinresp finresp fin_resp (f12.5).
formats  urstamp svcdate(date11).

sort cases by ru case opdate.
match files /table='//covenas/decisionsupport/Meinzer/Production/Backup/stage/epscgx.sav' /rename Staff = StaffEPS /file=* /by ru case opdate /keep all.
if missing(closdate) closdate=date.dmy(17,11,1858).
 * save outfile='//covenas/decisionsupport/meinzer/temp/allsvcwork.sav'.
 * get file='//covenas/decisionsupport/meinzer/temp/allsvcwork.sav'.

 * select if any(ru,'00621','','').
 * save outfile='//covenas/decisionsupport/meinzer/temp/allsvcworkone.sav'.
*get file='//covenas/decisionsupport/meinzer/temp/allsvcworkone.sav'.

 * insert file='//covenas/decisionsupport/modules/calsvcdate.sps'.
 * insert file='//covenas/decisionsupport/modules/duration.sps'.

*other vars needed by dashboards.
*unit 	agency 	ru 	case 	opdate	closdate	proced	svcdate	cost 	duration	psmask2	mcsvccat	svcmode	primarytherapist	staff	proclong 	epflag	county	kidsru	calendar	service_stamp	mcpay	costffpelig	svcage	payor	provname.

*i'm going to ru for
*agency psmask2 county svcmode UMBRELLA.

sort cases by ru.
match files /table='//covenas/decisionsupport/rutable.sav' /file=* /by ru /drop Level3Classic TAYru svcType EPSDTGroup school  svcType3 CESDC 
cds_Code MHSA start_dt end_dt OAru Level2 program Residential OutCty CalWorks SafePassages RUCITY frc .

match files /file=* /keep=ru provname RU2 agency svcmode OurKids kidsru ab3632RU psmask2 county DayTx
UMBRELLA case opdate closdate epflag primdx refsrce lst_svc StaffEPS PrimaryTherapist epStamp service_Stamp
urstamp proced location hours minute grpsize staff co_staff cs_hours cs_mnts svcdate cost tfinresp finresp fin_resp.

 * compute justdate=number(substring(service_stamp,1,10),sdate10).
 * compute justtime=number(substring(service_stamp,index(service_stamp," ")+1,13),time11).
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
save outfile='//covenas/decisionsupport/Meinzer/Production/Backup/DBSVC2011later.sav'.
* /keep agency provname ru case opdate closdate svcdate svcmode psmask2 proced county mcsvccat kidsru calendar 
duration duration2 cost LastService proclong svcage PrimaryTherapist staff bday epflag primdx unit svcmode ab3632RU DayTx RU2 service_Stamp svc_Stmp grpsize.
 * save outfile='//covenas/decisionsupport/Meinzer/Production/Backup/stage/DBSVC.sav' /keep agency provname ru case opdate closdate svcdate svcmode psmask2 proced county mcsvccat kidsru calendar 
duration duration2 cost LastService proclong svcage PrimaryTherapist staff bday epflag primdx unit svcmode ab3632RU DayTx RU2 service_Stamp svc_Stmp.
*
case svcdate proced ru  opdate agency provname psMask2 svcage closdate proclong epflag primarytherapist staff bday calendar.

 * sort cases by proced.
 * match files /table='//covenas/decisionsupport/procedsma.sav' /file=* /by proced.
* /keep unit proclong mcsvccat mcsvccatdetail fspSvcCat	FspSvcCatShort	MedicareExempt MC_SvcCat.
* network vars    /keep ru case proced svcdate cost calendar duration..
*level2 agency provname ru case opdate closdate svcdate cost calendar duration.
*insyst.
*proced	unit	ProcLong	MCSvcCat	MCSvcCatDetail	fspSvcCat	FspSvcCatShort	MedicareExempt	MC_SvcCat	RU	case	Opdate	EPFLAG	PrimaryTherapist	CLOSDATE	epStamp	
lst_svc	PrimDx	psmask2	agency	provname	kidsru	ab3632RU	county	oldRU	svcmode	frc	ClientID	LastMedsINSYST	LastAidCodeINsyst	bday	cin	InsystPrimAidCode	InMedsTable	
eCounty	calendar	Full	UserName	Medical_Number	medical_Eligibility_Stamp	service_Stamp	staff	svcdate	cost	fin_resp	counter	SvcAge	duration	duration2	AB3632svc	PartBElig	PartAElig	payor	MCpay	CostFFPElig	costSMA.


*This match files makes the classic "SERVICES_QTR" set of variables with the addition of service_Stamp , some of these are actually episode variables.
match files /file=*  /keep case ru opdate primdx closdate service_Stamp case urstamp proced location hours minute 
grpsize staff co_staff cs_hours cs_mnts svcdate cost tfinresp finresp fin_resp svc_Stmp cost LastService.

variable labels
ru	"REPORTING_UNIT"
opdate	"OPENING_DATE"
primdx	"PRIMARY_DIAGNOSIS"
closdate	"PROJECT_VIEW.CLOSING_DATE"
svc_stmp	"PROJECT_VIEW.SERVICE_STAMP"
case	"PROJECT_VIEW.CLIENT_NUMBER"
urstamp	"PROJECT_VIEW.UR_POSTED_STAMP"
proced	"PROJECT_VIEW.PROCEDURE_CODE"
location	"PROJECT_VIEW.TREATMENT_LOCATION"
hours	"PROJECT_VIEW.HOURS"
minute	"PROJECT_VIEW.MINUTES"
grpsize	"PROJECT_VIEW.NUMBER_IN_GROUP"
staff	"PROJECT_VIEW.PRIMARY_THERAPIST"
co_staff	"PROJECT_VIEW.CO_THERAPIST"
cs_hours	"PROJECT_VIEW.CO_STAFF_HOURS"
cs_mnts	"PROJECT_VIEW.CO_STAFF_MINUTES"
svcdate	"PROJECT_VIEW.SERVICE_DATE"
cost	"PROJECT_VIEW.COST_OF_SERVICE"
tfinresp	"PROJECT_VIEW.TRIED_FINANCIAL_RESPONSIBILITY"
finresp	"PROJECT_VIEW.FINANCIAL_RESPONSIBILITY"
fin_resp	"PROJECT_VIEW.ACTUAL_FINANCIAL_RESPONSIBILITY".


COMPUTE quarter=XDATE.QUARTER(svcdate).
COMPUTE year=XDATE.YEAR(svcdate).

 * if closdate = date.dmy(17,11,1858) closdate=$sysmis.
if missing(closdate) closdate=date.dmy(17,11,1858).
if missing(urstamp) urstamp=date.dmy(17,11,1858).

temp.
select if quarter=1 and year=2011.
*xsave outfile='//covenas/spssdata/services11_qtr1.sav' /drop quarter year LastService.
save outfile='//covenas/decisionsupport/Meinzer/Production/Backup/stage/services11_qtr1.sav' /drop quarter year LastService.

temp.
select if quarter=2 and year=2011.
*xsave outfile='//covenas/spssdata/services11_qtr2.sav' /drop quarter year LastService.
save outfile='//covenas/decisionsupport/Meinzer/Production/Backup/stage/services11_qtr2.sav' /drop quarter year LastService.

temp.
select if quarter=3 and year=2011.
*xsave outfile='//covenas/spssdata/services11_qtr3.sav' /drop quarter year LastService.
save outfile='//covenas/decisionsupport/Meinzer/Production/Backup/stage/services11_qtr3.sav' /drop quarter year LastService.

temp.
select if quarter=4 and year=2011.
*xsave outfile='//covenas/spssdata/services11_qtr4.sav' /drop quarter year LastService.
save outfile='//covenas/decisionsupport/Meinzer/Production/Backup/stage/services11_qtr4.sav' /drop quarter year LastService.

temp.
select if quarter=1 and year=2012.
*xsave outfile='//covenas/spssdata/services12_qtr1.sav' /drop quarter year LastService.
save outfile='//covenas/decisionsupport/Meinzer/Production/Backup/stage/services12_qtr1.sav' /drop quarter year LastService.

temp.
select if quarter=2 and year=2012.
*xsave outfile='//covenas/spssdata/services12_qtr2.sav' /drop quarter year LastService.
save outfile='//covenas/decisionsupport/Meinzer/Production/Backup/stage/services12_qtr2.sav' /drop quarter year LastService.

temp.
select if quarter=3 and year=2012.
*xsave outfile='//covenas/spssdata/services12_qtr3.sav' /drop quarter year LastService.
save outfile='//covenas/decisionsupport/Meinzer/Production/Backup/stage/services12_qtr3.sav' /drop quarter year LastService.

temp.
select if quarter=4 and year=2012.
*xsave outfile='//covenas/spssdata/services12_qtr4.sav' /drop quarter year LastService.
save outfile='//covenas/decisionsupport/Meinzer/Production/Backup/stage/services12_qtr4.sav' /drop quarter year LastService.

temp.
select if quarter=1 and year=2013.
*xsave outfile='//covenas/spssdata/services13_qtr1.sav' /drop quarter year LastService.
save outfile='//covenas/decisionsupport/Meinzer/Production/Backup/stage/services13_qtr1.sav' /drop quarter year LastService.

temp.
select if quarter=2 and year=2013.
*xsave outfile='//covenas/spssdata/services13_qtr2.sav' /drop quarter year LastService.
save outfile='//covenas/decisionsupport/Meinzer/Production/Backup/stage/services13_qtr2.sav' /drop quarter year LastService.

temp.
select if quarter=3 and year=2013.
*xsave outfile='//covenas/spssdata/services13_qtr3.sav' /drop quarter year LastService.
save outfile='//covenas/decisionsupport/Meinzer/Production/Backup/stage/services13_qtr3.sav' /drop quarter year LastService.

temp.
select if quarter=4 and year=2013.
*xsave outfile='//covenas/spssdata/services13_qtr4.sav' /drop quarter year LastService.
save outfile='//covenas/decisionsupport/Meinzer/Production/Backup/stage/services13_qtr4.sav' /drop quarter year LastService.

temp.
select if quarter=1 and year=2014.
*xsave outfile='//covenas/spssdata/services14_qtr1.sav' /drop quarter year LastService.
save outfile='//covenas/decisionsupport/Meinzer/Production/Backup/stage/services14_qtr1.sav' /drop quarter year LastService.

insert file='//covenas/decisionsupport/meinzer/production/ps/modules/svcadd.sps'.


add files
/file='//covenas/decisionsupport/Meinzer/Production/Backup/DBSVC2011later.sav' 
/file='//covenas/decisionsupport/Meinzer/Production/Backup/DBSVCuntil2011.sav'.

if closdate = date.dmy(17,11,1858) closdate=$sysmis.

temp.
select if svcdate ge date.dmy(1,1,2008).
xsave outfile='//covenas/decisionsupport/Meinzer/Production/Backup/stage/DBSVCallVars.sav' .
save outfile='//covenas/decisionsupport/Meinzer/Production/Backup/stage/DBSVC.sav'  /keep agency provname ru case opdate closdate svcdate svcmode psmask2 proced county mcsvccat kidsru calendar 
duration duration2 cost LastService proclong svcage PrimaryTherapist staff bday epflag primdx unit svcmode ab3632RU DayTx RU2 service_Stamp svc_Stmp grpsize.
* /keep agency provname ru case opdate closdate svcdate svcmode psmask2 proced county mcsvccat kidsru calendar 
duration duration2 cost LastService proclong svcage PrimaryTherapist staff bday epflag primdx unit svcmode ab3632RU DayTx RU2 service_Stamp svc_Stmp grpsize.
 * SAVE TRANSLATE OUTFILE='//covenas/decisionsupport/Meinzer/Production/Backup/csv/dbsvc.csv'
  /TYPE=CSV
  /ENCODING='Locale'
  /MAP
  /REPLACE
  /FIELDNAMES
  /CELLS=VALUES
/keep agency provname ru case opdate closdate svcdate svcmode psmask2 proced county mcsvccat kidsru calendar 
duration duration2 cost LastService proclong svcage PrimaryTherapist staff bday epflag primdx unit svcmode ab3632RU DayTx RU2 service_Stamp svc_Stmp grpsize.

aggregate outfile=*
   /break ru case opdate
   /LastService=max(svcdate).
match files /table=* /file='//covenas/decisionsupport/Meinzer/Production/Backup/stage/epscgx.sav' /by ru case opdate /keep case opdate ru closdate epflag primdx refsrce staff PrimaryTherapist lst_svc LastService.

 * aggregate outfile='//covenas/decisionsupport/temp/epslastSVC.sav'
   /break ru case opdate
   /LastService=max(svcdate).
 * get file='//covenas/spssdata/epscg.sav'.
 * match files /file=* /table='//covenas/decisionsupport/temp/epslastSVC.sav' /by ru case opdate.
select if opdate ge date.dmy(1,1,2008) OR epflag = "O" OR closdate ge date.dmy(1,1,2008).
save outfile='//covenas/decisionsupport/Meinzer/Production/Backup/stage/epscg.sav'.
*get file='//covenas/decisionsupport/Meinzer/Production/Backup/csv/epscg.sav'.
 * SAVE TRANSLATE OUTFILE='//covenas/decisionsupport/Meinzer/Production/Backup/csv/epscg.csv'
  /TYPE=CSV
  /ENCODING='Locale'
  /MAP
  /REPLACE
  /FIELDNAMES
  /CELLS=VALUES.       
                             

 * save outfile='//covenas/spssdata/epscg.sav'.
 * get file='//covenas/decisionsupport/rutable.sav'.
 * SAVE TRANSLATE OUTFILE='//covenas/decisionsupport/Meinzer/Production/Backup/csv/rutable.csv'
  /TYPE=CSV
  /ENCODING='Locale'
  /MAP
  /REPLACE
  /FIELDNAMES
  /CELLS=VALUES.       
 * get file='//covenas/decisionsupport/procedsma.sav'.
 * SAVE TRANSLATE OUTFILE='//covenas/decisionsupport/Meinzer/Production/Backup/csv/procedsma.csv'
  /TYPE=CSV
  /ENCODING='Locale'
  /MAP
  /REPLACE
  /FIELDNAMES
  /CELLS=VALUES.       
 * get file='//covenas/decisionsupport/clinfo.sav'.
 * SAVE TRANSLATE OUTFILE='//covenas/decisionsupport/Meinzer/Production/Backup/csv/clinfo.csv'
  /TYPE=CSV
  /ENCODING='Locale'
  /MAP
  /REPLACE
  /FIELDNAMES
  /CELLS=VALUES.       









GET DATA /TYPE=ODBC /CONNECT='DSN=mhs;Description=mhs;UID=;Database=CG_Snappers;Trusted_Connection=Yes;APP=IBM SPSS Products: '+
    'Statistics Common;WSID=HPMXL2221NXK'
 /SQL = 'SELECT REPORTING_UNIT as ru, convert(varchar(22), service_stamp, 121) as service_Stamp ,'+
'convert(varchar(23), episode_Stamp,121) AS EPSTAMP, CLIENT_NUMBER as "case", UR_POSTED_STAMP as urstamp, PROCEDURE_CODE as proced, TREATMENT_LOCATION as location ,'+
'HOURS as hours, MINUTES as minute, NUMBER_IN_GROUP as grpsize, PRIMARY_THERAPIST as staff, CO_THERAPIST as co_staff ,'+
'CO_STAFF_HOURS as cs_hours, CO_STAFF_MINUTES as cs_mnts, SERVICE_DATE as svcdate, COST_OF_SERVICE as cost ,'+
'TRIED_FINANCIAL_RESPONSIBILITY as tfinresp, FINANCIAL_RESPONSIBILITY as finresp, ACTUAL_FINANCIAL_RESPONSIBILITY as fin_resp FROM CG_Snappers.dbo.[DIRECT_SERVICES]'+
 ' WHERE SERVICE_DATE >= {ts ''2004-07-01 00:00:00''} AND SERVICE_DATE < {ts ''2008-07-01 00:00:00''} order by reporting_unit   '
 /ASSUMEDSTRWIDTH=255.

CACHE.

execute.

match files /table='//covenas/decisionsupport/rutable.sav'/file=*/by ru.
if ru2 ne " " RU=ru2.

sort cases by  epstamp.
match files /table='//covenas/decisionsupport/Meinzer/Production/Backup/stage/EpStampMatch.sav'   /file=* /by epstamp.

 * temp.
 * select if missing(opdate).
 * freq ru.

formats case (f8.0).
formats staff(f12).
*staff was 12.5.
formats proced hours minute grpsize co_staff cs_hours cs_mnts svcdate cost tfinresp finresp fin_resp (f12.5).
formats  urstamp svcdate(date11).

sort cases by ru case opdate.
match files /table='//covenas/decisionsupport/Meinzer/Production/Backup/stage/epscgx.sav' /rename Staff = StaffEPS /file=* /by ru case opdate /keep all.
if missing(closdate) closdate=date.dmy(17,11,1858).
 * save outfile='//covenas/decisionsupport/meinzer/temp/allsvcwork.sav'.
 * get file='//covenas/decisionsupport/meinzer/temp/allsvcwork.sav'.

 * select if any(ru,'00621','','').
 * save outfile='//covenas/decisionsupport/meinzer/temp/allsvcworkone.sav'.
*get file='//covenas/decisionsupport/meinzer/temp/allsvcworkone.sav'.

 * insert file='//covenas/decisionsupport/modules/calsvcdate.sps'.
 * insert file='//covenas/decisionsupport/modules/duration.sps'.

*other vars needed by dashboards.
*unit 	agency 	ru 	case 	opdate	closdate	proced	svcdate	cost 	duration	psmask2	mcsvccat	svcmode	primarytherapist	staff	proclong 	epflag	county	kidsru	calendar	service_stamp	mcpay	costffpelig	svcage	payor	provname.

*i'm going to ru for
*agency psmask2 county svcmode UMBRELLA.

sort cases by ru.
match files /table='//covenas/decisionsupport/rutable.sav' /file=* /by ru /drop Level3Classic TAYru svcType EPSDTGroup school  svcType3 CESDC 
cds_Code MHSA start_dt end_dt OAru Level2 program Residential OutCty CalWorks SafePassages RUCITY frc .

match files /file=* /keep=ru provname RU2 agency svcmode OurKids kidsru ab3632RU psmask2 county DayTx
UMBRELLA case opdate closdate epflag primdx refsrce lst_svc StaffEPS PrimaryTherapist epStamp service_Stamp
urstamp proced location hours minute grpsize staff co_staff cs_hours cs_mnts svcdate cost tfinresp finresp fin_resp.

 * compute justdate=number(substring(service_stamp,1,10),sdate10).
 * compute justtime=number(substring(service_stamp,index(service_stamp," ")+1,13),time11).
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
save outfile='//covenas/decisionsupport/Meinzer/Production/Backup/stage/DBSVC04_09.sav' /keep agency provname ru case opdate closdate svcdate svcmode psmask2 proced county mcsvccat kidsru calendar 
duration duration2 cost LastService proclong svcage PrimaryTherapist staff bday epflag primdx unit svcmode ab3632RU DayTx RU2 service_Stamp svc_Stmp grpsize.



