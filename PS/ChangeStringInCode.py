from os import walk

def changeEnd(mypath,endFill):
    list=[]
    fails=[]
    f = []
    for (dirpath, dirnames, filenames) in walk(mypath):
        for file in filenames:
            f.append(dirpath+'/'+file)
    [list.append(i) for i in f if i.upper().endswith(endFill.upper())] 
    for file in list:
        print file
        try:
            with open(file, "r") as f: 
                c=f.readlines() 
            with open(file, 'w') as ts:
                for item in c:
                    print item
                    itemchange=re.compile(re.escape('k:/'),re.IGNORECASE)
                    itemswitch=itemchange.sub('//covenas/decisionsupport/',item)
                    itemchange=re.compile(re.escape('k:\\'),re.IGNORECASE)
                    itemswitch=itemchange.sub('//covenas/decisionsupport/',itemswitch)
                    itemchange=re.compile(re.escape('i:/'),re.IGNORECASE)
                    itemswitch=itemchange.sub('//covenas/spssdata/',itemswitch)
                    itemchange=re.compile(re.escape('i:\\'),re.IGNORECASE)
                    itemswitch=itemchange.sub('//covenas/spssdata/',itemswitch)
                    itemchange=re.compile(re.escape('k:'),re.IGNORECASE)
                    itemswitch=itemchange.sub('//covenas/decisionsupport/',itemswitch)
                    itemchange=re.compile(re.escape('i:'),re.IGNORECASE)
                    itemswitch=itemchange.sub('//covenas/spssdata/',itemswitch)
                    #print itemswitch
                    ts.write(itemswitch) 
        except Exception,e:
            print e
            fails.append(file)
    print 'if error, it was'
    for item in fails:
        print item
    print 'otherwise, these attempted'
    for file in list:
        print file  

def changeEndRandom(mypath,endFill,randomThing):
    list=[]
    fails=[]
    f = []
    for (dirpath, dirnames, filenames) in walk(mypath):
        for file in filenames:
            f.append(dirpath+'/'+file)
    [list.append(i) for i in f if i.upper().endswith(endFill.upper()) and randomThing.upper() in i.upper()]
    for file in list:
        print file
        try:
            with open(file, "r") as f: 
                c=f.readlines() 
            with open(file, 'w') as ts:
                for item in c:
                    print item
                    itemchange=re.compile(re.escape('k:/'),re.IGNORECASE)
                    itemswitch=itemchange.sub('//covenas/decisionsupport/',item)
                    itemchange=re.compile(re.escape('k:\\'),re.IGNORECASE)
                    itemswitch=itemchange.sub('//covenas/decisionsupport/',itemswitch)
                    itemchange=re.compile(re.escape('i:/'),re.IGNORECASE)
                    itemswitch=itemchange.sub('//covenas/spssdata/',itemswitch)
                    itemchange=re.compile(re.escape('i:\\'),re.IGNORECASE)
                    itemswitch=itemchange.sub('//covenas/spssdata/',itemswitch)
                    itemchange=re.compile(re.escape('k:'),re.IGNORECASE)
                    itemswitch=itemchange.sub('//covenas/decisionsupport/',itemswitch)
                    itemchange=re.compile(re.escape('i:'),re.IGNORECASE)
                    itemswitch=itemchange.sub('//covenas/spssdata/',itemswitch)
                    #print itemswitch
                    ts.write(itemswitch) 
        except Exception,e:
            print e
            fails.append(file)

def change(mypath,endFill,whatthing,subthing):
    list=[]
    fails=[]
    f = []
    for (dirpath, dirnames, filenames) in walk(mypath):
        for file in filenames:
            f.append(dirpath+'/'+file)
    [list.append(i) for i in f if i.upper().endswith(endFill.upper())]
    for file in list:
        print file
        try:
            with open(file, "r") as f: 
                c=f.readlines() 
            with open(file, 'w') as ts:
                for item in c:
                    print item
                    itemchange=re.compile(re.escape(whatthing),re.IGNORECASE)
                    itemswitch=itemchange.sub(subthing,item)
                    ts.write(itemswitch) 
        except Exception,e:
            print e
            fails.append(file)