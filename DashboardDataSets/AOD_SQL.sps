
GET DATA
  /TYPE=ODBC
  /CONNECT='DSN=AOD;UID=;Trusted_Connection=Yes;APP=IBM SPSS Products: Statistics '+
    'Common;WSID=HPMXL2221NXK;DATABASE=CG_AOD'
  /SQL='SELECT T0.REPORTING_UNIT AS ru, T1.OPENING_DATE AS opdate, T1.CLOSING_DATE AS closdate, '+
     'T0.SERVICE_YEAR,T0.SERVICE_STAMP AS svc_stmp, T0.CLIENT_NUMBER AS "case", T0.PROCEDURE_CODE AS proced, '+
    'T0.TREATMENT_LOCATION AS location, T0.HOURS AS hours, T0.MINUTES AS "minute", '+
    'T0.NUMBER_IN_GROUP AS grpsize, T0.PRIMARY_THERAPIST AS pr_staff, T0.CO_STAFF_HOURS AS '+
    'cs_hours, T0.CO_STAFF_MINUTES AS cs_mnts, T0.SERVICE_DATE AS svcdate, T0.COST_OF_SERVICE AS '+
    'cost, T0.ACTUAL_FINANCIAL_RESPONSIBILITY AS fin_resp, T1.EPISODE_STAMP FROM '+
    'CG_AOD.dbo.DIRECT_SERVICES T0, CG_AOD.dbo.EPISODES T1 WHERE  T0.EPISODE_STAMP = T1.EPISODE_STAMP    '+
   ' AND (T0.SERVICE_YEAR >= 2001)'
  /ASSUMEDSTRWIDTH=255.


VARIABLE LABELS ru 'REPORTING_UNIT'.
VARIABLE LABELS opdate 'OPENING_DATE'.
VARIABLE LABELS closdate 'CLOSING_DATE'.
VARIABLE LABELS svc_stmp 'SERVICE_STAMP'.
VARIABLE LABELS case 'CLIENT_NUMBER'.
VARIABLE LABELS proced 'PROCEDURE_CODE'.
VARIABLE LABELS location 'TREATMENT_LOCATION'.
VARIABLE LABELS hours 'HOURS'.
VARIABLE LABELS minute 'MINUTES'.
VARIABLE LABELS grpsize 'NUMBER_IN_GROUP'.
VARIABLE LABELS pr_staff 'PRIMARY_THERAPIST'.
VARIABLE LABELS cs_hours 'CO_STAFF_HOURS'.
VARIABLE LABELS cs_mnts 'CO_STAFF_MINUTES'.
VARIABLE LABELS svcdate 'SERVICE_DATE'.
VARIABLE LABELS cost 'COST_OF_SERVICE'.
VARIABLE LABELS fin_resp 'ACTUAL_FINANCIAL_RESPONSIBILITY'.
CACHE.
EXECUTE.
COMPUTE quarter=XDATE.QUARTER(svcdate).
*COMPUTE year=XDATE.YEAR(svcdate).

insert file='//covenas/decisionsupport/meinzer/production/ps/AODServices.sps'.

select if svcdate ge date.dmy(1,1,2010).
save outfile='//covenas/decisionsupport/meinzer/production/backup/stage/aodDBSVC.sav'.

GET DATA
  /TYPE=ODBC
  /CONNECT='DSN=AOD;UID=;Trusted_Connection=Yes;APP=IBM SPSS Products: Statistics '+
    'Common;WSID=HPMXL2221NXK;DATABASE=CG_AOD'
  /SQL='SELECT T0.CLIENT_NAME AS NAME, T0.ETHNICITY as ethnic, T0.PREFERRED_LANGUAGE AS "LANGUAGE", '+
    'T0.SOCIAL_SECURITY_NUMBER as ssn, T0.BIRTH_DATE as bday, T1.SHORT_PROVIDER_NAME as runame, T2.OPENING_DATE as opdate, '+
    'T2.CLOSING_DATE as closdate, T2.PRIMARY_DIAGNOSIS as primdx, T2.SECONDARY_DIAGNOSIS as sec_dx, T2.DIAGNOSIS_AXIS_TWO as dx2, '+
    'T2.ADMISSION_LIVING_SITUATION as adliv, T2.SUPPLEMENTAL_AXIS_ONE as altdx1, T2.REFERRAL_SOURCE as ref_srce, '+
    'T2.REFERRAL_DESTINATION_ONE as ref_out1, T2.ADHERENCE_TO_TX_PLAN as tx_adher, T2.REASON_FOR_DISCHARGE as dis_stat, '+
    'T2.ADMISSION_STATUS as ad_stat, T2.HOMELESS, T2.CLIENT_NUMBER as "case", T2.REPORTING_UNIT as ru, T2.PRIMARY_THERAPIST as pr_staff, '+    
    'T2.LAST_SERVICE_DATE as lst_svc, T2.PRIMARY_PROBLEM_ADMISSION as adprob1, T2.SECONDARY_PROBLEM_ADMISSION as adprob2, '+
    'T2.TERTIARY_PROBLEM_ADMISSION as adprob3, T2.EMPLOYMENT_STATUS_ENTRY as emp_stat, T2.CLIENT_PREGNANT as cl_preg, '+
    'T2.EPISODE_STATUS_FLAG as op_flag, T2.SPECIAL_CONTRACT_NUMBER as pfn, T0.SEX FROM CG_AOD.dbo.CLIENTS T0, '+
    'CG_AOD.dbo.PROVIDER_MASTER T1, CG_AOD.dbo.EPISODES T2 WHERE T0.CLIENT_NUMBER = '+
    'T2.CLIENT_NUMBER AND T2.REPORTING_UNIT = T1.REPORTING_UNIT'
  /ASSUMEDSTRWIDTH=255.
VARIABLE LABELS 
name 'PROJECT_VIEW.CLIENT_NAME'
ethnic 'PROJECT_VIEW.ETHNICITY'
language 'PROJECT_VIEW.PREFERRED_LANGUAGE'
ssn 'PROJECT_VIEW.SOCIAL_SECURITY_NUMBER'
bday 'PROJECT_VIEW.BIRTH_DATE'
runame 'PROJECT_VIEW.SHORT_PROVIDER_NAME'
opdate 'PROJECT_VIEW.OPENING_DATE'
closdate 'PROJECT_VIEW.CLOSING_DATE'
primdx 'PROJECT_VIEW.PRIMARY_DIAGNOSIS'
sec_dx 'PROJECT_VIEW.SECONDARY_DIAGNOSIS'
dx2 'PROJECT_VIEW.DIAGNOSIS_AXIS_TWO'
adliv 'PROJECT_VIEW.ADMISSION_LIVING_SITUATION'
altdx1 'PROJECT_VIEW.SUPPLEMENTAL_AXIS_ONE'
ref_srce 'PROJECT_VIEW.REFERRAL_SOURCE'
ref_out1 'PROJECT_VIEW.REFERRAL_DESTINATION_ONE'
tx_adher 'PROJECT_VIEW.ADHERENCE_TO_TX_PLAN'
dis_stat 'PROJECT_VIEW.REASON_FOR_DISCHARGE'
ad_stat 'PROJECT_VIEW.ADMISSION_STATUS'
homeless 'PROJECT_VIEW.HOMELESS'
case 'PROJECT_VIEW.CLIENT_NUMBER'
ru 'PROJECT_VIEW.REPORTING_UNIT'
pr_staff 'PROJECT_VIEW.PRIMARY_THERAPIST'
lst_svc 'PROJECT_VIEW.LAST_SERVICE_DATE'
adprob1 'PROJECT_VIEW.PRIMARY_PROBLEM_ADMISSION'
adprob2 'PROJECT_VIEW.SECONDARY_PROBLEM_ADMISSION'
adprob3 'PROJECT_VIEW.TERTIARY_PROBLEM_ADMISSION'
emp_stat 'PROJECT_VIEW.EMPLOYMENT_STATUS_ENTRY'
cl_preg 'PROJECT_VIEW.CLIENT_PREGNANT'
op_flag 'PROJECT_VIEW.EPISODE_STATUS_FLAG'
pfn 'PROJECT_VIEW.SPECIAL_CONTRACT_NUMBER'.
CACHE.
EXECUTE.
save outfile='//covenas/decisionsupport/Meinzer/Production/Backup/stage/AODEpisodes.sav' .

*check how closdate works in aod.
 * insert file='//covenas/decisionsupport/meinzer/production/ps/AODEpisodes.sps'.


