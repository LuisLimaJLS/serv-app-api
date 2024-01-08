from flask import Blueprint, jsonify
#models
from models.AbonadoModel import AbonadoModel

main=Blueprint('app_blueprint', __name__)

@main.route('/abonados')
def get_abonados():
    try:
        abonados=AbonadoModel.get_abonados()
        return jsonify(abonados)
    except Exception as ex:
        return jsonify({'message': str(ex)}), 500
    
@main.route('/abonadosByCI/<ci>')
def get_abonados_by_client(ci):
    try:
        abonados=AbonadoModel.get_abonados_by_ci(ci)
        if abonados != None:
            return jsonify(abonados)
        else:
            return jsonify({}), 404
    except Exception as ex:
        return jsonify({'message': str(ex)}), 500