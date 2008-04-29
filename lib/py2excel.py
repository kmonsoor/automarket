import pyExcelerator as xl

class ExcelReport(object):
    
    excelObject = None
   
    def __init__(self, headers, po, data):
        """
        data is:
        ((value,value,value,value,value,),
         (value,value,value,value,value,),
         ...)
        
        """
        self.data = data
        self.po = po
        self.headers = headers
        return self    
    
    def create(self):
        #Open new workbook
        self.excelObject = xl.Workbook()
        #Add a worksheet
        mysheet = self.excelObject.add_sheet("report")
        #write headers
        header_font = xl.Font() #make a font object
        header_font.bold = True
        header_font.underline = True
        #font needs to be style actually
        mysheet.write(0,0,self.po)
        
        header_style = xl.XFStyle() 
        header_style.font = header_font
        for col,value in enumerate(self.headers):
            mysheet.write(1,col,value,header_style)
        #write values and highlight those that match my criteria
        highlighted_row_font = xl.Font() #no real highlighting available?
        highlighted_row_font.bold = True
        highlighted_row_font.colour_index = 2 #2 is red,
        highlighted_row_style = xl.XFStyle()
        highlighted_row_style.font = highlighted_row_font
        
        for row_num,row_values in enumerate(data[1:]):
            row_num += 2 #start at row 2
            for col,value in enumerate(row_values):
               #normal row
               mysheet.write(row_num,col,value)
        return self
    
    def saveAsFile(self, path):
        self.excelObject.save(path)
    
    