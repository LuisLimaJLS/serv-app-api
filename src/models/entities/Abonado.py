from utils.DateFormat import DateFormat
class Abonado():
    def __init__(self, id, id_predio=None,
                id_categoria=None,
                nro_medidor=None,
                estado=None,
                fecha_instalacion=None,
                marca_medidor=None,
                direccion=None,
                secuencia=None,
                observacion=None,
                id_cliente=None,
                id_ruta=None,
                situacion=None) -> None:
        self.id=id
        self.id_predio=id_predio,
        self.id_categoria=id_categoria,
        self.nro_medidor=nro_medidor,
        self.estado=estado,
        self.fecha_instalacion=fecha_instalacion,
        self.marca_medidor=marca_medidor,
        self.direccion=direccion,
        self.secuencia=secuencia,
        self.observacion=observacion,
        self.id_cliente=id_cliente,
        self.id_ruta=id_ruta,
        self.situacion=situacion
    
    def to_JSON(self):
        return {
            'id': self.id,
            'id_predio': self.id_predio,
            'id_categoria': self.id_categoria,
            'nro_medidor': self.nro_medidor,
            'estado': self.estado,
            'fecha_instalacion': DateFormat.convert_date(self.fecha_instalacion),
            'marca_medidor': self.marca_medidor,
            'direccion': self.direccion,
            'secuencia': self.secuencia,
            'observacion': self.observacion,
            'id_cliente': self.id_cliente,
            'id_ruta': self.id_ruta,
            'situacion': self.situacion
        }