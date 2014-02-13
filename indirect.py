
import os

def main(searchtext,*arg):
    IndList=[]
    IndList=[i for i in os.listdir('//covenas/spssdata/') if searchtext in i and ('11' in i or '12' in i or '13' in i or '14' in i or '15' in i)]

    s="""add files\n"""
    for savfile in IndList:
            line="""/file="%s/%s"\n""" % ('//covenas/spssdata/',savfile)
            s+=line
    s+=""".\n exe."""
    cmdind=s
    # spss.Submit(cmdind)
    print cmdind



if __name__=='__main__':
 main('IndirectS')