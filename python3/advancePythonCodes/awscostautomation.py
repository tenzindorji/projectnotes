# importing csv module
import csv

# csv file name
filename = "aapl.csv"

# initializing the titles and rows list
fields = []
rows = []

# reading csv file
with open(filename, 'r') as csvfile:
    # creating a csv reader object
    csvreader = csv.reader(csvfile)

    # extracting field names through first row
    fields = next(csvreader)

    # extracting each data row one by one
    for row in csvreader:
        rows.append(row)

    # get total number of rows
    print("Total no. of rows: %d"%(csvreader.line_num))

# printing the field names
print('Field names are:' + ', '.join(field for field in fields))

#  printing first 5 rows
print('\nFirst 5 rows are:\n')
for row in rows[:5]:
    # parsing each column of a row
    for col in row:
        print("%10s"%col, end=''),
        #print('\n')
    print('\n')



    #row=[]
    """
loc = ("/pythongLearning/awscost.xls")

# To open Workbook
wb = xlrd.open_workbook(loc)
sheet = wb.sheet_by_index(0)

# For row 0 and column 0
sheet.cell_value(0, 0)
print(sheet.nrows)
print(sheet.ncols)

for i in range(sheet.ncols):
    print(sheet.cell_value(0, i), end='')

print(sheet.row_values(2))

#for i in range(sheet.nrows):
#    print(sheet.cell_value(i, 0))

"""
'''
    list=[] #used in first loop
    row=[] #used in second loop
    #open workbook
    wb=xlrd.open_workbook(filename)
    sheet = wb.sheet_by_index(0)
    #for row 0 and column 0
    sheet.cell_value(0, 0)
    #print number of rows
    print(sheet.nrows)
'''
    #open filename
    #filename=open("/pythongLearning/awscostautomation/amitbindal.text", 'r')
    #text=filename.readline()
    #filename.close()
    #filename.close()
    #print(text)
'''
    for value in filename:
        #val=value.split()
        print(value)
        for row in range(sheet.nrows):
        #list.append(sheet.row_values(i))
          for col in range(sheet.ncols):
            if (sheet.cell_value(row, col) == value):
                print(col, sheet.cell_value(row,col)) '''
                '''

    with open('/pythongLearning/awscostautomation/amitbindal.text') as line:
        word=line.read()
        print(word)
        for row in range(sheet.nrows):
        #list.append(sheet.row_values(i))
                for col in range(sheet.ncols):
                    if word in sheet.cell_value(row, col):
                        print(col, sheet.cell_value(row,col)) '''

    #text=filename.readline()
    #filename.close()
    #for service_name in filename.readline():
        #return list
