import smtplib
from email.mime.multipart import MIMEMultipart
from email.mime.text import MIMEText
import secrets

##we're using localhost for testing
apiUrl = "http://10.0.2.2:5000"


class EmailSender:
    # to-do get an app email
    fromEmail = "malek.gabriel33@gmail.com"

    # this return a verification token to store in the db
    def sendAuthenticationEmail(userEmail):
        # Set your email and password
        message = MIMEMultipart()
        message["From"] = EmailSender.fromEmail
        message["To"] = userEmail
        message["Subject"] = "ISS - Email Verification"
        token = secrets.token_urlsafe(32)

        body = (
            "Hello, please click on the link to verify your email: "
            + apiUrl
            + "/verify?token="
            + token
        )
        return token
