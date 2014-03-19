import shutil

primaryFolder='//covenas/decisionsupport/Meinzer/Production/Backup/epssvcupdate/'
def tryCopy(dstFile):
    list=[]
    src=primaryFolder+afile
    dst=dstFile
    try:
        print 'sending '+src+ ' to '+dst
        shutil.copyfile(src,dst)
        print 'complete!'
    except Exception,e:  
        list.append(dst)
        print dst+' could not be copied'
    return list

for afile in os.listdir(primaryFolder):
      if afile.upper().endswith('.SAV'):
        if 'EPS_YEAR' in afile.upper():
            tryCopy('//covenas/decisionsupport/%s' % afile)
            tryCopy('//covenas/spssdata/%s' % afile)
        if 'SERVICES' in afile.upper():
            tryCopy('//covenas/decisionsupport/%s' % afile)
            tryCopy('//covenas/spssdata/%s' % afile)
        # if 'DBSVC' in afile.upper():
            # tryCopy('//covenas/decisionsupport/temp/%s' % afile)
            # tryCopy('//covenas/spssdata/temp/%s' % afile)
        if r'EPSCG.' in afile.upper():
            tryCopy('//covenas/decisionsupport/%s' % afile)
            tryCopy('//covenas/spssdata/%s' % afile)


            FileWOext=os.path.splitext(afile)[0]
        FileExt=os.path.splitext(afile)[1]
        print FileWOext
        
    
        DBList.append(FileWOext)
        
        if afile.upper().endswith('.SPS'):
        
        
        
import os.path, time
print "last modified: %s" % time.ctime(os.path.getmtime(file))



                try:

                except Exception,e:  