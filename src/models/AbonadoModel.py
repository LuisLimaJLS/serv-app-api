from database.db import get_connection
from .entities.Abonado import Abonado

class AbonadoModel():

    @classmethod
    def get_abonados(self):
        
        try:
            connection=get_connection()
            abonados=[]

            with connection.cursor() as cursor:
                cursor.execute("SELECT id,id_predio,id_categoria,nro_medidor,estado,fecha_instalacion,marca_medidor,direccion,secuencia,observacion,id_cliente,id_ruta,situacion FROM abonado ORDER BY id")
                
                resultset=cursor.fetchall()
                for row in resultset:
                    abonado=Abonado(row[0],row[1],row[2],row[3],row[4],row[5],row[6],row[7],row[8],row[9],row[10],row[11],row[12])
                    print(abonado)
                    abonados.append(abonado.to_JSON())
            
            connection.close()
            return abonados
        except Exception as ex:
            raise Exception(ex)