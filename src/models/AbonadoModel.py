from database.db import get_connection
from .entities.Abonado import Abonado
from .entities.Cliente import Cliente
from .entities.PromedioMedior import PromedioMedidor
from .entities.AbonadoEmision import AbonadoEmision
from .entities.History import History
class AbonadoModel():

    '''
    Obtener todos los abonados
    '''
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
        
    '''
    Obtener todos los abonados por identificador del cliente
    '''
    @classmethod
    def get_abonados_by_ci(self, ci):
        try:
            connection = get_connection()
            abonados=[]

            with connection.cursor() as cursor:
                cursor.execute("select * from get_all_abonados_by_ci(%s)", (ci,))
                resultset=cursor.fetchall()
                for row in resultset:
                    emisiones = []
                    cursor.execute("select * from get_emsion_by_abonado (%s, %s)", (row[0],6))
                    resultset_em=cursor.fetchall()
                    for row_em in resultset_em:
                        emision=AbonadoEmision(row_em[0],row_em[1],row_em[2],row_em[3],row_em[4],row_em[5],row_em[6],row_em[7])
                        emisiones.append(emision.to_JSON())
                    abonado=Abonado(row[0],row[1],row[2],row[3],row[4],row[5],row[6],row[7],row[8],row[9],row[10],row[11],row[12],emisiones)
                    abonados.append(abonado.to_JSON())
            connection.close()
            return abonados
        except Exception as ex:
            raise Exception(ex)

    '''
    Obtener cliente por identificador
    '''   
    @classmethod
    def get_cliente_by_ci(self, ci):
        try:
            connection = get_connection()
            with connection.cursor() as cursor:
                cursor.execute("select * from get_cliente_by_ci(%s)", (ci,))
                row=cursor.fetchone()
                cliente = None
                if row != None:
                    cliente=Cliente(row[0],row[1],row[2],row[3],row[4],row[5],row[6],row[7],False,'')
                    cliente=cliente.to_JSON()
            connection.close()
            return cliente
        except Exception as ex:
            raise Exception(ex)
        

    '''
    Obtener promedio de consumo y valores a pagar de un medidor de los ultimos n meses
    '''   
    @classmethod
    def get_avg_by_abonado_emi(self, id_abonado, nro_meses):
        try:
            connection = get_connection()
            with connection.cursor() as cursor:
                cursor.execute("select * from get_avg_by_abonado_emi(%s, (select max(id) from emision_abonado WHERE id_abonado = %s), %s)", (id_abonado,id_abonado,nro_meses))
                row=cursor.fetchone()
                promedio_medidor = None
                if row != None:
                    promedio_medidor=PromedioMedidor(row[0],row[1],row[2],row[3])
                    promedio_medidor=promedio_medidor.to_JSON()
            connection.close()
            return promedio_medidor
        except Exception as ex:
            raise Exception(ex)
        
    '''
    Obtener los consumos de los ultmios de n meses de un medidior vs promedios
    '''   
    @classmethod
    def get_emsion_by_abonado(self, id_abonado, nro_meses):
        try:
            connection = get_connection()
            emisiones = []
            with connection.cursor() as cursor:
                cursor.execute("select * from get_emsion_by_abonado (%s, %s)", (id_abonado,nro_meses))
                resultset=cursor.fetchall()
                for row in resultset:
                    emision=AbonadoEmision(row[0],row[1],row[2],row[3],row[4],row[5],row[6],row[7])
                    emisiones.append(emision.to_JSON())
            connection.close()
            return emisiones
        except Exception as ex:
            raise Exception(ex)
        

    '''
    Obtener los n maximos consumos de un medidor vs promedios
    '''   
    @classmethod
    def get_max_emsion_by_abonado(self, id_abonado, nro_meses):
        try:
            connection = get_connection()
            emisiones = []
            with connection.cursor() as cursor:
                cursor.execute("select * from get_max_emsion_by_abonado (%s, %s)", (id_abonado,nro_meses))
                resultset=cursor.fetchall()
                for row in resultset:
                    emision=AbonadoEmision(row[0],row[1],row[2],row[3],row[4],row[5],row[6],row[7])
                    emisiones.append(emision.to_JSON())
            connection.close()
            return emisiones
        except Exception as ex:
            raise Exception(ex)
        


    '''
    Obtener el historia de emisiones de un cliente por el identificador
    '''
    @classmethod
    def get_all_history_by_ci(self, ci):
        try:
            connection = get_connection()
            histories = []
            with connection.cursor() as cursor:
                cursor.execute("select * from get_all_history_by_ci(%s)", (ci,))
                resultset=cursor.fetchall()
                for row in resultset:
                    history=History(row[0],row[1],row[2],row[3],row[4],row[5],row[6],row[7],row[8],row[9])
                    histories.append(history.to_JSON())
            connection.close()
            return histories
        except Exception as ex:
            raise Exception(ex)