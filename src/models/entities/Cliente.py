from utils.DateFormat import DateFormat
class Cliente():
    def __init__(self, id, 
                identificador=None,
                apellidos=None,
                nombres=None,
                direccion=None,
                fecha_nacimiento=None,
                contrasena=None,
                estado=None,
                autenticado=None,
                token=None
                ) -> None:
        self.id=id
        self.identificador=identificador
        self.apellidos=apellidos
        self.nombres=nombres
        self.direccion=direccion
        self.fecha_nacimiento=fecha_nacimiento
        self.contrasena=contrasena
        self.estado=estado
        self.autenticado=autenticado
        self.token=token

    def to_JSON(self):
        return {
            'id': self.id,
            'identificador': self.identificador,
            'apellidos': self.apellidos,
            'nombres': self.nombres,
            'direccion': self.direccion,
            'fecha_nacimiento': DateFormat.convert_date(self.fecha_nacimiento),
            'contrasena': self.contrasena,
            'estado': self.estado,
            'autenticado': self.autenticado,
            'token': self.token
        }