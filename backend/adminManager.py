from classes.DBManager import *

adminEmails = ["Mr.Whiskers@example.com", "Good_Boy@example.com", "Kevin@example.com", "Luna@example.com"]

def setAdmins():
    DBManager.setAdmins(adminEmails)

setAdmins()