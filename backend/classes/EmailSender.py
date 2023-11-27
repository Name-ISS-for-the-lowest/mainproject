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
    
    @staticmethod
    def sendAuthenticationEmail(userEmail):
        # Set your email and password
        message = MIMEMultipart()
        message["From"] = EmailSender.fromEmail
        message["To"] = userEmail
        message["Subject"] = "ISS - Email Verification"
        token = secrets.token_urlsafe(32)

        body = f"""
        
<html lang="en">
  <head>
    <meta charset="utf-8" />
    <meta content="width=device-width, initial-scale=1.0" name="viewport" />
    <title>Welcome to ISS!</title>
  </head>
  <body>
    <div class="main-container">
      <h1 class="main-header">
        Welcome to Sacramento State's International Student Station (ISS)!
      </h1>
      <p class="mb-6">
        You are one step closer to becoming an integral part of our diverse
        community! To fully benefit from our support, please verify your email
        address.
      </p>
      <p class="mb-6">
        Why this step? It's simply because communication is key when joining a
        new community.
      </p>
      <p class="mb-6">
        If you did not create an ISS account using this address, or if you have
        any questions or concerns, please reach out to us at us at
        <a class="link" href="mailto:internationlstudentstation@gmail.com">
          internationlstudentstation@gmail.com
        </a>
      </p>
      <div class="button">
        <a class="button-link" href="{apiUrl+ "/verify?token="+ token}"> Verify your account </a>
        <p>
          Or verify using this
          <a class="link" href="{apiUrl+ "/verify?token="+ token}"> link </a>
          :
        </p>
      </div>
      <p class="footer">
        Sent by ISS, 6000 J Street, Sacramento, CA 95819
      </p>
    </div>
    <style>
        *{{
            font-family: ui-sans-serif, system-ui, -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, "Helvetica Neue", Arial, "Noto Sans", sans-serif, "Apple Color Emoji", "Segoe UI Emoji", "Segoe UI Symbol", "Noto Color Emoji";
            box-sizing: border-box;
        }}
      .bg-medium-green {{
        background-color: #00ab6b;
      }}
      .text-medium-green {{
        color: #00ab6b;
      }}
      body {{
        display: flex;
        flex-direction: column;
        justify-content: center;
        align-items: center;
        height: 100vh;
        color: #374151;
        background-color: #f3f4f6;
      }}
      .main-container {{
        padding-left: 1rem;
        padding-right: 1rem;
        padding-top: 2rem;
        padding-bottom: 2rem;
        max-width: 42rem;
        text-align: center;
      }}
      .main-header {{
        margin-bottom: 1rem;
        font-size: 2.25rem;
        line-height: 2.5rem;
        font-weight: 700;
        color: #000000;
      }}
      .mb-6 {{
        margin-bottom: 1.5rem;
      }}
      .link:hover {{
        text-decoration: underline;
      }}
      .link {{
        color: #00ab6b;
        text-decoration: none;
      }}

      .button {{
        display: flex;
        margin-top: 1rem;
        flex-direction: column;
        justify-content: center;
        align-items: center;
      }}
      .button-link {{
        text-decoration: none;
        background-color: #00ab6b;
        padding-top: 0.5rem;
        padding-bottom: 0.5rem;
        padding-left: 1.5rem;
        padding-right: 1.5rem;
        border-radius: 0.25rem;
        font-weight: 700;
        color: #ffffff;
        transition-property: background-color, border-color, color, fill, stroke,
          opacity, box-shadow, transform;
        transition-timing-function: cubic-bezier(0.4, 0, 0.2, 1);
        transition-duration: 300ms;
        transition-duration: 300ms;
        transition-timing-function: cubic-bezier(0.4, 0, 0.2, 1);
      }}

      .button-link:hover {{
        --transform-scale-x: 1.05;
        --transform-scale-y: 1.05;
        transform: scale(var(--transform-scale-x), var(--transform-scale-y));
      }}
      .footer {{
        margin-top: 2rem;
        font-size: 0.75rem;
        line-height: 1rem;
        color: #6b7280;
      }}
    </style>
  </body>
</html>
        """
        message.attach(MIMEText(body, "html"))
        # Create SMTP session for sending the mail
        try:
            print("sending email to: ", userEmail)
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

    def sendResetPasswordEmail(userEmail: str):
        message = MIMEMultipart()
        message["From"] = EmailSender.fromEmail
        message["To"] = userEmail
        message["Subject"] = "ISS - Reset Email Verification"
        token = secrets.token_urlsafe(32)

        body = f"""

  <html lang="en">
  <head>
    <meta charset="utf-8" />
    <meta content="width=device-width, initial-scale=1.0" name="viewport" />
    <title>Welcome to ISS!</title>
  </head>
  <body>
    <div class="main-container">
      <h1 class="main-header">
        Reset Email!
      </h1>
      <p class="mb-6">
       We received a request for you to reset your password. If you did not make this request, you can safely ignore this email.
      </p>
      <p class="mb-6">
        If you have
        any questions or concerns, please reach out to us at us at
        <a class="link" href="mailto:internationlstudentstation@gmail.com">
          internationlstudentstation@gmail.com
        </a>
      </p>
      <div class="button">
        <a class="button-link" href="{apiUrl+ "/resetPassword?token="+ token}"> Reset Password Here </a>
        <p>
          Or  using this
          <a class="link" href="{apiUrl+ "/resetPassword?token="+ token}"> link </a>
          :
        </p>
      </div>
      <p class="footer">
        Sent by ISS, 6000 J Street, Sacramento, CA 95819
      </p>
    </div>
    <style>
        *{{
            font-family: ui-sans-serif, system-ui, -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, "Helvetica Neue", Arial, "Noto Sans", sans-serif, "Apple Color Emoji", "Segoe UI Emoji", "Segoe UI Symbol", "Noto Color Emoji";
            box-sizing: border-box;
        }}
      .bg-medium-green {{
        background-color: #00ab6b;
      }}
      .text-medium-green {{
        color: #00ab6b;
      }}
      body {{
        display: flex;
        flex-direction: column;
        justify-content: center;
        align-items: center;
        height: 100vh;
        color: #374151;
        background-color: #f3f4f6;
      }}
      .main-container {{
        padding-left: 1rem;
        padding-right: 1rem;
        padding-top: 2rem;
        padding-bottom: 2rem;
        max-width: 42rem;
        text-align: center;
      }}
      .main-header {{
        margin-bottom: 1rem;
        font-size: 2.25rem;
        line-height: 2.5rem;
        font-weight: 700;
        color: #000000;
      }}
      .mb-6 {{
        margin-bottom: 1.5rem;
      }}
      .link:hover {{
        text-decoration: underline;
      }}
      .link {{
        color: #00ab6b;
        text-decoration: none;
      }}

      .button {{
        display: flex;
        margin-top: 1rem;
        flex-direction: column;
        justify-content: center;
        align-items: center;
      }}
      .button-link {{
        text-decoration: none;
        background-color: #00ab6b;
        padding-top: 0.5rem;
        padding-bottom: 0.5rem;
        padding-left: 1.5rem;
        padding-right: 1.5rem;
        border-radius: 0.25rem;
        font-weight: 700;
        color: #ffffff;
        transition-property: background-color, border-color, color, fill, stroke,
          opacity, box-shadow, transform;
        transition-timing-function: cubic-bezier(0.4, 0, 0.2, 1);
        transition-duration: 300ms;
        transition-duration: 300ms;
        transition-timing-function: cubic-bezier(0.4, 0, 0.2, 1);
      }}

      .button-link:hover {{
        --transform-scale-x: 1.05;
        --transform-scale-y: 1.05;
        transform: scale(var(--transform-scale-x), var(--transform-scale-y));
      }}
      .footer {{
        margin-top: 2rem;
        font-size: 0.75rem;
        line-height: 1rem;
        color: #6b7280;
      }}
    </style>
  </body>
</html>
          """
        message.attach(MIMEText(body, "html"))
        # Create SMTP session for sending the mail
        try:
            print("sending email to: ", userEmail)
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

    # testing function DO NOT USE
    def sendHTMLEMAIL(userEmail: str, subject: str, token: str):
        # Set your email and password
        message = MIMEMultipart("alternative")
        message["From"] = EmailSender.fromEmail
        message["To"] = userEmail
        message["Subject"] = subject

        body = f"""
<html lang="en">
  <head>
    <meta charset="utf-8" />
    <meta content="width=device-width, initial-scale=1.0" name="viewport" />
    <title>Welcome to ISS!</title>
  </head>
  <body>
    <div class="main-container">
      <h1 class="main-header">
        Welcome to Sacramento State's International Student Station (ISS)!
      </h1>
      <p class="mb-6">
        You are one step closer to becoming an integral part of our diverse
        community! To fully benefit from our support, please verify your email
        address.
      </p>
      <p class="mb-6">
        Why this step? It's simply because communication is key when joining a
        new community.
      </p>
      <p class="mb-6">
        If you did not create an ISS account using this address, or if you have
        any questions or concerns, please reach out to us at us at
        <a class="link" href="mailto:internationlstudentstation@gmail.com">
          internationlstudentstation@gmail.com
        </a>
      </p>
      <div class="button">
        <a class="button-link" href="{apiUrl+ "/verify?token="+ token}"> Verify your account </a>
        <p>
          Or verify using this
          <a class="link" href="{apiUrl+ "/verify?token="+ token}"> link </a>
          :
        </p>
      </div>
      <p class="footer">
        Sent by ISS, 6000 J Street, Sacramento, CA 95819
      </p>
    </div>
    <style>
        *{{
            font-family: ui-sans-serif, system-ui, -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, "Helvetica Neue", Arial, "Noto Sans", sans-serif, "Apple Color Emoji", "Segoe UI Emoji", "Segoe UI Symbol", "Noto Color Emoji";
            box-sizing: border-box;
        }}
      .bg-medium-green {{
        background-color: #00ab6b;
      }}
      .text-medium-green {{
        color: #00ab6b;
      }}
      body {{
        display: flex;
        flex-direction: column;
        justify-content: center;
        align-items: center;
        height: 100vh;
        color: #374151;
        background-color: #f3f4f6;
      }}
      .main-container {{
        padding-left: 1rem;
        padding-right: 1rem;
        padding-top: 2rem;
        padding-bottom: 2rem;
        max-width: 42rem;
        text-align: center;
      }}
      .main-header {{
        margin-bottom: 1rem;
        font-size: 2.25rem;
        line-height: 2.5rem;
        font-weight: 700;
        color: #000000;
      }}
      .mb-6 {{
        margin-bottom: 1.5rem;
      }}
      .link:hover {{
        text-decoration: underline;
      }}
      .link {{
        color: #00ab6b;
        text-decoration: none;
      }}

      .button {{
        display: flex;
        margin-top: 1rem;
        flex-direction: column;
        justify-content: center;
        align-items: center;
      }}
      .button-link {{
        text-decoration: none;
        background-color: #00ab6b;
        padding-top: 0.5rem;
        padding-bottom: 0.5rem;
        padding-left: 1.5rem;
        padding-right: 1.5rem;
        border-radius: 0.25rem;
        font-weight: 700;
        color: #ffffff;
        transition-property: background-color, border-color, color, fill, stroke,
          opacity, box-shadow, transform;
        transition-timing-function: cubic-bezier(0.4, 0, 0.2, 1);
        transition-duration: 300ms;
        transition-duration: 300ms;
        transition-timing-function: cubic-bezier(0.4, 0, 0.2, 1);
      }}

      .button-link:hover {{
        --transform-scale-x: 1.05;
        --transform-scale-y: 1.05;
        transform: scale(var(--transform-scale-x), var(--transform-scale-y));
      }}
      .footer {{
        margin-top: 2rem;
        font-size: 0.75rem;
        line-height: 1rem;
        color: #6b7280;
      }}
    </style>
  </body>
</html>
        """

        message.attach(MIMEText(body, "html"))
        # Create SMTP session for sending the mail
        try:
            print("sending email to: ", userEmail)
            server = smtplib.SMTP("smtp.gmail.com", 587)
            server.starttls()
            server.login(EmailSender.fromEmail, emailPassword)

            text = message.as_string()

            server.sendmail(EmailSender.fromEmail, userEmail, text)

            server.quit()
        except Exception as e:
            print("Error: unable to send email", e)

            #
