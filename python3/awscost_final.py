#This program is created to map directs with services in aws cost report
#Requires python3

import xlrd
from openpyxl.workbook import Workbook
import sys
import yaml
import datetime

def extract_data(filename):
    #load excel input file
    wb=xlrd.open_workbook(filename)
    sheet = wb.sheet_by_index(0)
    sheet.cell_value(0, 0)

    headers= ["Account #", "Acct. Name", "Period", "Financial BUFG", "BUFG L2 (Ops)", "BUFG L3 (Ops)", "Application", "Usage", "App Env", "Billing BU", "Billing Component", "Billing fp", "Billing User", "Billing User App", "Cost", "Directs"]
    #create new xlsx
    workbook_name = "fdp_awscost_by_directs_" + str(datetime.date.today()) + ".xlsx"
    wwb = Workbook()
    page = wwb.active
    page.title = 'awscostdata'
    page.append(headers)

    #load service owner Bhushan's Direct
    directs=yaml.load(open('/pythongLearning/directs.yml'))
    print("Mapping services with Directs ....")

    for row in range(2, sheet.nrows):
        col_count=0
        value_found=False
        for direct in directs:
            for service in directs[direct]:

                for col in range(sheet.ncols-2):

                    if sheet.cell_value(row, col)==service:
                        a=sheet.row_values(row)
                        a.append(direct)
                        page.append(a)
                        value_found=True
                        col_count=col
                        break
                if value_found==True:
                    break
            if value_found==True:
                break
        if col_count==0:
            a=sheet.row_values(row)
            a.append("No Tag")
            page.append(a)

    wwb.save(filename=workbook_name)
    return workbook_name

def main():
    if len(sys.argv) != 2:
        print ('Provide excel file as input\nUsage: python3', sys.argv[0], 'excel_filename')
        sys.exit(1)

    input_file=sys.argv[1]
    finalexceloutput=extract_data(input_file)
    print("Completed")
    print("Here is the name of the extrated file:", finalexceloutput)

if __name__=='__main__':
    main()
