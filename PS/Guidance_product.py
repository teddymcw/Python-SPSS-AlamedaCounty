
import os

def main(searchtext,*arg):
    IndList=[]
    IndList=[i for i in os.listdir('//covenas/decisionsupport/productivity') if searchtext in i]
    s="""add files\n"""
    for savfile in IndList:
            line="""/file="%s/%s"\n""" % ('//covenas/spssdata/',savfile)
            s+=line
    s+=""".\n exe."""
    cmdind=s
    # spss.Submit(cmdind)
    print cmdind



if __name__=='__main__':
 main('Work')