import datetime

class DateFormat():

    @classmethod
    def convert_date(self, date):
        print ('FECHA ------',date)
        return datetime.datetime.strftime(date[0], '%d/%m/%Y')