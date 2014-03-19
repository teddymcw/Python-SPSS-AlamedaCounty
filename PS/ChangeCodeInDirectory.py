from os import walk

def walkChange(mypath):
    f = []
    for (dirpath, dirnames, filenames) in walk(mypath):
        for file in filenames:
            f.append(dirpath+'/'+file)
    return f

list=[]
fails=[]
f=walkChange('k:/meinzer/production/')    
[list.append(i) for i in f if i.upper().endswith('SPS')]
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
