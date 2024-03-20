from flask import Flask
from config import config
from flask_cors import CORS

#Rutes
from routes import app_routes
app = Flask(__name__)

def page_not_found(error):
    return "<h1>Pagina no encontrada</h1>", 404

if __name__=='__main__':
    app.config.from_object(config['development'])
    # Registro de extensiones
    CORS(app)  # Aquí se aplica Flask-CORS a la aplicación Flask
    #Blueprints
    app.register_blueprint(app_routes.main, url_prefix='/api')
    #error handlers
    app.register_error_handler(404, page_not_found)
    app.run(host='0.0.0.0')