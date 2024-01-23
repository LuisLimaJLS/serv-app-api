from utils.DateFormat import DateFormat
class AbonadoEmision():
    def __init__(self,
                id_abonado=None,
                id_emision=None,
                nro_medidor=None,
                emsion=None,
                consumo=None,
                valor=None,
                promedio_consumo=None,
                promedio_valor=None) -> None:
        self.id_abonado=id_abonado
        self.id_emision=id_emision
        self.nro_medidor=nro_medidor
        self.emsion=emsion
        self.consumo=consumo
        self.valor=valor
        self.promedio_consumo=promedio_consumo
        self.promedio_valor=promedio_valor
    
    def to_JSON(self):
        return {
            'id_abonado': self.id_abonado,
            'id_emision': self.id_emision,
            'nro_medidor': self.nro_medidor,
            'emsion': self.emsion,
            'consumo': self.consumo,
            'valor': self.valor,
            'promedio_consumo': self.promedio_consumo,
            'promedio_valor': self.promedio_valor
        }