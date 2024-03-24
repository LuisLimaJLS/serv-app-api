from utils.DateFormat import DateFormat
class Rubro():
    def __init__(self, 
                id, 
                descripcion=None,
                cantidad=None,
                valor_unitario=None,
                valor=None,
                ) -> None:
        self.id=id
        self.descripcion=descripcion
        self.cantidad=cantidad
        self.valor_unitario=valor_unitario
        self.valor=valor

    def to_JSON(self):
        return {
            'id': self.id,
            'descripcion': self.descripcion,
            'cantidad': self.cantidad,
            'valor_unitario': self.valor_unitario,
            'valor': self.valor
        }