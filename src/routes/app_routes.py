from flask import Blueprint, jsonify
#models
from models.AbonadoModel import AbonadoModel

main=Blueprint('app_blueprint', __name__)

@main.route('/')
def get_abonados():
    try:
        abonados=AbonadoModel.get_abonados()
        return jsonify(abonados)
    except Exception as ex:
        return jsonify({'message': str(ex)}), 500