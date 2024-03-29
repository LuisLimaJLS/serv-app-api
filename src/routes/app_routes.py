from secrets import token_hex
from flask import Blueprint, jsonify, request
#models
from models.AbonadoModel import AbonadoModel
from models.ServicesModel import ServicesModel

main=Blueprint('app_blueprint', __name__)

@main.route('/abonados')
def get_abonados():
    try:
        abonados=AbonadoModel.get_abonados()
        return jsonify(abonados)
    except Exception as ex:
        return jsonify({'message': str(ex)}), 500
    
@main.route('/abonadosByCI/<ci>/<nro_meses>')
def get_abonados_by_client(ci, nro_meses):
    try:
        abonados=AbonadoModel.get_abonados_by_ci(ci, nro_meses)
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
        identificador=request.json['identifier']
        contrasena=request.json['password']
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
    
@main.route('/SearchByCIFull/<ci>/<src>')
def get_all_search_by_ci_full(ci, src):
    try:
        results=AbonadoModel.get_all_search_by_ci('full', ci, src)
        if results != None:
            return jsonify(results)
        else:
            return jsonify({}), 404
    except Exception as ex:
        return jsonify({'message': str(ex)}), 500
    
@main.route('/SearchByCIMin/<ci>/<src>')
def get_all_search_by_ci_min(ci, src):
    try:
        results=AbonadoModel.get_all_search_by_ci('min', ci, src)
        if results != None:
            return jsonify(results)
        else:
            return jsonify({}), 404
    except Exception as ex:
        return jsonify({'message': str(ex)}), 500
    
@main.route('/getDetailValuesByAbonado/<id>/<nro_meses>')
def get_detail_values_by_abonado(id, nro_meses):
    try:
        results=AbonadoModel.get_detail_values_by_abonado(id, nro_meses)
        if results != None:
            return jsonify(results)
        else:
            return jsonify({}), 404
    except Exception as ex:
        return jsonify({'message': str(ex)}), 500
    
@main.route('/dataByEmission/<id_emision>/<nro_meses>')
def get_all_data_by_emision(id_emision, nro_meses):
    try:
        emision=AbonadoModel.get_all_data_by_emision(id_emision, nro_meses)
        if emision != None:
            return jsonify(emision)
        else:
            return jsonify({}), 404
    except Exception as ex:
        return jsonify({'message': str(ex)}), 500

@main.route('/maxEmsionAlertByCi/<ci>/<nro_meses>')
def get_max_emsion_alert_by_ci(ci, nro_meses):
    try:
        alerts=AbonadoModel.get_max_emsion_alert_by_ci(ci, nro_meses)
        if alerts != None:
            return jsonify(alerts)
        else:
            return jsonify({}), 404
    except Exception as ex:
        return jsonify({'message': str(ex)}), 500


@main.route('/mail/sendMail', methods=['POST'])
def send_mail():
    try:
        identificador=request.json['identifier']
        subject=request.json['subject']
        message=request.json['message']
        response=ServicesModel.send_mail(identificador, subject, message)
        if response != None:
            return jsonify(response)
        else:
            return jsonify({}), 404
    except Exception as ex:
        return jsonify({'message': str(ex)}), 500