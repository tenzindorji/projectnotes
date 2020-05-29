from xlrd import open_workbook
from xlwt import Workbook
def saveWorkSpace(fields,r):
    wb = open_workbook('test.xls')
    ws = wb.sheet_by_index(0)
    r = ws.nrows
    r += 1
    wb = Workbook()
    ws.write(r,0,fields['name'])
    ws.write(r,1,fields['phone'])
    ws.write(r,2,fields['email'])
    wb.save('test.xls')
    print ('Wrote test.xls')
