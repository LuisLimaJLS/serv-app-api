from database.db import get_connection
from .entities.Respuesta import Respuesta
from .entities.Cliente import Cliente

class ServicesModel():
    '''
    Enviar correo
    '''
    @classmethod
    def send_mail(self,identificador, subject, message):
        try:
            connection=get_connection()
            cliente = None
            respuesta=Respuesta(identificador,'No Enviado', False) 
            with connection.cursor() as cursor:
                cursor.execute("select * from get_cliente_by_ci(%s)", (identificador,))
                row=cursor.fetchone()
                if row != None:
                    cliente=Cliente(row[0],row[1],row[2],row[3],row[4],row[5],row[6],row[7],False,'',row[8])
                
            if cliente:
                respuesta=Respuesta(identificador,'Enviado', True) 
                respuesta=respuesta.to_JSON()
            connection.close()
            return respuesta
        except Exception as ex:
            raise Exception(ex)