import smtplib
from email.mime.multipart import MIMEMultipart
from email.mime.text import MIMEText
import secrets
from dotenv import load_dotenv
import os


load_dotenv()
##this is local host in the emulator
# apiUrl = "http://10.0.2.2:5000"

apiUrl = "http://localhost:8000"

# apiUrl= somebackendurl for later
emailPassword = os.getenv("EMAIL_PASSWORD")


class EmailSender:
    # app email
    fromEmail = "internationlstudentstation@gmail.com"

    # this returns a verification token to store in the db
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
        message.attach(MIMEText(body, "plain"))
        # Create SMTP session for sending the mail
        try:
            print("sending email to: ", userEmail)
            print("email password: ", emailPassword)
            server = smtplib.SMTP("smtp.gmail.com", 587)
            server.starttls()
            server.login(EmailSender.fromEmail, emailPassword)

            text = message.as_string()

            server.sendmail(EmailSender.fromEmail, userEmail, text)

            server.quit()
        except Exception as e:
            print("Error: unable to send email", e)

            #

        return token
