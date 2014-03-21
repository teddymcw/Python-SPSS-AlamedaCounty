*CALENDAR OPDATE.
compute year=xdate.year(opdate).
compute month = xdate.month(opdate).
compute calendar = date.MOYR(month,year).
formats calendar(MOYR6).

match files/file=* /drop month year.