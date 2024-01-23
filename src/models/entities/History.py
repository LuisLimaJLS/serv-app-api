from utils.DateFormat import DateFormat
class History():
    def __init__(self,
                id_abonado=None,
                id_emision=None,
                nro_medidor=None,
                emsion=None,
                fecha_emision=None,
                novedad=None,
                consumo=None,
                valor=None,
                estado=None,
                pagado=None) -> None:
        self.id_abonado=id_abonado
        self.id_emision=id_emision
        self.nro_medidor=nro_medidor
        self.emsion=emsion
        self.fecha_emision=fecha_emision
        self.novedad=novedad
        self.consumo=consumo
        self.valor=valor
        self.estado=estado
        self.pagado=pagado
    
    def to_JSON(self):
        return {
            'id_abonado': self.id_abonado,
            'id_emision': self.id_emision,
            'nro_medidor': self.nro_medidor,
            'emsion': self.emsion,
            'fecha_emision': self.fecha_emision,
            'novedad': self.novedad,
            'consumo': self.consumo,
            'valor': self.valor,
            'estado': self.estado,
            'pagado': self.pagado
        }