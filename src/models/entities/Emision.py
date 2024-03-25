from utils.DateFormat import DateFormat
class Emision():
    def __init__(self,
                id_emision=None,
                emisiones=None,
                rubros=None,
                history=None) -> None:
        self.id_emision=id_emision
        self.emisiones=emisiones
        self.rubros=rubros
        self.history=history
    
    def to_JSON(self):
        return {
            'id_emision': self.id_emision,
            'emisiones': self.emisiones,
            'rubros': self.rubros,
            'history': self.history,
        }