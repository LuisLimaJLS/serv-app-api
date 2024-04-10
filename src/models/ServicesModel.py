import smtplib
from database.db import get_connection
from .entities.Respuesta import Respuesta
from .entities.Cliente import Cliente
from decouple import config
from email.mime.text import MIMEText
from datetime import datetime

class ServicesModel():
    '''
    Enviar correo
    '''
    @classmethod
    def send_mail(self,identificador, subject, message):
        try:
            connection=get_connection()
            cliente = None
            respuesta=Respuesta(identificador,'No Enviado', False) 
            with connection.cursor() as cursor:
                cursor.execute("select * from get_cliente_by_ci(%s)", (identificador,))
                row=cursor.fetchone()
                if row != None:
                    cliente=Cliente(row[0],row[1],row[2],row[3],row[4],row[5],row[6],row[7],False,'',row[8])
            if cliente:
                self.sendmail(self, cliente.correo_electronico,subject, message, server=None, strict=False)
                respuesta=Respuesta(identificador,'Enviado', True) 
                respuesta=respuesta.to_JSON()
            connection.close()
            return respuesta
        except Exception as ex:
            raise Exception(ex)
        
    def sendmail(self, sender_email, subject, message, server=None, strict=False):

        msg = MIMEText(message)
        msg['From'] = sender_email
        msg['To'] = config('RECEIVER_EMAIL')
        msg['Subject'] = subject

        if server is None:
            server = self.get_smtp_server(strict=strict)
            if not server:
                return
            quit = True
        else:
            quit = False
        if 'Date' not in msg:
            now = datetime.now()
            message['Date'] = now.date()
        try:
            senderrs = server.sendmail(config('SMTP_USERNAME'), config('RECEIVER_EMAIL'), msg.as_string())
        except Exception:
            if strict:
                raise
            print('fail to send email')
        else:
            if senderrs:
                print('fail to send email to %s', senderrs)
        if quit:
            server.quit()

    
    def get_smtp_server(strict=False):
        if config('SMTP_SCHEME').startswith('smtps'):
            connector = smtplib.SMTP_SSL
        else:
            connector = smtplib.SMTP
        try:
            server = connector(config('SMTP_HOSTNAME'), config('SMTP_PORT'))
        except Exception:
            if strict:
                raise
            return
        if config('SMTP_SCHEME_TLS'):
            server.starttls()

        if config('SMTP_USERNAME') and config('SMTP_PASSWORD'):
            server.login(config('SMTP_USERNAME'),config('SMTP_PASSWORD'))
        return server