*CALENDAR SVCDATE.
*compute year=xdate.year(svcdate).
*compute month = xdate.month(svcdate).
compute calendar = date.MOYR(xdate.month(svcdate),xdate.year(svcdate)).
formats calendar(MOYR6).
*match files/file=* /drop month year.
