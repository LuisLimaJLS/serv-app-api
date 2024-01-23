from utils.DateFormat import DateFormat
class PromedioMedidor():
    def __init__(self,
                id_abonado=None,
                nro_medidor=None,
                promedio_consumo=None,
                promedio_valor=None) -> None:
        self.id_abonado=id_abonado
        self.nro_medidor=nro_medidor
        self.promedio_consumo=promedio_consumo
        self.promedio_valor=promedio_valor
    
    def to_JSON(self):
        return {
            'id_abonado': self.id_abonado,
            'nro_medidor': self.nro_medidor,
            'promedio_consumo': self.promedio_consumo,
            'promedio_valor': self.promedio_valor
        }