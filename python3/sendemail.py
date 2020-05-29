import smtplib

from email.message import EmailMessage

textfile="/pythongLearning/testemail.txt"

with open(textfile) as fp:
    msg=EmailMessage()
    msg.set_content(fp.read())

msg['Subject']='The contents of %s' % textfile
msg['From']="tenzin_dorji@intuit.com"
msg['To']="tenzin_dorji@intuit.com"

s=smtplib.SMTP('localhost')
s.send_message(msg)
s.quit()
