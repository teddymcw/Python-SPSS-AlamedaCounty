String HospProvname (a30).
*If psmask2=5 HospProvname=Provname. 
*Add above line?.
If Provname = "ALTA BATES/HERRICK MEDICAL CTR" HospProvname = "Alta Bates".
If Provname = "BEHAVIORAL HEALTH CARE FREMONT" HospProvname = "Fremont".
If Provname = "EDEN HOSPITAL" HospProvname = "Eden".
If Provname = "JOHN GEORGE PSY SVS INPATIENT" HospProvname = "John George".
If Provname = "JOHN MUIR BEHAVIORAL HLTH CTR" HospProvname = "John Muir".
If Provname = "OUT-OF-COUNTY HOSPITAL" HospProvname = "Out of County".
If Provname = "TELECARE WILLOW ROCK PHF CHILD" HospProvname = "Willow Rock".
If Provname = "ST HELENA HOSP CTR BEHAV HLTH" HospProvname = "St Helena".
if Provname = "ST MARY'S HOSPITAL MEDICAL CTR" HospProvname = "Saint Mary’s".
*If hospProvname = "ST HELENA HOSP CTR BEHAV HLTH" HospProvname = "Out of County".


