from fbs_runtime.application_context import ApplicationContext
from PyQt5.QtWidgets import QMainWindow

# http://build-system.fman.io/pyqt5-tutorial
# from PyQt5.QWidgets import QApplication, QLabel, QCheckBox, QComboBox, QRadioButton, QPushButton, QSlider, QTableWidget, QProgressBar, QVBoxLayout, QWidget, QMessageBox
from PyQt5.QtWidgets import *
from PyQt5.QtCore import Qt
from UiFile import Ui_MainWindow

import sys

if __name__ == '__main__':
    # appctxt = ApplicationContext()       # 1. Instantiate ApplicationContext

    app = ApplicationContext()

    window = QMainWindow()
    ui = Ui_MainWindow()
    ui.setupUi(window)
    window.show()

    exit_code = app.app.exec_()      # 2. Invoke appctxt.app.exec_()
    sys.exit(exit_code)

    # What I need:
    # 1. QCheckBox for options T/F.
    # 2. QComboBox for dropdown
    # 3. Radio BUtton for selection
    # 4. QTableWidget for different pages.
    # 5. QSlider for contrast levels.
    # 6. Progress bar! Yay
    # 7. QPushButton

    # To compile a ui file, do pyuic5 [options] .ui-file
