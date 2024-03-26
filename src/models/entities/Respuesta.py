from utils.DateFormat import DateFormat
class Respuesta():
    def __init__(self, 
                identificador=None, 
                mensaje=None,
                enviado=None
                ) -> None:
        self.identificador=identificador
        self.mensaje=mensaje
        self.enviado=enviado

    def to_JSON(self):
        return {
            'identificador': self.identificador,
            'mensaje': self.mensaje,
            'enviado': self.enviado
        }