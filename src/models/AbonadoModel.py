from database.db import get_connection
from .entities.Abonado import Abonado

class AbonadoModel():

    @classmethod
    def get_abonados(self):
        
        try:
            connection=get_connection()
            abonados=[]

            with connection.cursor() as cursor:
                cursor.execute("SELECT * FROM	get_all_abonados_data()")
                
                resultset=cursor.fetchall()
                for row in resultset:
                    abonado=Abonado(row[0],row[1],row[2],row[3],row[4],row[5],row[6],row[7],row[8],row[9],row[10],row[11],row[12])
                    abonados.append(abonado.to_JSON())
            
            connection.close()
            return abonados
        except Exception as ex:
            raise Exception(ex)
        
    @classmethod
    def get_abonados_by_ci(self, ci):
        try:
            connection = get_connection()
            abonados=[]

            with connection.cursor() as cursor:
                cursor.execute("select * from get_all_abonados_by_ci(%s)", (ci,))
                resultset=cursor.fetchall()
                for row in resultset:
                    abonado=Abonado(row[0],row[1],row[2],row[3],row[4],row[5],row[6],row[7],row[8],row[9],row[10],row[11],row[12])
                    abonados.append(abonado.to_JSON())
            connection.close()
            return abonados
        except Exception as ex:
            raise Exception(ex)