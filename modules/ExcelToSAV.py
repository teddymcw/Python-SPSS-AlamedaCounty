
def xlsToSpss(rdir,varnames=True,sheets='all'):
    import xlrd,spss,os
    fils=[fil for fil in os.listdir(rdir) if fil.endswith(".xls")]
    allData=[] 
    for cnt,fil in enumerate(fils): 
        wb=xlrd.open_workbook(os.path.join(rdir,fil)) 
        if sheets != 'all':
            rWs = [wb.sheets()[int(i)] for i in sheets.split(',')]
        else:
            rWs = wb.sheets()
        for ws in rWs:
            if varnames:
                vNames = ["source_file"]+["source_sheet"]+ws.row_values(0)
            else:
                vNames = ["source_file"]+["source_sheet"]+["column_%d"%(i + 1) for i in range(ws.ncols)]
            fRow = 1 if varnames else 0
            for row in range(fRow,ws.nrows):
                allData.append([fil]+[ws.name]+[val for val in ws.row_values(row)])
    mxLens=[0]*len(vNames) 
    for line in allData: 
        for cnt in range(len(line)): 
            if isinstance(line[cnt],basestring) and len(line[cnt])>mxLens[cnt]:
                mxLens[cnt]=len(line[cnt])
    with spss.DataStep(): 
        nds = spss.Dataset('*')
        for var in zip(vNames,mxLens): 
            nds.varlist.append(var[0],var[1])
        for line in allData: 
            nds.cases.append([None if val=='' else val for val in line]) 
xlsToSpss('//covenas/decisionsupport/Meinzer\Projects\SSI\Pending Processed',varnames=True,sheets='all')

