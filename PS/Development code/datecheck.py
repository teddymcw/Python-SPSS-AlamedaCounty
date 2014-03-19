import datetime
def whenRun(when):
    today=datetime.date.today()
    #test 16
    today=today+datetime.timedelta(days=6)
    month=today.month
    print month
    dayofweek=today.isoweekday()
    print dayofweek
    dayofmonth=today.day
    print dayofmonth
    #when='daily, saturday, sunday, weekly, monthly,yearly,quart'
    run=0
    #Daily  
    if 'DAILY' in when.upper():
        if dayofweek > 0 and dayofweek < 6:
            run=1
            print 'daily time condition met'
            AlertDays=4
    #weekend
    #Saturday
    if "SATUR" in when.upper():
        if dayofweek ==6:
            run=1
            print 'saturday time condition met'
            AlertDays=8
    #Sunday
    if "SUND" in when.upper():
        if dayofweek ==7:
            run=1
            print 'sunday time condition met'
            AlertDays=8
    #weekly  
    if 'WEEKLY' in when.upper():
        if dayofweek ==7:
            run=1
            print 'weekly time condition met'
            AlertDays=8
    #monthly 16th
    if 'MONTHLY' in when.upper():
        if dayofmonth ==16:
            run=1
            print 'monthly time condition met'
            AlertDays=33
    #qtrl
    if 'QT' in when.upper() or 'QU' in when.upper():
        if month==1 or month==4 or month==7 or month==10:
            if dayofmonth==16:
                run=1
                print 'quarterly time condition met'
                AlertDays=99
    #yearly sept 1   
    if 'YEAR' in when.upper():
        if month==9:
            if dayofmonth==16:
                run=1
                print 'yearly time condition met'
                AlertDays=366