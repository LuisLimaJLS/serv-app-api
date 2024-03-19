from secrets import token_hex
from flask import Blueprint, jsonify, request
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
    
@main.route('/clienteByCI/<ci>')
def get_cliente_by_ci(ci):
    try:
        cliente=AbonadoModel.get_cliente_by_ci(ci)
        if cliente != None:
            cliente['contrasena']='#####'
            return jsonify(cliente)
        else:
            return jsonify({}), 404
    except Exception as ex:
        return jsonify({'message': str(ex)}), 500
    

@main.route('/auth/login', methods=['POST'])
def get_auth():
    try:
        identificador=request.json['identificador']
        contrasena=request.json['contrasena']
        cliente=AbonadoModel.get_cliente_by_ci(identificador)
        if cliente != None:
            if contrasena == cliente['contrasena']:
                cliente['contrasena']='#####'
                cliente['autenticado']=True
                cliente['token']=token_hex(16) 
                return jsonify(cliente)
            else:
                cliente['contrasena']='#####'
                cliente['autenticado']=False
                cliente['token']='invalid'
                return jsonify(cliente)
        else:
            return jsonify({}), 404
    except Exception as ex:
        return jsonify({'message': str(ex)}), 500
    

@main.route('/promedioByMedidor/<id>/<nro_meses>')
def get_avg_by_abonado_emi(id,nro_meses):
    try:
        promedio_medidor=AbonadoModel.get_avg_by_abonado_emi(id, nro_meses)
        if promedio_medidor != None:
            return jsonify(promedio_medidor)
        else:
            return jsonify({}), 404
    except Exception as ex:
        return jsonify({'message': str(ex)}), 500
    

@main.route('/emisionsByAbonado/<id>/<nro_meses>')
def get_emsion_by_abonado(id, nro_meses):
    try:
        emisiones=AbonadoModel.get_emsion_by_abonado(id, nro_meses)
        if emisiones != None:
            return jsonify(emisiones)
        else:
            return jsonify({}), 404
    except Exception as ex:
        return jsonify({'message': str(ex)}), 500
    

@main.route('/maxEmisionsByAbonado/<id>/<nro_meses>')
def get_max_emsion_by_abonado(id, nro_meses):
    try:
        emisiones=AbonadoModel.get_max_emsion_by_abonado(id, nro_meses)
        if emisiones != None:
            return jsonify(emisiones)
        else:
            return jsonify({}), 404
    except Exception as ex:
        return jsonify({'message': str(ex)}), 500
    

@main.route('/historyByCi/<ci>')
def get_all_history_by_ci(ci):
    try:
        histories=AbonadoModel.get_all_history_by_ci(ci)
        if histories != None:
            return jsonify(histories)
        else:
            return jsonify({}), 404
    except Exception as ex:
        return jsonify({'message': str(ex)}), 500
    
@main.route('/historyByAbonado/<id_abonado>')
def get_all_history_by_abonado(id_abonado):
    try:
        histories=AbonadoModel.get_all_history_by_abonado(id_abonado)
        if histories != None:
            return jsonify(histories)
        else:
            return jsonify({}), 404
    except Exception as ex:
        return jsonify({'message': str(ex)}), 500