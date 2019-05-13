from PyQt5.QtWidgets import QFileDialog
def selectDir():
    file = str(QFileDialog.getExistingDirectory("Select Directory"))
    return file
