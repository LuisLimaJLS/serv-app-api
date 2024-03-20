from utils.DateFormat import DateFormat
class Search():
    def __init__(self,
                id_abonado=None,
                id_emision=None,
                nro_medidor=None,
                emsion=None,
                fecha_emision=None,
                consumo=None,
                valor=None,
                estado=None,
                pagado=None,
                id_ruta=None,
                id_predio=None,
                id_categoria=None,
                novedad=None,
                lectura_actual=None,
	            lectura_anterior=None,
                promedio_consumo=None,
                promedio_valor=None,
                fecha_cobro=None) -> None:
        self.id_abonado=id_abonado
        self.id_emision=id_emision
        self.nro_medidor=nro_medidor
        self.emsion=emsion
        self.fecha_emision=fecha_emision
        self.consumo=consumo
        self.valor=valor
        self.estado=estado
        self.pagado=pagado
        self.id_ruta=id_ruta
        self.id_predio=id_predio
        self.id_categoria=id_categoria
        self.novedad=novedad
        self.lectura_actual=lectura_actual
        self.lectura_anterior=lectura_anterior
        self.promedio_consumo=promedio_consumo
        self.promedio_valor=promedio_valor
        self.fecha_cobro=fecha_cobro
    
    def to_JSON(self):
        return {
            'id_abonado': self.id_abonado,
            'id_emision': self.id_emision,
            'nro_medidor': self.nro_medidor,
            'emsion': self.emsion,
            'fecha_emision': DateFormat.convert_date(self.fecha_emision),
            'consumo': self.consumo,
            'valor': self.valor,
            'estado': self.estado,
            'pagado': self.pagado,
            'id_ruta': self.id_ruta,
            'id_predio': self.id_predio,
            'id_categoria': self.id_categoria,
            'novedad': self.novedad,
            'lectura_actual': self.lectura_actual,
            'lectura_anterior': self.lectura_anterior,
            'promedio_consumo': self.promedio_consumo,
            'promedio_valor': self.promedio_valor,
            'fecha_cobro': DateFormat.convert_date(self.fecha_cobro) if self.fecha_cobro else self.fecha_cobro
        }